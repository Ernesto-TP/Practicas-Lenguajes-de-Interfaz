/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Suma números pares e impares en un array predefinido
 *  Demostración: [ASCIINEMA.ORG/XXXXXX]
 * ---------------------------------------------------------------------------------
 */

.data
    array:      .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10    // Array de prueba
    length = (. - array)/4                             // Cálculo de longitud
    even_msg:   .asciz "Suma pares: %d\n"
    odd_msg:    .asciz "Suma impares: %d\n"

.text
.global main
.extern printf

main:
    // Prólogo
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Inicializar registros
    mov x19, #0                  // Contador de índice
    mov w20, #0                  // Suma de pares
    mov w21, #0                  // Suma de impares
    ldr x22, =array              // Puntero al array

sum_loop:
    cmp x19, #length             // Verificar fin del array
    bge show_results

    // Cargar elemento actual
    ldr w23, [x22, x19, lsl #2]  // array[i] (offset = i * 4)

    // Verificar par/impar (LSB = 0/1)
    tst w23, #1                  // Testear bit menos significativo
    beq even_number

odd_number:
    add w21, w21, w23            // Sumar a impares
    b next_iteration

even_number:
    add w20, w20, w23            // Sumar a pares

next_iteration:
    add x19, x19, #1             // Incrementar índice
    b sum_loop

show_results:
    // Mostrar suma de pares
    ldr x0, =even_msg
    mov w1, w20
    bl printf

    // Mostrar suma de impares
    ldr x0, =odd_msg
    mov w1, w21
    bl printf

    // Epílogo
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
