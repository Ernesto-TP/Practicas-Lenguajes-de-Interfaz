/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Verifica si un número es de Armstrong (la suma de sus dígitos elevados
 *               al número de dígitos es igual al número mismo)
 *  Demostración: [ASCIINEMA.ORG/XXXXXX]
 * ---------------------------------------------------------------------------------
 */
.global main
.text
// Función para contar dígitos
// Entrada: x0 = número
// Salida: x0 = conteo de dígitos
count_digits:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    mov     x1, #0          // Inicializar contador
    mov     x2, #10         // Divisor constante
    
    // Si el número es 0, debe tener al menos 1 dígito
    cmp     x0, #0
    bne     count_loop
    mov     x0, #1
    b       count_exit
    
count_loop:
    cmp     x0, #0
    beq     count_done
    
    udiv    x0, x0, x2      // Dividir entre 10 (usando registro x2)
    add     x1, x1, #1      // Incrementar contador
    b       count_loop
    
count_done:
    mov     x0, x1          // Devolver conteo

count_exit:
    ldp     x29, x30, [sp], #16
    ret

// Función para calcular potencia
// Entrada: x0 = base, x1 = exponente
// Salida: x0 = resultado
power:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    mov     x2, #1          // Resultado inicial
    
power_loop:
    cmp     x1, #0
    beq     power_done
    
    mul     x2, x2, x0      // Multiplicar por base
    sub     x1, x1, #1      // Decrementar exponente
    b       power_loop
    
power_done:
    mov     x0, x2          // Devolver resultado
    ldp     x29, x30, [sp], #16
    ret

// Función para verificar Armstrong
// Entrada: x0 = número
// Salida: x0 = 1 (es Armstrong), 0 (no es Armstrong)
is_armstrong:
    stp     x29, x30, [sp, #-64]!
    stp     x19, x20, [sp, #16]
    stp     x21, x22, [sp, #32]
    stp     x23, x24, [sp, #48]
    mov     x29, sp
    
    mov     x19, x0         // Guardar número original
    mov     x20, x0         // Copia para trabajar
    mov     x23, #10        // Divisor constante
    mov     x24, #10        // Para operación módulo
    
    // Contar dígitos
    bl      count_digits
    mov     x21, x0         // Guardar conteo de dígitos (n)
    
    mov     x22, #0         // Inicializar suma
    mov     x20, x19        // Restaurar copia para trabajar
    
sum_loop:
    cmp     x20, #0
    beq     check_armstrong
    
    // Obtener último dígito
    udiv    x0, x20, x23    // x0 = x20 / 10
    msub    x1, x0, x24, x20 // x1 = x20 % 10
    mov     x20, x0         // x20 = x20 / 10
    
    // Calcular dígito^n
    mov     x0, x1
    mov     x1, x21
    bl      power
    
    // Sumar a total
    add     x22, x22, x0
    
    b       sum_loop

check_armstrong:
    // Comparar suma con número original
    cmp     x22, x19
    cset    x0, eq          // x0 = 1 si igual, 0 si no
    
    ldp     x23, x24, [sp, #48]
    ldp     x21, x22, [sp, #32]
    ldp     x19, x20, [sp, #16]
    ldp     x29, x30, [sp], #64
    ret

main:
    // Reserve stack space and save registers
    // Make sure stack remains 16-byte aligned
    stp     x29, x30, [sp, #-32]!  // Reserve 32 bytes (2 register pairs)
    str     x19, [sp, #16]        // Use part of the reserved space
    mov     x29, sp               // Set frame pointer
    
    sub     sp, sp, #16          // Reserve additional space for scanf
    
    // Solicitar input al usuario
    adr     x0, input_prompt
    bl      printf
    
    // Leer número del usuario
    adr     x0, input_format
    mov     x1, sp               // Use the reserved stack space for the number
    bl      scanf
    
    // Cargar número leído en x19
    ldr     x19, [sp]
    
    // Imprimir mensaje inicial
    adr     x0, prompt_msg
    mov     x1, x19
    bl      printf
    
    // Verificar si es número Armstrong
    mov     x0, x19
    bl      is_armstrong
    
    // Imprimir resultado
    cmp     x0, #1
    bne     not_armstrong
    
    adr     x0, armstrong_msg
    mov     x1, x19
    bl      printf
    b       exit_program
    
not_armstrong:
    adr     x0, not_armstrong_msg
    mov     x1, x19
    bl      printf

exit_program:
    // Restore stack and registers
    add     sp, sp, #16          // Free the additional space
    ldr     x19, [sp, #16]       // Restore x19
    ldp     x29, x30, [sp], #32  // Restore frame pointer and link register, and free stack
    
    // Return 0
    mov     w0, #0
    ret

.section .rodata
input_prompt:
    .string "Ingrese un número para verificar si es Armstrong: "
input_format:
    .string "%ld"
prompt_msg:
    .string "\nVerificando si %ld es un número Armstrong...\n"
armstrong_msg:
    .string "\n¡Sí! %ld es un número Armstrong.\n"
not_armstrong_msg:
    .string "\nNo, %ld no es un número Armstrong.\n"
