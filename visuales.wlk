import wollok.game.*
import nivel.* // Importa 'nivel' para poder llamarlo (ej. nivel.enemigoDerrotado())

/**
 * Clase base para CUALQUIER objeto que se muestre en el juego.
 * Define las propiedades básicas que todos los visuales comparten.
 */
class Visual {
	var property image
	var property position = game.origin()
}

/**
 * Clase abstracta para todos los seres vivos del juego (Jugador y Enemigos).
 * Hereda de Visual (porque se ve en el mapa).
 * Define los atributos y comportamientos comunes de un personaje.
 */
class Personaje inherits Visual {
	var property vida
	var property dmg
	var property defensa
	
	// --- Métodos abstractos (deben ser implementados por las clases hijas) ---
	
	/**
	 * Lógica para cuando el personaje recibe daño.
	 * @param personaje El atacante (para obtener su 'dmg').
	 */
	method recibirAtaque(personaje)
	
	/** Lógica para la acción de curarse. */
	method curarse()
	
	/** Lógica para la acción de defenderse (subir defensa temporalmente). */
	method defenderse()
	
	/**
	 * Lógica para la acción de atacar a otro personaje.
	 * @param personaje El objetivo del ataque.
	 */
	method atacarA(personaje) { 
		game.say(self, "¡Al ataque!") // TODO: Reemplazar con HUD
		// Llama al método 'recibirAtaque' del objetivo, pasándole el daño del atacante.
		personaje.recibirAtaque(dmg) 
	}
}

/**
 * Objeto que representa al jugador (Héroe Mago).
 * Es 'object' porque es único (Singleton).
 */
object mago inherits Personaje {
	var property mana = 100
	var vidas = 3 // Cantidad de "intentos" o vidas extra.
	const property pociones = [] // Inventario de pociones.
	
	/** Aumenta la defensa (temporalmente, según el README). */
	override method defenderse() { defensa += 5 }
	
	/** Usa la primera poción disponible en el inventario. */
	override method curarse() {
		// Chequea si tiene pociones y si necesita curarse (vida, mana o defensa no están al máximo)
		if (pociones.nonEmpty() and (vida < 100 or mana < 100 or defensa < 10)) { //TODO: El '10' de defensa debería ser la defensa base.
			// La poción aplica sus efectos al 'mago' (self).
			// .min(100) asegura que la vida no pase de 100 (clamp).
			pociones.first().serTomadaPor(self).min(100) // TODO: Revisar esta lógica, serTomadaPor no retorna un número.
			
			// Gasta la poción.
			pociones.remove(pociones.first())
		}
	}
	
	/**
	 * Implementación de cómo el Mago recibe daño.
	 * @param enemigo El objeto Enemigo que lo ataca.
	 */
	override method recibirAtaque(enemigo) {
		if (vida > 0) { 
			// Reduce la vida. .max(0) asegura que la vida no sea negativa.
			vida = (vida - enemigo.dmg()).max(0) 
		} else {
			// Si la vida llega a 0, llama al método que gestiona las vidas extra.
			self.perderVidaOTerminar(enemigo) 
		}
	}
	
	/**
	 * Maneja la lógica de "muerte" del Mago.
	 * O gasta una vida extra, o es Game Over.
	 */
	method perderVidaOTerminar(enemigo) {
		if (vidas == 0) {
			// Game Over
			game.say(self, "¡Se me terminaron las vidas!")
			game.onTick(5000, "gameEnd", { nivel.gameOver() }) // Llama a 'nivel.gameOver()'
		} 
		else {
			// Gasta una vida y resetea stats y posiciones.
			vidas = vidas - 1
			vida = 100
			enemigo.resetPosition()
		}
	}
	
	// --- Habilidades Especiales (Aún no implementadas en la batalla) ---
	
	method bajarDefensasDe(enemigo) { enemigo.defensaReducida(dmg) }
	
	// --- Métodos de Movimiento y Sprites ---
	
	// Cambia la imagen del Mago según la dirección.
	method mirarAlNorte() { image = "magoReves.png" }
	method mirarAlSur() { image = "magoFrente.png" }
	method mirarAlEste() { image = "magoDerecho.png" }
	method mirarAlOeste() { image = "magoIzquierdo.png" }
	
