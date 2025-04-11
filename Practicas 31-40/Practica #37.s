/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Muestra la representación binaria de un número de 32 bits
 *               y cuenta la cantidad de bits activados (en 1).
 *               Usa operaciones AND, LSR, y printf para mostrar resultados.
 *  Demostración: [https://asciinema.org/a/vyjbp2yAPM2WujazZgtHcPsok]
 * ---------------------------------------------------------------------------------
 */

.global main
.extern printf

.section .rodata
fmt_bin: .asciz "Bit %d: %d\n"
fmt_res: .asciz "Total de bits en 1: %d\n"

.section .data
numero: .word 0b10110101  // Puedes cambiarlo por otro número

.section .text
main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    ldr x1, =numero
    ldr w2, [x1]           // w2 = número a procesar
    mov w3, 31             // contador de bit (desde el más significativo)
    mov w4, 0              // acumulador de bits en 1

loop:
    lsr w5, w2, w3         // desplazar w2 >> w3
    and w5, w5, 1          // extraer bit actual (0 o 1)

    // Imprimir bit
    ldr x0, =fmt_bin
    mov w1, w3            // índice de bit
    mov w2, w5            // valor del bit
    bl printf

    // Sumar si el bit es 1
    cmp w5, 1
    bne siguiente
    add w4, w4, 1         // w4++

siguiente:
    subs w3, w3, 1
    bge loop

mostrar:
    ldr x0, =fmt_res
    mov w1, w4
    bl printf

    ldp x29, x30, [sp], #16
    mov w0, 0
    ret
