/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Cálculo aproximado del coseno usando series de Taylor. 
 *  Demostración: [https://asciinema.org/a/Gj01iFmsEqslN03SlhCeT9h2o]
 * ---------------------------------------------------------------------------------
 */

.global main
.extern printf
.extern atof

.section .rodata
.align 3
fmt_prompt: .asciz "Uso: %s <ángulo_en_radianes>\nEjemplo: %s 1.0472 (para π/3)\n"
fmt_result: .asciz "\ncos(%.4f) = %.10f\n"
fmt_header: .asciz "\nCálculo del coseno usando series de Taylor (5 términos)\n"

one:        .double 1.0
two:        .double 2.0
twentyfour: .double 24.0
seven20:    .double 720.0
four0320:   .double 40320.0

.section .text
main:
    stp x29, x30, [sp, #-32]!
    mov x29, sp

    // Verificar argumentos
    cmp x0, #2
    b.lt missing_arg

    // Convertir argumento a double
    ldr x0, [x1, #8]
    bl atof                   // d0 = ángulo
    b calc_cosine

missing_arg:
    ldr x0, =fmt_prompt
    ldr x1, [x1]              // argv[0]
    mov x2, x1                // Segundo %s
    bl printf
    mov w0, #1
    b exit

calc_cosine:
    fmov d10, d0              // d10 = x (ángulo)

    // Imprimir encabezado
    ldr x0, =fmt_header
    bl printf

    // ===== CARGAR CONSTANTES CORRECTAMENTE =====
    adrp x0, one              // Cargar dirección de 'one'
    add x0, x0, :lo12:one
    ldr d1, [x0]              // d1 = 1.0

    adrp x0, two
    add x0, x0, :lo12:two
    ldr d5, [x0]              // d5 = 2.0

    adrp x0, twentyfour
    add x0, x0, :lo12:twentyfour
    ldr d6, [x0]              // d6 = 24.0

    adrp x0, seven20
    add x0, x0, :lo12:seven20
    ldr d7, [x0]              // d7 = 720.0

    adrp x0, four0320
    add x0, x0, :lo12:four0320
    ldr d8, [x0]              // d8 = 40320.0

    // ===== CÁLCULO EXACTO =====
    // Término 0: 1
    fmov d4, d1               // resultado = 1.0

    // Término 1: -x²/2!
    fmul d2, d10, d10         // x²
    fdiv d2, d2, d5           // x²/2!
    fneg d2, d2               // -x²/2!
    fadd d4, d4, d2

    // Término 2: +x⁴/4!
    fmul d2, d10, d10         // x²
    fmul d2, d2, d2           // x⁴
    fdiv d2, d2, d6           // x⁴/4!
    fadd d4, d4, d2

    // Término 3: -x⁶/6!
    fmul d2, d10, d10         // x²
    fmul d2, d2, d2           // x⁴
    fmul d2, d2, d10          // x⁵
    fmul d2, d2, d10          // x⁶
    fdiv d2, d2, d7           // x⁶/6!
    fneg d2, d2               // -x⁶/6!
    fadd d4, d4, d2

    // Término 4: +x⁸/8!
    fmul d2, d10, d10         // x²
    fmul d2, d2, d2           // x⁴
    fmul d2, d2, d2           // x⁸
    fdiv d2, d2, d8           // x⁸/8!
    fadd d4, d4, d2

    // Imprimir resultado
    ldr x0, =fmt_result
    fmov d0, d10              // Ángulo
    fmov d1, d4               // Resultado
    bl printf

    mov w0, #0

exit:
    ldp x29, x30, [sp], #32
    ret
