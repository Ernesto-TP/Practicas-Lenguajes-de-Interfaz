/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz - TECNM Campus ITT
 *  Autor: Ernesto Torres Pineda
 *  Fecha: 2025-04-10
 *  Descripción: Resuelve ecuaciones cuadráticas de la forma ax² + bx + c = 0
 *               Calcula raíces reales usando la fórmula cuadrática con precisión
 *               de punto flotante. Maneja casos especiales (discriminante negativo).
 *  Demostración: [https://asciinema.org/a/qhUSaHzejUBJIjORhNjaOhrym]
 * ---------------------------------------------------------------------------------
 */

.data
    // Coeficientes de prueba (ax² + bx + c = 0)
    a:          .double 1.0     // Coeficiente cuadrático (cambiar para probar)
    b:          .double -5.0    // Coeficiente lineal
    c:          .double 6.0     // Término constante
    zero:       .double 0.0     // Constante cero para comparaciones

    // Mensajes de salida
    prompt:     .asciz "Resolviendo: %.2fx² + %.2fx + %.2f = 0\n"
    real_roots: .asciz "Raíces reales:\nx₁ = %.4f\nx₂ = %.4f\n"
    one_root:   .asciz "Raíz única:\nx = %.4f\n"
    no_real:    .asciz "No hay raíces reales (discriminante negativo)\n"
    disc_msg:   .asciz "Discriminante: %.4f\n"

.text
.global main
.extern printf
.extern sqrt

/*
 * Función: solve_quadratic
 * Parámetros:
 *   d0 - a (coeficiente cuadrático)
 *   d1 - b (coeficiente lineal)
 *   d2 - c (término constante)
 * Retorna:
 *   d0 - x₁ (primera raíz)
 *   d1 - x₂ (segunda raíz)
 *   w0 - 2 (raíces reales), 1 (raíz única), 0 (sin raíces reales)
 */
solve_quadratic:
    // Prólogo
    stp x29, x30, [sp, -80]!
    mov x29, sp

    // Guardar coeficientes en stack para recuperarlos después
    str d0, [sp, 16]          // Guardar a
    str d1, [sp, 24]          // Guardar b
    str d2, [sp, 32]          // Guardar c

    // Calcular discriminante (b² - 4ac)
    fmul d3, d1, d1            // d3 = b²
    fmul d4, d0, d2            // d4 = a*c
    mov x0, #4
    scvtf d5, x0               // d5 = 4.0
    fmul d4, d4, d5            // d4 = 4ac
    fsub d3, d3, d4            // d3 = discriminante (b² - 4ac)

    // Guardar discriminante para posible impresión
    str d3, [sp, 40]

    // Cargar cero para comparación
    adr x0, zero
    ldr d4, [x0]               // d4 = 0.0

    // Caso 1: Discriminante negativo (no raíces reales)
    fcmp d3, d4
    b.lt no_real_roots

    // Caso 2: Discriminante cero (raíz única)
    b.eq single_root

    // Caso 3: Dos raíces reales ----------------------------
    // Calcular sqrt(discriminante)
    fmov d0, d3               // Pasar discriminante a d0 para sqrt
    bl sqrt
    fmov d3, d0               // Guardar resultado de sqrt en d3

    // Recuperar valores de a y b (dañados por la llamada a sqrt)
    ldr d0, [sp, 16]         // Recuperar a
    ldr d1, [sp, 24]         // Recuperar b

    // Calcular denominador (2a)
    mov x0, #2
    scvtf d4, x0               // d4 = 2.0
    fmul d4, d0, d4            // d4 = 2a

    // Calcular x₁ = (-b + √disc) / (2a)
    fneg d5, d1                // d5 = -b
    fadd d6, d5, d3            // d6 = -b + √disc
    fdiv d0, d6, d4            // x₁ = (-b + √disc)/2a

    // Calcular x₂ = (-b - √disc) / (2a)
    fsub d6, d5, d3            // d6 = -b - √disc
    fdiv d1, d6, d4            // x₂ = (-b - √disc)/2a

    mov w0, #2                 // Retornar código 2 (dos raíces)
    b quad_end

single_root:
    // x = -b / (2a)
    ldr d0, [sp, 16]         // Recuperar a
    ldr d1, [sp, 24]         // Recuperar b
    
    fneg d5, d1                // d5 = -b
    mov x0, #2
    scvtf d4, x0               // d4 = 2.0
    fmul d4, d0, d4            // d4 = 2a
    fdiv d0, d5, d4            // x = -b/2a
    fmov d1, d0                // Ambas raíces iguales
    mov w0, #1                 // Retornar código 1 (raíz única)
    b quad_end

no_real_roots:
    mov w0, #0                 // Retornar código 0 (sin raíces reales)

quad_end:
    // Epílogo
    ldp x29, x30, [sp], 80
    ret

/*
 * Función principal
 */
main:
    // Prólogo
    stp x29, x30, [sp, -80]!   // Aumentamos espacio para variables locales
    mov x29, sp

    // Cargar coeficientes
    adr x0, a
    ldr d0, [x0]
    str d0, [sp, 16]          // Guardar a
    
    adr x0, b
    ldr d1, [x0]
    str d1, [sp, 24]          // Guardar b
    
    adr x0, c
    ldr d2, [x0]
    str d2, [sp, 32]          // Guardar c

    // Mostrar ecuación a resolver
    adr x0, prompt
    ldr d0, [sp, 16]          // a
    ldr d1, [sp, 24]          // b
    ldr d2, [sp, 32]          // c
    bl printf

    // Resolver la ecuación
    ldr d0, [sp, 16]          // a
    ldr d1, [sp, 24]          // b
    ldr d2, [sp, 32]          // c
    bl solve_quadratic
    
    // Guardar resultados antes de printf
    str w0, [sp, 48]          // Guardar código de retorno
    str d0, [sp, 56]          // Guardar primera raíz
    str d1, [sp, 64]          // Guardar segunda raíz

    // Manejar resultados según el código de retorno
    ldr w0, [sp, 48]
    cmp w0, #2
    b.eq two_roots
    cmp w0, #1
    b.eq one_root_case

    // Caso sin raíces reales
    adr x0, no_real
    bl printf
    b end

two_roots:
    // Mostrar dos raíces
    adr x0, real_roots
    ldr d0, [sp, 56]          // Primera raíz
    ldr d1, [sp, 64]          // Segunda raíz
    bl printf
    b show_disc

one_root_case:
    // Mostrar raíz única
    adr x0, one_root
    ldr d0, [sp, 56]          // Raíz única
    bl printf

show_disc:
    // Opcional: Mostrar discriminante
    adr x0, disc_msg
    ldr d0, [sp, 40]          // Recuperar discriminante guardado
    bl printf

end:
    // Epílogo
    mov w0, #0
    ldp x29, x30, [sp], 80
    ret
