import sys
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import *
import time

class Thread(QThread):
    def __init__(self):
        QThread.__init__(self)

    def run(self):
        thread_function()
        self.exec()

timers = []

def thread_function():
    print("Thread works")
    timer = QTimer()
    timer.timeout.connect(print_stuff)
    timer.start(1000)
    print(timer.remainingTime())
    print(timer.isActive())
    # timer gets destroyed when this function finishes unless i save a reference somewhere
    timers.append(timer)

def print_stuff():
    print("Timer works")
    print(time.time())

class Thread2(QThread):
    def __init__(self):
        QThread.__init__(self)

    def run(self):
        thread_function2()
        self.exec()

def thread_function2():
    for i in range(20):
        print("hjälp mig")
        time.sleep(0.3)

app = QCoreApplication(sys.argv)
#engine = QQmlApplicationEngine()

thing = Thread()

thing.start()

thang = Thread2()

thang.start()

# om systemet dödar appen dör den helt
sys.exit(app.exec())
