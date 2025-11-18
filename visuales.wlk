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
    
    // Propiedad para guardar el nombre del archivo (ej: "oso", "slime")
    var property nombreArchivo = "" 
    
    // --- Lógica de Imagenes Dinámicas ---
    // Construye el nombre del archivo sumando el nombreBase + la dirección
    method mirarAlNorte() { image = nombreArchivo + "Reves.png" }
    method mirarAlSur()   { image = nombreArchivo + "Frente.png" }
    method mirarAlEste()  { image = nombreArchivo + "Derecho.png" }
    method mirarAlOeste() { image = nombreArchivo + "Izquierdo.png" } // ¡Ojo con la I mayúscula!
    
    // --- Métodos de movimiento ---
    // Ahora cambian la imagen Y la posición
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
// --- FIN CLASE ENEMIGO ---


/**
 * El jugador principal (Mago).
 */
object mago inherits Visual {
    
    // 💥 CORRECCIÓN CLAVE: Agregamos la propiedad 'direccion'
    var property direccion = "abajo"
    
    method initialize() {
        image = "magoFrente.png"
        position = game.at(3, 2) 
    }
    
    // --- MÉTODOS DE MIRADA: AHORA ACTUALIZAN 'direccion' ---
    method mirarAlNorte() { 
        image = "magoReves.png" 
        direccion = "arriba"
    }
    method mirarAlSur()   { 
        image = "magoFrente.png" 
        direccion = "abajo"
    }
    method mirarAlEste()  { 
        image = "magoDerecho.png" 
        direccion = "derecha"
    }
    method mirarAlOeste() { 
        image = "magoIzquierdo.png" 
        direccion = "izquierda"
    } 
    
    // --- Métodos de Movimiento ---
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
 * Enemigos (Instancias)
 */
object avispa inherits Enemigo {
    method initialize() {
        nombreArchivo = "avispa" // Definimos el prefijo
        image = "avispaDerecho.png"
        position = game.at(4, 4) 
    }

    // ¡EXCEPCIÓN! Como pediste, si mira al norte, usamos la imagen "Derecho"
    override method mirarAlNorte() { image = "avispaDerecho.png" }
}

object oso inherits Enemigo {
    method initialize() {
        nombreArchivo = "oso"
        image = "osoFrente.png" 
        position = game.at(8, 7) 
    }
}

object slime inherits Enemigo {
    method initialize() {
        nombreArchivo = "slime"
        image = "slimeIzquierdo.png"
        position = game.at(14, 6) 
    }
}

object dragon inherits Enemigo {
    method initialize() {
        nombreArchivo = "dragon"
        image = "dragonIzquierdo.png"
        position = game.at(17, 3) 
    }
}


