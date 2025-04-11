/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Busca el valor mínimo en un arreglo de enteros.
 *               Recorre todos los elementos con un bucle y comparación CMP.
 *  Demostración: [https://asciinema.org/a/nUn9zFfUwhmcZVlvsl8TrZEfi]
 * ---------------------------------------------------------------------------------
 */

.global main
.extern printf

.section .rodata
fmt: .asciz "Valor mínimo: %d\n"

.section .data
array: .word 45, 12, 78, 3, 99, 24, 6, 31
length: .word 8

.section .text
main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    ldr x1, =array       // x1 apunta al arreglo
    ldr w2, =8           // w2 = número de elementos
    mov w3, 1            // índice = 1
    ldr w4, [x1]         // w4 = mínimo = array[0]

loop:
    cmp w3, w2
    bge imprimir

    ldr w5, [x1, w3, SXTW #2]   // w5 = array[i]
    cmp w5, w4
    bge siguiente

    mov w4, w5           // nuevo mínimo

siguiente:
    add w3, w3, 1
    b loop

imprimir:
    // printf("Valor mínimo: %d\n", w4)
    ldr x0, =fmt
    mov w1, w4
    bl printf

    ldp x29, x30, [sp], #16
    mov w0, 0
    ret
