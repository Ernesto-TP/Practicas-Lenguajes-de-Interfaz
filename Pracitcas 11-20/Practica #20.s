/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: [Ernesto Torres Pineda]
 *  Fecha: [2025-04-08]
 *  Descripción: Multiplica una matriz 2x2 por un escalar ingresado por el usuario.
 *  Demostración: [ASCIINEMA.ORG/.....]
 * ---------------------------------------------------------------------------------
 */
.global main
.extern printf
.extern scanf
.section .data
matrix:          .word 1, 2, 3, 4           // Matriz inicial 2x2
matrix_copy:     .word 0, 0, 0, 0           // Copia de la matriz original
scalar:          .word 0                    // Escalar a multiplicar
// Formatos para impresión y entrada
prompt_msg:      .asciz "Ingrese el valor escalar: "
scan_fmt:        .asciz "%d"
header_orig:     .asciz "\nMatriz Original:\n"
header_result:   .asciz "\nMatriz Resultado (x%d):\n"
fmt_matrix_row:  .asciz "| %d %d |\n"
newline:         .asciz "\n"
.section .text
main:
    // Prólogo de función - preserve registers properly
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Hacer una copia de la matriz original
    ldr x0, =matrix              // Load address of original matrix
    ldr x1, =matrix_copy         // Load address of copy matrix
    mov x2, #0                   // Initialize index
copy_loop:
    cmp x2, #4                   // Check if we've copied all 4 elements
    bge end_copy
    ldr w3, [x0, x2, lsl #2]     // Load element from original matrix
    str w3, [x1, x2, lsl #2]     // Store it in copy matrix
    add x2, x2, #1               // Increment index
    b copy_loop
end_copy:
    // Solicitar valor escalar al usuario
    ldr x0, =prompt_msg
    bl printf
    
    ldr x0, =scan_fmt
    ldr x1, =scalar
    bl scanf
    
    // Imprimir la matriz original
    ldr x0, =header_orig
    bl printf
    
    // Imprimir la matriz original por filas
    ldr x0, =matrix
    bl print_matrix
    
    // Obtener el valor escalar para el encabezado
    ldr x1, =scalar
    ldr w1, [x1]                 // w1 = scalar
    
    // Imprimir encabezado de matriz resultado
    ldr x0, =header_result
    bl printf
    
    // Realizar la multiplicación en la copia
    ldr x0, =matrix_copy         // Address of copy matrix
    ldr x1, =scalar
    ldr w1, [x1]                 // Load scalar value
    mov x2, #0                   // Initialize index
scalar_loop:
    cmp x2, #4                   // Check if we've processed all 4 elements
    bge end_scalar
    ldr w3, [x0, x2, lsl #2]     // Load element from copy matrix
    mul w3, w3, w1               // Multiply by scalar
    str w3, [x0, x2, lsl #2]     // Store result back in copy matrix
    add x2, x2, #1               // Increment index
    b scalar_loop
end_scalar:
    // Imprimir la matriz resultante por filas
    ldr x0, =matrix_copy
    bl print_matrix
    
    // Epílogo de función y salida
    mov w0, #0                   // Return 0
    ldp x29, x30, [sp], #16      // Restore registers
    ret

// Subrutina para imprimir una matriz 2x2
print_matrix:
    // Save registers
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Additional register preservation for calling printf
    stp x19, x20, [sp, #-16]!
    
    mov x19, x0                  // Save matrix pointer in preserved register
    
    // Imprimir primera fila
    ldr x0, =fmt_matrix_row
    ldr w1, [x19]                // Elemento (0,0)
    ldr w2, [x19, #4]            // Elemento (0,1)
    bl printf
    
    // Imprimir segunda fila
    ldr x0, =fmt_matrix_row
    ldr w1, [x19, #8]            // Elemento (1,0)
    ldr w2, [x19, #12]           // Elemento (1,1)
    bl printf
    
    // Imprimir nueva línea
    ldr x0, =newline
    bl printf
    
    // Restore additional registers
    ldp x19, x20, [sp], #16
    
    // Restore saved registers
    ldp x29, x30, [sp], #16
    ret
