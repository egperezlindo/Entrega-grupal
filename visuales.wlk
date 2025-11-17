import wollok.game.*

/**
 * Clase base para cualquier cosa visible en el juego.
 */
class Visual {
    var property image
    var property position
}

// --- Clase Enemigo ACTUALIZADA ---
class Enemigo inherits Visual {
	var property vida = 3
	
	// --- ¡NUEVO! Métodos de movimiento para enemigos ---
	// (No cambian la imagen, solo la posición)
	method subir() { position = position.up(1) }
	method bajar() { position = position.down(1) }
	method irADerecha() { position = position.right(1) }
	method irAIzquierda() { position = position.left(1) }
}
// --- FIN DE LA ACTUALIZACIÓN ---


/**
 * El jugador principal.
 * Hereda de Visual.
 */
object mago inherits Visual {
    
    method initialize() {
        image = "magoFrente.png"
        position = game.at(3, 2) // Cuadrante 1
    }
    
    // --- Métodos de Movimiento (Siguen "tontos") ---
    
    method mirarAlNorte() { image = "magoReves.png" }
    method mirarAlSur() { image = "magoFrente.png" }
    method mirarAlEste() { image = "magoDerecho.png" }
    method mirarAlOeste() { image = "magoIzquierdo.png" } 
    
    method subir() {
        self.mirarAlNorte()
        position = position.up(1)
    }
    method bajar() {
        self.mirarAlSur()
        position = position.down(1)
    }
    method irADerecha() {
        self.mirarAlEste()
        position = position.right(1)
    }
    method irAIzquierda() {
        self.mirarAlOeste()
        position = position.left(1)
    }
}

/**
 * Enemigos
 * Heredan de Enemigo.
 */
object avispa inherits Enemigo {
    method initialize() {
        image = "avispaDerecho.png"
        position = game.at(4, 4) 
    }
}

object oso inherits Enemigo {
    method initialize() {
        image = "osoFrente.png" 
        position = game.at(8, 7) 
    }
}



object slime inherits Enemigo {
    method initialize() {
        image = "slimeIzquierdo.png"
        position = game.at(14, 6) 
    }
}

object dragon inherits Enemigo {
    method initialize() {
        image = "dragonIzquierdo.png"
        position = game.at(17, 3) 
    }
}

// ¡ESTE OBJETO ES INVISIBLE!

/*
object rect inherits Visual {
    method initialize() {
        image = "rect.png"
        position = game.at(6, 1) 
    }
}
esto es en caso de querer asignar un objeto invisible.

*/