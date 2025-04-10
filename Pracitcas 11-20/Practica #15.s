/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Invierte una cadena ingresada por el usuario
 *  Demostración: [https://asciinema.org/a/I0WHjL44iEJY7hOwM4iQvUozg]
 * ---------------------------------------------------------------------------------
 */
.global main
.extern printf
.extern scanf

.section .data
buffer:     .space 100        // Buffer para almacenar la entrada (99 chars + null)
fmt_scan:   .asciz "%99s"     // Formato para scanf

.section .rodata
prompt:     .asciz "Ingrese una cadena para invertir: "
fmt_rev:    .asciz "Cadena invertida: %s\n"

.section .text
main:
    // Guardar registros en la pila
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Mostrar prompt
    adr x0, prompt
    bl printf
    
    // Leer entrada con scanf en lugar de fgets
    adr x0, fmt_scan
    adr x1, buffer
    bl scanf
    
    // Calcular longitud de la cadena
    adr x0, buffer
    bl strlen_custom
    
    // Ahora x0 contiene la longitud
    mov x2, x0                // guardar longitud en x2
    
    // Invertir cadena
    adr x0, buffer
    mov x1, #0                // i = 0
    sub x2, x2, #1            // j = len-1
    
reverse_loop:
    cmp x1, x2
    bge end_reverse           // si i >= j, terminamos
    
    ldrb w3, [x0, x1]         // cargar string[i]
    ldrb w4, [x0, x2]         // cargar string[j]
    
    strb w4, [x0, x1]         // string[i] = w4
    strb w3, [x0, x2]         // string[j] = w3
    
    add x1, x1, #1            // i++
    sub x2, x2, #1            // j--
    b reverse_loop
    
end_reverse:
    // Imprimir resultado
    adr x0, fmt_rev
    adr x1, buffer
    bl printf
    
    // Restaurar registros y retornar
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret

// Función personalizada para calcular longitud de cadena
strlen_custom:
    mov x1, #0                // Contador de longitud
    
strlen_loop:
    ldrb w2, [x0, x1]         // Cargar byte en la posición actual
    cbz w2, strlen_end        // Si es cero, fin de cadena
    add x1, x1, #1            // Incrementar contador
    b strlen_loop
    
strlen_end:
    mov x0, x1                // Retornar longitud en x0
    ret
