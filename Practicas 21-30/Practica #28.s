/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Convierte mayúsculas a minúsculas en una cadena ingresada
 *  Demostración: [https://asciinema.org/a/8X04RgZy8C8eWD0R8XgDw3ZBB]
 * ---------------------------------------------------------------------------------
 */

.data
    prompt:     .asciz "Ingrese texto: "
    result:     .asciz "Texto convertido: %s\n"
    buffer:     .skip 100
    formato:    .asciz "%99[^\n]"  // Lee hasta newline

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

    // Leer cadena (incluyendo espacios)
    adrp x0, formato
    add x0, x0, :lo12:formato
    adrp x1, buffer
    add x1, x1, :lo12:buffer
    bl scanf

    // Configurar puntero
    adrp x19, buffer
    add x19, x19, :lo12:buffer

convert_loop:
    ldrb w20, [x19]         // Cargar carácter actual
    cbz w20, show_converted // Fin de cadena

    // Verificar si es mayúscula (A-Z)
    cmp w20, #'A'
    blt next_char
    cmp w20, #'Z'
    bgt next_char

    // Convertir a minúscula (+32 en ASCII)
    add w20, w20, #32
    strb w20, [x19]         // Guardar carácter convertido

next_char:
    add x19, x19, #1        // Siguiente carácter
    b convert_loop

show_converted:
    // Mostrar resultado
    adrp x0, result
    add x0, x0, :lo12:result
    adrp x1, buffer
    add x1, x1, :lo12:buffer
    bl printf

    // Epílogo
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
