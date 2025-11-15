import wollok.game.*
import nivel.*

class Visual {
	var property image
	var property position = game.origin()
}

class Personaje inherits Visual {
    var property vida
    var property dmg
    var property defensa
    method recibirAtaque(personaje)
    method curarse()
    method defenderse()
    method atacarA(personaje) { 
        game.say(self, "...") // hay que meterle que diga algo
        personaje.recibirAtaque(dmg) 
    }
}

object mago inherits Personaje {
    var property mana = 100
    var vidas = 3
    const property pociones = []
    override method defenderse() { defensa += 5 }
    override method curarse() {
        if (vida < 100 or mana < 100 or defensa < 10) {
            pociones.first().serTomadaPor(self).min(100)
            pociones.remove(pociones.first())
        }
    }
    override method recibirAtaque(enemigo) {
        if (vida > 0) { 
            vida = (vida - enemigo.dmg()).max(0) 
        } else { self.perderVidaOTerminar(enemigo) }
    }
    method perderVidaOTerminar(enemigo) {
        if (vidas == 0) {
            game.say(self, "¡Se me terminaron las vidas!")
			game.onTick(5000, "gameEnd", {game.stop()})
        } 
        else {
            vidas = vidas - 1
            vida = 100
		    enemigo.resetPosition()
        }
    }
    method bajarDefensasDe(enemigo) { enemigo.defensaReducida(dmg) }
    method mirarAlNorte() { image = "magoReves.png" }
    method mirarAlSur() { image = "magoFrente.png" }
    method mirarAlEste() { image = "magoDerecho.png" }
    method mirarAlOeste() { image = "magoIzquierdo.png" }
    method subir() {
        self.mirarAlNorte()
        if(self.position().y() == game.height()-1) {
            self.position(game.at(self.position().x(),self.position().y()))
        }
        else { self.position(self.position().up(1)) }
    }
    method bajar() {
        self.mirarAlSur()
        if(self.position().y() == game.height()-10) {
            self.position(game.at(self.position().x(),self.position().y()))
        }
        else { self.position(self.position().down(1)) }    
    }
    method irADerecha() {
        self.mirarAlEste()
        if(self.position().x() == game.width()-1) {
            self.position(game.at(self.position().x(),self.position().y()))
            
        }
        else { self.position(self.position().right(1)) }
    }
    method irAIzquierda() {
        self.mirarAlOeste()
        if(self.position().x() == game.width()-20) {
            self.position(game.at(self.position().x(),self.position().y()))
        }
        else { self.position(self.position().left(1)) }
    }
    method conseguirPocion(pocion) {pociones.add(pocion)}
    method tomarPocion(pocion) {
        pociones.remove(pocion)
    }
    method initialize() {
        vida = 100
        dmg = 1
        defensa = 10
        image = "magoFrente.png"
    }
}

class Enemigo inherits Personaje {
    const numero
    var previousPosition = position
    const property acciones = [] // hay que pensarla
    override method recibirAtaque(daño) { 
        if (vida == 0) {
            game.say(self, "...") // hay que meterle que diga algo cuando recibe daño
            game.removeVisual(self)
            nivel.enemigoDerrotado()
        } else { vida = vida - daño }
    }
    override method defenderse() { defensa += 2 }
    override method curarse() { // meterle un gif con particulas, para no sobreusar el say
        dmg = dmg - 3
        vida = vida + 3
    }
    method buffarse() { dmg = dmg * 0.3 }
    method seDejaDeDefender() { defensa -= 2 }
    method defensaReducida(daño) { defensa -= daño }
    method recuperaSuDmg() { dmg = dmg + 3 }
    method hacerAlgo() {
        const dado = 1.randomUpTo(3)
        if(dado == 1) {self.atacarA(mago)}
        if(dado == 2) {self.defenderse()}
        else(dado == 3) {self.curarse()}
    }
	method acercarseA(personaje) {
		const otroPosicion = personaje.position()
		var newX = position.x() + if (otroPosicion.x() > position.x()) 1 else -1
		var newY = position.y() + if (otroPosicion.y() > position.y()) 1 else -1
		// evitas que se posicione fuera del tablero
		newX = newX.max(0).min(game.width() - 1)
		newY = newY.max(0).min(game.height() - 1)
		previousPosition = position
		position = game.at(newX, newY)
	}
	method resetPosition() { position = game.at(numero + 1, numero + 1) }
	method chocarCon(otro) { self.resetPreviousPosition() }
	method resetPreviousPosition() { position = previousPosition }
}

