/*
para el archivo mago:
method chocarCon(rival) {
	// sin dudas perdí una vida
	vidas = vidas - 1
    position = game.origin()
	rival.resetPosition()
	agregamos la validación del juego terminado en pacman
	if (self.juegoTerminado()) {
		game.say(self, "Se me terminaron las vidas!!!")
		game.onTick(5000, "gameEnd", { game.stop() })
	} else {
		game.say(self, "Ups! Perdí una vida")
	}
} 

para el archivo game:
const rivales = [oso, abeja, slime]
	rivales.forEach { rival => 
		game.addVisual(rival)
		game.whenCollideDo(rival, { personaje =>
			personaje.chocarCon(rival)
			game.say(personaje, "Bicho de mier...")
			if (personaje.juegoTerminado()) {
				game.say(personaje, "¿Cague?")
				game.onTick(5000, "Cagaste", { game.stop() })
      }})
      game.onTick(1.randomUpTo(5) * 500, "movimiento", {rival.acercarseA(mago)})}

poder ubicar un cofre en un escenario y posición cualquiera usando el metodo ya existente ubicarAleatoriamente(visual):
method ubicarCofreEnCualquierEscenario() { tiene la una pocion x adentro (abajo del cofre)
        const pocionRandom = escenarioElegido.pociones().randomize().first() 
        cofre.pocion(pocionRandom)
        const pos = game.at(1.randomUpTo(game.width() - 1), 1.randomUpTo(game.height() - 1))
        cofre.position(pos)
        game.addVisual(cofre)
    }

para enemigo:
perseguir al mago para atacarlo, O SEA, hacer un archivo con movimientos y aplicarle eso a
todos para ahorrar código. usen de ref el game de bob esponja subido en la página de wollok

respondan cosas al colisionar
*/