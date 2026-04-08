import sys
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from logic.timer import BoxingTimer

if __name__ == "__main__":
    app = QGuiApplication()
    engine = QQmlApplicationEngine()

    #ladda timer
    boxing_timer = BoxingTimer()
    engine.rootContext().setContextProperty("boxing_timer", boxing_timer)

    # kopplar ihop motorns avstängning med aplikationens
    engine.quit.connect(app.quit)

    # ladda qmlmodulen och bryggan mellan python och qml
    engine.load('main.qml')

    root = engine.rootObjects()

    if not root:
        print("Failed to load QML")
        sys.exit(-1)

    # om systemet dödar appen dör den helt
    sys.exit(app.exec())
