import wollok.game.*
import visuales.*

/**
 * Objeto principal que actúa como el "Controlador del Juego" o "Administrador de Niveles".
 * Se encarga de:
 * - Configurar el tablero de juego.
 * - Administrar la progresión de los escenarios (cámaras).
 * - Manejar los controles del teclado.
 * - Gestionar los estados de victoria o derrota.
 */
object nivel {
	
	/**
	 * 'indice' rastrea en qué escenario (cámara) se encuentra el jugador.
	 * Se usa para obtener el escenario correcto de la lista 'escenarios'.
	 * 0 = escenarioFacil
	 * 1 = escenarioIntermedio
	 * 2 = escenarioDificil
	 * 3 = escenarioFinal
	 */
	var property indice = 0
	
	// --- Constantes de Configuración del Tablero ---
	const anchoTotal = 20
	const altoTotal = 10
	
	// Dimensiones usables (dejando un borde de 1 celda)
	const anchoRecuadro = 19
	const altoRecuadro = 9
	
	/**
	 * Lista ordenada de todos los escenarios del juego.
	 * La progresión es lineal, siguiendo el orden de esta lista.
	 */
	const property escenarios = [escenarioFacil, escenarioIntermedio, escenarioDificil, escenarioFinal]
	
	/**
	 * Método helper para obtener el objeto 'escenario' actual
	 * basado en el 'indice'.
	 * @return El objeto 'Escenario' que se debe jugar ahora.
	 */
	method escenarioActual() = escenarios.get(indice)
	
	/**
	 * Método de inicialización principal del juego.
	 * Se llama una sola vez desde 'game.wpgm'.
	 */
	method iniciarJuego() {
		self.indice(0) // Asegura que el juego comience en el primer nivel.
		
		// Configuración básica de la ventana de Wollok Game
		game.width(anchoTotal)
		game.height(altoTotal)
		game.title("6bits RPG") // Título del juego
		game.cellSize(50) // Tamaño de cada "celda" en píxeles.
		
		// game.addVisual("inicioDelJuego") // TODO: Pantalla de inicio
		
		// Añade al Mago (jugador) al juego.
		game.addVisual(mago)
		
		// Configura qué hace cada tecla (WASD, P, F).
		self.configuracionTeclado()
		
		// Carga el primer escenario (fondo y enemigo).
		self.cargarEscenarioActual()
	}
	
	/**
	 * Método de utilidad para limpiar todos los objetos visuales del tablero.
	 * Se usa al cambiar de nivel o al terminar el juego.
	 */
	method clearGame() { game.allVisuals().forEach({visual => game.removeVisual(visual)}) }
	
	/**
	 * Carga el escenario (cámara) actual basado en el 'indice'.
	 * Si el índice es mayor que la cantidad de escenarios, el jugador gana.
	 */
	method cargarEscenarioActual() {
		if (indice > escenarios.size()) {
			// Si el índice supera la lista, significa que venció al último jefe.
			self.ganaste()
		}
		else {
			// Si no, llama al método 'iniciar()' del escenario actual.
			self.escenarioActual().iniciar() 
		}
	}
	
	// method configuracion() { self.cargarEscenarioActual() } // TODO: Implementar menú de inicio
	
	/**
	 * Este método es llamado por un 'Enemigo' cuando es derrotado.
	 * Incrementa el índice y carga el siguiente nivel.
	 */
	method enemigoDerrotado() {
		indice += 1
		if (indice >= escenarios.size()) {
			// Si el índice es igual o mayor, significa que venció al último enemigo (Dragón).
			self.ganaste() 
		} 
		else {
			// Carga el siguiente escenario (Oso -> Slime -> Cofre -> Dragón).
			self.cargarEscenarioActual()
		}
	}
	
	/**
	 * Define lo que sucede cuando el jugador gana el juego.
	 */
	method ganaste() {
		self.clearGame() // Limpia el tablero (quita al mago, etc.)
		game.boardGround("ganaste.jpeg") // TODO: Pone la imagen de victoria.
	}
	
	/**
	 * Define lo que sucede cuando el jugador pierde (Game Over).
	 */
	method gameOver() {
		game.clear()
		game.title("GAME OVER") // TODO: Poner el nombre del juego
		
		// Teclas de reinicio o salida (ejemplo)
		keyboard.p().onPressDo({escenarioFacil.iniciar()}) // Reinicia (ejemplo)
		keyboard.f().onPressDo({game.stop()}) // Cierra
	}
	
	// TODO: game.whenCollideDo(pocion, mago) {mago.conseguirPocion(pocion)} // Implementar colisión con pociones
	
	/**
	 * Configura todas las teclas que el jugador puede usar.
	 */
	method configuracionTeclado() {
		// Tecla 'P' para el menú de pausa.
		keyboard.p().onPressDo({pausaMenu.abrir()})
		
		// IMPORTANTE: Solo permite el movimiento y ataque si el juego NO está en pausa.
		if (!pausaMenu.estaAbierto()) {
			
			// --- Controles de Movimiento (WASD) ---
			// (El README mencionaba flechas, pero el código usa WASD)
			keyboard.w().onPressDo({mago.subir()})
			keyboard.s().onPressDo({mago.bajar()})
			keyboard.d().onPressDo({mago.irADerecha()})
			keyboard.a().onPressDo({mago.irAIzquierda()})
			
			// --- Controles de Acción ---
			// Tecla 'F' para atacar (inicia la batalla según el README).
			// Ataca al enemigo que está definido en el escenario actual.
			keyboard.f().onPressDo({mago.atacarA(self.escenarioActual().enemigo())})
		}
	}
	
	/**
	 * Método de utilidad para encontrar una posición aleatoria vacía en el tablero.
	 * (Actualmente no se está usando, pero es útil para spawns).
	 * @param visual El objeto que se quiere ubicar.
	 */
	method ubicarAleatoriamente(visual) {
		const posicion = new Position(
			x = 1.randomUpTo(anchoRecuadro),
			y = 1.randomUpTo(altoRecuadro)
		)
		
		// Control recursivo: si la posición está ocupada, vuelve a llamar al método.
		if (game.getObjectsIn(posicion).isEmpty()) visual.position(posicion)
		else self.ubicarAleatoriamente(visual)
	}
}