/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: [Ernesto Torres Pineda]
 *  Fecha: [2025-04-08]
 *  Descripción: Suma de dos matrices 3x3 predefinidas.
 *  Demostración: [ASCIINEMA.ORG/.....]
 * ---------------------------------------------------------------------------------
 */
.global main
.extern printf

.section .data
// Primera matriz predefinida
matrix_a:   .word 1, 2, 3
            .word 4, 5, 6
            .word 7, 8, 9

// Segunda matriz predefinida
matrix_b:   .word 9, 8, 7
            .word 6, 5, 4
            .word 3, 2, 1

// Matriz resultado
matrix_c:   .skip 36    // 9 elementos de 4 bytes cada uno

// Formatos de salida
fmt_matrix: .asciz "| %2d %2d %2d |\n"
header_a:   .asciz "\nMatriz A:\n"
header_b:   .asciz "\nMatriz B:\n"
header_sum: .asciz "\nMatriz Suma (A + B):\n"
newline:    .asciz "\n"

.section .text
main:
    // Prólogo
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    // ===== IMPRIMIR MATRIZ A =====
    ldr x0, =header_a
    bl printf
    ldr x0, =matrix_a
    bl print_3x3

    // ===== IMPRIMIR MATRIZ B =====
    ldr x0, =header_b
    bl printf
    ldr x0, =matrix_b
    bl print_3x3

    // ===== SUMAR MATRICES =====
    ldr x19, =matrix_a   // Dirección matriz A
    ldr x20, =matrix_b   // Dirección matriz B
    ldr x21, =matrix_c   // Dirección matriz resultado
    mov x22, #0          // Índice del elemento

sum_loop:
    cmp x22, #9          // 9 elementos en total
    bge end_sum

    // Cargar elementos
    ldr w23, [x19, x22, lsl #2]  // Elemento de A
    ldr w24, [x20, x22, lsl #2]  // Elemento de B

    // Sumar y guardar
    add w25, w23, w24            // A + B
    str w25, [x21, x22, lsl #2]  // Guardar en C

    add x22, x22, #1     // Incrementar índice
    b sum_loop
end_sum:

    // ===== IMPRIMIR RESULTADO =====
    ldr x0, =header_sum
    bl printf
    ldr x0, =matrix_c
    bl print_3x3

    // Epílogo
    mov w0, #0           // Código de retorno 0
    ldp x29, x30, [sp], #16
    ret

// ===== SUBRUTINA PARA IMPRIMIR MATRIZ 3x3 =====
print_3x3:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    mov x19, x0          // Guardar dirección de la matriz

    // Imprimir fila 1
    ldr x0, =fmt_matrix
    ldr w1, [x19]
    ldr w2, [x19, #4]
    ldr w3, [x19, #8]
    bl printf

    // Imprimir fila 2
    ldr x0, =fmt_matrix
    ldr w1, [x19, #12]
    ldr w2, [x19, #16]
    ldr w3, [x19, #20]
    bl printf

    // Imprimir fila 3
    ldr x0, =fmt_matrix
    ldr w1, [x19, #24]
    ldr w2, [x19, #28]
    ldr w3, [x19, #32]
    bl printf

    ldr x0, =newline
    bl printf

    ldp x29, x30, [sp], #16
    ret
