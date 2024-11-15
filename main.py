from pylsl import StreamInlet, resolve_stream
import time

# Resolve an EEG stream on the network
streams = resolve_stream('type', 'EEG')

# Create a new inlet to read from the stream
inlet = StreamInlet(streams[0])

while True:
    sample, timestamp = inlet.pull_sample()
    tp9 = sample[0]
    af7 = sample[1]
    af8 = sample[2]
    tp10 = sample[3]
    print("----------------")
    print("tp9: " + str(tp9), "af7: "+ str(af7), "af8: "+ str(af8), "tp10: "+ str(tp10))
    print(timestamp)
    print("----------------")
    time.sleep(1)