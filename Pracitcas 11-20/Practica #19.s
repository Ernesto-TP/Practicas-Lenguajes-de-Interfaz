/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: [Ernesto Torres Pineda]
 *  Fecha: [2025-04-08]
 *  Descripción: Transpone una matriz 4x4 ingresada por el usuario.
 *  Demostración: [https://asciinema.org/a/IQoI0CQ5brToqBNvKibN8ahnJ]
 * ---------------------------------------------------------------------------------
 */
.global main
.extern printf
.extern scanf

.section .data
// Mensajes para ingresar valores
prompt_template: .asciz "Ingrese elemento [%d][%d]: "
fmt_scan:       .asciz "%d"
fmt_row:        .asciz "| %2d %2d %2d %2d |\n"
header_orig:    .asciz "\nMatriz Original:\n"
header_trans:   .asciz "\nMatriz Transpuesta:\n"
newline:        .asciz "\n"

.section .bss
matrix:     .skip 64    // 16 elementos de 4 bytes cada uno
matrix_t:   .skip 64    // Matriz transpuesta

.section .text
main:
    // Prólogo
    stp x29, x30, [sp, #-32]!
    mov x29, sp

    // ===== LEER MATRIZ 4x4 =====
    mov x19, #0                  // Contador de filas (i)
read_rows:
    cmp x19, #4
    bge end_read
    mov x20, #0                  // Contador de columnas (j)
read_cols:
    cmp x20, #4
    bge next_row

    // Mostrar prompt
    ldr x0, =prompt_template
    add w1, w19, #1              // i+1 para mostrar desde 1
    add w2, w20, #1              // j+1 para mostrar desde 1
    bl printf

    // Leer valor
    ldr x0, =fmt_scan
    ldr x1, =matrix
    // Calcular offset = (i*4 + j)*4
    lsl x21, x19, #2             // i*4
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

    // ===== IMPRIMIR MATRIZ ORIGINAL =====
    ldr x0, =header_orig
    bl printf
    ldr x0, =matrix
    bl print_4x4

    // ===== TRANSPONER MATRIZ =====
    ldr x19, =matrix             // Matriz original
    ldr x20, =matrix_t           // Matriz transpuesta
    mov x21, #0                  // Contador de filas (i)
trans_outer:
    cmp x21, #4
    bge end_trans
    mov x22, #0                  // Contador de columnas (j)
trans_inner:
    cmp x22, #4
    bge next_trans_row

    // Calcular offset original (i,j)
    lsl x23, x21, #2             // i*4
    add x23, x23, x22            // +j
    lsl x23, x23, #2             // *4
    // Calcular offset transpuesta (j,i)
    lsl x24, x22, #2             // j*4
    add x24, x24, x21            // +i
    lsl x24, x24, #2             // *4

    // Copiar elemento
    ldr w25, [x19, x23]          // Cargar elemento original
    str w25, [x20, x24]          // Guardar en posición transpuesta

    add x22, x22, #1             // Incrementar columna
    b trans_inner
next_trans_row:
    add x21, x21, #1             // Incrementar fila
    b trans_outer
end_trans:

    // ===== IMPRIMIR MATRIZ TRANSPUESTA =====
    ldr x0, =header_trans
    bl printf
    ldr x0, =matrix_t
    bl print_4x4

    // Epílogo
    mov w0, #0                   // Código de retorno 0
    ldp x29, x30, [sp], #32
    ret

// ===== SUBRUTINA PARA IMPRIMIR MATRIZ 4x4 =====
print_4x4:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    mov x19, x0                  // Guardar dirección de la matriz

    // Imprimir fila 1
    ldr x0, =fmt_row
    ldr w1, [x19]
    ldr w2, [x19, #4]
    ldr w3, [x19, #8]
    ldr w4, [x19, #12]
    bl printf

    // Imprimir fila 2
    ldr x0, =fmt_row
    ldr w1, [x19, #16]
    ldr w2, [x19, #20]
    ldr w3, [x19, #24]
    ldr w4, [x19, #28]
    bl printf

    // Imprimir fila 3
    ldr x0, =fmt_row
    ldr w1, [x19, #32]
    ldr w2, [x19, #36]
    ldr w3, [x19, #40]
    ldr w4, [x19, #44]
    bl printf

    // Imprimir fila 4
    ldr x0, =fmt_row
    ldr w1, [x19, #48]
    ldr w2, [x19, #52]
    ldr w3, [x19, #56]
    ldr w4, [x19, #60]
    bl printf

    ldr x0, =newline
    bl printf

    ldp x29, x30, [sp], #16
    ret
