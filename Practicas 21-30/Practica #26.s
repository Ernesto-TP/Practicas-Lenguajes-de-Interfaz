/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Cuenta la frecuencia de cada letra en una cadena (ignora mayúsculas/minúsculas)
 *  Demostración: [ASCIINEMA.ORG/XXXXXX]
 * ---------------------------------------------------------------------------------
 */

.data
    prompt:     .asciz "Ingrese texto: "
    result_msg: .asciz "Frecuencia de '%c': %d\n"
    buffer:     .skip 100
    formato:    .asciz "%99[^\n]"
    freq_table: .skip 26        // Tabla para a-z (26 letras)

.text
.global main
.extern printf
.extern scanf
.extern memset

main:
    // Prólogo
    stp x29, x30, [sp, -32]!
    mov x29, sp

    // Inicializar tabla de frecuencias a 0
    ldr x0, =freq_table
    mov w1, #0
    mov w2, #26
    bl memset

    // Mostrar prompt
    ldr x0, =prompt
    bl printf

    // Leer cadena
    ldr x0, =formato
    ldr x1, =buffer
    bl scanf

    // Configurar puntero
    ldr x19, =buffer

count_loop:
    ldrb w20, [x19]         // Cargar carácter actual
    cbz w20, print_results  // Fin de cadena

    // Convertir a minúscula si es mayúscula
    cmp w20, #'A'
    blt next_char
    cmp w20, #'Z'
    bgt check_lower
    add w20, w20, #32       // Convertir a minúscula
    b check_letter

check_lower:
    cmp w20, #'a'
    blt next_char
    cmp w20, #'z'
    bgt next_char

check_letter:
    // Calcular índice (a=0, z=25)
    sub w21, w20, #'a'
    ldr x22, =freq_table
    ldrb w23, [x22, x21]    // Cargar frecuencia actual
    add w23, w23, #1        // Incrementar
    strb w23, [x22, x21]    // Guardar

next_char:
    add x19, x19, #1        // Siguiente carácter
    b count_loop

print_results:
    // Imprimir resultados para letras con frecuencia > 0
    mov w24, #0            // Contador de letras (a=0)
    ldr x25, =freq_table

print_loop:
    cmp w24, #26
    bge exit

    ldrb w26, [x25, w24, uxtw] // Cargar frecuencia
    cbz w26, skip_print

    // Preparar parámetros para printf
    ldr x0, =result_msg
    add w1, w24, #'a'      // Letra actual
    mov w2, w26            // Frecuencia
    bl printf

skip_print:
    add w24, w24, #1       // Siguiente letra
    b print_loop

exit:
    // Epílogo
    mov w0, #0
    ldp x29, x30, [sp], #32
    ret
