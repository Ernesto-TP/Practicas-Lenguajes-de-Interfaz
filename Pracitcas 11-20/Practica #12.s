/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Determina si un número es positivo, negativo o cero
 *               Lee un número entero ingresado por el usuario
 *  Demostración: [ASCIINEMA.ORG/XXXXXX]
 * ---------------------------------------------------------------------------------
 */
.global main
.extern printf
.extern scanf

.section .data
number:     .word 0              // Almacena el número ingresado (4 bytes = 32 bits)

.section .rodata
prompt:     .asciz "Ingrese un número entero: "  // Mensaje para solicitar entrada
fmt_scan:   .asciz "%d"                          // Formato para lectura de entero
positive:   .asciz "El número %d es positivo\n"  // Mensaje para números > 0
negative:   .asciz "El número %d es negativo\n"  // Mensaje para números < 0
zero:       .asciz "El número ingresado es cero\n" // Mensaje para número = 0

.section .text
main:
    // Prólogo: Guardar registros y establecer frame pointer
    stp x29, x30, [sp, -16]!    // Reserva 16 bytes en el stack
    mov x29, sp                  // Establece frame pointer
    
    // Mostrar prompt
    ldr x0, =prompt              // Carga dirección del mensaje
    bl printf                    // Llama a función de impresión
    
    // Leer número
    ldr x0, =fmt_scan            // Formato "%d" para scanf
    ldr x1, =number              // Dirección donde almacenar el número
    bl scanf                     // Llama a función de lectura
    
    // Cargar número a registro w0
    ldr x1, =number              // Carga la dirección de number
    ldr w0, [x1]                 // w0 = valor leído (32 bits)
    
    // Guardar el número para uso posterior
    mov w9, w0                   // Salvar el número en w9 para usarlo después
    
    // Determinar signo mediante comparación
    cmp w0, #0                   // Compara con cero
    bgt es_positivo              // Salta si mayor que cero (positive)
    blt es_negativo              // Salta si menor que cero (negative)
                                 // Si no salta, es cero
    
    // ----- Caso Cero -----
    ldr x0, =zero                // Carga mensaje para cero
    bl printf                    // Imprime resultado
    b exit                       // Salta al final
    
es_positivo:
    // ----- Caso Positivo -----
    ldr x0, =positive            // Carga mensaje positivo
    mov w1, w9                   // Usa el número guardado en w9
    bl printf                    // Imprime resultado
    b exit                       // Salta al final
    
es_negativo:
    // ----- Caso Negativo -----
    ldr x0, =negative            // Carga mensaje negativo
    mov w1, w9                   // Usa el número guardado en w9
    bl printf                    // Imprime resultado
    
exit:
    mov w0, #0                   // Código de retorno 0 (éxito)
    ldp x29, x30, [sp], 16       // Restaura registros FP y LR
    ret                          // Retorna al sistema operativo
