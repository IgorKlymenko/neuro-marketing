# Usage:
- pip install muselsl
  pip install pylsl
- muselsl stream
- python main.py



# Some Simple Science

## How to Analyze EEG

### Big Picture
You decompose the data into distinct frequency bands:
- delta (0.5-4 Hz)
- theta (4-8 Hz)
- alpha (8-12 Hz)
- beta (12-30 Hz)
- gamma (30-100 Hz)

The decomposition is usually achieved through the **(Fast) Fourier Transforms (FFT)**, in simple language - the amplitude of specific frequency

Additionaly **magnitude-squared** is taken from the FFT to calculate **power spectral density (periodogram)** expressed in (micro)-Volts^2 per Hertz for EEG.

### What we do
For simplicity we use **average band power** - in simple language - contribution of the given fr band to the oberall power of the signal.

Not surprisingly, we can calculate the **Relative Band Power** dividing ave band power by total power.

### What Matters
1. We can find the relative band power (amount of contribution)
2. We can compare band powers and conclude (ex. delta / beta ratio is a well-known index of slow-wave sleep quality)

### What does not matter (for now)
Average bandpower using Multitaper methods - way too complicated - have spent wuite a bit tof time
I feel that it is unnecessary not working when we are already using brainflow API


