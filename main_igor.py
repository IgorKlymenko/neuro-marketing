from brainflow.board_shim import BoardShim, BrainFlowInputParams, BoardIds
import argparse
import time

def main():
    BoardShim.enable_dev_board_logger()

    # Set up arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('--timeout', type=int, help='timeout for device discovery or connection', required=False, default=0)
    parser.add_argument('--serial-port', type=str, help='serial port', required=False, default='/dev/cu.Bluetooth-Incoming-Port')
    parser.add_argument('--mac-address', type=str, help='mac address', required=False, default='6B2A39A9-E7B4-28FE-856A-CCB8955DFF44')
    parser.add_argument('--board-id', type=int, help='board id', required=False, default=BoardIds.MUSE_S_BLED_BOARD.value)
    args = parser.parse_args()

    # Initialize BrainFlowInputParams
    params = BrainFlowInputParams()
    params.serial_port = args.serial_port
    params.mac_address = args.mac_address
    params.timeout = args.timeout

    # Create board object
    board = BoardShim(args.board_id, params)
    BoardShim.enable_dev_board_logger()


    try:
        # Prepare session
        print("Preparing session...")
        import time
        start_time = time.time()
        board.prepare_session()
        end_time = time.time()
        print("Session prepared successfully.")
        print(f"Session preparation took {end_time - start_time} seconds.")

        # Start streaming data
        print("Starting data stream...")
        board.start_stream()
        print("Streaming started...")

        time.sleep(10)  # Stream data for 10 seconds

        # Get data from the board
        print("Retrieving data...")
        data = board.get_board_data()
        print("Data retrieved successfully!")

        # Print data
        print("Data:")
        print(data)

    except Exception as e:
        print(f"Error: {e}")

    finally:
        # Stop stream and release session
        print("Stopping data stream...")
        board.stop_stream()
        print("Data stream stopped.")
        board.release_session()
        print("Session released.")

import time
import numpy as np
import pandas as pd
import argparse
from brainflow.board_shim import BoardShim, BrainFlowInputParams, LogLevels, BoardIds
from brainflow.data_filter import DataFilter
import matplotlib.pyplot as plt
from pprint import pprint


def main():
    # Set up argument parser for command-line inputs
    parser = argparse.ArgumentParser()
    parser.add_argument('--timeout', type=int, help='timeout for device discovery or connection', required=False, default=0)
    parser.add_argument('--serial-port', type=str, help='serial port', required=False, default='/dev/cu.Bluetooth-Incoming-Port')  ### CHANGE HERE
    parser.add_argument('--mac-address', type=str, help='mac address', required=False, default='6B2A39A9-E7B4-28FE-856A-CCB8955DFF44')
    parser.add_argument('--board-id', type=int, help='board id', required=False, default=BoardIds.MUSE_S_BLED_BOARD.value)
    args = parser.parse_args()

    # Initialize BrainFlowInputParams
    params = BrainFlowInputParams()
    params.serial_port = args.serial_port
    params.mac_address = args.mac_address
    params.timeout = args.timeout

    # Use synthetic board for demo purposes
    board = BoardShim(BoardIds.SYNTHETIC_BOARD.value, params)
    board.prepare_session()

    # Start the data stream
    board.start_stream()
    BoardShim.log_message(LogLevels.LEVEL_INFO.value, 'Start sleeping in the main thread')
    time.sleep(10)  # sleep to collect data

    # Get data from the board
    data = board.get_board_data()
    board.stop_stream()
    board.release_session()

    # Create a pandas DataFrame
    df = pd.DataFrame(np.transpose(data))
    print('Data From the Board')
    print(df.head(10))

    # Channel names based on BrainFlow documentation
    eeg_channels = BoardShim.get_eeg_channels(BoardIds.SYNTHETIC_BOARD.value)
    channel_names = {
        'EEG': ['Fz', 'C3', 'Cz', 'C4', 'Pz', 'PO7', 'Oz', 'PO8', 'F5', 'F7', 'F3', 'F1', 'F2', 'F4', 'F6', 'F8'],
        'ECG': ['ECG_1', 'ECG_2', 'ECG_3'],  # If available
        'EMG': ['EMG_1', 'EMG_2', 'EMG_3'],  # If available
        'EOG': ['EOG_1', 'EOG_2'],  # If available
        'Gyroscope': ['Gyro_X', 'Gyro_Y', 'Gyro_Z'],
        'Accelerometer': ['Accel_X', 'Accel_Y', 'Accel_Z'],
        'Temperature': ['Temperature'],
        'Resistance': ['Resistance_1', 'Resistance_2'],
        'Marker': ['Marker']
    }

    # Assign names to EEG data based on the channel indices
    eeg_data = df[eeg_channels]
    eeg_data.columns = channel_names['EEG'][:len(eeg_channels)]
    print('EEG Data:')
    print(eeg_data.head(10))

    # Visualize the EEG data
    plt.figure(figsize=(10, 6))
    for channel in eeg_data.columns:
        plt.plot(df.index, eeg_data[channel], label=channel)
    plt.xlabel('Time (samples)')
    plt.ylabel('EEG Signal')
    plt.title('EEG Data Over Time')
    plt.legend()
    plt.show()

    # Serialize data using BrainFlow's API (recommended over pandas.to_csv)
    DataFilter.write_file(data, 'test.csv', 'w')  # 'w' for write mode, 'a' for append mode
    restored_data = DataFilter.read_file('test.csv')

    # Convert restored data to DataFrame
    restored_df = pd.DataFrame(np.transpose(restored_data))

    # Print restored data
    print('Restored Data From the File:')
    print(restored_df.head(10))

    # Print board description
    board_id = BoardIds.SYNTHETIC_BOARD.value
    pprint(BoardShim.get_board_descr(board_id))


def main():
    # Set up argument parser for command-line inputs
    parser = argparse.ArgumentParser()
    parser.add_argument('--timeout', type=int, help='timeout for device discovery or connection', required=False, default=0)
    parser.add_argument('--serial-port', type=str, help='serial port', required=False, default='/dev/cu.Bluetooth-Incoming-Port')  ### CHANGE HERE
    parser.add_argument('--mac-address', type=str, help='mac address', required=False, default='6B2A39A9-E7B4-28FE-856A-CCB8955DFF44')
    parser.add_argument('--board-id', type=int, help='board id', required=False, default=BoardIds.MUSE_S_BOARD.value)
    args = parser.parse_args()

    # Initialize BrainFlowInputParams
    params = BrainFlowInputParams()
    params.serial_port = args.serial_port
    params.mac_address = args.mac_address
    params.timeout = args.timeout

    # Use synthetic board for demo purposes
    board = BoardShim(args.board_id, params)  # Use the board ID from the arguments
    try:
        board.prepare_session()
        
        # Start the data stream
        board.start_stream()
        BoardShim.log_message(LogLevels.LEVEL_INFO.value, 'Start sleeping in the main thread')
        time.sleep(10)  # Sleep to collect data

        # Get data from the board
        data = board.get_board_data()
        board.stop_stream()

        # Release session after data collection
        board.release_session()

        # Convert data to a DataFrame and display
        df = pd.DataFrame(np.transpose(data))
        print('Data From the Board:')
        print(df.head(1000))


        # Serialize data using BrainFlow's API (recommended over pandas.to_csv)
        #DataFilter.write_file(data, 'test_muse.csv', 'w')  # 'w' for write mode, 'a' for append mode
        #restored_data = DataFilter.read_file('test_muse.csv')

    except Exception as e:
        print(f"An error occurred: {e}")
        if board.is_prepared():
            board.release_session()



if __name__ == "__main__":
    main()
