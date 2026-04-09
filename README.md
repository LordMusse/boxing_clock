# boxing clock
## Embedded pedal switch

![image](files://./img/pedal.jpg)

Built with a PIC12F683, an LM324 and a CH340 board which were found in a drawer.

Datasheet for the PIC:
https://ww1.microchip.com/downloads/en/DeviceDoc/41211D_.pdf

Datasheet for the opamp:
https://www.ti.com/lit/ds/symlink/lm324.pdf

Compiled with xc8:
https://ww1.microchip.com/downloads/aemDocuments/documents/DEV/ProductDocuments/UserGuides/MPLAB-XC8-C-Compiler-Users-Guide-for-PIC-DS50002737.pdf

With the pack(linker scripts, headers etc.):
https://packs.download.microchip.com/Microchip.PIC10-12Fxxx_DFP.1.8.184.atpack
Found at:
https://packs.download.microchip.com/

Extracted into main

Compiled as(exchange mdfp for your pack path) in the build directory
xc8-cc -mcpu=12F683 -mdfp="./Microchip.PIC10-12Fxxx_DFP.1.8.184/xc8" ../src/PIC_program/main.c

Programmed with a PICkit3 and the PICkitminus software:
https://github.com/jaka-fi/PICkitminus

## UI and timer
Built with python and QML

Mediacontrol using playerctl on linux:
https://github.com/altdesktop/playerctl
