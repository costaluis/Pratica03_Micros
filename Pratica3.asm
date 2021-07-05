
_read_ADC:

;Pratica3.c,10 :: 		int read_ADC()
;Pratica3.c,14 :: 		ADCON0.GO = 1;
	BSF         ADCON0+0, 1 
;Pratica3.c,17 :: 		while (ADCON0.GO){}
L_read_ADC0:
	BTFSS       ADCON0+0, 1 
	GOTO        L_read_ADC1
	GOTO        L_read_ADC0
L_read_ADC1:
;Pratica3.c,20 :: 		aux = ADRESH;
	MOVF        ADRESH+0, 0 
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
;Pratica3.c,21 :: 		aux <<= 8;
	MOVF        R3, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R0, 0 
	MOVWF       R3 
	MOVF        R1, 0 
	MOVWF       R4 
;Pratica3.c,24 :: 		aux += ADRESL;
	MOVF        ADRESL+0, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        R0, 0 
	MOVWF       R3 
	MOVF        R1, 0 
	MOVWF       R4 
;Pratica3.c,27 :: 		return aux;
;Pratica3.c,28 :: 		}
L_end_read_ADC:
	RETURN      0
; end of _read_ADC

_main:

;Pratica3.c,54 :: 		void main()
;Pratica3.c,58 :: 		ADCON1 = 0b00001011;
	MOVLW       11
	MOVWF       ADCON1+0 
;Pratica3.c,62 :: 		ADCON2 = 0b10011011;
	MOVLW       155
	MOVWF       ADCON2+0 
;Pratica3.c,65 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;Pratica3.c,68 :: 		Lcd_Cmd(_LCD_CLEAR);   // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Pratica3.c,71 :: 		Lcd_Cmd(_LCD_TURN_ON); // Cursor off
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Pratica3.c,73 :: 		while (1)
L_main2:
;Pratica3.c,77 :: 		ADCON0 = 0b00000001;
	MOVLW       1
	MOVWF       ADCON0+0 
;Pratica3.c,81 :: 		ADCON1.F4 = 0;
	BCF         ADCON1+0, 4 
;Pratica3.c,82 :: 		VREFH = 5;
	MOVLW       5
	MOVWF       _VREFH+0 
;Pratica3.c,85 :: 		input_ADC = read_ADC();
	CALL        _read_ADC+0, 0
	MOVF        R0, 0 
	MOVWF       _input_ADC+0 
	MOVF        R1, 0 
	MOVWF       _input_ADC+1 
;Pratica3.c,88 :: 		input = (((float)input_ADC) * (float)(VREFH - VREFL) + VREFL * ((float)ADC_BITS)) / ((float)ADC_BITS);
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
	MOVLW       0
	MOVWF       R4 
	MOVLW       192
	MOVWF       R5 
	MOVLW       127
	MOVWF       R6 
	MOVLW       136
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _input+0 
	MOVF        R1, 0 
	MOVWF       _input+1 
	MOVF        R2, 0 
	MOVWF       _input+2 
	MOVF        R3, 0 
	MOVWF       _input+3 
;Pratica3.c,91 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Pratica3.c,94 :: 		FloatToStr(input, output);
	MOVF        _input+0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        _input+1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        _input+2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        _input+3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _output+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_output+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;Pratica3.c,97 :: 		if(strlen(output) > 8){
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
	GOTO        L__main17
	MOVF        R0, 0 
	SUBLW       8
L__main17:
	BTFSC       STATUS+0, 0 
	GOTO        L_main4
;Pratica3.c,98 :: 		if(output[strlen(output)-1]=='1'){
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
	GOTO        L_main5
;Pratica3.c,99 :: 		aux = output[2];
	MOVF        _output+2, 0 
	MOVWF       _aux+0 
;Pratica3.c,100 :: 		output[2] = output[0];
	MOVF        _output+0, 0 
	MOVWF       _output+2 
;Pratica3.c,101 :: 		output[0] = '0';
	MOVLW       48
	MOVWF       _output+0 
;Pratica3.c,102 :: 		output[3] = aux;
	MOVF        _aux+0, 0 
	MOVWF       _output+3 
;Pratica3.c,103 :: 		}
	GOTO        L_main6
L_main5:
;Pratica3.c,105 :: 		output[3] = output[0];
	MOVF        _output+0, 0 
	MOVWF       _output+3 
;Pratica3.c,106 :: 		output[0] = '0';
	MOVLW       48
	MOVWF       _output+0 
;Pratica3.c,107 :: 		output[2] = '0';
	MOVLW       48
	MOVWF       _output+2 
;Pratica3.c,109 :: 		}
L_main6:
;Pratica3.c,110 :: 		}
L_main4:
;Pratica3.c,113 :: 		if(strlen(output) ==1){
	MOVLW       _output+0
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(_output+0)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main18
	MOVLW       1
	XORWF       R0, 0 
L__main18:
	BTFSS       STATUS+0, 2 
	GOTO        L_main7
;Pratica3.c,114 :: 		output[1] = '.';
	MOVLW       46
	MOVWF       _output+1 
;Pratica3.c,115 :: 		output[2] = '0';
	MOVLW       48
	MOVWF       _output+2 
;Pratica3.c,116 :: 		output[3] = '0';
	MOVLW       48
	MOVWF       _output+3 
;Pratica3.c,117 :: 		}
L_main7:
;Pratica3.c,119 :: 		output[4] = 'V';
	MOVLW       86
	MOVWF       _output+4 
