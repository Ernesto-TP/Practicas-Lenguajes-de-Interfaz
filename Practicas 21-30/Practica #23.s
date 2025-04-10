/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: [Ernesto Torres Pineda]
 *  Fecha: [2025-04-08]
 *  Descripción: Multiplica dos matrices 2x2 ingresadas por el usuario.
 *  Demostración: [ASCIINEMA.ORG/.....]
 * ---------------------------------------------------------------------------------
 */
.global main
.extern printf
.extern scanf

.section .data
// Mensajes para matriz A
prompt_a11: .asciz "Ingrese A[1][1]: "
prompt_a12: .asciz "Ingrese A[1][2]: "
prompt_a21: .asciz "Ingrese A[2][1]: "
prompt_a22: .asciz "Ingrese A[2][2]: "

// Mensajes para matriz B
prompt_b11: .asciz "Ingrese B[1][1]: "
prompt_b12: .asciz "Ingrese B[1][2]: "
prompt_b21: .asciz "Ingrese B[2][1]: "
prompt_b22: .asciz "Ingrese B[2][2]: "

// Formatos
fmt_scan:   .asciz "%d"
fmt_result: .asciz "\nMatriz Resultante:\n| %d %d |\n| %d %d |\n"

.section .bss
matrix_a:   .skip 16
matrix_b:   .skip 16
matrix_c:   .skip 16

.section .text
main:
    // Prólogo
    stp x29, x30, [sp, #-32]!
    mov x29, sp

    // ===== LEER MATRIZ A =====
    // A[1][1]
    ldr x0, =prompt_a11
    bl printf
    ldr x0, =fmt_scan
    ldr x1, =matrix_a
    bl scanf

    // A[1][2]
    ldr x0, =prompt_a12
    bl printf
    ldr x0, =fmt_scan
    ldr x1, =matrix_a
    add x1, x1, #4
    bl scanf

    // A[2][1]
    ldr x0, =prompt_a21
    bl printf
    ldr x0, =fmt_scan
    ldr x1, =matrix_a
    add x1, x1, #8
    bl scanf

    // A[2][2]
    ldr x0, =prompt_a22
    bl printf
    ldr x0, =fmt_scan
    ldr x1, =matrix_a
    add x1, x1, #12
    bl scanf

    // ===== LEER MATRIZ B =====
    // B[1][1]
    ldr x0, =prompt_b11
    bl printf
    ldr x0, =fmt_scan
    ldr x1, =matrix_b
    bl scanf

    // B[1][2]
    ldr x0, =prompt_b12
    bl printf
    ldr x0, =fmt_scan
    ldr x1, =matrix_b
    add x1, x1, #4
    bl scanf

    // B[2][1]
    ldr x0, =prompt_b21
    bl printf
    ldr x0, =fmt_scan
    ldr x1, =matrix_b
    add x1, x1, #8
    bl scanf

    // B[2][2]
    ldr x0, =prompt_b22
    bl printf
    ldr x0, =fmt_scan
    ldr x1, =matrix_b
    add x1, x1, #12
    bl scanf

    // ===== MULTIPLICACIÓN =====
    ldr x19, =matrix_a   // Usamos registros preservados
    ldr x20, =matrix_b
    ldr x21, =matrix_c

    // C[1][1] = A[1][1]*B[1][1] + A[1][2]*B[2][1]
    ldr w0, [x19]        // A[1][1]
    ldr w1, [x20]        // B[1][1]
    mul w2, w0, w1
    
    ldr w0, [x19, #4]    // A[1][2]
    ldr w1, [x20, #8]    // B[2][1]
    madd w2, w0, w1, w2
    str w2, [x21]

    // C[1][2] = A[1][1]*B[1][2] + A[1][2]*B[2][2]
    ldr w0, [x19]        // A[1][1]
    ldr w1, [x20, #4]    // B[1][2]
    mul w2, w0, w1
    
    ldr w0, [x19, #4]    // A[1][2]
    ldr w1, [x20, #12]   // B[2][2]
    madd w2, w0, w1, w2
    str w2, [x21, #4]

    // C[2][1] = A[2][1]*B[1][1] + A[2][2]*B[2][1]
    ldr w0, [x19, #8]    // A[2][1]
    ldr w1, [x20]        // B[1][1]
    mul w2, w0, w1
    
    ldr w0, [x19, #12]   // A[2][2]
    ldr w1, [x20, #8]    // B[2][1]
    madd w2, w0, w1, w2
    str w2, [x21, #8]

    // C[2][2] = A[2][1]*B[1][2] + A[2][2]*B[2][2]
    ldr w0, [x19, #8]    // A[2][1]
    ldr w1, [x20, #4]    // B[1][2]
    mul w2, w0, w1
    
    ldr w0, [x19, #12]   // A[2][2]
    ldr w1, [x20, #12]   // B[2][2]
    madd w2, w0, w1, w2
    str w2, [x21, #12]

    // ===== IMPRIMIR RESULTADO =====
    ldr x0, =fmt_result
    ldr w1, [x21]
    ldr w2, [x21, #4]
    ldr w3, [x21, #8]
    ldr w4, [x21, #12]
    bl printf

    // Epílogo
    mov w0, #0
    ldp x29, x30, [sp], #32
    ret
