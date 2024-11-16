import time
import pandas as pd
from brainflow.board_shim import BoardShim, BrainFlowInputParams, LogLevels, BoardIds
from brainflow.data_filter import DataFilter, FilterTypes, AggOperations, WindowOperations

# Step 1: Set up BrainFlow connection
params = BrainFlowInputParams()
params.mac_address = '6B2A39A9-E7B4-28FE-856A-CCB8955DFF44'  # Replace with Muse S MAC address
board_id = BoardIds.MUSE_2_BOARD.value
board = BoardShim(board_id, params)

try:
    # Step 2: Start Streaming
    BoardShim.enable_board_logger()
    board.prepare_session()
    board.start_stream(45000)
    print("Collecting data for 10 seconds...")
    time.sleep(10)
    
    # Step 3: Retrieve Data
    data = board.get_board_data()


    eeg_channels = BoardShim.get_eeg_channels(board_id)


    # Step 4: Calculate Band Powers for Each Channel
    band_powers = []
    bands = ['Delta', 'Theta', 'Alpha', 'Beta', 'Gamma']
    for channel in eeg_channels:
        nfft = DataFilter.get_nearest_power_of_two(BoardShim.get_sampling_rate(board_id))
        psd = DataFilter.get_psd_welch(data[channel], nfft, nfft // 2, BoardShim.get_sampling_rate(board_id), WindowOperations.HANNING.value)


        print(data[channel])
        print(BoardShim.get_sampling_rate(board_id))
        # Compute band power for each frequency band
        delta = DataFilter.get_band_power(psd, 0.5, 4.0)
        theta = DataFilter.get_band_power(psd, 4.0, 8.0)
        alpha = DataFilter.get_band_power(psd, 8.0, 13.0)
        beta = DataFilter.get_band_power(psd, 13.0, 30.0)
        gamma = DataFilter.get_band_power(psd, 30.0, 100.0)

        band_powers.append([delta, theta, alpha, beta, gamma])

    # Step 5: Save Band Powers to CSV
    df = pd.DataFrame(band_powers, columns=bands, index=[f"EEG Channel {i+1}" for i in range(len(eeg_channels))])
    df.index.name = "Channel"
    # Save as comma-separated CSV
    df.to_csv("brainwave_bandpowers.csv", sep=",", index=True)
    print("Bandpower data saved to 'brainwave_bandpowers.csv'")


finally:
    # Step 6: Release Session
    board.stop_stream()
    board.release_session()
    print("Session ended.")