object oso inherits Enemigo (numero = 1) { // PUEDEN SER CONSTANTES INSTANCIADAS DE ENEMIGO
    method initialize() {
        position = game.at(3,3)
        vida = 40
        dmg = 2
        defensa = 4
        image = "osoFrente.png"
    }
}
object avispa inherits Enemigo (numero = 2) {
    method initialize() {
        position = game.at(4,4)
        vida = 60
        dmg = 3
        defensa = 6
        image = "avispaFrente.png"
    }
}
object slime inherits Enemigo (numero = 3) {
    method initialize() {
        position = game.at(5,5)
        vida = 80
        dmg = 4
        defensa = 8
        image = "slimeFrente.png"
    }
}

object dragon inherits Enemigo (numero = 4) {
    method initialize() {
        position = game.at(6,6)
        vida = 100
        dmg = 5
        defensa = 10
        image = "dragonFrente.png"
    }
}

class Escenario {
    var property fondo
    var property enemigo
    const property pociones = [pocionDeVida, pocionDeMana, pocionDeDefensa]
    method aplicarFondo() { game.boardGround(fondo) }
    method iniciar() {
        self.aplicarFondo()
        game.addVisual(enemigo)
        mago.dmg(enemigo.dmg() * 0.8)  /* es para que el mago tenga un poco menos de daño según el enemigo,
        se podría aplicar también que se pueda elegir la dificultad y que el daño del mago siempre
        sea mayor a que la del enemigo (en una dificultad fácil), también que haya una poción de 
        daño en vez de una de defensa para que haya posibilidad de que el mago haga mucho daño que el
        propio enemigo que le tocó. chequear según tiempo de entrega del game */
        game.onTick(1500, "accionesEnemigo", {enemigo.hacerAlgo()})
    }
}

object escenarioFacil inherits Escenario { // PUEDEN SER CONSTANTES INSTANCIAS DE ESCENARIO TAMBIEN, NO NECESARIAMENTE OBJETOS
    method initialize() {
        fondo = "fondoRonda1.png"
        enemigo = oso
    }
    
}

object escenarioIntermedio inherits Escenario {
    method initialize() {
        fondo = "fondoRonda2.png"
        enemigo = avispa
    }
}

object escenarioDificil inherits Escenario {
    method initialize() {
        fondo = "fondoRonda3.png"
        enemigo = slime
    }
}

object escenarioFinal inherits Escenario {
    method initialize() {
        fondo = "fondoRonda4.png"
        enemigo = dragon
    }
}

object inicio inherits Visual {
    method initialize() { image = "inicio.jpeg" }
}

object win inherits Visual { // PUEDEN SER CONSTANTES INSTANCIAS DE VISUAL TAMBIEN, NO NECESARIAMENTE OBJETOS
    method initialize() { image = "ganaste.png" }
}

object end inherits Visual {
    method initialize() { image = "perdiste.png" }
}

object pausaMenu inherits Visual {
    var property estaAbierto = false
    method abrir() {
        if (estaAbierto) {
        estaAbierto = true
        game.addVisual(image)
        game.say(mago, "Juego en pausa")
        keyboard.c().onPressDo({self.cerrar()})
        }
    }
    method cerrar() {
        estaAbierto = false
        game.removeVisual(image)
    }
    method initialize() {
        image = "..." // meterle img para pausa
        position = game.at(5, 3)
    }
}

class Pocion inherits Visual {
    const property numero
    var property vidaQueRecupera
    var property manaQueRecupera
    var property defensaQueRecupera
    method serTomadaPor(personaje) {
        personaje.vida(personaje.vida() + vidaQueRecupera)
        personaje.mana(personaje.mana() + manaQueRecupera)
        personaje.defensa(personaje.defensa() + defensaQueRecupera)
    }
}

object pocionDeVida inherits Pocion (numero = 1) { // PUEDEN SER CONSTANTES INSTANCIAS DE POCION TAMBIEN, NO NECESARIAMENTE OBJETOS
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

// object pocionDeDaño inherits Pocion (numero = 4) {}

object cofre inherits Visual {
    var property pocion = pocionDeDefensa
    method colisionado() {
        mago.conseguirPocion(pocion)
        image = "cogreAbierto.png" // cambias al cofre abierto
    }
    method initialize() {
        image = "cofreCerrado.png" // imagen con cofre cerrado
    }
}

// object barraDeVida inherits Visual {}
// game.onTick(200, "actualizarHUD", { barraDeVida.actualizar() })