	/** Mueve al Mago hacia arriba (W), con control de bordes. */
	method subir() {
		self.mirarAlNorte()
		// Control de borde superior
		if(self.position().y() == game.height()-1) {
			self.position(game.at(self.position().x(),self.position().y()))
		}
		else { self.position(self.position().up(1)) }
	}
	
	/** Mueve al Mago hacia abajo (S), con control de bordes. */
	method bajar() {
		self.mirarAlSur()
		// Control de borde inferior (y=0)
		// TODO: La lógica 'game.height()-10' parece ser un error, debería ser '0'.
		if(self.position().y() == game.height()-10) { // Debería ser '== 0'
			self.position(game.at(self.position().x(),self.position().y()))
		}
		else { self.position(self.position().down(1)) } 		
	}
	
	/** Mueve al Mago a la derecha (D), con control de bordes. */
	method irADerecha() {
		self.mirarAlEste()
		// Control de borde derecho
		if(self.position().x() == game.width()-1) {
			self.position(game.at(self.position().x(),self.position().y()))
			
		}
		else { self.position(self.position().right(1)) }
	}
	
	/** Mueve al Mago a la izquierda (A), con control de bordes. */
	method irAIzquierda() {
		self.mirarAlOeste()
		// Control de borde izquierdo (x=0)
		// TODO: La lógica 'game.width()-20' parece ser un error, debería ser '0'.
		if(self.position().x() == game.width()-20) { // Debería ser '== 0'
			self.position(game.at(self.position().x(),self.position().y()))
		}
		else { self.position(self.position().left(1)) }
	}
	
	/** Añade una poción al inventario (ej. al colisionar con un cofre). */
	method conseguirPocion(pocion) {pociones.add(pocion)}
	
	/** Quita una poción del inventario (se usa en 'curarse'). */
	method tomarPocion(pocion) { // TODO: Este método no se usa, 'curarse' tiene su propia lógica.
		pociones.remove(pocion)
	}
	
	/** Método de inicialización: define los stats base del Mago. */
	method initialize() {
		vida = 100
		dmg = 1 // El daño base parece bajo, pero el README dice que se mejora.
		defensa = 10
		image = "magoFrente.png"
	}
}

/**
 * Clase base abstracta para todos los enemigos.
 */
class Enemigo inherits Personaje {
	const numero // Un ID o número para identificar al enemigo.
	var previousPosition = position // Guarda la posición anterior (para colisiones).
	const property acciones = [] // TODO: Lista de acciones posibles.
	
	/**
	 * Implementación de cómo el Enemigo recibe daño.
	 * @param daño El valor numérico del 'dmg' del Mago.
	 */
	override method recibirAtaque(daño) { 
		vida = (vida - daño).max(0) // Reduce la vida, asegurando que no baje de 0.
		
		if (vida == 0) {
			// Si la vida llega a 0, el enemigo "muere".
			game.say(self, "¡Derrotado!") // TODO: Reemplazar con HUD
			game.removeVisual(self) // Desaparece del mapa.
			
			// **¡IMPORTANTE!** Notifica al 'nivel' que el enemigo fue derrotado.
			// Esto dispara la lógica para cargar el siguiente escenario.
			nivel.enemigoDerrotado()
		} else {
			// Sigue vivo, solo muestra un mensaje de dolor.
			game.say(self, "¡Auch!") // TODO: Reemplazar con HUD
		}
	}
	
	/** Aumenta la defensa temporalmente. */
	override method defenderse() { defensa += 2 }
	
	/** El enemigo se cura vida a costa de su daño (interesante mecánica). */
	override method curarse() { 
		// TODO: meterle un gif con particulas
		dmg = (dmg - 3).max(0) // Reduce su daño, mínimo 0.
		vida = vida + 3 // Recupera vida.
	}
	
	// --- Métodos de IA (Inteligencia Artificial) ---
	
	method buffarse() { dmg = dmg * 0.3 }
	method seDejaDeDefender() { defensa -= 2 }
	method defensaReducida(daño) { defensa -= daño }
	method recuperaSuDmg() { dmg = dmg + 3 }
	
