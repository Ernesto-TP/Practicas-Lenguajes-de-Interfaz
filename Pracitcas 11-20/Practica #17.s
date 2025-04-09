/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: [Ernesto Torres Pineda]
 *  Fecha: [2025-04-08]
 *  Descripción: Suma dos arrays de 5 elementos y guarda el resultado en un tercero.
 *  Demostración: [ASCIINEMA.ORG/.....]
 * ---------------------------------------------------------------------------------
 */
.global main
.extern printf
.section .data
array1:     .word 1, 2, 3, 4, 5       // Primer array
array2:     .word 6, 7, 8, 9, 10      // Segundo array
result:     .word 0, 0, 0, 0, 0        // Array resultado
fmt:        .asciz "Suma[%d]: %d\n"
.section .text
main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    mov x19, #0                  // Índice (i = 0)
    ldr x20, =array1             // Dirección de array1
    ldr x21, =array2             // Dirección de array2
    ldr x22, =result             // Dirección de resultado

loop:
    cmp x19, #5                  // ¿i < 5?
    bge end

    ldr w23, [x20, x19, lsl #2]  // Carga array1[i] (offset = i * 4)
    ldr w24, [x21, x19, lsl #2]  // Carga array2[i]
    add w25, w23, w24            // Suma
    str w25, [x22, x19, lsl #2]  // Guarda en result[i]

    // Imprime resultado
    ldr x0, =fmt
    mov w1, w19                  // Índice
    ldr w2, [x22, x19, lsl #2]   // Valor calculado
    bl printf

    add x19, x19, #1             // i++
    b loop

end:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
