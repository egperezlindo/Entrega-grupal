import wollok.game.*


object personaje {
    var image = "Idle.gif"
    var property position = game.origin()
    var vidas = 3

	method chocarCon(rival) {
		// sin dudas perdí una vida
		vidas = vidas - 1
        position = game.origin()
		rival.resetPosition()
		// agregamos la validación del juego terminado en pacman
		/*if (self.juegoTerminado()) {
			game.say(self, "Se me terminaron las vidas!!!")
			game.onTick(5000, "gameEnd", { game.stop() })
		} else {
			game.say(self, "Ups! Perdí una vida")
		}*/
	}
    //caras del personaje cuando camina
    method image() = image
    method mirandoAlNorte() {image = "mirandoNorte.png"}
    method mirandoAlSur() {image = "magoMirandoSur.jpeg"}
    method mirandoAlEste() {image = "mirandoDerecha.png"}
    method mirandoAlOeste() {image = "mirandoIzquierda.png"}

    method juegoTerminado() = vidas == 0
    method subir() {
        if(self.position().y() == game.height()-1) {
            self.position(game.at(self.position().x(),self.position().y()))
        }
        else {
            self.mirandoAlNorte()
            self.position(self.position().up(1))
        }
    }
    method bajar() {
        if(self.position().y() == game.height()-10) {
            self.position(game.at(self.position().x(),self.position().y()))
        }
        else {
            self.mirandoAlSur()
            self.position(self.position().down(1))
        }
    }
    method irADerecha() {
        if(self.position().x() == game.width()-1) {
            self.position(game.at(self.position().x(),self.position().y()))
        }
        else {
            self.position(self.position().right(1))
        }
    }
    method irAIzquierda() {
        if(self.position().x() == game.width()-20) {
            self.position(game.at(self.position().x(),self.position().y()))
        }
        else {
            self.position(self.position().left(1))
        }
    }
}

object enemigo {
    method esEnemigo() = true
}

class Oso {
    const numero
    //const property image = "boar.png" 
    var property position = game.at(3,3)
    var previousPosition = position

    //method image() = "boar" + numero.toString() + ".png"
    method image() = "boar.png"
    //method position() = game.at(numero + 2, numero + 2)
	method acercarseA(personaje) {
		const otroPosicion = personaje.position()
		var newX = position.x() + if (otroPosicion.x() > position.x()) 1 else -1
		var newY = position.y() + if (otroPosicion.y() > position.y()) 1 else -1
		// evitamos que se posicionen fuera del tablero
		newX = newX.max(0).min(game.width() - 1)
		newY = newY.max(0).min(game.height() - 1)
		previousPosition = position
		position = game.at(newX, newY)
	}

	method resetPosition() {
		position = game.at(numero + 1, numero + 1)
	}
	
	method chocarCon(otro) {
		self.resetPreviousPosition()
	}
	
	method resetPreviousPosition() {
		position = previousPosition 
	}
}

class Abejita {
    const numero
    //const property image = "abejita.png"
    var property position = game.at(4,4)
    var previousPosition = position

    //method image() = "abejita" + numero.toString() + ".png"
    method image() = "abejita.png"
    //method position() = game.at(numero + 3, numero + 3)
	method acercarseA(personaje) {
		const otroPosicion = personaje.position()
		var newX = position.x() + if (otroPosicion.x() > position.x()) 1 else -1
		var newY = position.y() + if (otroPosicion.y() > position.y()) 1 else -1
		// evitamos que se posicionen fuera del tablero
		newX = newX.max(0).min(game.width() - 1)
		newY = newY.max(0).min(game.height() - 1)
		previousPosition = position
		position = game.at(newX, newY)
	}

	method resetPosition() {
		position = game.at(numero + 1, numero + 1)
	}
	
	method chocarCon(otro) {
		self.resetPreviousPosition()
	}
	
	method resetPreviousPosition() {
		position = previousPosition 
	}
}