	/**
	 * La "IA" principal del enemigo. Se llama cada 1.5 segundos (ver Escenario.iniciar()).
	 * Elige una acción al azar.
	 */
	method hacerAlgo() {
		const dado = 1.randomUpTo(3)
		if(dado == 1) {self.atacarA(mago)}
		if(dado == 2) {self.defenderse()}
		else(dado == 3) {self.curarse()}
	}
	
	/** Lógica de movimiento simple: se acerca al Mago. */
	method acercarseA(personaje) {
		const otroPosicion = personaje.position()
		var newX = position.x() + if (otroPosicion.x() > position.x()) 1 else -1
		var newY = position.y() + if (otroPosicion.y() > position.y()) 1 else -1
		
		// evitas que se posicione fuera del tablero
		newX = newX.max(0).min(game.width() - 1)
		newY = newY.max(0).min(game.height() - 1)
		
		previousPosition = position // Guarda la posición vieja
		position = game.at(newX, newY) // Se mueve
	}
	
	/** Resetea la posición del enemigo (usado si el Mago muere). */
	method resetPosition() { position = game.at(numero + 1, numero + 1) }
	
	/** Cuando choca, vuelve a su posición anterior (evita superponerse). */
	method chocarCon(otro) { self.resetPreviousPosition() }
	method resetPreviousPosition() { position = previousPosition }
}

// --- Implementaciones de Enemigos Específicos ---

/** El primer enemigo. */
object oso inherits Enemigo (numero = 1) {
	method initialize() {
		position = game.at(3,3)
		vida = 40
		dmg = 2
		defensa = 4
		image = "osoFrente.png"
	}
}

/** El segundo enemigo. */
object avispa inherits Enemigo (numero = 2) {
	method initialize() {
		position = game.at(4,4)
		vida = 60
		dmg = 3
		defensa = 6
		image = "avispaFrente.png"
	}
}

/** El tercer enemigo. */
object slime inherits Enemigo (numero = 3) {
	method initialize() {
		position = game.at(5,5)
		vida = 80
		dmg = 4
		defensa = 8
		image = "slimeFrente.png"
	}
}

/** El Jefe Final. */
object dragon inherits Enemigo (numero = 4) {
	method initialize() {
		position = game.at(6,6)
		vida = 100
		dmg = 5
		defensa = 10
		image = "dragonFrente.png"
	}
}

// --- Clase Escenario (Cámara) ---

/**
 * Clase base para un nivel o "cámara".
 * Define el fondo y el enemigo de ese nivel.
 */
class Escenario {
	var property fondo // Imagen de fondo
	var property enemigo // El enemigo específico de este escenario
	const property pociones = [pocionDeVida, pocionDeMana, pocionDeDefensa] // Pociones en el escenario
	
	/** Establece el fondo del tablero. */
	method aplicarFondo() { game.boardGround(fondo) }
	
	/**
	 * Configura e inicia el escenario.
	 * Es llamado por 'nivel.cargarEscenarioActual()'.
	 */
	method iniciar() {
		self.aplicarFondo()
		game.addVisual(enemigo) // Añade el enemigo al mapa.
		
		/* * Mecánica de escalado: ajusta el daño del mago basado en el enemigo.
		 * TODO: Esta lógica es interesante, pero podría ser compleja de balancear.
		 * El README sugiere que el Mago se vuelve más fuerte con items (cofre),
		 * no más débil con enemigos.
		 */
		mago.dmg(enemigo.dmg() * 0.8) 
		
		/**
		 * Inicia la "IA" del enemigo.
		 * Llama al método 'hacerAlgo()' del enemigo cada 1500ms (1.5 segundos).
		 */
		game.onTick(1500, "accionesEnemigo", {enemigo.hacerAlgo()})
	}
}

// --- Implementaciones de Escenarios Específicos ---

/** Nivel 1: Oso */
object escenarioFacil inherits Escenario {
	method initialize() {
		fondo = "fondoRonda1.png"
		enemigo = oso
	}
}

/** Nivel 2: Avispa */
object escenarioIntermedio inherits Escenario {
	method initialize() {
		fondo = "fondoRonda2.png"
		enemigo = avispa
	}
}

