import os
import threading
import wave

import numpy as np
import sounddevice as sd
from PySide6.QtCore import Property, QObject, QTimer, Signal, Slot


class SoundHandler(QObject):
    interval_completed = Signal()
    time_updated = Signal()
    timer_complete = Signal()

    def __init__(self):
        super().__init__()
        self._beep_data, sample_rate, channels = self._load_wav("./sound/beep.wav")
        self._active_sounds = []
        self._lock = threading.Lock()
        self._stream = sd.OutputStream(
            samplerate=sample_rate,
            channels=channels,
            dtype="float32",
            callback=self._audio_callback,
            blocksize=512,
        )
        self._stream.start()

    def _load_wav(self, path):
        with wave.open(path) as wav_file:
            sample_rate = wav_file.getframerate()
            channels = wav_file.getnchannels()
            frames = wav_file.readframes(wav_file.getnframes())
        data = (
            np.frombuffer(frames, dtype=np.int16)
            .reshape(-1, channels)
            .astype(np.float32)
            / 32768
            * 0.8
        )
        return data, sample_rate, channels

    def _audio_callback(self, outdata, frames, time, status):
        outdata.fill(0)
        with self._lock:
            still_active = []
            for sound, pos in self._active_sounds:
                chunk_end = min(pos + frames, len(sound))
                outdata[: chunk_end - pos] += sound[pos:chunk_end]
                if chunk_end < len(sound):
                    still_active.append([sound, chunk_end])
            self._active_sounds = still_active
        np.clip(outdata, -1.0, 1.0, out=outdata)

    def beep(self):
        with self._lock:
            self._active_sounds.append([self._beep_data, 0])

    def double_beep(self):
        self.beep()
        QTimer.singleShot(500, self.beep)

    def play_music(self):
        os.system("playerctl play")

    def pause_music(self):
        os.system("playerctl pause")
