# camera_qml_preview.py
import sys
import time
import threading
import cv2

from PySide6.QtCore import QObject, Signal, Property, QUrl, QTimer, QThread
from PySide6.QtGui import QGuiApplication, QImage
from PySide6.QtQml import QQmlApplicationEngine, QQmlEngine, qmlRegisterType, QmlElement
from PySide6.QtQuick import QQuickImageProvider

QML_IMPORT_NAME = "io.qt.textproperties"
QML_IMPORT_MAJOR_VERSION = 2
timers = []

class MyImageProvider(QQuickImageProvider):
    def __init__(self):
        super(MyImageProvider, self).__init__(QQuickImageProvider.Image)
        self.picture = QImage()

    def requestImage(self, s_string, p_str, size):
        return self.picture

@QmlElement
class Bridge(QObject):
    ImageChanged = Signal()
    def __init__(self):
        super().__init__()
        self.timer_1Hz = QTimer()
        self.timer_1Hz.start(1000)
        self.timer_1Hz.timeout.connect(self.load_picture_to_pixmap)
        timers.append(self.timer_1Hz)
        self.image_provider = MyImageProvider()
        self.counter = 0
        self.camera = cv2.VideoCapture(0)
        self.load_picture_to_pixmap()

    def load_picture_to_pixmap(self):
        return_value, cv_image = self.camera.read()
        height, width, channel = cv_image.shape
        print(height)
        bytes_per_line = channel * width
        q_image = QImage(cv_image.data, width, height, bytes_per_line, QImage.Format_RGB888).rgbSwapped()
        self.image_provider.picture = q_image
        self.ImageChanged.emit()

    # def load_picture_to_pixmap(self):
    #     path = "./picture" + str(self.counter%2 + 1) + ".png"
    #     cv_image = cv2.imread(path)
    #     self.counter += 1
    #     height, width, channel = cv_image.shape
    #     print(height)
    #     bytes_per_line = channel * width
    #     q_image = QImage(cv_image.data, width, height, bytes_per_line, QImage.Format_RGB888).rgbSwapped()
    #     self.image_provider.picture = q_image
    #     self.ImageChanged.emit()
    #     print("image changed to: " + path)

# ---- main ----
if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    bridge = Bridge()

    # register provider och backend
    image_provider = MyImageProvider()
#    backend = FrameBackend()
    engine.rootContext().setContextProperty("bridge", bridge)
    engine.addImageProvider("live", bridge.image_provider)

    # load qml
    engine.load("main.qml")

    root = engine.rootObjects()

    if not root:
        print("Failed to load QML")
        sys.exit(-1)

    # DU MÅSTE EXPLICIT KOPPLA EN SIGNAL I PYTHON TILL EN FUNKTION(SLOT) I QML
    bridge.ImageChanged.connect(root[0].reloaded)

    # start camera worker
#    worker = CameraWorker(provider, backend, size=(1280, 720), fps=30)
#    worker.start()

    #try:
    sys.exit(app.exec())
#    finally:
#        worker.stop()

