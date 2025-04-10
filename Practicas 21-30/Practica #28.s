/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Cuenta palabras en una cadena (separadas por espacios)
 *  Demostración: [https://asciinema.org/a/8X04RgZy8C8eWD0R8XgDw3ZBB]
 * ---------------------------------------------------------------------------------
 */

.data
    prompt:     .asciz "Ingrese texto: "
    count_msg:  .asciz "Número de palabras: %d\n"
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

    // Inicializar contadores
    mov x19, #0          // Contador de palabras
    mov w20, #0          // Estado: 0 = fuera de palabra, 1 = en palabra
    adrp x21, buffer
    add x21, x21, :lo12:buffer  // Puntero a la cadena

count_loop:
    ldrb w22, [x21]      // Cargar carácter actual
    cbz w22, end_count   // Fin de cadena

    // Verificar si es espacio (ASCII 32)
    cmp w22, #32
    bne not_space

is_space:
    // Si encontramos espacio y estábamos en palabra
    cmp w20, #1
    bne skip_increment
    mov w20, #0          // Cambiar estado a "fuera de palabra"
    b skip_increment

not_space:
    // Si no es espacio y estábamos fuera de palabra
    cmp w20, #1
    beq skip_increment
    mov w20, #1          // Cambiar estado a "en palabra"
    add x19, x19, #1     // Incrementar contador

skip_increment:
    add x21, x21, #1     // Siguiente carácter
    b count_loop

end_count:
    // Mostrar resultado
    adrp x0, count_msg
    add x0, x0, :lo12:count_msg
    mov x1, x19
    bl printf

    // Epílogo
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
