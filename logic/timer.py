from PySide6.QtCore import QObject, QTimer, Signal
from config_loader import load_config
import time

class BoxingTimer (QObject):
    def __init__(self):
        super().__init__()

        self.config = load_config("timer_settings")
        self.current_time = 0 #milliseconds
        self.current_interval = 0
        self.timer_active = False
        self.base_timer()

    def base_timer(self):
        timer = QTimer(self)
        timer.timeout.connect(self.update_timer)
        timer.start(self.config["timer_update_interval"])

    time_updated = Signal()

    def update_timer(self):
        if timer_active:
            current_time + self.config["timer_update_interval"]
            time_updated.emit()
            print("time incremented")
        else:
            print("Timer is inactive")
    
    def activate_timer(self, minutes, seconds):
        self.current_time = 0
        self.timer_active = True
        self.current_interval = ((minutes * 60) + seconds) * 1000

    def start_timer(self, interval):
        timer = QTimer(self)
        timer.timeout.connect()
        timer.start(1000)

    def get_time_remaining(self):
        seconds_remaining = (self.current_interval - self.current_time)/1000
        return "{0}:{1}".format(seconds_remaining/60, seconds_remaining%60)

if __name__ == "__main__":
    import os
    timer = BoxingTimer()
    timer.activate_timer(0,30)
    while timer.current_interval > timer.current_time:
        print(timer.get_time_remaining())
        time.sleep(0.5)

