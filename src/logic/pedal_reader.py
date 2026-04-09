import serial
from PySide6.QtCore import QObject, QRunnable, Signal, Slot


class PedalSignals(QObject):
    pedal_pressed = Signal()


class PedalReader(QRunnable):
    def __init__(self):
        super().__init__()
        self.signals = PedalSignals()
        print("Thread started")

    # button polling
    @Slot()
    def run(self):
        serial_interface = serial.Serial("/dev/ttyUSB1")
        print("serial: ", serial_interface.name)
        last_state = b"\x00"
        current_state = b"\x00"
        while True:
            current_state = serial_interface.read()
            # click done | software falling edge triggering
            if (last_state == b"\x01") and (current_state == b"\x00"):
                print("pedal pressed")
                self.signals.pedal_pressed.emit()
            last_state = current_state
