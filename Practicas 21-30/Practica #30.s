/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Calcula el Mínimo Común Múltiplo (LCM) usando la relación
 *               LCM(a,b) = (a × b) / GCD(a,b). Incluye cálculo de GCD mediante
 *               el algoritmo de Euclides.
 *  Demostración: [https://asciinema.org/a/6pR58lNRRmva1Un3l10pb4Wdi]
 * ---------------------------------------------------------------------------------
 */

.global main
.text

// Función para calcular el MCD usando el algoritmo de Euclides
mcd:
    // x0 y x1 contienen los números para calcular el MCD
    // Guardamos los registros que vamos a usar
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

mcd_loop:
    // Si b (x1) es 0, el MCD está en a (x0)
    cmp     x1, #0
    beq     mcd_end
    
    // Dividir a entre b para obtener el resto
    udiv    x2, x0, x1      // x2 = a / b
    msub    x2, x2, x1, x0  // x2 = a - (a / b) * b (resto)
    
    // a = b, b = resto
    mov     x0, x1
    mov     x1, x2
    
    b       mcd_loop

mcd_end:
    ldp     x29, x30, [sp], #16
    ret

main:
    // Guardamos el link register
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Números para calcular el MCD
    mov     x19, #48        // Primer número
    mov     x20, #18        // Segundo número

    // Imprimir mensaje inicial
    adr     x0, msg1
    mov     x1, x19
    mov     x2, x20
    bl      printf

    // Calcular MCD
    mov     x0, x19
    mov     x1, x20
    bl      mcd
    mov     x21, x0         // Guardamos el resultado

    // Imprimir el proceso paso a paso
    mov     x0, x19
    mov     x1, x20
    bl      print_steps

    // Imprimir resultado
    adr     x0, msg2
    mov     x1, x21
    bl      printf

    // Restauramos el stack y retornamos
    ldp     x29, x30, [sp], #16
    mov     w0, #0
    ret

// Función para imprimir los pasos del algoritmo
print_steps:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    // Guardamos los valores originales
    stp     x19, x20, [sp, #-16]!
    mov     x19, x0
    mov     x20, x1

print_loop:
    cmp     x20, #0
    beq     print_end
    
    // Imprimir paso actual
    adr     x0, step_msg
    mov     x1, x19
    mov     x2, x20
    bl      printf
    
    // Calcular siguiente paso
    udiv    x2, x19, x20
    msub    x2, x2, x20, x19
    
    // Actualizar valores para siguiente iteración
    mov     x19, x20
    mov     x20, x2
    
    b       print_loop

print_end:
    ldp     x19, x20, [sp], #16
    ldp     x29, x30, [sp], #16
    ret

.section .rodata
msg1:
    .string "\nCalculando el MCD de %d y %d\n"
msg2:
    .string "\nEl MCD es: %d\n"
step_msg:
    .string "Dividiendo %d entre %d\n"
