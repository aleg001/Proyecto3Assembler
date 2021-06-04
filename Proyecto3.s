
/*---------------------------------------------
* PARA EJECUTAR:
* gcc -c phys_to_virt.c
* as -o Proyecto3.o Proyecto3.s
* gcc -o Proyecto3 Proyecto3.o phys_to_virt.o
* sudo ./Proyecto3
*---------------------------------------------*/

/* --------------------------------------------
* Proyecto 3
* Fecha: 03/06/21
* Creado por:
* Alejandro Gómez 20347
* Marco Jurado 20308
* Adaptado de Lab 10
 -------------------------------------------*/ 


/*
Puertos GPIO a utilizar:
		
		Puertos 20-29
		GPIO 27 = 13
		GPIO 22 = 15
		GPIO 23 = 16
		GPIO 24 = 18
		GPIO 25 = PIN 37 = DipSwitch

		Puertos 0-9
		GPIO 5  = 29
		GPIO 6  = 31

		Puertos 10-19
		GPIO 17 = 11
		GPIO 16 = 36
		
		GROUND  = 6
*/

/* REPRESENTACION EN GRAFICO
	GPIO 21 = Segmento A 
	GPIO 5 = Segmento B
	GPIO 4 = Segmento F
	GPIO 3 = Segmento G
	GPIO 2 = Segmento C
	GPIO 1 = Segmento E
	GPIO 7 = Segmento D
	GPIO 6 = Segmento DP
	Ground = Ground
	GPIO 25 = PIN 37 = DipSwitch
	*/

.data
.balign 4	
Intro: 	 .asciz  "  >>Raspberry Pi wiringPi blink test\n"
ErrMsg:	 .asciz	"  >>Setup didn't work... Aborting...\n"
pin1:	.int	7 //segmento D
pin2:	.int	1 //segmento E
pin3:	.int 	22 //segmento C
pin4:	.int 	3 //segmento G
pin5:	.int 	4  //segmento F
pin6:	.int 	5  //segmento B
pin7:	.int	6 //segmento DP
pin8:	.int 	21 //segmento A

pin9:   .int    25 //DIP SWITCH

i:	 	 .int	0
delayMs: .int	1600
delayMsPruebas: .int 300
OUTPUT	 =	1
INPUT    =  0
ingresoNum: .byte 0

mensajeDespedida: .asciz "\n  >> Vuelve pronto!\n"
formatoIngreso: .asciz "%c" //Se usa char pues es solo una letra
mensajeIngreso: .asciz "\n  >> Bienvenido! \n  1. ingresa Y para ejecutar\n  2. ingresa Q para detener y cerrar\n\n"
mensajeDIPApagado: .asciz " \n >> El Dip Switch está apagado... Enciendelo para usar el programa!\n"
	
@ ---------------------------------------
@	codigo
@ ---------------------------------------
	
	.text
	.global main
	.extern printf
	.extern puts
	.extern wiringPiSetup
	.extern delay
	.extern digitalWrite
	.extern pinMode
	.extern scanf
	
main:   
	push 	{ip, lr}	@ push return address + dummy register
				@ for alignment
	bl	wiringPiSetup			// Inicializar librería wiringpi
	mov	r1,#-1					// -1 representa un código de error
	cmp	r0, r1					// verifica si se retornó cod error en r0
	bne	init					// NO error, entonces iniciar programa
	ldr	r0, =ErrMsg				// SI error, 
	bl	printf					// imprimir mensaje y
	b	done					// salir del programa

