/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 * Descripción: Calcula la potencia a^b usando multiplicación
 *           repetida. Usa printf para mostrar el resultado.
 *  
 *  Demostración: [https://asciinema.org/a/6C3393nnvssSXwjYX2IRGCK18]
 * ---------------------------------------------------------------------------------
 */

.global main
.extern printf

.section .rodata
fmt: .asciz "%d^%d = %d\n"

.section .data
base:     .word 2     // a
exponente: .word 5    // b

.section .text
main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    // Cargar base y exponente
    ldr x1, =base
    ldr w1, [x1]           // w1 = base (a)

    ldr x2, =exponente
    ldr w2, [x2]           // w2 = exponente (b)

    mov w3, 1              // resultado = 1
    mov w4, w2             // contador = exponente

    // Si exponente es 0, resultado = 1 por definición
    cmp w2, 0
    beq imprimir

loop:
    mul w3, w3, w1         // resultado *= base
    sub w4, w4, 1          // contador--
    cmp w4, 0
    bgt loop

imprimir:
    // printf("%d^%d = %d\n", base, exponente, resultado)
    ldr x0, =fmt
    mov w1, w1             // base
    mov w2, w2             // exponente original
    mov w3, w3             // resultado
    bl printf

    ldp x29, x30, [sp], #16
    mov w0, 0
    ret
