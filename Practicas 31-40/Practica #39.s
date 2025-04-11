/* ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Aproximación del seno de π/3 radianes usando series de Taylor.
 *               
 *  Demostración: [https://asciinema.org/a/4o06UBTZnB7QOlqhq1A9J8ikG]
 * ---------------------------------------------------------------------------------
 */

.global main
.extern printf

.section .rodata
.align 3
pi_third:   .double 1.0471975511965976  // π/3 exacto
one:        .double 1.0
neg_one:    .double -1.0
six:        .double 6.0
twenty:     .double 20.0
fortytwo:   .double 42.0
seventytwo: .double 72.0

fmt_result: .asciz "sin(%.4f) ≈ %.10f\n"
fmt_header: .asciz "\nCálculo exacto del seno (π/3):\n"

.section .text
main:
    // Prólogo
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    // Imprimir encabezado
    adrp x0, fmt_header
    add x0, x0, :lo12:fmt_header
    bl printf

    // ===== CARGAR CONSTANTES EXACTAS =====
    adrp x0, pi_third
    add x0, x0, :lo12:pi_third
    ldr d0, [x0]              // d0 = π/3

    // Cargar todas las constantes FP
    adrp x1, one
    add x1, x1, :lo12:one
    ldr d1, [x1]              // d1 = 1.0

    adrp x2, neg_one
    add x2, x2, :lo12:neg_one
    ldr d2, [x2]              // d2 = -1.0

    adrp x3, six
    add x3, x3, :lo12:six
    ldr d5, [x3]              // d5 = 6.0

    adrp x4, twenty
    add x4, x4, :lo12:twenty
    ldr d6, [x4]              // d6 = 20.0

    adrp x5, fortytwo
    add x5, x5, :lo12:fortytwo
    ldr d7, [x5]              // d7 = 42.0

    adrp x6, seventytwo
    add x6, x6, :lo12:seventytwo
    ldr d8, [x6]              // d8 = 72.0

    // ===== CÁLCULO DIRECTO DE CADA TÉRMINO =====
    // Término 1: x
    fmov d4, d0               // resultado = x

    // Término 2: -x³/6
    fmul d3, d0, d0           // x²
    fmul d3, d3, d0           // x³
    fdiv d3, d3, d5           // x³/6 (d5 = 6.0)
    fneg d3, d3               // -x³/6
    fadd d4, d4, d3           // resultado += término

    // Término 3: +x⁵/120
    fmul d3, d3, d0           // -x⁴/6
    fmul d3, d3, d0           // -x⁵/6
    fneg d3, d3               // x⁵/6
    fdiv d3, d3, d6           // x⁵/120 (d6 = 20.0)
    fadd d4, d4, d3           // resultado += término

    // Término 4: -x⁷/5040
    fmul d3, d3, d0           // x⁶/120
    fmul d3, d3, d0           // x⁷/120
    fdiv d3, d3, d7           // x⁷/5040 (d7 = 42.0)
    fneg d3, d3               // -x⁷/5040
    fadd d4, d4, d3           // resultado += término

    // Término 5: +x⁹/362880
    fmul d3, d3, d0           // -x⁸/5040
    fmul d3, d3, d0           // -x⁹/5040
    fneg d3, d3               // x⁹/5040
    fdiv d3, d3, d8           // x⁹/362880 (d8 = 72.0)
    fadd d4, d4, d3           // resultado += término

    // ===== IMPRIMIR RESULTADO =====
    adrp x0, fmt_result
    add x0, x0, :lo12:fmt_result
    fmov d0, d0               // Ángulo π/3
    fmov d1, d4               // Resultado final
    bl printf

    // Epílogo
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
