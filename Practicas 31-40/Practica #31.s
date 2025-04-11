/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Convierte una cadena binaria ("1011") a su valor decimal (11).
 *               Usa un bucle y desplazamientos de bits (LSL).
 *  Demostración: [https://asciinema.org/a/NLA8pTPnEcsAdMxIIXuuPYbQi]
 * ---------------------------------------------------------------------------------
 */

.global main
.extern printf

.section .rodata
binario: .asciz "1011"        // Cambia aquí el número binario
fmt:     .asciz "Decimal: %d\n"

.section .text
main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    ldr x0, =binario           // puntero a la cadena
    mov w1, 0                  // acumulador decimal

conv_loop:
    ldrb w2, [x0], #1          // cargar siguiente byte y avanzar
    cmp w2, 0
    beq mostrar                // fin de la cadena

    // validar: si no es '0' ni '1', ignoramos
    cmp w2, '0'
    blt conv_loop
    cmp w2, '1'
    bgt conv_loop

    // shift acumulador a la izquierda (decimal <<= 1)
    lsl w1, w1, 1

    // sumar bit si es '1'
    cmp w2, '1'
    bne conv_loop
    add w1, w1, 1

    b conv_loop

mostrar:
    // printf("Decimal: %d\n", decimal)
    ldr x0, =fmt
    mov w1, w1
    bl printf

    ldp x29, x30, [sp], #16
    mov w0, 0
    ret
