/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: [Ernesto Torres Pineda]
 *  Fecha: [2025-04-09]
 *  Descripción: Calcula el determinante de una matriz 2x2 ingresada por el usuario.
 *  Demostración: [ASCIINEMA.ORG/.....]
 * ---------------------------------------------------------------------------------
 */
.global main
.extern printf
.extern scanf
.section .data
prompt_a:  .asciz "Ingrese a (fila 1, col 1): "
prompt_b:  .asciz "Ingrese b (fila 1, col 2): "
prompt_c:  .asciz "Ingrese c (fila 2, col 1): "
prompt_d:  .asciz "Ingrese d (fila 2, col 2): "
fmt_scan:  .asciz "%d"
fmt_det:   .asciz "\nDeterminante: %d\n"
.section .bss
matrix:    .skip 16       // Reserva 4 words (a, b, c, d)
.section .text
main:
    // Save frame pointer and link register
    stp x29, x30, [sp, #-32]!   // Reserve more stack space
    mov x29, sp
    
    // Leer valores de la matriz
    ldr x0, =prompt_a
    bl printf
    
    ldr x0, =fmt_scan
    ldr x1, =matrix
    bl scanf                     // Lee 'a'
    
    ldr x0, =prompt_b
    bl printf
    
    ldr x0, =fmt_scan
    ldr x1, =matrix
    add x1, x1, #4
    bl scanf                     // Lee 'b'
    
    ldr x0, =prompt_c
    bl printf
    
    ldr x0, =fmt_scan
    ldr x1, =matrix
    add x1, x1, #8
    bl scanf                     // Lee 'c'
    
    ldr x0, =prompt_d
    bl printf
    
    ldr x0, =fmt_scan
    ldr x1, =matrix
    add x1, x1, #12
    bl scanf                     // Lee 'd'
    
    // Calcular determinante
    ldr x4, =matrix              // Cargar la dirección de la matriz en x4
    
    ldr w5, [x4]                 // a
    ldr w6, [x4, #12]            // d
    mul w7, w5, w6               // a * d
    
    ldr w5, [x4, #4]             // b
    ldr w6, [x4, #8]             // c
    mul w8, w5, w6               // b * c
    
    sub w1, w7, w8               // det = (a*d) - (b*c), store in w1 for printf
    
    // Save determinant result to stack
    str w1, [sp, #16]
    
    // Imprimir resultado
    ldr x0, =fmt_det
    ldr w1, [sp, #16]           // Load determinant from stack
    bl printf
    
    // Salir
    mov w0, #0
    ldp x29, x30, [sp], #32     // Restore saved registers and deallocate stack
    ret
