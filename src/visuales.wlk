import wollok.game.*
import movimientos.*
import nivel.*
import mago.*

class Visual {
    var property image
    var property position
}

class Personaje inherits Visual {
    var property vida
    var property daño
    var property direccion = abajo
    method vidaTotal()
    method puedeMoverseA(pos)
    method atacar()
    method recibirDaño(enemigo) { vida = (vida - enemigo.daño()).max(0) }
    method curarse(cantidad) {self.vida(vida + cantidad)}
}

class Enemigo inherits Personaje {
    var property cuadranteMinX // tendrian q ser const
    var property cuadranteMaxX
    var property cuadranteMinY
    var property cuadranteMaxY
    method estaEnSuCuadrante(pos) =
        pos.x() >= cuadranteMinX and
        pos.x() <= cuadranteMaxX and
        pos.y() >= cuadranteMinY and
        pos.y() <= cuadranteMaxY
    method realizarTurno() {
        if (self.estaCercaDelMago()) { self.atacar() }
        else if (self.necesitaCurarse()) { self.curarse(10) }
        else { self.moverseEnDireccionAlMago() }
    }
    method magoEnSuCuadrante() =
        mago.position().x() >= cuadranteMinX and
        mago.position().x() <= cuadranteMaxX and
        mago.position().y() >= cuadranteMinY and
        mago.position().y() <= cuadranteMaxY
    method moverseEnDireccionAlMago() {
    const difX = mago.position().x() - position.x()
    const difY = mago.position().y() - position.y()
    if (difX.abs() > difY.abs()) {
        if (difX > 0) { self.moverseALaDerecha() } 
        else { self.moverseALaIzquierda() }
    } 
    else {
        if (difY > 0) { self.moverseAlNorte() } 
        else {self.moverseAlSur() }
        }
    }
    method estaCercaDelMago() = self.position().distance(mago.position()) <= 1
    method necesitaCurarse() = vida < 100
    method moverseAlNorte() {
        direccion = arriba
        if (self.puedeMoverseA(arriba.siguiente(self.position()))) {
            self.position(arriba.siguiente(self.position()))
        }
    }
    method moverseAlSur() {
        direccion = abajo
        if (self.puedeMoverseA(abajo.siguiente(self.position()))) {
            self.position(abajo.siguiente(self.position()))
        }
    }
    method moverseALaDerecha() {
        direccion = derecha
        if (self.puedeMoverseA(derecha.siguiente(self.position()))) {
            self.position(derecha.siguiente(self.position()))
        }
    }
    method moverseALaIzquierda() {
        direccion = izquierda
        if (self.puedeMoverseA(izquierda.siguiente(self.position()))) {
            self.position(izquierda.siguiente(self.position()))
        }
    }
    override method atacar() {
        mago.recibirDaño(self)
        game.sound("punch.wav").play()
    }

    override method puedeMoverseA(pos) =
        self.estaEnSuCuadrante(pos) and
        nivel.noHayEnemigoVivoAhi(pos) and
        pos != mago.position()
}

object avispa inherits Enemigo {
    override method vidaTotal() = 40
    override method moverseAlNorte() { image = "avispaFrente.png" super() }
    override method moverseAlSur() { image = "avispaFrente.png" super() }
    override method moverseALaIzquierda() { image = "avispaIzquierdo.png" super() }
    override method moverseALaDerecha() { image = "avispaDerecho.png" super() }
    method initialize() {
        image = "avispaDerecho.png"
        position = game.at(4,4)
        vida = nivel.dificultad().vidaEnemigo(self.vidaTotal())
        daño = nivel.dificultad().dañoEnemigo(5)
        cuadranteMinX = 2
        cuadranteMaxX = 8
        cuadranteMinY = 1
        cuadranteMaxY = 4
    }
}

object oso inherits Enemigo {
    override method vidaTotal() = 60
    override method moverseAlNorte() { image = "osoFrente.png" super() }
    override method moverseAlSur() { image = "osoFrente.png" super() }
    override method moverseALaIzquierda() { image = "osoIzquierdo.png" super() }
    override method moverseALaDerecha() { image = "osoDerecho.png" super() }
    method initialize() {
        image = "osoFrente.png" 
        position = game.at(8, 7) 
        vida = nivel.dificultad().vidaEnemigo(self.vidaTotal())
        daño = nivel.dificultad().dañoEnemigo(10)
        cuadranteMinX = 2
        cuadranteMaxX = 8
        cuadranteMinY = 6
        cuadranteMaxY = 8
    }
}

object slime inherits Enemigo {
    override method vidaTotal() = 80
    override method moverseAlNorte() { image = "slimeFrente.png" super() }
    override method moverseAlSur() { image = "slimeFrente.png" super() }
    override method moverseALaIzquierda() { image = "slimeIzquierdo.png" super() }
    override method moverseALaDerecha() { image = "slimeDerecho.png" super() }
    method initialize() {
        image = "slimeIzquierdo.png"
        position = game.at(14, 6)
        vida = nivel.dificultad().vidaEnemigo(self.vidaTotal())
        daño = nivel.dificultad().dañoEnemigo(15)
        cuadranteMinX = 11
        cuadranteMaxX = 17
        cuadranteMinY = 6
        cuadranteMaxY = 8
    }
}

object dragon inherits Enemigo {
    override method vidaTotal() = 100
    override method moverseAlNorte() { image = "dragonFrente.png" super() }
    override method moverseAlSur() { image = "dragonFrente.png" super() }
    override method moverseALaIzquierda() { image = "dragonIzquierdo.png" super() }
    override method moverseALaDerecha() { image = "dragonDerecho.png" super() }
    method initialize() {
        image = "dragonIzquierdo.png"
        position = game.at(17, 3) 
        vida = nivel.dificultad().vidaEnemigo(self.vidaTotal())
        daño = nivel.dificultad().dañoEnemigo(20)
        cuadranteMinX = 11
        cuadranteMaxX = 17
        cuadranteMinY = 1
        cuadranteMaxY = 4
    }
}