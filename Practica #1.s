/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz en TECNM Campus ITT
 *  Autor: [Ernesto Torres Pineda]
 *  Fecha: [2025-04-01]
 *  Descripción: Programa que captura nombre y lo despliega
 *  Demostración:  [https://asciinema.org/a/Lk4EtwKDJIVlmWsMcg3BIng78]
 * ---------------------------------------------------------------------------------
 */

    .global _start
    .section .bss
name: .skip 100  // Espacio reservado para el nombre

    .section .text
_start:
    // Leer nombre desde entrada estándar
    mov x0, #0         // STDIN
    ldr x1, =name      // Dirección del buffer
    mov x2, #100       // Tamaño del buffer
    mov x8, #63        // syscall: read
    svc #0             

    // Imprimir mensaje
    mov x0, #1         // STDOUT
    ldr x1, =msg       // Dirección del mensaje
    mov x2, #18        // Longitud del mensaje
    mov x8, #64        // syscall: write
    svc #0             

    // Imprimir nombre
    mov x0, #1         // STDOUT
    ldr x1, =name      // Dirección del buffer con el nombre
    mov x2, #100       // Tamaño del buffer
    mov x8, #64        // syscall: write
    svc #0             

    // Salir del programa
    mov x8, #93        // syscall: exit
    mov x0, #0
    svc #0

    .section .data
msg: .asciz "Nombre ingresado: "
