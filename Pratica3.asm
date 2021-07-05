
_read_ADC:

;Pratica3.c,26 :: 		int read_ADC()
;Pratica3.c,29 :: 		ADCON0.GO = 1;
	BSF         ADCON0+0, 1 
;Pratica3.c,30 :: 		while (ADCON0.GO)
L_read_ADC0:
	BTFSS       ADCON0+0, 1 
	GOTO        L_read_ADC1
;Pratica3.c,32 :: 		}
	GOTO        L_read_ADC0
L_read_ADC1:
;Pratica3.c,33 :: 		aux = ADRESH;
	MOVF        ADRESH+0, 0 
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
;Pratica3.c,34 :: 		aux <<= 8;
	MOVF        R3, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R0, 0 
	MOVWF       R3 
	MOVF        R1, 0 
	MOVWF       R4 
;Pratica3.c,35 :: 		aux += ADRESL;
	MOVF        ADRESL+0, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        R0, 0 
	MOVWF       R3 
	MOVF        R1, 0 
	MOVWF       R4 
;Pratica3.c,36 :: 		return aux;
;Pratica3.c,37 :: 		}
L_end_read_ADC:
	RETURN      0
; end of _read_ADC

_main:

;Pratica3.c,39 :: 		void main()
;Pratica3.c,41 :: 		ADCON0 = 0b00000001;
	MOVLW       1
	MOVWF       ADCON0+0 
;Pratica3.c,42 :: 		ADCON1 = 0b00001011;
	MOVLW       11
	MOVWF       ADCON1+0 
;Pratica3.c,43 :: 		ADCON2 = 0b10011011;
	MOVLW       155
	MOVWF       ADCON2+0 
;Pratica3.c,45 :: 		TRISA5_bit = 1;
	BSF         TRISA5_bit+0, BitPos(TRISA5_bit+0) 
;Pratica3.c,46 :: 		adc_bits = 1023;
	MOVLW       255
	MOVWF       _adc_bits+0 
	MOVLW       3
	MOVWF       _adc_bits+1 
;Pratica3.c,47 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;Pratica3.c,48 :: 		Lcd_Cmd(_LCD_CLEAR);   // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Pratica3.c,49 :: 		Lcd_Cmd(_LCD_TURN_ON); // Cursor off
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Pratica3.c,51 :: 		while (1)
L_main2:
;Pratica3.c,53 :: 		if(PORTA.F5){
	BTFSS       PORTA+0, 5 
	GOTO        L_main4
;Pratica3.c,54 :: 		ADCON1.F4 = 1;
	BSF         ADCON1+0, 4 
;Pratica3.c,55 :: 		VREFH = 1;
	MOVLW       1
	MOVWF       _VREFH+0 
;Pratica3.c,56 :: 		}else{
	GOTO        L_main5
L_main4:
;Pratica3.c,57 :: 		ADCON1.F4 = 0;
	BCF         ADCON1+0, 4 
;Pratica3.c,58 :: 		VREFH = 5;
	MOVLW       5
	MOVWF       _VREFH+0 
;Pratica3.c,59 :: 		}
L_main5:
;Pratica3.c,62 :: 		input_ADC = read_ADC();
	CALL        _read_ADC+0, 0
	MOVF        R0, 0 
	MOVWF       _input_ADC+0 
	MOVF        R1, 0 
	MOVWF       _input_ADC+1 
;Pratica3.c,64 :: 		input = (((float)input_ADC) * (float)(VREFH - VREFL) + VREFL * ((float)adc_bits)) / ((float)adc_bits);
	CALL        _int2double+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__main+0 
	MOVF        R1, 0 
	MOVWF       FLOC__main+1 
	MOVF        R2, 0 
	MOVWF       FLOC__main+2 
	MOVF        R3, 0 
	MOVWF       FLOC__main+3 
	MOVF        _VREFH+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVF        FLOC__main+0, 0 
	MOVWF       R4 
	MOVF        FLOC__main+1, 0 
	MOVWF       R5 
	MOVF        FLOC__main+2, 0 
	MOVWF       R6 
	MOVF        FLOC__main+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__main+0 
	MOVF        R1, 0 
	MOVWF       FLOC__main+1 
	MOVF        R2, 0 
	MOVWF       FLOC__main+2 
	MOVF        R3, 0 
	MOVWF       FLOC__main+3 
	MOVF        _adc_bits+0, 0 
	MOVWF       R0 
	MOVF        _adc_bits+1, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	MOVF        FLOC__main+2, 0 
	MOVWF       R2 
	MOVF        FLOC__main+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _input+0 
	MOVF        R1, 0 
	MOVWF       _input+1 
	MOVF        R2, 0 
	MOVWF       _input+2 
	MOVF        R3, 0 
	MOVWF       _input+3 
