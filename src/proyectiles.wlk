import wollok.game.*
import movimientos.*
import menus.*
import config.*
import visuales.*

class Proyectil inherits Visual (position = direccionDisparo.siguiente(personaje.position())) {
    var property personaje
    var property direccionDisparo
    method serLanzado() { game.addVisual(self) }
    method moverseRecto()
    method estaFuera()
    method tieneVidas() = false
    method hayColumna(pos) = juegoPorNiveles.nivelActual().columnas().any({c => c.position() == pos})
}

class ProyectilMago inherits Proyectil (personaje = mago) {
    var property contador = 0
    var property tickId
    var property enemigo
    override method serLanzado() {
        super()
        game.onCollideDo(self, { enemigo =>
            if (enemigo.tieneVidas()) { enemigo.perderVida() }
            game.removeVisual(image)
        })
            if(!enemigo.tieneVidas()) {self.moverseRecto()} //esto debería resolver el tema del que mago se coma sus propios proyectiles
            game.onTick(225, tickId, {self.moverseRecto()}) //si es necesario puede volverse a la normalidad
    }
    override method moverseRecto() {
        if(!menuPausa.menuPausaAbierto() and !self.hayColumna(direccionDisparo.siguiente(self.position()))) {
            self.position(direccionDisparo.siguiente(self.position()))
        }
        if (self.estaFuera()) { 
            game.removeVisual(self)
            game.removeTickEvent(tickId)
        }
    }
    override method estaFuera() = 
        position.x() > game.width() or
        position.x() < 0 or
        position.y() > game.height() or
        position.y() < 0
    method initialize() {
        enemigo = personaje.enemigo()
        image = "proyectilMago.gif"
        contador = contador + 1
        tickId = "proyectilMago" + contador.toString()
        direccionDisparo = personaje.direccion()
    }
}

class ProyectilGusano inherits Proyectil (personaje = gusano) {
    var property contador = 0
    var property tickId = "proyectilGusano"
    override method serLanzado() {
        super()
        game.onCollideDo(self, { mago =>
            if (mago.tieneVidas()) { mago.perderVida() }
            game.removeVisual(self)
        })
        game.onTick(350, tickId, {self.moverseRecto()})
    }
    override method moverseRecto() {
        if(!menuPausa.menuPausaAbierto()) {
            self.position(direccionDisparo.siguiente(self.position()))
        }
        if ( self.estaFuera()) { 
            game.removeVisual(self)
            game.removeTickEvent("tickId")
        }
    }
    override method estaFuera() = 
        position.x() > game.width() or
        position.x() < 0 or
        position.y() > game.height() or
        position.y() < 0
    method initialize() {
        image = "proyectilGusano.gif"
        contador = contador + 1
        tickId = tickId + contador.toString()
        direccionDisparo = arriba
    }
}

class ProyectilCaracol inherits Proyectil (personaje = caracol) {
    var property contador = 0
    var property tickId = "proyectilCaracol"
    override method serLanzado() {
        super()
        game.onCollideDo(self, { mago =>
            if (mago.tieneVidas()) {mago.perderVida() }
            game.removeVisual(self)
        })
        game.onTick(350, tickId, {self.moverseRecto()})
    }
    override method moverseRecto() {
        if(!menuPausa.menuPausaAbierto()) {
            self.position(direccionDisparo.siguiente(self.position()))
        }
        if ( self.estaFuera()) { 
            game.removeVisual(self)
            game.removeTickEvent("tickId")
        }
    }
    override method estaFuera() = 
        position.x() > game.width() or
        position.x() < 0 or
        position.y() > game.height() or
        position.y() < 0
    method initialize() {
        image = "proyectilCaracol.gif"
        contador = contador + 1
        tickId = tickId + contador.toString()
        direccionDisparo = caracol.direccion().siguienteCiclo()
    }
}

class ProyectilDemonio inherits Proyectil (personaje = demonio) {
    var property contador = 0
    var property tickId = "proyectilDemonio"
    override method serLanzado() {
        super()
        game.onCollideDo(self, { mago =>
            if (mago.tieneVidas()) {mago.perderVida() }
            game.removeVisual(self)
        })
        game.onTick(350, tickId, {self.moverseRecto()})
    }
    override method moverseRecto() {
        if(!menuPausa.menuPausaAbierto()) {
            self.position(direccionDisparo.siguiente(self.position()))
        }
        if ( self.estaFuera()) { 
            game.removeVisual(self)
            game.removeTickEvent("tickId")
        }
    }
    override method estaFuera() = 
        position.x() > game.width() or
        position.x() < 0 or
        position.y() > game.height() or
        position.y() < 0
    method initialize() {
        image = "proyectilDemonio.gif"
        contador = contador + 1
        tickId = tickId + contador.toString()
        direccionDisparo = demonio.direccion().siguienteCiclo()
    }
}