/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Multiplicación con detección de desbordamiento para enteros de 64 bits
 *  Demostración: [https://asciinema.org/a/8BpzOn0TP3MHwfeeQe4Hn6uxg]
 * ---------------------------------------------------------------------------------
 */

.data
prompt1:    .string "Ingrese primer número: "
prompt2:    .string "Ingrese segundo número: "
result:     .string "Producto: %ld\n"
overflow:   .string "¡Desbordamiento detectado!\n"
no_overflow:.string "No hubo desbordamiento\n"
format:     .string "%ld"

.text
.global main
main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    // Leer primer número
    adr x0, prompt1
    bl printf
    sub sp, sp, #16
    mov x1, sp
    adr x0, format
    bl scanf
    ldr x19, [sp]        // x19 = primer número

    // Leer segundo número
    adr x0, prompt2
    bl printf
    mov x1, sp
    adr x0, format
    bl scanf
    ldr x20, [sp]        // x20 = segundo número
    add sp, sp, #16

    // Realizar multiplicación y detectar overflow
    smulh x21, x19, x20  // Parte alta del producto
    mul x22, x19, x20    // Parte baja del producto
    
    // Verificar overflow (parte alta debe ser igual a producto extendido con signo)
    asr x23, x22, #63    // Extender signo de parte baja
    cmp x21, x23
    b.ne overflow_detected

no_overflow_detected:
    // Imprimir resultado
    adr x0, result
    mov x1, x22
    bl printf
    
    // Imprimir mensaje sin overflow
    adr x0, no_overflow
    bl printf
    b end

overflow_detected:
    // Imprimir resultado (puede estar incorrecto)
    adr x0, result
    mov x1, x22
    bl printf
    
    // Imprimir mensaje de overflow
    adr x0, overflow
    bl printf

end:
    ldp x29, x30, [sp], #16
    mov w0, #0
    ret