;Pratica3.c,66 :: 		FloatToStr(input, output);
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _output+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_output+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;Pratica3.c,68 :: 		if(strlen(output) > 8){
	MOVLW       _output+0
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(_output+0)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVLW       128
	MOVWF       R2 
	MOVLW       128
	XORWF       R1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main13
	MOVF        R0, 0 
	SUBLW       8
L__main13:
	BTFSC       STATUS+0, 0 
	GOTO        L_main6
;Pratica3.c,69 :: 		if(output[strlen(output)-1]=='1'){
	MOVLW       _output+0
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(_output+0)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVLW       1
	SUBWF       R0, 1 
	MOVLW       0
	SUBWFB      R1, 1 
	MOVLW       _output+0
	ADDWF       R0, 0 
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(_output+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_main7
;Pratica3.c,70 :: 		aux = output[2];
	MOVF        _output+2, 0 
	MOVWF       _aux+0 
;Pratica3.c,71 :: 		output[2] = output[0];
	MOVF        _output+0, 0 
	MOVWF       _output+2 
;Pratica3.c,72 :: 		output[0] = '0';
	MOVLW       48
	MOVWF       _output+0 
;Pratica3.c,73 :: 		output[3] = aux;
	MOVF        _aux+0, 0 
	MOVWF       _output+3 
;Pratica3.c,74 :: 		}
	GOTO        L_main8
L_main7:
;Pratica3.c,76 :: 		output[3] = output[0];
	MOVF        _output+0, 0 
	MOVWF       _output+3 
;Pratica3.c,77 :: 		output[0] = '0';
	MOVLW       48
	MOVWF       _output+0 
;Pratica3.c,78 :: 		output[2] = '0';
	MOVLW       48
	MOVWF       _output+2 
;Pratica3.c,80 :: 		}
L_main8:
;Pratica3.c,81 :: 		}
L_main6:
;Pratica3.c,83 :: 		if(strlen(output) ==1){
	MOVLW       _output+0
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(_output+0)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main14
	MOVLW       1
	XORWF       R0, 0 
L__main14:
	BTFSS       STATUS+0, 2 
	GOTO        L_main9
;Pratica3.c,84 :: 		output[1] = '.';
	MOVLW       46
	MOVWF       _output+1 
;Pratica3.c,85 :: 		output[2] = '0';
	MOVLW       48
	MOVWF       _output+2 
;Pratica3.c,86 :: 		output[3] = '0';
	MOVLW       48
	MOVWF       _output+3 
;Pratica3.c,87 :: 		}
L_main9:
;Pratica3.c,90 :: 		output[4] = 'º';
	MOVLW       186
	MOVWF       _output+4 
;Pratica3.c,91 :: 		output[5] = 'C';
	MOVLW       67
	MOVWF       _output+5 
;Pratica3.c,92 :: 		output[6] = '\0';
	CLRF        _output+6 
;Pratica3.c,94 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Pratica3.c,95 :: 		Lcd_Out(1, 1, output);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _output+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_output+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pratica3.c,96 :: 		Delay_ms(500);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main10:
	DECFSZ      R13, 1, 1
	BRA         L_main10
	DECFSZ      R12, 1, 1
	BRA         L_main10
	DECFSZ      R11, 1, 1
	BRA         L_main10
	NOP
	NOP
;Pratica3.c,97 :: 		}
	GOTO        L_main2
;Pratica3.c,98 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