init:
	//*****************************************************CONFIG PUERTOS*************************************************************/
	
	//Pin 1
	ldr	r0, =pin1				// coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #OUTPUT				// lo configura como salida, r1 = 1
	bl	pinMode					// llama funcion wiringpi para configurar
	
	//Pin 2
	ldr	r0, =pin2				// coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #OUTPUT				// lo configura como salida, r1 = 1
	bl	pinMode	

	//Pin 3
	ldr	r0, =pin3				// coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #OUTPUT				// lo configura como salida, r1 = 1
	bl	pinMode	

	//Pin 4
	ldr	r0, =pin4			// coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #OUTPUT				// lo configura como salida, r1 = 1
	bl	pinMode	

	//Pin 5
	ldr	r0, =pin5				// coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #OUTPUT				// lo configura como salida, r1 = 1
	bl	pinMode	

	//Pin 6
	ldr	r0, =pin6				// coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #OUTPUT				// lo configura como salida, r1 = 1
	bl	pinMode	

	//Pin 7
	ldr	r0, =pin7				// coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #OUTPUT				// lo configura como salida, r1 = 1
	bl	pinMode	

	//Pin 8
	ldr	r0, =pin8				// coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #OUTPUT				// lo configura como salida, r1 = 1
	bl	pinMode

	//Pin 9
	ldr	r0, =pin9				// coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #INPUT				// lo configura como entrada, r1 = 1  ENTRADA---- DIP SWITCH
	bl	pinMode
			

	
@   for ( i=0; i<10; i++ ) { 	
	ldr	r4, =i					// carga valor de contador en 10
	ldr	r4, [r4]
	mov	r5, #10


/**********************************************************PUERTO DE ENTRADA*************************************************************/

VerificacionDeSwitch:
	
	@delay(250)		 ;
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay

	ldr r0,=pin9                //Carga el pin de entrada
	ldr r0,[r0]
	bl digitalRead              //Escritura y no lectura
	cmp r0,#1                   // Si está en 1 esta encendido

	beq menu 	         //Pide ingreso solo si el switch esta activo.
	ldr r0,=mensajeDIPApagado
	bl printf

	b VerificacionDeSwitch      //Loopea

/*************************************************************MENU Q y Y*******************************************************************/

menu:

	mov r1,#0
	ldr r11,=ingresoNum 
	str r1,[r11]
	mov r5,#0

	ldr r0,=mensajeIngreso
	bl printf

	ldr r0,=formatoIngreso
	ldr r1,=ingresoNum
	bl scanf

	

	ldr r11,= formatoIngreso
	ldrb r11,[r11]


	cmp r11,#'y'
	beq forLoop
	b IngresoChar


	cmp r11,#'q'
	beq done

forLoop:						// inicio de ciclo 
	cmp	r4, r5
	bgt	done					// si el ciclo se ha completado 10 veces entonces termina programa

	/*  Se organiza para cada una de las letras*/




	/* SE DEFINE PARA LA PRIMERA LETRA */
	
	/*Primera letra A:
	
	 	   = 
		||   ||
		   =
		||   ||

	*/
@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin8				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin5				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin6				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin4				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin3				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO


@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO



@       delay(250)		 ;
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay



@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin8				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin5				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin6				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin4				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin3				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO


@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO


	/* Segunda letra b:
		
		||
		   =
		||   ||
		   =

	 */

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin5				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin4				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin3				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO


@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin1				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO


@       delay(250)		 ;
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay



@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin5				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin4				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin3				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO


@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin1				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO


	/* Tercera letra C:
		    =
		||
		||
		   =
	
	 */


@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin5				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin8				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin1				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO


@       delay(250)		 ;
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin5				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin8				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin1				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO



	 /* Tercera letra d:
 		  
		    ||
		  =
		||  ||
		  =
	 */


@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin6				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin4				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin3				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO


@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin1				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO


@       delay(250)		 ;
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay



@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin6				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin4				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin3				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO


@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin1				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO


	 /* Cuarto simbolo: E
	           =
	 		||
			   =
			||
			   =
	 
	 */
	 
	 @	digitalWrite(pin, 1) ;		
	ldr	r0, =pin5				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin8				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin1				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin4				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO


@       delay(250)		 ;
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin5				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin8				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin1				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO
@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin4				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO


/* Cuarto simbolo: F
	           =
	 		||
			   =
			||
	 
	 */
	 
	 @	digitalWrite(pin, 1) ;		
	ldr	r0, =pin5				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin8				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin4				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO


@       delay(250)		 ;
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin5				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin8				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO

@	digitalWrite(pin, 0) ;		
	ldr	r0, =pin4				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO



/* SE FINALIZA DE DECLARAR LAS LETRAS */

IngresoChar: 
	bl getchar
	b VerificacionDeSwitch

done:	
		ldr r0,= mensajeDespedida
		bl puts
        pop 	{ip, pc}	@ pop return address into pc
