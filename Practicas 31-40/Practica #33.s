/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Calcula el Mínimo Común Múltiplo (LCM) usando la relación
 *               LCM(a,b) = (a × b) / GCD(a,b). Incluye cálculo de GCD mediante
 *               el algoritmo de Euclides.
 *  Demostración: [https://asciinema.org/a/2VdLVKcG9vHaVI6OPCeWapkow]
 * ---------------------------------------------------------------------------------
 */

.data
    num1:       .word 24          // Primer número (modificar para probar)
    num2:       .word 36          // Segundo número
    lcm_msg:    .asciz "LCM(%d, %d) = %d\n"
    gcd_msg:    .asciz " (GCD calculado: %d)\n"

.text
.global main
.extern printf

/*
 * Función gcd: Calcula el Máximo Común Divisor usando el algoritmo de Euclides
 * Parámetros:
 *   w0 - Primer número (a)
 *   w1 - Segundo número (b)
 * Retorna:
 *   w0 - GCD(a,b)
 */
gcd:
    // Prólogo
    stp x29, x30, [sp, -16]!
    mov x29, sp

gcd_loop:
    cmp w1, #0                  // ¿b == 0?
    beq gcd_end                 // Si sí, terminar
    
    // Calcular a % b
    udiv w2, w0, w1             // w2 = a / b
    msub w2, w2, w1, w0         // w2 = a - (a/b)*b (módulo)
    
    // Preparar siguiente iteración: a = b, b = a % b
    mov w0, w1
    mov w1, w2
    b gcd_loop

gcd_end:
    // Epílogo
    ldp x29, x30, [sp], #16
    ret

/*
 * Función principal
 */
main:
    // Prólogo
    stp x29, x30, [sp, -32]!
    mov x29, sp

    // Cargar números
    ldr w19, =num1              // w19 = num1
    ldr w20, =num2              // w20 = num2

    // Calcular GCD primero
    mov w0, w19
    mov w1, w20
    bl gcd
    mov w21, w0                 // Guardar GCD en w21

    // Calcular LCM = (num1 × num2) / GCD
    mul w22, w19, w20           // w22 = num1 × num2
    udiv w23, w22, w21          // w23 = (num1×num2)/GCD

    // Mostrar resultados
    ldr x0, =lcm_msg
    mov w1, w19
    mov w2, w20
    mov w3, w23
    bl printf

    // Opcional: Mostrar GCD también
    ldr x0, =gcd_msg
    mov w1, w21
    bl printf

    // Epílogo
    mov w0, #0                  // Retorno 0
    ldp x29, x30, [sp], #32
    ret
