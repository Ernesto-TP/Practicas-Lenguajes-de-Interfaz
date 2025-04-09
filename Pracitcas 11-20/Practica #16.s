/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Encuentra correctamente el valor máximo en un array de 7 elementos.
 *  Demostración: [ASCIINEMA.ORG/XXXXXX]
 * ---------------------------------------------------------------------------------
 */
.global main
.extern printf
.section .data
array:      .word 4, 3, 1, 10, 11, 7, 6
fmt_max:    .asciz "Máximo: %d\n"
.section .text
main:
    // Prologue
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Preparar parámetros para find_max
    ldr x0, =array             // x0 = dirección del array
    mov w1, #7                 // w1 = longitud del array
    bl find_max
    
    // Guardar resultado (w0) antes de llamar a printf
    mov w19, w0                // Preservar el valor máximo en w19
    
    // Preparar e imprimir resultado
    ldr x0, =fmt_max           // x0 = formato de impresión
    mov w1, w19                // w1 = valor máximo (guardado en w19)
    bl printf
    
    // Epilogue
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret

find_max:
    ldr w2, [x0]               // max = array[0]
    mov x3, #1                 // i = 1
    
find_loop:
    cmp x3, x1                 // Comparar con la longitud pasada como parámetro (w1)
    bge end_find
    
    lsl x4, x3, #2             // x4 = i * 4 (tamaño de word)
    ldr w4, [x0, x4]           // Carga array[i]
    
    cmp w4, w2
    ble next
    mov w2, w4                 // Actualiza max
    
next:
    add x3, x3, #1             // i++
    b find_loop
    
end_find:
    mov w0, w2                 // Devuelve max en w0
    ret
