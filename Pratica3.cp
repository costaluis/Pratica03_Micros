#line 1 "C:/users/luis/My Documents/AplicacoesDeMicros/Pratica3/Pratica3.c"




sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D7 at RB3_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D4 at RB0_bit;


sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D7_Direction at TRISB3_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D4_Direction at TRISB0_bit;

float input;
int input_ADC, adc_bits;
char output[15];
char aux;
char VREFH;

int read_ADC()
{
 int aux;
 ADCON0.GO = 1;
 while (ADCON0.GO)
 {
 }
 aux = ADRESH;
 aux <<= 8;
 aux += ADRESL;
 return aux;
}

void main()
{
 ADCON0 = 0b00000001;
 ADCON1 = 0b00001011;
 ADCON2 = 0b10011011;

 TRISA5_bit = 1;
 adc_bits = 1023;
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_TURN_ON);

 while (1)
 {
 if(PORTA.F5){
 ADCON1.F4 = 1;
 VREFH = 1;
 }else{
 ADCON1.F4 = 0;
 VREFH = 5;
 }


 input_ADC = read_ADC();

 input = (((float)input_ADC) * (float)(VREFH -  0 ) +  0  * ((float)adc_bits)) / ((float)adc_bits);

 FloatToStr(input, output);

 if(strlen(output) > 8){
 if(output[strlen(output)-1]=='1'){
 aux = output[2];
 output[2] = output[0];
 output[0] = '0';
 output[3] = aux;
 }
 else{
 output[3] = output[0];
 output[0] = '0';
 output[2] = '0';

 }
 }

 if(strlen(output) ==1){
 output[1] = '.';
 output[2] = '0';
 output[3] = '0';
 }


 output[4] = 'º';
 output[5] = 'C';
 output[6] = '\0';

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, output);
 Delay_ms(500);
 }
}
