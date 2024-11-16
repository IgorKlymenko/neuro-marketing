import time
import pandas as pd
import numpy as np
from brainflow.board_shim import BoardShim, BrainFlowInputParams, LogLevels, BoardIds
from brainflow.data_filter import DataFilter, FilterTypes, AggOperations, WindowOperations
import os

# Helper function to get the next file index
def get_next_file_index(folder_path):
    if not os.path.exists(folder_path):
        os.makedirs(folder_path)  # Create folder if it doesn't exist
        return 1  # Start from 1 if no files are present

    existing_files = [f for f in os.listdir(folder_path) if f.startswith("data_") and f.endswith(".csv")]
    if not existing_files:
        return 1  # Start from 1 if no matching files are found

    indices = [int(f.split('_')[1].split('.')[0]) for f in existing_files]
    return max(indices) + 1  # Increment the highest index by 1

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
        
        # Welch PSD
        psd_welch = DataFilter.get_psd_welch(
            data[channel], nfft, nfft // 2, 
            BoardShim.get_sampling_rate(board_id), 
            WindowOperations.HANNING.value
        )

    
        # Print debug information
        print(f"Channel {channel} data: {data[channel]}")
        print(f"Sampling rate: {BoardShim.get_sampling_rate(board_id)}")
        
        # Compute band power for each frequency band (Welch)
        delta_welch = DataFilter.get_band_power(psd_welch, 0.5, 4.0)
        theta_welch = DataFilter.get_band_power(psd_welch, 4.0, 8.0)
        alpha_welch = DataFilter.get_band_power(psd_welch, 8.0, 13.0)
        beta_welch = DataFilter.get_band_power(psd_welch, 13.0, 30.0)
        gamma_welch = DataFilter.get_band_power(psd_welch, 30.0, 100.0)
        
        band_powers.append([delta_welch, theta_welch, alpha_welch, beta_welch, gamma_welch])

    # Step 5: Save Band Powers to CSV

    #           Band Power Measurement Table Formatting
    #
    #       Delta   Theta   Alpha   Beta    Gamma
    # EEG_1
    # EEG_2 
    # EEG_3
    # EEG_4

    folder_path = "data"
    next_index = get_next_file_index(folder_path)
    file_path = os.path.join(folder_path, f"data_{next_index}.csv")

    df = pd.DataFrame(band_powers)

    #wiht names
    #columns = [f"{band}_Welch" for band in bands]
    #df = pd.DataFrame(band_powers, columns=columns, index=[f"EEG Channel {i+1}" for i in range(len(eeg_channels))])

    df.to_csv(file_path, sep=",", index = False, header = False)
    print(f"Bandpower data saved to '{file_path}'")

    # Step 6: Visualization of the total Band Power
    # import matplotlib.pyplot as plt

    # for i, channel in enumerate(eeg_channels):
    #     plt.figure(figsize=(6, 4))
    #     plt.plot(psd_welch[0], psd_welch[1], label="Welch", alpha=0.7)
    #     plt.xlabel("Frequency (Hz)")
    #     plt.ylabel("Power Spectral Density")
    #     plt.legend()
    #     plt.grid(True)
    #     plt.show()

finally:
    # Step 7: Release Session
    board.stop_stream()
    board.release_session()
    print("Session ended.")
