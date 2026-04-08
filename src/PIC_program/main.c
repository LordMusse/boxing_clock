#define _XTAL_FREQ 3686400

#include <xc.h>
#include <stdint.h>

// BEGIN CONFIG
#pragma config FOSC = HS // Oscillator Selection bits (HS oscillator)
#pragma config WDTE = OFF // Watchdog Timer Enable bit (WDT enabled)
#pragma config PWRTE = OFF // Power-up Timer Enable bit (PWRT disabled)
#pragma config BOREN = OFF // Brown-out Reset Enable bit (BOR enabled)
//#pragma config LVP = OFF // Low-Voltage (Single-Supply) In-Circuit Serial Programming Enable bit (RB3 is digital I/O, HV on MCLR must be used for programming)
#pragma config CPD = OFF // Data EEPROM Memory Code Protection bit (Data EEPROM code protection off)
//#pragma config WRT = OFF // Flash Program Memory Write Enable bits (Write protection off; all program memory may be written to by EECON control)
#pragma config CP = OFF // Flash Program Memory Code Protection bit (Code protection off)
//END CONFIG

#define SERIAL_TX GP0
#define LED GP1
#define BUTTON GP2
//9600 baudrate with code delays
#define SERIAL_DELAY 68

void setup(void);
void data_submit(uint8_t data);
void send_word_serial(uint8_t word);

void main() {
  setup();
  uint8_t button_status = BUTTON;
  while(1)
  {
    button_status = BUTTON;
    LED = button_status & 0x01;
    send_word_serial(button_status);
  }
}

void setup(void) {
  ADCON0 = 0b00000000; //Internal ADC off
  ANSEL = 0b00000000; //turn all analog pins to digital
  CMCON0 = 0b00000111; //turn off comparators (needed for digital I/O)
  VRCON = 0b00000000; // shut off all voltage references
  TRISIO = 0b11111100; //GP1 and GP0 as Output PIN and rest as high impedance input
  GPIO = 0; //set all GPIO LOW
}

void send_word_serial(uint8_t data) {
  SERIAL_TX = 0; //startbit
  __delay_us(SERIAL_DELAY);
  for (uint8_t i = 0; i < 8; i++) {
    SERIAL_TX = (data >> i) & 0x01;
    __delay_us(SERIAL_DELAY);
  }
  SERIAL_TX = 1; //stopbit
  __delay_us(SERIAL_DELAY);
}
