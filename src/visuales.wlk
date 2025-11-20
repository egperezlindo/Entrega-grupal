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
    method estadoInicial() {}
    method vida() = vida.max(0)
    method puedeMoverseA(pos)
    method recibirDaño(enemigo) { vida = vida - enemigo.daño() }
    method curarse(cantidad) {vida = vida + (vida - cantidad)}
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
    override method puedeMoverseA(pos) =
        self.estaEnSuCuadrante(pos) and
        nivel.noHayEnemigoVivoAhi(pos) and
        pos != mago.position()
}

object avispa inherits Enemigo {
    method initialize() {
        image = "avispaDerecho.png"
        position = game.at(4,4)
        vida = 40
        daño = 5
        cuadranteMinX = 2
        cuadranteMaxX = 8
        cuadranteMinY = 1
        cuadranteMaxY = 4
    }
    override method estadoInicial() {
        position = game.at(4,4)
        vida = 40
    }
}

object oso inherits Enemigo {
    method initialize() {
        image = "osoFrente.png" 
        position = game.at(8, 7) 
        vida = 60
        daño = 10
        cuadranteMinX = 2
        cuadranteMaxX = 8
        cuadranteMinY = 6
        cuadranteMaxY = 8
    }
    override method estadoInicial() {
        position = game.at(8, 7) 
        vida = 60
    }
}

object slime inherits Enemigo {
    method initialize() {
        image = "slimeIzquierdo.png"
        position = game.at(14, 6)
        vida = 80
        daño = 15
        cuadranteMinX = 11
        cuadranteMaxX = 17
        cuadranteMinY = 6
        cuadranteMaxY = 8
    }
    override method estadoInicial() {
        position = game.at(14, 6)
        vida = 80
    }
}

object dragon inherits Enemigo {
    method initialize() {
        image = "dragonIzquierdo.png"
        position = game.at(17, 3) 
        vida = 100
        daño = 20
        cuadranteMinX = 11
        cuadranteMaxX = 17
        cuadranteMinY = 1
        cuadranteMaxY = 4
    }
    override method estadoInicial() {
        position = game.at(17, 3) 
        vida = 100
    }
}