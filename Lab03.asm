/**************************************************************************
 * File: Lab03.asm
 * Lab Name: Lab03 - Decisions, Decisions, Decisons!
 * Author: Christian Sorensen
 * Created: 09/14/2026
 *
 * This program simulates reading sensor data and doing operations on them.
 * It uses memory locations for sensors and result writes.
 * We hope to learn more about branching in assembly.
 *************************************************************************/

/************************************************************************
 * NOTE!  To populate the sensor data to memory, follow these steps!
 * 1) Set breakpoint on 1st instruction RJMP
 * 2) Set the stimulus file
 *    - Debug->Set Stimufile.  Select Lab03.stim
 *    - This only needs to be done ONCE (will save in project file)
 *    - Should be in your Project file from the Repo, but do once to be sure.
 * 3) Execute stimulus file
 *    - Debug->Execute Stimufile
 *    - This needs to be run EVERY TIME you restart a debug session.  :-(
 * 4) single step code
 * 5) Check that data IRAM at 0x0100 has changed "61 97"
 * 
 * Sensor1 Located at 0x0100 (preset to 0x61)
 * Sensor2 Located at 0x0101 (preset to 0x97)
 * 
 * NOTE:  For testing, you can modify these after loading them
 * to make sure all of your branches work properly
 ***********************************************************************/
 .equ THRESHOLD = 0x90 ; Create a constant
 .def Sensor1   = R20  ; Define a nickname for R20
 .def Sensor2   = R21  ; Define a nickname for R21
 .org 0x0000 ; next instruction will be written to address 0x0000
             ; (the location of the reset vector)
RJMP main    ; set reset vector to point to the main code entry point

main:        ; jump here on reset

	; initialize the stack (RAMEND = 0x10FF by default for the ATmega128A)
	LDI R16, HIGH(RAMEND)
	OUT SPH, R16
	LDI R16, low(RAMEND)
	OUT SPL, R16

    ;----------------------------------
    ; student-written code begins here    

	LDI YL, 0x00	 ; load lower Y bits
	LDI YH, 0x01     ; load upper Y bits
					 ; Y points to 0x0100

	LD Sensor1, Y+   ; Sensor1 = 0x61, Y incremented
	LD Sensor2, Y    ; Sensor2 = 0x97

	ADIW YH:YL, 0x0f ; bump Y to 0x0110 
	
	CPI Sensor1, THRESHOLD	; 0x61 >= 0x90 ?
	BRSH YES

	LDI R19, 0x50	
	RJMP NEXT00

	YES:
	LDI R19, 0x46

	NEXT00:
	ST Y+, R19	; load appropriate value, increment Y

	ST Y+, Sensor1	; store Sensor1, increment Y

	CPI Sensor2, THRESHOLD	; 0x97 < 0x90 ?
	BRLT LESS

	LDI R19, 's'
	RJMP NEXT01

	LESS:
	LDI R19, 'i'

	NEXT01:
	ST Y+, R19	; load appropriate value, increment Y
	
	CP Sensor1, Sensor2
	BRNE NOT_EQUAL

	LDI R19, 108
	RJMP END

	NOT_EQUAL:
	LDI R19, 115

	END:
	ST Y, R19	; load appropriate value
	NOP