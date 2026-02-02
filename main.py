import sys
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import Qt
from PySide6 import QtQuick
sys.path.append('./logic')
from config import MyConfig
from QmlIntegration import Bridge

if __name__ == "__main__":
    app = QGuiApplication()
    engine = QQmlApplicationEngine()

    #ladda configfilen till en dictionary
    config = MyConfig()

    #ladda qmlintegrationen
    qml_integration = Bridge()
    engine.rootContext().setContextProperty("qml_integration", qml_integration)

    # kopplar ihop motorns avstängning med aplikationens
    engine.quit.connect(app.quit)

    # ladda qmlmodulen och bryggan mellan python och qml
    engine.load('main.qml')

    # om systemet dödar appen dör den helt
    sys.exit(app.exec())
