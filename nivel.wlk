import wollok.game.*
import visuales.*

object nivel {
    var property indice = 0
    const anchoTotal = 20
	const altoTotal = 10
	const anchoRecuadro = 19
	const altoRecuadro = 9
    // const property escenarioElegido = self.escenarios().randomize()
    const property escenarios = [escenarioFacil, escenarioIntermedio, escenarioDificil, escenarioFinal]
    method escenarioActual() = escenarios.get(indice)
    method iniciarJuego() {
        self.indice(0)
        game.width(anchoTotal)
		game.height(altoTotal)
        game.title("Game") // meterle un titulo
        game.cellSize(50)
        // game.addVisual("inicioDelJuego") meterle una pantalla d inicio
        game.addVisual(mago)
        self.configuracionTeclado()
        self.cargarEscenarioActual()
    }
    method clearGame() { game.allVisuals().forEach({visual => game.removeVisual(visual)}) }
    method cargarEscenarioActual() {
        if (indice > escenarios.size()) {
            self.ganaste()
        }
        else { self.escenarioActual().iniciar() }
    }
    // method configuracion() { self.cargarEscenarioActual() } hay que hacer un menu de inicio con este método
    method enemigoDerrotado() {
        indice += 1
        if (indice >= escenarios.size()) { self.ganaste() } 
        else { self.cargarEscenarioActual()}
    }
    method ganaste() {
        self.clearGame()
        game.boardGround("ganaste.jpeg") // hay que clavarle una imagen final, o sea, cuando gana
    }
    method gameOver() {
		game.clear()
		game.title("Game") // hay que meterle el nombre del juego jaja
		keyboard.p().onPressDo({escenarioFacil.iniciar()})
		keyboard.f().onPressDo({game.stop()})
	}
    // game.whenCollideDo(pocion, mago) {mago.conseguirPocion(pocion)} chequear como hacerlo

    method configuracionTeclado() {
        keyboard.p().onPressDo({pausaMenu.abrir()})
        if (!pausaMenu.estaAbierto()) {
            keyboard.w().onPressDo({mago.subir()})
            keyboard.s().onPressDo({mago.bajar()})
            keyboard.d().onPressDo({mago.irADerecha()})
            keyboard.a().onPressDo({mago.irAIzquierda()})
            keyboard.f().onPressDo({mago.atacarA(self.escenarioActual().enemigo())})
        }
    }
    method ubicarAleatoriamente(visual) {
		const posicion = new Position(
			x = 1.randomUpTo(anchoRecuadro),
			y = 1.randomUpTo(altoRecuadro)
		)
		if (game.getObjectsIn(posicion).isEmpty()) visual.position(posicion)
		else self.ubicarAleatoriamente(visual)
	}
}