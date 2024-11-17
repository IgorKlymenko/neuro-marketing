
# I was wotrking on the psd_multitapper to substitude psd_welch provided by the Brainflow API to improve the accuracy cleaning noise
# The problem that it is hard to compare to the data we receive from the Brainflow API, so it takes unnecessary long time 

import time
import pandas as pd
import numpy as np
from brainflow.board_shim import BoardShim, BrainFlowInputParams, LogLevels, BoardIds
from brainflow.data_filter import DataFilter, FilterTypes, AggOperations, WindowOperations
from scipy.integrate import simps

# Helper function to compute band power manually
from scipy.integrate import simps
from mne.time_frequency import psd_array_multitaper

def compute_bandpower_multitaper(data, sf, band, relative=False):
    """
    Compute the average power of the signal in a specific frequency band using Multitaper PSD.

    Parameters
    ----------
    data : 1d-array
        Input signal in the time domain.
    sf : float
        Sampling frequency of the data.
    band : list
        Lower and upper frequencies of the band of interest.
    relative : boolean
        If True, return the relative power (divided by total power).
        If False, return the absolute power.

    Returns
    -------
    bp : float
        Absolute or relative band power.
    """
    # Extract lower and upper frequencies of the band
    low, high = band
    
    # Compute the Multitaper PSD
    psd, freqs = psd_array_multitaper(data, sf, adaptive=True, normalization='length', verbose=0)
    
    # Frequency resolution
    freq_res = freqs[1] - freqs[0]
    
    # Find indices of the desired frequency band
    idx_band = (freqs >= low) & (freqs <= high)
    
    # Compute the band power using Simpson's rule
    bp = simps(psd[idx_band], dx=freq_res)
    
    # Compute relative power if required
    if relative:
        total_power = simps(psd, dx=freq_res)
        bp /= total_power
    
    return bp




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

 
        from mne.time_frequency import psd_array_multitaper

        
        # Multitaper PSD
        #psd_multitaper, freqs = psd_array_multitaper(data[channel], BoardShim.get_sampling_rate(board_id), adaptive=True,
        #                                  normalization='length', verbose=0)


        
        # Print debug information
        print(f"Channel {channel} data: {data[channel]}")
        print(f"Sampling rate: {BoardShim.get_sampling_rate(board_id)}")
        
        # Compute band power for each frequency band (Welch)
        delta_welch = DataFilter.get_band_power(psd_welch, 0.5, 4.0)
        theta_welch = DataFilter.get_band_power(psd_welch, 4.0, 8.0)
        alpha_welch = DataFilter.get_band_power(psd_welch, 8.0, 13.0)
        beta_welch = DataFilter.get_band_power(psd_welch, 13.0, 30.0)
        gamma_welch = DataFilter.get_band_power(psd_welch, 30.0, 100.0)
        
        # Compute band power for each frequency band (Multitaper)
        # Compute power for various frequency bands
        delta_mt = compute_bandpower_multitaper(data[channel], BoardShim.get_sampling_rate(board_id), [0.5, 4.0])
        theta_mt = compute_bandpower_multitaper(data[channel], BoardShim.get_sampling_rate(board_id), [4.0, 8.0])
        alpha_mt = compute_bandpower_multitaper(data[channel], BoardShim.get_sampling_rate(board_id), [8.0, 13.0])
        beta_mt = compute_bandpower_multitaper(data[channel], BoardShim.get_sampling_rate(board_id), [13.0, 30.0])
        gamma_mt = compute_bandpower_multitaper(data[channel], BoardShim.get_sampling_rate(board_id), [30.0, 100.0])

        band_powers.append([delta_welch, theta_welch, alpha_welch, beta_welch, gamma_welch,
                            delta_mt, theta_mt, alpha_mt, beta_mt, gamma_mt])

    # Step 5: Save Band Powers to CSV
    columns = [f"{band}_Welch" for band in bands] + [f"{band}_Multitaper" for band in bands]
    df = pd.DataFrame(band_powers, columns=columns, index=[f"EEG Channel {i+1}" for i in range(len(eeg_channels))])
    df.index.name = "Channel"
    df.to_csv("brainwave_bandpowers_comparison.csv", sep=",", index=True)
    print("Bandpower data saved to 'brainwave_bandpowers_comparison.csv'")

    # Step 6: Visualization
    import matplotlib.pyplot as plt

    for i, channel in enumerate(eeg_channels):
        plt.figure(figsize=(6, 4))
        
        plt.subplots_adjust(left=0.1, right=0.9, top=0.9, bottom=0.1)
        plt.plot(psd_welch[0], psd_welch[1], label="Welch", alpha=0.7)

        psd_multitaper, freqs = psd_array_multitaper(data[channel], BoardShim.get_sampling_rate(board_id), adaptive=True, normalization='length', verbose=0)
        plt.plot(psd_multitaper[0], psd_multitaper[1], label="Multitaper", alpha=0.7)

        print(psd_multitaper)
        
        plt.title(f"PSD Comparison for Channel {i+1}")
        plt.xlabel("Frequency (Hz)")
        plt.ylabel("Power Spectral Density")
        plt.legend()
        plt.grid(True)
        plt.show()

finally:
    # Step 6: Release Session
    board.stop_stream()
    board.release_session()
    print("Session ended.")
