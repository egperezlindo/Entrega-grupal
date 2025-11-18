import wollok.game.*
import visuales.* // Importa a los "actores"
import musica.* //importa obj musicaDeFondo
import objetoFondoGano.* //importa objetoFondoGano

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
        avispa,
        oso,
        slime,
        dragon
    ]

    /**
     * Método de inicialización principal.
     */
    method iniciarJuego() {
        //musica de fondo
        musicaDeFondo.play() // por temas con la API de Chrome, la música no se activa hasta que el jugador haga algo.
        //
        game.width(anchoTotal)
        game.height(altoTotal)
        game.title("6bits RPG - Estable")
        game.cellSize(50) 
        game.boardGround("escenario.png")
        
        // Inicializa y añade todos los visuales
        mago.initialize()
        avispa.initialize()
        oso.initialize()
        slime.initialize()
        dragon.initialize()
        // visuales.rect.initialize() 
        
        game.addVisual(mago)
        game.addVisual(avispa)
        game.addVisual(oso)
        game.addVisual(slime)
        game.addVisual(dragon)
        //game.addVisual(visuales.rect) 
        
        self.configuracionTeclado()
        
        // --- MOVIMIENTO ALEATORIO DE ENEMIGOS ---
        game.onTick(500.randomUpTo(800), "mov_avispa", { self.moverEnemigoAleatorio(avispa) })
        game.onTick(500.randomUpTo(800), "mov_oso", { self.moverEnemigoAleatorio(oso) })
        game.onTick(500.randomUpTo(800), "mov_slime", { self.moverEnemigoAleatorio(slime) })
        game.onTick(500.randomUpTo(800), "mov_dragon", { self.moverEnemigoAleatorio(dragon) })
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
        
        
        // --- LÓGICA DE TECLA "F" (ATAQUE DIRECCIONAL CORREGIDO) ---
        keyboard.f().onPressDo({
            
            // 1. Calculamos DÓNDE va a pegar el mago
            var posicionDeAtaque = mago.position()
            
            // 💥 FIX: Estructura de IF/ELSE IF para calcular la posición de ataque
            if (mago.direccion() == "arriba") { 
                posicionDeAtaque = posicionDeAtaque.up(1) 
            } 
             if (mago.direccion() == "abajo" ){ 
                posicionDeAtaque = posicionDeAtaque.down(1) 
            } 
             if (mago.direccion() == "derecha" ){ 
                posicionDeAtaque = posicionDeAtaque.right(1) 
            } 
            else  (mago.direccion() == "izquierda" ){ 
                posicionDeAtaque = posicionDeAtaque.left(1) 
            }
            
            // 2. Buscamos si hay un enemigo EXACTAMENTE en esa posición (Direccional)
            const enemigoCercano = enemigosVivos.find({ enemigo => 
                enemigo.position() == posicionDeAtaque 
            })
            
            // 3. Si encontramos a alguien, le pegamos
            if (enemigoCercano != null) {
                
                // Si la explosión está activa, puedes descomentar la llamada aquí:
                // visualAtaque.position(posicionDeAtaque)
                // game.addVisual(visualAtaque)
                // game.schedule(500, { game.removeVisual(visualAtaque) }) 
                
                // 3. ¡Lo golpeamos! (Restamos vida)
                enemigoCercano.vida(enemigoCercano.vida() - 1)
                
                // 4. Revisamos la vida RESTANTE para dar el mensaje
                if (enemigoCercano.vida() == 2) {
                    game.say(mago, "¡Faltan 2 golpes para matar al enemigo!")
                    game.sound("punch.wav").play()
                } 
                else if (enemigoCercano.vida() == 1) {
                    game.say(mago, "¡Falta 1, casi lo logras!")
                    game.sound("punch.wav").play()
                } 
                else if (enemigoCercano.vida() <= 0) {
                    // Murió
                    game.say(mago, "¡Lo lograste, mataste un enemigo!")
                    game.sound("8_bit_chime_positive.wav").play()
                    
                    // 5. Lo sacamos del juego
                    game.removeVisual(enemigoCercano)
                    enemigosVivos.remove(enemigoCercano)
                    
                    // 6. Chequeamos si era el último
                    if (enemigosVivos.isEmpty()) {
                        self.ganaste()
                    }
                }
                
            } else {
                // 4. No hay nadie en la casilla de enfrente
                game.say(mago, "¡No hay nadie ahí!")
            }
        })
    }
    
    // --- Métodos de Fin de Juego ---
    
    method ganaste() {
        const gano = game.sound("06 - Victory!.wav")
        musicaDeFondo.stop()
        gano.volume(0.3)
        game.clear()
        game.addVisual(fondo)//game.boardGround("ganaste.jpeg")
        gano.play()
        self.pararMusicaGanadora(gano)
    }
    method pararMusicaGanadora(musica) {game.schedule(5000, {musica.stop()})}
    // --- Métodos de Movimiento del JUGADOR ---

    method intentarMover(direccion) {
        var proximaPosicion
        //const pisadas = game.sound("foley_footstep_concrete_4.wav")
        //pisadas.volume(0.1)
        
        if (direccion == "arriba") {
            proximaPosicion = mago.position().up(1)
            game.sound("foley_footstep_concrete_4.wav").play()
        } else if (direccion == "abajo") {
            proximaPosicion = mago.position().down(1)
            game.sound("foley_footstep_concrete_4.wav").play()
        } else if (direccion == "derecha") {
            proximaPosicion = mago.position().right(1)
            game.sound("foley_footstep_concrete_4.wav").play()
        } else if (direccion == "izquierda") {
            proximaPosicion = mago.position().left(1)
            game.sound("foley_footstep_concrete_4.wav").play()
        }
        
        if (self.esMovimientoValido(proximaPosicion)) {
            if (direccion == "arriba") { mago.subir() }
            else if (direccion == "abajo") { mago.bajar() }
            else if (direccion == "derecha") { mago.irADerecha() }
            else if (direccion == "izquierda") { mago.irAIzquierda() }
        } else {
            if (direccion == "arriba") { mago.mirarAlNorte() }
            else if (direccion == "abajo") { mago.mirarAlSur() }
            else if (direccion == "derecha") { mago.mirarAlEste() }
            else if (direccion == "izquierda") { mago.mirarAlOeste() }
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
               posicion != mago.position()
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
        
        if (enemigo == avispa) { 
            return enC1
        } 
        else if (enemigo == oso) { 
            return enC2
        }
        else if (enemigo == slime) {
            return enC3
        }
        else  (enemigo == dragon) { // <-- ¡TU CORRECCIÓN!
            return enC4
        }
        
        return false // Si no es ninguno
    }
}