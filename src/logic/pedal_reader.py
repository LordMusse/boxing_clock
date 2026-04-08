import serial
from PySide6.QtCore import QRunnable, Signal

class PedalReader(QRunnable):
    pedal_pressed = Signal()
    def __init__(self):
        super().__init__()

    # button polling
    def run(self):
        serial_interface = serial.Serial("/dev/ttyUSB0", 9600)
        print("serial: ", self.serial_interface.name)
        last_state = 0
        current_state = 0
        while True:
            current_state = serial_interface.read()
            #click done | software falling edge triggering
            if (last_state == 0x01) and (current_state == 0x00):
                self.pedal_pressed.emit()
            last_state = self.current_state
