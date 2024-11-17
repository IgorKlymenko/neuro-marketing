from fastapi import FastAPI, WebSocket
from contextlib import asynccontextmanager
import asyncio
import pandas as pd
import numpy as np
from brainflow.board_shim import BoardShim, BrainFlowInputParams, LogLevels, BoardIds
from brainflow.data_filter import DataFilter, WindowOperations

import time
# Initialize FastAPI app
app = FastAPI()

# EEG Data Buffers
band_powers_list = []

# Frequency bands
BANDS = {
    "Delta": (0.5, 4.0),
    "Theta": (4.0, 8.0),
    "Alpha": (8.0, 13.0),
    "Beta": (13.0, 30.0),
    "Gamma": (30.0, 50.0),
}

# BrainFlow connection setup
params = BrainFlowInputParams()
params.mac_address = "6B2A39A9-E7B4-28FE-856A-CCB8955DFF44"
board_id = BoardIds.MUSE_2_BOARD.value
board = BoardShim(board_id, params)

def calculate_band_powers(eeg_channels, data):
    band_powers = []
    for channel in eeg_channels:
        nfft = DataFilter.get_nearest_power_of_two(BoardShim.get_sampling_rate(board_id))

        print(data[channel])
        print(nfft)
        print(WindowOperations.HANNING.value)
        psd_welch = DataFilter.get_psd_welch(
            data[channel], nfft, nfft // 2, 
            BoardShim.get_sampling_rate(board_id), 
            WindowOperations.HANNING.value
        )
        band_powers.append({
            band: DataFilter.get_band_power(psd_welch, *freq_range)
            for band, freq_range in BANDS.items()
        })
    return band_powers

# async def collect_eeg_data():
#     BoardShim.enable_board_logger()
#     board.prepare_session()
#     board.start_stream(45000)
#     print("Started EEG data collection...")
#     time.sleep(15)
#     try:
#         data = board.get_board_data()
#         eeg_channels = BoardShim.get_eeg_channels(board_id)
#         band_powers = calculate_band_powers(eeg_channels, data)
#         band_powers_list.append(band_powers)
#         if len(band_powers_list) > 100:
#             band_powers_list.pop(0)
#         await asyncio.sleep(1)
#     finally:
#         board.stop_stream()
#         board.release_session()
#         print("Stopped EEG data collection.")

# @asynccontextmanager
# async def lifespan(app: FastAPI):
#     # Run the data collection in the background
#     asyncio.create_task(collect_eeg_data())
#     print("Lifespan started.")
#     yield
#     print("Lifespan ending...")

# app = FastAPI(lifespan=lifespan)

@app.get("/")
def read_root():
    return {"message": "Server is running!"}


@app.get("/get-band-powers")
async def get_band_powers():
    BoardShim.enable_board_logger()
    board.prepare_session()
    board.start_stream(45000)
    print("Started EEG data collection...")
    time.sleep(5)
    try:
        data = board.get_board_data()
        eeg_channels = BoardShim.get_eeg_channels(board_id)
        band_powers = calculate_band_powers(eeg_channels, data)
        band_powers_list.append(band_powers)
        if len(band_powers_list) > 100:
            band_powers_list.pop(0)
        await asyncio.sleep(1)
    finally:
        board.stop_stream()
        board.release_session()
        print("Stopped EEG data collection.")
    return {"band_powers_list": band_powers_list}

@app.websocket("/stream-band-powers")
async def stream_band_powers(websocket: WebSocket):
    await websocket.accept()
    try:
        while True:
            if band_powers_list:
                await websocket.send_json({"latest_band_powers": band_powers_list[-1]})
            await asyncio.sleep(1)  # Wait for a short time before sending again
    except Exception as e:
        print(f"Error with WebSocket: {e}")
    finally:
        await websocket.close()

import uvicorn

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)