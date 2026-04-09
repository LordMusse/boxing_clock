import sys
import time

from PySide6.QtCore import QThreadPool
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from logic.pedal_reader import PedalReader
from logic.timer import BoxingTimer

if __name__ == "__main__":
    app = QGuiApplication()
    engine = QQmlApplicationEngine()

    # ladda timer
    boxing_timer = BoxingTimer()
    engine.rootContext().setContextProperty("boxing_timer", boxing_timer)

    # ladda pedalläsaren
    pedal_reader = PedalReader()
    threadpool = QThreadPool()
    threadpool.start(pedal_reader)

    pedal_reader.signals.pedal_pressed.connect(boxing_timer.pedal_pressed)

    # kopplar ihop motorns avstängning med aplikationens
    engine.quit.connect(app.quit)

    # ladda qmlmodulen och bryggan mellan python och qml
    engine.load("main.qml")

    root = engine.rootObjects()

    if not root:
        print("Failed to load QML")
        sys.exit(-1)

    # om systemet dödar appen dör den helt
    print("starting app")
    sys.exit(app.exec())
