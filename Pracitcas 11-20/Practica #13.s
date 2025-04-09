/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Verificador de números primos en ARM64
 *               Determina si un número ingresado es primo mediante división trial
 *  Demostración: [ASCIINEMA.ORG/XXXXXX]
 * ---------------------------------------------------------------------------------
 */

.global main
.extern printf
.extern scanf

.section .data
number:     .word 0              // Almacena el número ingresado (inicializado a 0)

.section .rodata
prompt:     .asciz "Ingrese un número entero positivo: "
scan_fmt:   .asciz "%d"
prime_msg:  .asciz "%d ES un número primo\n"
notprime_msg: .asciz "%d NO es número primo\n"
error_msg:  .asciz "Error: El número debe ser mayor que 1\n"

.section .text
main:
    // Prólogo: Guardar registros
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    // Solicitar entrada
    ldr x0, =prompt
    bl printf

    // Leer número
    ldr x0, =scan_fmt
    ldr x1, =number
    bl scanf

    // Cargar y guardar el número
    ldr x1, =number
    ldr w19, [x1]               // w19 = número a verificar
    mov w9, w19                 // Guardar copia en w9 para printf

    // Casos especiales
    cmp w19, #1
    ble invalid_input

    // Inicialización
    mov w20, #2                 // w20 = divisor inicial (i=2)
    udiv w21, w19, w20          // w21 = n/2 (límite inicial)

prime_check_loop:
    cmp w20, w21                // ¿i > límite?
    bgt is_prime                // Si sí, es primo

    // Verificar divisibilidad
    udiv w22, w19, w20          // n/i
    msub w23, w22, w20, w19     // w23 = n % i
    cbz w23, not_prime          // Si resto=0, no es primo

    // Optimización: actualizar límite a √n
    add w20, w20, #1            // i++
    udiv w21, w19, w20          // nuevo límite = n/i
    b prime_check_loop

is_prime:
    ldr x0, =prime_msg
    mov w1, w9                  // Usar el valor guardado
    bl printf
    b exit

not_prime:
    ldr x0, =notprime_msg
    mov w1, w9                  // Usar el valor guardado
    bl printf
    b exit

invalid_input:
    ldr x0, =error_msg
    bl printf

exit:
    // Epílogo
    mov w0, #0                  // Retorno 0
    ldp x29, x30, [sp], #16
    ret
