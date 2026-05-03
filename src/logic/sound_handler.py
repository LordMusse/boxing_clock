import os

from PySide6.QtCore import Property, QObject, QTimer, QUrl, Signal, Slot
from PySide6.QtMultimedia import QAudioOutput, QMediaPlayer


class SoundHandler(QObject):
    # Signals
    interval_completed = Signal()
    time_updated = Signal()
    timer_complete = Signal()

    def __init__(self):
        super().__init__()
        self.player = QMediaPlayer()
        self.audio_output = QAudioOutput()
        self.audio_output.setVolume(50)
        self.player.setAudioOutput(self.audio_output)

    def beep(self):
        self.player.setSource(QUrl.fromLocalFile("./sound/beep.wav"))
        self.player.play()

    def double_beep(self):
        self.beep()
        QTimer.singleShot(200, self.beep)

    def play_music(self):
        os.system("playerctl play")

    def pause_music(self):
        os.system("playerctl pause")
