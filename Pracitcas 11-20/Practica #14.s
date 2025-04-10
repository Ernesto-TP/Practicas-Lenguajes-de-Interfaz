/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Verificador de palíndromos en ARM64
 *               Compara una cadena hardcodeada para determinar si es palíndromo
 *               (se lee igual de izquierda a derecha y viceversa)
 *  Demostración: [https://asciinema.org/a/YEZY1VQrNKtcRAagQA6zkNiHT]
 * ---------------------------------------------------------------------------------
 */

.global main
.extern printf

.section .rodata
string:    .asciz "reconocer"    // Cadena a verificar (cambiar para probar otros casos)
true_msg:  .asciz "La cadena \"%s\" ES un palíndromo\n"
false_msg: .asciz "La cadena \"%s\" NO es un palíndromo\n"

.section .text
main:
    // Prologue
    stp x29, x30, [sp, #-16]!   // Guardar registros
    mov x29, sp                  // Establecer frame pointer

    // Inicialización de punteros
    ldr x0, =string              // x0 = inicio del string
    mov x1, x0                   // x1 = copia para encontrar el final

find_end:
    ldrb w2, [x1], #1            // Cargar byte y avanzar puntero
    cmp w2, #0                   // ¿Llegamos al null terminator?
    bne find_end                 // Si no, continuar
    sub x1, x1, #2               // Ajustar al último carácter válido

check_loop:
    cmp x0, x1                   // ¿Punteros se cruzaron?
    bge is_palindrome            // Si sí, es palíndromo

    ldrb w2, [x0], #1            // Cargar carácter izquierdo
    ldrb w3, [x1], #-1           // Cargar carácter derecho
    cmp w2, w3                   // ¿Caracteres iguales?
    bne not_palindrome           // Si no, terminar

    b check_loop                 // Repetir

is_palindrome:
    ldr x0, =true_msg            // Mensaje de éxito
    b print_result

not_palindrome:
    ldr x0, =false_msg           // Mensaje de fallo

print_result:
    ldr x1, =string              // Cargar string para printf
    bl printf

    // Epilogue
    mov w0, #0                   // Retorno 0 (éxito)
    ldp x29, x30, [sp], #16      // Restaurar registros
    ret
