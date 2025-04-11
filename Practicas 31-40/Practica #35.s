/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Calcula la suma de los primeros N números naturales (1 + 2 + ... + N)
 *               usando un bucle `add` y un contador decreciente.
 *  Demostración: [https://asciinema.org/a/1DIkj2mlvzfohUpFrMVf8DVn0]
 * ---------------------------------------------------------------------------------
 */

.global main
.extern printf

.section .rodata
fmt: .asciz "Suma de 1 a %d = %d\n"

.section .data
n: .word 5    // Cambia este valor para otro N

.section .text
main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    ldr x1, =n
    ldr w1, [x1]        // w1 = N (hasta dónde sumar)

    mov w2, w1          // Guardamos N original para imprimir
    mov w3, 0           // w3 = acumulador (suma)
    mov w4, 1           // w4 = contador

loop:
    cmp w4, w1
    bgt mostrar

    add w3, w3, w4      // suma += i
    add w4, w4, 1       // i++
    b loop

mostrar:
    add w3, w3, w4      // incluir el último número (w4 == N)

    // printf("Suma de 1 a %d = %d\n", N, suma)
    ldr x0, =fmt
    mov w1, w2
    mov w2, w3
    bl printf

    ldp x29, x30, [sp], #16
    mov w0, 0
    ret
