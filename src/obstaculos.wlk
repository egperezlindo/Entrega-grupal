import wollok.game.*
import niveles.*
import visuales.*
import proyectiles.*

class Columna inherits Visual {
    method tieneVidas() = false
}

const columna1 = new Columna(image = "Columna1.png", position = game.at(15,15))
const columna2 = new Columna(image = "Columna2.png", position = game.at(15,10))
const columna3 = new Columna(image = "Columna3.png", position = game.at(15,5))