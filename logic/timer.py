from PySide6.QtCore import QObject Signal
from config_loader import load_config
import time

class BoxingTimer (QObject):
    def __init__(self):
        super().__init__()

        self.config = load_config("timer_settings")
        self.time_remaining = 0 #milliseconds

    time_updated = Signal()
    
    interval_completed = Signal()

    def stop_timer(self):
    
    def activate_interval_timer(self, list_of_interval_times): #in seconds
        for interval_time in list_of_interval_times:
            run_interval(interval_time)
            interval_completed.emit()

    def run_interval(self, interval_time): #in seconds
        interval_ending = time.time() + interval_time
        self.time_remaining = interval_ending
        while True:
            current_time = time.time()
            if current_time == interval_ending:
                break
            self.time_remaining = interval_ending - current_time
            sleep(self.config["timer_update_interval"])


        self.current_time = 
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

