/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Cuenta dígitos numéricos y letras en una cadena ingresada
 *  Demostración: [ASCIINEMA.ORG/XXXXXX]
 * ---------------------------------------------------------------------------------
 */

.data
    prompt:     .asciz "Ingrese texto: "
    digit_msg:  .asciz "Dígitos: %d\n"
    letter_msg: .asciz "Letras: %d\n"
    buffer:     .skip 100
    formato:    .asciz "%99s"

.text
.global main
.extern printf
.extern scanf

main:
    // Prólogo
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Mostrar prompt
    adrp x0, prompt
    add x0, x0, :lo12:prompt
    bl printf

    // Leer cadena
    adrp x0, formato
    add x0, x0, :lo12:formato
    adrp x1, buffer
    add x1, x1, :lo12:buffer
    bl scanf

    // Inicializar contadores
    mov x19, #0          // Contador de dígitos
    mov x20, #0          // Contador de letras
    adrp x21, buffer
    add x21, x21, :lo12:buffer  // Puntero a la cadena

count_loop:
    ldrb w22, [x21]      // Cargar carácter actual
    cbz w22, show_result // Fin de cadena

    // Verificar si es dígito (0-9)
    cmp w22, #'0'
    blt check_letter
    cmp w22, #'9'
    bgt check_letter
    add x19, x19, #1     // Incrementar contador de dígitos
    b next_char

check_letter:
    // Verificar si es letra mayúscula (A-Z)
    cmp w22, #'A'
    blt next_char
    cmp w22, #'Z'
    ble is_letter
    
    // Verificar si es letra minúscula (a-z)
    cmp w22, #'a'
    blt next_char
    cmp w22, #'z'
    bgt next_char

is_letter:
    add x20, x20, #1     // Incrementar contador de letras

next_char:
    add x21, x21, #1     // Mover al siguiente carácter
    b count_loop

show_result:
    // Mostrar conteo de dígitos
    adrp x0, digit_msg
    add x0, x0, :lo12:digit_msg
    mov x1, x19
    bl printf

    // Mostrar conteo de letras
    adrp x0, letter_msg
    add x0, x0, :lo12:letter_msg
    mov x1, x20
    bl printf

    // Epílogo
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
