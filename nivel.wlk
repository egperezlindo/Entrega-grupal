import wollok.game.*
import visuales.* // Importa a los "actores"

/**
 * Objeto principal que actúa como el "Controlador del Juego".
 * ¡VERSIÓN FINAL CON TODAS LAS FUNCIONES!
 * - Movimiento y Colisiones (X/Y) FUNCIONANDO.
 * - Tecla "F" con 3 vidas y MENSAJES FUNCIONANDO.
 * - Movimiento aleatorio de IA FUNCIONANDO.
 */
object nivel {
    
    // --- Configuración del Tablero ---
    const anchoTotal = 20 
    const altoTotal = 10
    
    // --- Lógica de Progresión ---
    var property enemigosVivos = [
        visuales.avispa,
        visuales.oso,
        visuales.slime,
        visuales.dragon
    ]
    
    
    /**
     * Método de inicialización principal.
     */
    method iniciarJuego() {
        
        game.width(anchoTotal)
        game.height(altoTotal)
        game.title("6bits RPG - Estable")
        game.cellSize(50) 
        game.boardGround("escenario.png")
        
        // Inicializa y añade todos los visuales
        visuales.mago.initialize()
        visuales.avispa.initialize()
        visuales.oso.initialize()
        visuales.slime.initialize()
        visuales.dragon.initialize()
       // visuales.rect.initialize() 
        
        game.addVisual(visuales.mago)
        game.addVisual(visuales.avispa)
        game.addVisual(visuales.oso)
        game.addVisual(visuales.slime)
        game.addVisual(visuales.dragon)
     //    game.addVisual(visuales.rect) 
        
        self.configuracionTeclado()
        
        // --- MOVIMIENTO ALEATORIO DE ENEMIGOS ---
        game.onTick(500.randomUpTo(800), "mov_avispa", { self.moverEnemigoAleatorio(visuales.avispa) })
        game.onTick(500.randomUpTo(800), "mov_oso", { self.moverEnemigoAleatorio(visuales.oso) })
        game.onTick(500.randomUpTo(800), "mov_slime", { self.moverEnemigoAleatorio(visuales.slime) })
        game.onTick(500.randomUpTo(800), "mov_dragon", { self.moverEnemigoAleatorio(visuales.dragon) })
    }
    
    
    /**
     * Configura las teclas WASD para mover al mago.
     * (¡VERSIÓN CON MENSAJES RESTAURADA!)
     */
    method configuracionTeclado() {
        
        // --- Teclas de Movimiento (Sin cambios) ---
        keyboard.w().onPressDo({ self.intentarMover("arriba") })
        keyboard.s().onPressDo({ self.intentarMover("abajo") }) 
        keyboard.d().onPressDo({ self.intentarMover("derecha") })
        keyboard.a().onPressDo({ self.intentarMover("izquierda") })
        
        
        // --- ¡LÓGICA DE TECLA "F" CON MENSAJES RESTAURADA! ---
        keyboard.f().onPressDo({
            
            // 1. Buscamos SI HAY *ALGÚN* enemigo cerca
            const magoPos = visuales.mago.position()
            const enemigoCercano = enemigosVivos.find({ enemigo =>
                const enemigoPos = enemigo.position()
                const distanciaX = (magoPos.x() - enemigoPos.x()).abs()
                const distanciaY = (magoPos.y() - enemigoPos.y()).abs()
                
                return (distanciaX <= 1 and distanciaY <= 1)
            })
            
            // 2. Verificamos si encontramos a alguien
            if (enemigoCercano != null) {
                
                // 3. ¡Lo golpeamos! (Restamos vida)
                enemigoCercano.vida(enemigoCercano.vida() - 1)
                
                // 4. Revisamos la vida RESTANTE para dar el mensaje
                if (enemigoCercano.vida() == 2) {
                    game.say(visuales.mago, "¡Faltan 2 golpes para matar al enemigo!")
                } 
                else if (enemigoCercano.vida() == 1) {
                    game.say(visuales.mago, "¡Falta 1, casi lo logras!")
                } 
                else if (enemigoCercano.vida() <= 0) {
                    // Murió
                    game.say(visuales.mago, "¡Lo lograste, mataste un enemigo!")
                    
                    // 5. Lo sacamos del juego
                    game.removeVisual(enemigoCercano)
                    enemigosVivos.remove(enemigoCercano)
                    
                    // 6. Chequeamos si era el último
                    if (enemigosVivos.isEmpty()) {
                        self.ganaste()
                    }
                }
                
            } else {
                // 4. No hay nadie cerca
                game.say(visuales.mago, "¡Tienes que pegarle al siguiente enemigo!")
            }
        })
    }
    
    // --- Métodos de Fin de Juego ---
    
    method ganaste() {
        game.clear()
        game.boardGround("ganaste.jpeg")
    }

    // --- Métodos de Movimiento del JUGADOR ---

