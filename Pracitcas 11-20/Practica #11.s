/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz en TECNM Campus ITT
 *  Autor: [Ernesto Torres Pineda]
 *  Fecha: [2025-04-07]
 *  Descripción: Programa que muestra los numeros de fibonacci dependiendo de la cantidad dada.
 *  Demostración:  [ ASCIINEMA.ORG/.....]
 * ---------------------------------------------------------------------------------
 */
.global main
.extern printf
.extern scanf

.section .rodata
prompt:   .asciz "Enter number of terms: "
fmt_in:   .asciz "%d"
fmt_out:  .asciz "Fibonacci(%d): %d\n"

.section .bss
.align 4
n:        .space 4       // Variable para almacenar N (4 bytes para un entero)

.section .text
main:
    // Save frame pointer and link register
    stp x29, x30, [sp, #-16]!
    mov x29, sp          // Set up frame pointer
    
    // Pedir entrada
    ldr x0, =prompt
    bl printf
    
    ldr x0, =fmt_in
    ldr x1, =n
    bl scanf
    
    // Cargar N en w22
    ldr x1, =n
    ldr w22, [x1]        // Cargar N
    
    // Verificar si N <= 0
    cmp w22, #0
    ble exit
    
    // Inicialización de variables
    mov w19, #0          // Primer término (a = 0)
    mov w20, #1          // Segundo término (b = 1)
    mov w21, #0          // Contador (i = 0)
    
    // =============================================
    // BUCLE ITERATIVO (Aquí ocurre la iteración)
    // =============================================
fib_loop:
    cmp w21, w22         // ¿i >= N?
    bge exit
    
    // Mostrar término actual
    ldr x0, =fmt_out
    mov w1, w21
    mov w2, w19
    bl printf
    
    // Calcular siguiente término
    add w23, w19, w20    // c = a + b
    mov w19, w20         // a = b
    mov w20, w23         // b = c
    
    add w21, w21, #1     // i++
    b fib_loop
    // =============================================
    
exit:
    mov w0, #0           // Return 0
    ldp x29, x30, [sp], #16
    ret
