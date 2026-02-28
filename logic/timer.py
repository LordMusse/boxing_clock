from PySide6.QtCore import QObject, Signal, Slot, QTimer, Property
from logic.config_loader import load_config
from math import *

#from gpiozero import button

timers = []

class BoxingTimer (QObject):
    # Signals
    interval_completed = Signal()
    time_updated = Signal()
    timer_complete = Signal()
    
    def __init__(self):
        super().__init__()
        self.config = load_config("timer_settings")
       # button = Button(3)
       # self.timer_1000hz = QTimer()
       # self.timer_1000hz.start(1)
       # self.timer_1000hz.timeout.connect(self.button_control)
        self.timer_1hz = QTimer()
        self.timer_1hz.start(1000)
        self.timer_1hz.timeout.connect(self.timer_tick)
        self.timer_active = False
        self.interval_number = 0
        self.interval = [11, 5, 3] #seconds
        self.interval_repetitions = 1
        self.seconds_remaining = self.interval[self.interval_number] #seconds

    # Slots
    def get_time_remaining(self):
        minutes = str(self.seconds_remaining//60)
        seconds = 100 + self.seconds_remaining%60
        seconds_first_digit = str(seconds)[1]
        seconds_second_digit = str(seconds)[2]
        return "{0}:{1}{2}".format(minutes, seconds_first_digit, seconds_second_digit)

    def get_current_repetition(self):
        total_repetition = self.get_total_repetitions
        current_repetition = total_repetition - ceil(self.interval_number/total_repetition)
        print("current_repetition: {0}".format(current_repetition))
        return current_repetition

    def get_total_repetitions(self):
        return self.interval_repetitions

    def set_total_repetitions(self, repetitions):
        self.interval_repetitions = repetitions

    def get_interval_number():
        pass

    @Slot()
    def start_interval(self):
        print("starting interval timer")
        self.seconds_remaining = self.interval[self.interval_number]
        self.timer_active = True

    @Slot()
    def stop_timer(self):
        self.timer_active = False
        print("resetting...")
        self.interval_number = 0
        self.seconds_remaining = self.interval[self.interval_number]
        self.time_updated.emit()

    # Properties
    time_remaining_property = Property(str, get_time_remaining, notify=time_updated)
    total_repetitions_property = Property(int, get_total_repetitions, set_total_repetitions, notify=interval_completed)
    current_repetition_property = Property(int, get_current_repetition, notify=interval_completed)

    # Methods
    def timer_tick(self):
        if self.timer_active:
            if self.seconds_remaining > 0:
                self.seconds_remaining -= 1
            else: 
                # all repetitions complete
                if self.get_current_repetition == 0:
                    self.timer_complete.emit()
                    print("timers done")
                    self.stop_timer()
                # prepare for next interval
                else:
                    self.interval_completed.emit()
                    print("interval done")
                    self.interval_number = self.interval_number + 1
                    self.start_interval()
            self.time_updated.emit()
            print(self.time_remaining_property)
        else:
            pass

#    def button_control():
#        # pressed
#        if button.value == 0:
#            if self.timer_active == True:
#                self.stop_timer
#            else:
#                self.start_interval

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
