// Definição do valor de referência VrefL
// Valor não se altera na prática
#define VREFL 0

// Valor utilizado na conversão do valor inteiro do conversor no valor analógico medido
// Representa (2^n - 1) onde n = 10 bits do conversor A/D
#define ADC_BITS 1023

// Função de leitura do valor inteiro produzido pelo conversor A/D
int read_ADC()
{
    int aux=0;
    // Inicia a conversão
    ADCON0.GO = 1;

    // Aguarda a conversão finalizar
    while (ADCON0.GO){}

    // Lê os bits mais significativos do conversor e realiza 8 shifts para atribuir seu valor
    aux = ADRESH;
    aux <<= 8;

    // Lê os bits menos significativos do conversor
    aux += ADRESL;

    // Retorna o valor inteiro lido
    return aux;
}

// Configuração dos pinos para utilização no LCD
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D7 at RB3_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D4 at RB0_bit;

// Configuração dos pinos para entrada e saída do LCD
sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D7_Direction at TRISB3_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D4_Direction at TRISB0_bit;

// Declaração das variáveis utilizadas
float input;
int input_ADC;
char output[15];
char aux;
char VREFH;

// Função principal
void main()
{
    // Configura as tensões de referência como Vdd e Vss
    // Configura os pinos AN3, AN2, AN1 e AN0 como analógicos, restante digital
    ADCON1 = 0b00001011;

    // Utiliza o conversor alinhado à direita (MSB em ADRESH)
    // Utiliza 6 TAD e um clock proveninte do oscilador
    ADCON2 = 0b10011011;

    // Inicia a utilização do LCD
    Lcd_Init();

    // Limpa o display
    Lcd_Cmd(_LCD_CLEAR);   // Clear display

    // Liga o display
    Lcd_Cmd(_LCD_TURN_ON); // Cursor off

    while (1)
    {
        // Configura o conversor para realizar leituras no pino AN0
        // Habilita o funcionamento do conversor A/D
        ADCON0 = 0b00000001;
        
        // Utiliza a tensão Vdd como VREFH
        // VREFH será de 5V
        ADCON1.F4 = 0;
        VREFH = 5;

        // Chamada da subrotina de conversão
        input_ADC = read_ADC();

        // Realiza a transformação do valor inteiro no valor analógico correspondente
        input = (((float)input_ADC) * (float)(VREFH - VREFL) + VREFL * ((float)ADC_BITS)) / ((float)ADC_BITS);

        // Limpa o display
        Lcd_Cmd(_LCD_CLEAR);

        // Realiza a conversão de float para char para ser exibido no display
        FloatToStr(input, output);

        // Tratamento necessário para entradas de tensão menores que 1V
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

        // Tratamento necessário para entrada de tensão igual a 0V ou 5V
        if(strlen(output) ==1){
            output[1] = '.';
            output[2] = '0';
            output[3] = '0';
        }

        output[4] = 'V';
        output[5] = '\0';

        // Exibe o valor lido no display
        Lcd_Out(1, 1, output);

        // Configura o conversor para realizar leituras no pino AN1
        // Habilita o funcionamento do conversor A/D
        ADCON0 = 0b00000101;
        
        // Utiliza a tensão em AN3 como VREFH
        // VREFH será de 1V
        ADCON1.F4 = 1;
        VREFH = 1;

        // Chamada da subrotina de conversão
        input_ADC = read_ADC();

        // Realiza a transformação do valor inteiro no valor analógico correspondente
        input = (((float)input_ADC) * (float)(VREFH - VREFL) + VREFL * ((float)ADC_BITS)) / ((float)ADC_BITS);
        input *= 100;
        
        // Realiza a conversão de float para char para ser exibido no display
        FloatToStr(input, output);

        // Tratamento necessário para entradas de tensão menores que 1V
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

        // Tratamento necessário para entrada de tensão igual a 0C
        if(strlen(output) ==1){
            output[1] = '.';
            output[2] = '0';
            output[3] = '0';
        }
        
        if(strlen(output) ==3){
            output[3] = '�';
            output[4] = 'C';
            output[5] = '\0';
        }else{
            output[4] = '�';
            output[5] = 'C';
            output[6] = '\0';
        }

        // Exibe o valor lido no display
        Lcd_Out(2, 1, output);

        // Aguarda um período para display ser atualizado
        Delay_ms(500);
    }
}