from math import *

from PySide6.QtCore import Property, QObject, QTimer, Signal, Slot

from logic.config_loader import load_config
from logic.sound_handler import SoundHandler

timers = []


class BoxingTimer(QObject):
    # Signals
    interval_completed = Signal()
    time_updated = Signal()
    timer_complete = Signal()
    timer_active_signal = Signal()
    time_to_rest_signal = Signal()

    def __init__(self):
        super().__init__()
        self.config = load_config("timer_settings")
        self.sound_handler = SoundHandler()
        self.timer_1hz = QTimer()
        self.timer_1hz.start(1000)
        self.timer_1hz.timeout.connect(self.timer_tick)
        self.timer_active = False
        self.interval_number = 0
        self.interval = [11, 5]  # seconds
        self.interval_repetitions = 4
        self.seconds_remaining = self.interval[self.interval_number]  # seconds
        self.time_to_rest = False

    # Slots
    def get_time_remaining(self):
        minutes = str(self.seconds_remaining // 60)
        seconds = 100 + self.seconds_remaining % 60
        seconds_first_digit = str(seconds)[1]
        seconds_second_digit = str(seconds)[2]
        return "{0}:{1}{2}".format(minutes, seconds_first_digit, seconds_second_digit)

    @Slot()
    def get_timer_active(self):
        return self.timer_active

    def get_current_repetition(self):
        current_repetition = self.interval_repetitions - ceil(
            self.interval_number / self.interval_repetitions
        )
        print("current_repetition: {0}".format(current_repetition))
        return current_repetition

    def get_total_repetitions(self):
        return self.interval_repetitions // 2

    def set_total_repetitions(self, repetitions):
        self.interval_repetitions = repetitions * 2

    def get_interval_number(self):
        return self.interval_number

    def get_time_to_rest(self):
        return self.time_to_rest

    @Slot()
    def start_interval(self):
        print("starting interval timer")
        self.seconds_remaining = self.interval[
            self.interval_number % len(self.interval)
        ]
        self.timer_active = True
        self.timer_active_signal.emit()

    @Slot()
    def stop_timer(self):
        self.timer_active = False
        self.timer_active_signal.emit()
        print("resetting...")
        self.interval_number = 0
        self.seconds_remaining = self.interval[
            self.interval_number % len(self.interval)
        ]
        self.time_updated.emit()
        self.sound_handler.pause_music()

    @Slot()
    def pedal_pressed(self):
        if self.timer_active == True:
            self.stop_timer()
        else:
            self.start_interval()

    # Properties
    time_remaining_property = Property(str, get_time_remaining, notify=time_updated)
    total_repetitions_property = Property(
        int, get_total_repetitions, set_total_repetitions, notify=interval_completed
    )
    current_repetition_property = Property(
        int, get_current_repetition, notify=interval_completed
    )
    timer_active_property = Property(bool, get_timer_active, notify=timer_active_signal)
    time_to_rest_property = Property(bool, get_time_to_rest, notify=time_to_rest_signal)

    # Methods
    def timer_tick(self):
        if self.timer_active:
            self.seconds_remaining -= 1
            match self.seconds_remaining:
                case 2:
                    self.sound_handler.beep()
                case 1:
                    self.sound_handler.beep()
                case 0:
                    self.end_of_repetition()
            self.time_updated.emit()
            print(self.time_remaining_property)
        else:
            return

    def end_of_repetition(self):
        # if all is done
        self.interval_number += 1
        for i in range(3):
            self.sound_handler.beep()
        if self.interval_number >= self.interval_repetitions:
            self.stop_timer
            self.timer_complete.emit()
        # even intervals are work now
        elif self.interval_number % 2 == 0:
            self.time_to_rest = False
            self.time_to_rest_signal.emit()
            self.sound_handler.play_music()
            self.start_interval()
        # prepare rest
        else:
            self.time_to_rest = True
            self.time_to_rest_signal.emit()
            self.sound_handler.pause_music()
            self.start_interval()


if __name__ == "__main__":
    import sys

    from PySide6.QtCore import QCoreApplication

    app = QCoreApplication()

    print("initiating timer")
    boxing_timer = BoxingTimer()

    def wait_for_restart():
        print("press any key to restart")
        input()
        boxing_timer.start_interval()

    boxing_timer.start_interval()
    print("connecting signals")
    boxing_timer.timer_complete.connect(wait_for_restart)

    app.exec()
