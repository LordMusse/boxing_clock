from PySide6.QtCore import QObject, Signal, QTimer, Property
from config_loader import load_config

timers = []

class BoxingTimer (QObject):
    # Signals
    interval_completed = Signal()
    time_updated = Signal()
    timer_complete = Signal()
    
    def __init__(self):
        super().__init__()
        self.timer_1hz = QTimer()
        self.timer_1hz.start(1000)
        self.timer_1hz.timeout.connect(self.timer_tick)
        self.config = load_config("timer_settings")
        self.timer_active = False
        self.interval_number = 0
        self.interval = [10] #seconds
        self.interval_repetitions = 1
        self.seconds_remaining = 0 #seconds

    # Slots
    def get_time_remaining(self):
        return "{0}:{1}".format(self.seconds_remaining//60, self.seconds_remaining%60)

    # Properties
    time_remaining_property = Property(str, get_time_remaining, notify=time_updated)

    # Methods
    def start_interval(self):
        print("starting interval")
        self.timer_active = True
        self.seconds_remaining = self.interval[self.interval_number%len(self.interval)]

    def reset_timer(self):
        self.interval_number = 0
    
    def stop_timer(self):
        self.timer_active = False
        self.reset_timer()

    def timer_tick(self):
        if self.timer_active:
            if self.seconds_remaining > 0:
                self.seconds_remaining -= 1
            # Interval completed
            else: 
                self.interval_completed.emit()
                self.interval_number = self.interval_number + 1
                if self.interval_number/len(self.interval):
                    self.timer_complete.emit()
                    self.stop_timer()
                else:
                    self.start_interval()

            self.time_updated.emit()
        else:
            pass

if __name__ == "__main__":
    import sys
    from PySide6.QtCore import QCoreApplication
    
    app = QCoreApplication()

    print("initiating timer")
    boxing_timer = BoxingTimer()

    def print_time():
        print(boxing_timer.time_remaining_property)
    
    def print_interval():
        print("interval done")
    
    def wait_for_restart():
        print("restarting")
        boxing_timer.reset_timer()
        boxing_timer.start_interval()

    print("starting interval")
    boxing_timer.start_interval()
    print("connecting signal")
    boxing_timer.time_updated.connect(print_time)
    boxing_timer.interval_completed.connect(print_interval)
    boxing_timer.timer_complete.connect(wait_for_restart)

    app.exec()
