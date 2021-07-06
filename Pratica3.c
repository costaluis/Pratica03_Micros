// Definicao do valor de referencia VrefL
// Valor nao se altera na pratica
#define VREFL 0

// Valor utilizado na conversao do valor inteiro do conversor no valor analogico medido
// Representa (2^n - 1) onde n = 10 bits do conversor A/D
#define ADC_BITS 1023

// Funcao de leitura do valor inteiro produzido pelo conversor A/D
int read_ADC()
{
    int aux=0;
    // Inicia a conversao
    ADCON0.GO = 1;

    // Aguarda a conversao finalizar
    while (ADCON0.GO){}

    // Le os bits mais significativos do conversor e realiza 8 shifts para atribuir seu valor
    aux = ADRESH;
    aux <<= 8;

    // Le os bits menos significativos do conversor
    aux += ADRESL;

    // Retorna o valor inteiro lido
    return aux;
}

// Configuracao dos pinos para utilizacao no LCD
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D7 at RB3_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D4 at RB0_bit;

// Configuracao dos pinos para entrada e saida do LCD
sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D7_Direction at TRISB3_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D4_Direction at TRISB0_bit;

// Declaracao das variaveis utilizadas
float input;
int input_ADC;
char output[15];
char aux;
char VREFH;

// Funcao principal
void main()
{
    // Configura as tensoes de referencia como Vdd e Vss
    // Configura os pinos AN3, AN2, AN1 e AN0 como analagicos, restante digital
    ADCON1 = 0b00001011;

    // Utiliza o conversor alinhado a direita (MSB em ADRESH)
    // Utiliza 6 TAD e um clock proveninte do conversor
    ADCON2 = 0b10011011;

    // Inicia a utilizacao do LCD
    Lcd_Init();

    // Limpa o display
    Lcd_Cmd(_LCD_CLEAR);

    // Liga o display
    Lcd_Cmd(_LCD_TURN_ON);

    while (1)
    {
        // Configura o conversor para realizar leituras no pino AN0
        // Habilita o funcionamento do conversor A/D
        ADCON0 = 0b00000001;
        
        // Utiliza a tensao Vdd como VREFH
        // VREFH sera de 5V
        ADCON1.F4 = 0;
        VREFH = 5;

        // Chamada da subrotina de conversao
        input_ADC = read_ADC();

        // Realiza a transformacao do valor inteiro no valor analogico correspondente
        input = (((float)input_ADC) * (float)(VREFH - VREFL) + VREFL * ((float)ADC_BITS)) / ((float)ADC_BITS);

        // Limpa o display
        Lcd_Cmd(_LCD_CLEAR);

        // Realiza a conversao de float para cadeia de char para ser exibido no display
        FloatToStr(input, output);

        // Tratamento necessario para entradas de tensao menores que 1V
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

        // Tratamento necessario para entrada de tensao igual a 0V ou 5V
        if(strlen(output) ==1){
            output[1] = '.';
            output[2] = '0';
            output[3] = '0';
        }

        // Adicao da unidade de medida
        output[4] = 'V';
        output[5] = '\0';

        // Exibe o valor lido na primeira linha do display
        Lcd_Out(1, 1, output);

        // Configura o conversor para realizar leituras no pino AN1
        // Habilita o funcionamento do conversor A/D
        ADCON0 = 0b00000101;
        
        // Utiliza a tensao em AN3 como VREFH
        // VREFH sera de 1V
        ADCON1.F4 = 1;
        VREFH = 1;

        // Chamada da subrotina de conversao
        input_ADC = read_ADC();

        // Realiza a transformacao do valor inteiro no valor analogico correspondente
        input = (((float)input_ADC) * (float)(VREFH - VREFL) + VREFL * ((float)ADC_BITS)) / ((float)ADC_BITS);
        input *= 100;
        
        // Realiza a conversao de float para cadeia de char para ser exibido no display
        FloatToStr(input, output);

        // Tratamento necessario para entradas de tensao menores que 1V
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

        // Tratamento necessario para entrada de tensao igual a 0C
        if(strlen(output) ==1){
            output[1] = '.';
            output[2] = '0';
            output[3] = '0';
        }
        
        // Tratamento necessario para entrada de tensao igual a 100C
        if(strlen(output) ==3){
            output[3] = 'º';
            output[4] = 'C';
            output[5] = '\0';
        }else{
            output[4] = 'º';
            output[5] = 'C';
            output[6] = '\0';
        }

        // Exibe o valor lido no display
        Lcd_Out(2, 1, output);

        // Aguarda um periodo para display ser atualizado
        Delay_ms(300);
    }
}