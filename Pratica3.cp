#line 1 "C:/users/luis/My Documents/AplicacoesDeMicros/Pratica3/Pratica3.c"









int read_ADC()
{
 int aux;

 ADCON0.GO = 1;


 while (ADCON0.GO){}


 aux = ADRESH;
 aux <<= 8;


 aux += ADRESL;


 return aux;
}


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
int input_ADC;
char output[15];
char aux;
char VREFH;


void main()
{


 ADCON1 = 0b00001011;



 ADCON2 = 0b10011011;


 Lcd_Init();


 Lcd_Cmd(_LCD_CLEAR);


 Lcd_Cmd(_LCD_TURN_ON);

 while (1)
 {


 ADCON0 = 0b00000001;



 ADCON1.F4 = 0;
 VREFH = 5;


 input_ADC = read_ADC();


 input = (((float)input_ADC) * (float)(VREFH -  0 ) +  0  * ((float) 1023 )) / ((float) 1023 );


 Lcd_Cmd(_LCD_CLEAR);


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

 output[4] = 'V';
 output[5] = '\0';


 Lcd_Out(1, 1, output);



 ADCON0 = 0b00000101;



 ADCON1.F4 = 1;
 VREFH = 1;


 input_ADC = read_ADC();


 input = (((float)input_ADC) * (float)(VREFH -  0 ) +  0  * ((float) 1023 )) / ((float) 1023 );
 input *= 100;


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

 if(strlen(output) ==3){
 output[3] = 'º';
 output[4] = 'C';
 output[5] = '\0';
 }else{
 output[4] = 'º';
 output[5] = 'C';
 output[6] = '\0';
 }


 Lcd_Out(2, 1, output);


 Delay_ms(500);
 }
}
