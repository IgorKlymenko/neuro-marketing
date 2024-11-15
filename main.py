from pylsl import StreamInlet, resolve_stream
import time

# Resolve an EEG stream on the network
streams = resolve_stream('type', 'EEG')

# Create a new inlet to read from the stream
inlet = StreamInlet(streams[0])

while True:
    sample, timestamp = inlet.pull_sample()
    print(f"Sample: {sample}, Timestamp: {timestamp}")
    time.sleep(3)
