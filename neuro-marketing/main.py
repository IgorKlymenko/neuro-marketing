from pylsl import StreamInlet, resolve_stream
import numpy as np
import time
from scipy.signal import welch, butter, filtfilt
import matplotlib.pyplot as plt
from collections import deque

# Parameters
fs = 256  # Sampling rate in Hz (adjust based on your device)
buffer_length = 0.5  # Reduced buffer length to 0.5 seconds
num_samples = int(fs * buffer_length)  # Total number of samples to collect per buffer

# Initialize plot
plt.ion()
fig, ax = plt.subplots()
line_tp9, = ax.plot([], [], label='TP9')
line_af7, = ax.plot([], [], label='AF7')
line_af8, = ax.plot([], [], label='AF8')
line_tp10, = ax.plot([], [], label='TP10')
ax.set_xlabel('Time (s)')
ax.set_ylabel('Delta Band Power (µV²)')
ax.set_title('Delta Band Power Over Time')
ax.legend()
plt.show()

# Initialize data storage
max_points = 200  # Increased number of points to display in the plot for smoother visualization
delta_powers_tp9 = deque(maxlen=max_points)
delta_powers_af7 = deque(maxlen=max_points)
delta_powers_af8 = deque(maxlen=max_points)
delta_powers_tp10 = deque(maxlen=max_points)
times = deque(maxlen=max_points)
start_time = time.time()

#Modified:
delta_powers = deque(maxlen=max_points)

# Resolve an EEG stream on the network
print("Looking for an EEG stream...")
streams = resolve_stream('type', 'EEG')

if not streams:
    print("No EEG stream found.")
    exit()

# Create a new inlet to read from the stream
inlet = StreamInlet(streams[0])

# Initialize buffers for each channel
tp9_buffer = []
af7_buffer = []
af8_buffer = []
tp10_buffer = []

print("Starting data acquisition...")

try:
    while True:
        # Collect data for the buffer length
        for _ in range(num_samples):
            sample, timestamp = inlet.pull_sample()
            tp9_buffer.append(sample[0])
            af7_buffer.append(sample[1])
            af8_buffer.append(sample[2])
            tp10_buffer.append(sample[3])

        # Convert buffers to NumPy arrays
        tp9_data = np.array(tp9_buffer)
        af7_data = np.array(af7_buffer)
        af8_data = np.array(af8_buffer)
        tp10_data = np.array(tp10_buffer)

        # Apply bandpass filter to remove noise outside the EEG frequency range
        def bandpass_filter(data, lowcut, highcut, fs, order=4):
            nyquist = 0.5 * fs
            low = lowcut / nyquist
            high = highcut / nyquist
            b, a = butter(order, [low, high], btype='band')
            y = filtfilt(b, a, data)
            return y

        lowcut = 0.5
        highcut = 50.0
        tp9_data = bandpass_filter(tp9_data, lowcut, highcut, fs)
        af7_data = bandpass_filter(af7_data, lowcut, highcut, fs)
        af8_data = bandpass_filter(af8_data, lowcut, highcut, fs)
        tp10_data = bandpass_filter(tp10_data, lowcut, highcut, fs)

        # Function to compute band powers
        def compute_band_powers(data, fs):
            # Compute the Power Spectral Density (PSD)
            freqs, psd = welch(data, fs, nperseg=len(data))

            # Define frequency bands
            bands = {
                'Delta': (0.5, 4),
                'Theta': (4, 8),
                'Alpha': (8, 13),
                'Beta': (13, 30),
                'Gamma': (30, 50)
            }

            band_powers = {}
            for band_name, (low, high) in bands.items():
                # Find indices corresponding to the frequency band
                idx_band = np.logical_and(freqs >= low, freqs <= high)
                # Integrate the PSD over the frequency band
                band_power = np.trapz(psd[idx_band], freqs[idx_band])
                band_powers[band_name] = band_power
            return band_powers

        # Compute band powers for each channel
        tp9_band_powers = compute_band_powers(tp9_data, fs)
        af7_band_powers = compute_band_powers(af7_data, fs)
        af8_band_powers = compute_band_powers(af8_data, fs)
        tp10_band_powers = compute_band_powers(tp10_data, fs)

        # Get current time
        current_time = time.time() - start_time
        times.append(current_time)

        # Store Delta band power
        delta_powers_tp9.append(tp9_band_powers['Delta'])
        delta_powers_af7.append(af7_band_powers['Delta'])
        delta_powers_af8.append(af8_band_powers['Delta'])
        delta_powers_tp10.append(tp10_band_powers['Delta'])

        #Modified:
        delta_powers.append(tp9_band_powers['Delta'] + af7_band_powers['Delta'] + af8_band_powers['Delta'] + tp10_band_powers['Delta'])

        # Update plot
        line_tp9.set_data(times, delta_powers_tp9)
        line_af7.set_data(times, delta_powers_af7)
        line_af8.set_data(times, delta_powers_af8)
        line_tp10.set_data(times, delta_powers_tp10)
        ax.relim()
        ax.autoscale_view()
        plt.pause(0.001)  # Decreased pause time for faster updates

        # Clear buffers
        tp9_buffer.clear()
        af7_buffer.clear()
        af8_buffer.clear()
        tp10_buffer.clear()

except KeyboardInterrupt:
    print("Data acquisition stopped.")