;Pratica3.c,120 :: 		output[5] = '\0';
	CLRF        _output+5 
;Pratica3.c,123 :: 		Lcd_Out(1, 1, output);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _output+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_output+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pratica3.c,127 :: 		ADCON0 = 0b00000101;
	MOVLW       5
	MOVWF       ADCON0+0 
;Pratica3.c,131 :: 		ADCON1.F4 = 1;
	BSF         ADCON1+0, 4 
;Pratica3.c,132 :: 		VREFH = 1;
	MOVLW       1
	MOVWF       _VREFH+0 
;Pratica3.c,135 :: 		input_ADC = read_ADC();
	CALL        _read_ADC+0, 0
	MOVF        R0, 0 
	MOVWF       _input_ADC+0 
	MOVF        R1, 0 
	MOVWF       _input_ADC+1 
;Pratica3.c,138 :: 		input = (((float)input_ADC) * (float)(VREFH - VREFL) + VREFL * ((float)ADC_BITS)) / ((float)ADC_BITS);
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
	MOVLW       0
	MOVWF       R4 
	MOVLW       192
	MOVWF       R5 
	MOVLW       127
	MOVWF       R6 
	MOVLW       136
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _input+0 
	MOVF        R1, 0 
	MOVWF       _input+1 
	MOVF        R2, 0 
	MOVWF       _input+2 
	MOVF        R3, 0 
	MOVWF       _input+3 
;Pratica3.c,139 :: 		input *= 100;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       72
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _input+0 
	MOVF        R1, 0 
	MOVWF       _input+1 
	MOVF        R2, 0 
	MOVWF       _input+2 
	MOVF        R3, 0 
	MOVWF       _input+3 
;Pratica3.c,142 :: 		FloatToStr(input, output);
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
;Pratica3.c,145 :: 		if(strlen(output) > 8){
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
	GOTO        L__main19
	MOVF        R0, 0 
	SUBLW       8
L__main19:
	BTFSC       STATUS+0, 0 
	GOTO        L_main8
;Pratica3.c,146 :: 		if(output[strlen(output)-1]=='1'){
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
	GOTO        L_main9
;Pratica3.c,147 :: 		aux = output[2];
	MOVF        _output+2, 0 
	MOVWF       _aux+0 
;Pratica3.c,148 :: 		output[2] = output[0];
	MOVF        _output+0, 0 
	MOVWF       _output+2 
;Pratica3.c,149 :: 		output[0] = '0';
	MOVLW       48
	MOVWF       _output+0 
;Pratica3.c,150 :: 		output[3] = aux;
	MOVF        _aux+0, 0 
	MOVWF       _output+3 
;Pratica3.c,151 :: 		}
	GOTO        L_main10
L_main9:
;Pratica3.c,153 :: 		output[3] = output[0];
	MOVF        _output+0, 0 
	MOVWF       _output+3 
;Pratica3.c,154 :: 		output[0] = '0';
	MOVLW       48
	MOVWF       _output+0 
;Pratica3.c,155 :: 		output[2] = '0';
	MOVLW       48
	MOVWF       _output+2 
;Pratica3.c,157 :: 		}
L_main10:
;Pratica3.c,158 :: 		}
L_main8:
;Pratica3.c,161 :: 		if(strlen(output) ==1){
	MOVLW       _output+0
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(_output+0)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main20
	MOVLW       1
	XORWF       R0, 0 
L__main20:
	BTFSS       STATUS+0, 2 
	GOTO        L_main11
;Pratica3.c,162 :: 		output[1] = '.';
	MOVLW       46
	MOVWF       _output+1 
;Pratica3.c,163 :: 		output[2] = '0';
	MOVLW       48
	MOVWF       _output+2 
;Pratica3.c,164 :: 		output[3] = '0';
	MOVLW       48
	MOVWF       _output+3 
;Pratica3.c,165 :: 		}
L_main11:
;Pratica3.c,167 :: 		if(strlen(output) ==3){
	MOVLW       _output+0
	MOVWF       FARG_strlen_s+0 
	MOVLW       hi_addr(_output+0)
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main21
	MOVLW       3
	XORWF       R0, 0 
L__main21:
	BTFSS       STATUS+0, 2 
	GOTO        L_main12
;Pratica3.c,168 :: 		output[3] = 'º';
	MOVLW       186
	MOVWF       _output+3 
;Pratica3.c,169 :: 		output[4] = 'C';
	MOVLW       67
	MOVWF       _output+4 
;Pratica3.c,170 :: 		output[5] = '\0';
	CLRF        _output+5 
;Pratica3.c,171 :: 		}else{
	GOTO        L_main13
L_main12:
;Pratica3.c,172 :: 		output[4] = 'º';
	MOVLW       186
	MOVWF       _output+4 
;Pratica3.c,173 :: 		output[5] = 'C';
	MOVLW       67
	MOVWF       _output+5 
;Pratica3.c,174 :: 		output[6] = '\0';
	CLRF        _output+6 
;Pratica3.c,175 :: 		}
L_main13:
;Pratica3.c,178 :: 		Lcd_Out(2, 1, output);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _output+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_output+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Pratica3.c,181 :: 		Delay_ms(500);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main14:
	DECFSZ      R13, 1, 1
	BRA         L_main14
	DECFSZ      R12, 1, 1
	BRA         L_main14
	DECFSZ      R11, 1, 1
	BRA         L_main14
	NOP
	NOP
;Pratica3.c,182 :: 		}
	GOTO        L_main2
;Pratica3.c,183 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