    method intentarMover(direccion) {
        var proximaPosicion
        
        if (direccion == "arriba") {
            proximaPosicion = visuales.mago.position().up(1)
        } else if (direccion == "abajo") {
            proximaPosicion = visuales.mago.position().down(1)
        } else if (direccion == "derecha") {
            proximaPosicion = visuales.mago.position().right(1)
        } else if (direccion == "izquierda") {
            proximaPosicion = visuales.mago.position().left(1)
        }
        
        if (self.esMovimientoValido(proximaPosicion)) {
            if (direccion == "arriba") { visuales.mago.subir() }
            else if (direccion == "abajo") { visuales.mago.bajar() }
            else if (direccion == "derecha") { visuales.mago.irADerecha() }
            else if (direccion == "izquierda") { visuales.mago.irAIzquierda() }
        } else {
            if (direccion == "arriba") { visuales.mago.mirarAlNorte() }
            else if (direccion == "abajo") { visuales.mago.mirarAlSur() }
            else if (direccion == "derecha") { visuales.mago.mirarAlEste() }
            else if (direccion == "izquierda") { visuales.mago.mirarAlOeste() }
        }
    }
    
    method esMovimientoValido(posicion) {
        const noHayObstaculo = self.noHayEnemigoVivoAhi(posicion)
        return self.esPosicionCaminable(posicion) and noHayObstaculo
    }

    /**
     * Revisa si la posición está dentro del perímetro rojo (las 4 salas).
     * (¡CON TUS COORDENADAS CORREGIDAS!)
     */
    method esPosicionCaminable(posicion) {
        const x = posicion.x()
        const y = posicion.y()
        
        // Cuadrante 1 (Abajo-Izquierda)
        const enC1 = (x >= 3 and x <= 8 and y >= 3 and y <= 4)
        // Cuadrante 2 (Arriba-Izquierda)
        const enC2 = (x >= 3 and x <= 8 and y >= 6 and y <= 8)
        // Cuadrante 3 (Arriba-Derecha)
        const enC3 = (x >= 11 and x <= 17 and y >= 6 and y <= 8)
        // Cuadrante 4 (Abajo-Derecha)
        const enC4 = (x >= 11 and x <= 17 and y >= 3 and y <= 4)
        
        // Pasillos
        const pasillo1_2 = (x == 4 and y == 5) // Conexión C1 a C2
        const pasillo2_3 = (x >= 9 and x <= 10 and y == 7) // Conexión C2 a C3
        const pasillo3_4 = (x == 14 and y == 5) // Conexión C3 a C4
        
        return enC1 or enC2 or enC3 or enC4 or pasillo1_2 or pasillo2_3 or pasillo3_4
    }
    
    method noHayEnemigoVivoAhi(posicion) {
        const posicionesEnemigosVivos = enemigosVivos.map({ enemigo => enemigo.position() })
        return not posicionesEnemigosVivos.contains(posicion)
    }
    
    
    // --- MÉTODOS DE MOVIMIENTO DE ENEMIGOS ---
    
    /**
     * Intenta mover un enemigo en una dirección aleatoria.
     */
    method moverEnemigoAleatorio(enemigo) {
        // 1. Elegir dirección aleatoria
        const direccion = #{"arriba", "abajo", "izquierda", "derecha"}.anyOne()
        var proximaPosicion
        
        if (direccion == "arriba") {
            proximaPosicion = enemigo.position().up(1)
        } else if (direccion == "abajo") {
            proximaPosicion = enemigo.position().down(1)
        } else if (direccion == "izquierda") {
            proximaPosicion = enemigo.position().left(1)
        } else if (direccion == "derecha") {
            proximaPosicion = enemigo.position().right(1)
        }
        
        // 2. Verificar si el movimiento es válido
        if (self.esMovimientoValidoParaEnemigo(enemigo, proximaPosicion)) {
            // 3. Mover usando sus propios métodos
            if (direccion == "arriba") { enemigo.subir() }
            else if (direccion == "abajo") { enemigo.bajar() }
            else if (direccion == "izquierda") { enemigo.irAIzquierda() }
            else if (direccion == "derecha") { enemigo.irADerecha() }
        }
        // 4. Si no es válido, no hace nada en este tick.
    }
    
    /**
     * Verifica si un enemigo puede moverse a una nueva posición.
     */
    method esMovimientoValidoParaEnemigo(enemigo, posicion) {
        return self.esPosicionCaminableParaEnemigo(enemigo, posicion) and
               self.noHayEnemigoVivoAhi(posicion) and
               posicion != visuales.mago.position()
    }

    /**
     * Revisa si la posición está DENTRO del cuadrante 
     * permitido para ESE enemigo. (¡CON TU CORRECCIÓN FINAL!)
     */
    method esPosicionCaminableParaEnemigo(enemigo, posicion) {
        const x = posicion.x()
        const y = posicion.y()
        
        // Cuadrante 1 (Abajo-Izquierda) - Avispa
        const enC1 = (x >= 3 and x <= 8 and y >= 3 and y <= 4)
        // Cuadrante 2 (Arriba-Izquierda) - Oso
        const enC2 = (x >= 3 and x <= 8 and y >= 6 and y <= 8)
        // Cuadrante 3 (Arriba-Derecha) - Slime
        const enC3 = (x >= 11 and x <= 17 and y >= 6 and y <= 8)
        // Cuadrante 4 (Abajo-Derecha) - Dragon
        const enC4 = (x >= 11 and x <= 17 and y >= 3 and y <= 4)
        
        // ¡Importante! Los enemigos solo se mueven DENTRO de su cuadrante.
        
        if (enemigo == visuales.avispa) { 
            return enC1
        } 
        else if (enemigo == visuales.oso) { 
            return enC2
        }
        else if (enemigo == visuales.slime) {
            return enC3
        }
        else  (enemigo == visuales.dragon) { // <-- ¡TU CORRECCIÓN!
            return enC4
        }
        
        return false // Si no es ninguno
    }
}