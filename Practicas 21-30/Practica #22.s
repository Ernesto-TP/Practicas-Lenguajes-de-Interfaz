/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: [Ernesto Torres Pineda]
 *  Fecha: [2025-04-09]
 *  Descripción: Encuentra el valor máximo en una matriz 3x3 ingresada por el usuario.
 *  Demostración: [https://asciinema.org/a/k5vg8eax8NDbccuM6P36lKCSu]
 * ---------------------------------------------------------------------------------
 */
.global main
.extern printf
.extern scanf

.section .data
prompt_template: .asciz "Ingrese elemento [%d][%d]: "
fmt_scan:       .asciz "%d"
fmt_matrix:     .asciz "| %d %d %d |\n"
fmt_max:        .asciz "\nEl valor máximo es: %d\n"
header_mat:     .asciz "\nMatriz ingresada:\n"
newline:        .asciz "\n"

.section .bss
matrix:     .skip 36    // 9 elementos de 4 bytes cada uno (3x3)

.section .text
main:
    // Prólogo
    stp x29, x30, [sp, #-32]!
    mov x29, sp

    // ===== LEER MATRIZ 3x3 =====
    mov x19, #0                  // Contador de filas (i)
read_rows:
    cmp x19, #3
    bge end_read
    mov x20, #0                  // Contador de columnas (j)
read_cols:
    cmp x20, #3
    bge next_row

    // Mostrar prompt
    ldr x0, =prompt_template
    add w1, w19, #1              // i+1 para mostrar desde 1
    add w2, w20, #1              // j+1 para mostrar desde 1
    bl printf

    // Leer valor
    ldr x0, =fmt_scan
    ldr x1, =matrix
    // Calcular offset = (i*3 + j)*4
    mov x21, #3
    mul x21, x19, x21            // i*3
    add x21, x21, x20            // +j
    lsl x21, x21, #2             // *4 (tamaño de palabra)
    add x1, x1, x21              // Dirección del elemento
    bl scanf

    add x20, x20, #1             // Incrementar columna
    b read_cols
next_row:
    add x19, x19, #1             // Incrementar fila
    b read_rows
end_read:

    // ===== IMPRIMIR MATRIZ INGRESADA =====
    ldr x0, =header_mat
    bl printf
    ldr x0, =matrix
    bl print_3x3

    // ===== ENCONTRAR VALOR MÁXIMO =====
    ldr x19, =matrix             // Dirección de la matriz
    ldr w20, [x19]               // Inicializar máximo con primer elemento
    mov x21, #1                  // Índice comenzando en 1 (segundo elemento)
find_max:
    cmp x21, #9                  // 9 elementos en total
    bge end_find

    ldr w22, [x19, x21, lsl #2]  // Cargar elemento actual
    cmp w22, w20
    ble next_element              // Si no es mayor, saltar
    mov w20, w22                 // Actualizar máximo
next_element:
    add x21, x21, #1             // Incrementar índice
    b find_max
end_find:

    // ===== IMPRIMIR RESULTADO =====
    ldr x0, =fmt_max
    mov w1, w20                  // Valor máximo
    bl printf

    // Epílogo
    mov w0, #0                   // Código de retorno 0
    ldp x29, x30, [sp], #32
    ret

// ===== SUBRUTINA PARA IMPRIMIR MATRIZ 3x3 =====
print_3x3:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    mov x19, x0                  // Guardar dirección de la matriz

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
