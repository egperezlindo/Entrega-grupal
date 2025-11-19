import wollok.game.*
import movimientos.*
import nivel.*
import mago.*

class Visual {
    var property image
    var property position
}

class Personaje inherits Visual {
    var vida
    var property daño
    var property direccion = abajo
    method vida() = vida.max(0)
    method vidaMáxima()
    method puedeMoverseA(pos)
    method atacar()
    method recibirDaño(enemigo) { vida = vida - enemigo.daño() }
    method mirarA(unaDireccion) { 
        direccion = unaDireccion
    }
    method moverA(unaDireccion) {
        self.mirarA(unaDireccion)
        if (self.puedeMoverseA(unaDireccion.siguiente(self.position()))) {
            self.position(unaDireccion.siguiente(self.position()))
        }
    }
}

class Enemigo inherits Personaje {
    const direcciones = #{arriba, abajo, izquierda, derecha}
    var property cuadranteMinX // tendrian q ser const
    var property cuadranteMaxX
    var property cuadranteMinY
    var property cuadranteMaxY

    method estaEnSuCuadrante(pos) =
        pos.x() >= cuadranteMinX and
        pos.x() <= cuadranteMaxX and
        pos.y() >= cuadranteMinY and
        pos.y() <= cuadranteMaxY

    method moverAleatorio() {
        const destino = direcciones.anyOne().siguiente(self.position())
        if (self.puedeMoverseA(destino)) {
            self.position(destino)
        }
    }

    method realizarTurno() {
        if (self.estaAlLadoDelMago()) {
            self.atacar()
        }
        else if (self.necesitaCurarse()) {
            self.curarse()
        }
        else if (self.magoEnSuCuadrante()) {
            self.moverseEnDireccionAlMago()
        }
        else {
            self.moverAleatorio()
        }
    }

    method magoEnSuCuadrante() =
        mago.position().x() >= cuadranteMinX and
        mago.position().x() <= cuadranteMaxX and
        mago.position().y() >= cuadranteMinY and
        mago.position().y() <= cuadranteMaxY

    method moverseEnDireccionAlMago() {
    const miPos = position
    const posMago = mago.position()
    // diferencia entre posiciones
    const difX = posMago.x() - miPos.x()
    const difY = posMago.y() - miPos.y()
    
    // avanza priorizando el eje donde haya más distancia
    if (difX.abs() > difY.abs()) {
        if (difX > 0) { self.moverA(derecha) } 
        else { self.moverA(izquierda) }
    } 
    else {
        if (difY > 0) { self.moverA(abajo) } 
        else { self.moverA(arriba) }
        }
    }

    method estaAlLadoDelMago() = direcciones.any({d => d.siguiente(self.position()) == mago.position()})
    
    method necesitaCurarse() = vida < 100
    
    method curarse() {
        vida = vida + 15
        game.sound("heal.wav").play()
        if (vida > self.vidaMáxima()) {
            vida = 100
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
    override method vidaMáxima() = 40
    override 
    method initialize() {
        image = "avispaDerecho.png"
        position = game.at(4,4)
        vida = 40
        daño = 5
        cuadranteMinX = 2
        cuadranteMaxX = 8
        cuadranteMinY = 6
        cuadranteMaxY = 9
    }
}

object oso inherits Enemigo {
    override method vidaMáxima() = 60
    method initialize() {
        image = "osoFrente.png" 
        position = game.at(8, 7) 
        vida = 60
        daño = 10
        cuadranteMinX = 2
        cuadranteMaxX = 8
        cuadranteMinY = 2
        cuadranteMaxY = 4
    }
}

object slime inherits Enemigo {
    override method vidaMáxima() = 80
    method initialize() {
        image = "slimeIzquierdo.png"
        position = game.at(14, 6)
        vida = 80
        daño = 15
        cuadranteMinX = 11
        cuadranteMaxX = 17
        cuadranteMinY = 6
        cuadranteMaxY = 9
    }
}

object dragon inherits Enemigo {
    override method vidaMáxima() = 100
    method initialize() {
        image = "dragonIzquierdo.png"
        position = game.at(17, 3) 
        vida = 100
        daño = 20
        cuadranteMinX = 11
        cuadranteMaxX = 17
        cuadranteMinY = 2
        cuadranteMaxY = 4
    }
}

object cofre inherits Visual {
    const property pociones = [pocionDeVida, pocionDeDaño]
    method initialize() {
        image = "cofre.png"
        position = game.at(12, 6)
    }
    
}

class Pocion inherits Visual {
    var property dañoQueSuma
    var property vidaQueSuma
}

const pocionDeVida = new Pocion(
    image = "pocionDeVida.png", 
    position = game.at(12,7), 
    dañoQueSuma = 0,
    vidaQueSuma = 30)

const pocionDeDaño = new Pocion(
    image = "pocionDeVida.png", 
    position = game.at(12,7), 
    dañoQueSuma = 5,
    vidaQueSuma = 0)