/** Nivel 3: Slime */
object escenarioDificil inherits Escenario {
	method initialize() {
		fondo = "fondoRonda3.png"
		enemigo = slime
	}
}

/** Nivel 4: Dragón (Final) */
object escenarioFinal inherits Escenario {
	method initialize() {
		fondo = "fondoRonda4.png"
		enemigo = dragon
	}
}

// --- Clases y Objetos Visuales (UI/Items) ---

/** Pantalla de inicio (visual simple). */
object inicio inherits Visual {
	method initialize() { image = "inicio.jpeg" }
}

/** Pantalla de victoria (visual simple). */
object win inherits Visual {
	method initialize() { image = "ganaste.png" }
}

/** Pantalla de derrota (visual simple). */
object end inherits Visual {
	method initialize() { image = "perdiste.png" }
}

/**
 * Objeto que maneja el Menú de Pausa.
 * TODO: La lógica de 'abrir()' parece tener un bug (dice 'if (estaAbierto)' en lugar de 'if (!estaAbierto)').
 */
object pausaMenu inherits Visual {
	var property estaAbierto = false
	
	method abrir() {
		// TODO: Esta lógica está invertida. Debería ser: if (!estaAbierto) { ... }
		if (estaAbierto) { 
			estaAbierto = true
			game.addVisual(image)
			game.say(mago, "Juego en pausa")
			keyboard.c().onPressDo({self.cerrar()}) // Permite cerrar con 'C'
		}
	}
	
	method cerrar() {
		estaAbierto = false
		game.removeVisual(image)
	}
	
	method initialize() {
		image = "pausa.png" // TODO: meterle img para pausa
		position = game.at(5, 3)
	}
}

/**
 * Clase base para todas las Pociones.
 */
class Pocion inherits Visual {
	const property numero
	var property vidaQueRecupera
	var property manaQueRecupera
	var property defensaQueRecupera
	
	/**
	 * Aplica los efectos de la poción al personaje que la toma.
	 * @param personaje El personaje (ej. 'mago') que la usa.
	 */
	method serTomadaPor(personaje) {
		personaje.vida(personaje.vida() + vidaQueRecupera)
		personaje.mana(personaje.mana() + manaQueRecupera)
		personaje.defensa(personaje.defensa() + defensaQueRecupera)
	}
}

// --- Implementaciones de Pociones Específicas ---

object pocionDeVida inherits Pocion (numero = 1) {
	method initialize() {
		image = "pocionDeVida.png"
		vidaQueRecupera = 50
		manaQueRecupera = 0
		defensaQueRecupera = 0
	}
}

object pocionDeMana inherits Pocion (numero = 2) {
	method initialize() {
		image = "pocionDeMana.png"
		vidaQueRecupera = 0
		manaQueRecupera = 45
		defensaQueRecupera = 0
	}
}

object pocionDeDefensa inherits Pocion (numero = 3) { // chequear utilidad
	method initialize() {
		image = "pocionDeDefensa.png"
		vidaQueRecupera = 0
		manaQueRecupera = 0
		defensaQueRecupera = 5
	}
}

// object pocionDeDaño inherits Pocion (numero = 4) {} // Idea para futuro

/**
 * El Cofre.
 * Según el README, debería dar armaduras y un báculo mejorado.
 * Según el CÓDIGO, da una 'pocionDeDefensa' al chocar.
 */
object cofre inherits Visual {
	var property pocion = pocionDeDefensa // El 'loot' (botín) del cofre.
	
	/**
	 * Método que se debe llamar cuando el Mago colisiona con el cofre.
	 */
	method colisionado() {
		mago.conseguirPocion(pocion) // Da la poción al mago.
		image = "cofreAbierto.png" // Cambia la imagen.
		// TODO: Esta lógica debe expandirse para cumplir con el README (dar armaduras).
	}
	
	method initialize() {
		image = "cofreCerrado.png"
	}
}

// --- Ideas para el HUD (interfaz de usuario) ---
// object barraDeVida inherits Visual {}
// game.onTick(200, "actualizarHUD", { barraDeVideo.actualizar() })