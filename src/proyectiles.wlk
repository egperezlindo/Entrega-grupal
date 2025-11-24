import wollok.game.*
import movimientos.*
import menus.*
import config.*
import visuales.*

class Proyectil inherits Visual (position = direccionDisparo.siguiente(personaje.position())) {
    var property personaje
    var property direccionDisparo
    method serLanzado() { game.addVisual(self) }
    method moverseRecto() {
        if(!menuPausa.menuPausaAbierto()) {
            self.position(direccionDisparo.siguiente(self.position()))
        }
    }
    method estaFuera() = 
        position.x() > game.width() or
        position.x() < 0 or
        position.y() > game.height() or
        position.y() < 0
    method hayColumna(pos) = juegoPorNiveles.nivelActual().columnas().any({c => c.position() == pos})
}

object id { // podría hacerse uno por proyectil para reducir todavía más el lag (creo)
    var ultimoId = 0
    method nuevoId(unID) = unID + ultimoId.toString()
    method actualizarUltimoID() { ultimoId = ultimoId + 1 }
}

class ProyectilMago inherits Proyectil (personaje = mago) {
    var property tickId
    const property enemigo
    override method serLanzado() {
        super()
        game.onCollideDo(self, { enemigo =>
            if (enemigo.tieneVidas()) {enemigo.perderVida() }
            game.removeVisual(self)
        })
        game.onTick(350, tickId, {self.moverseRecto()})
    }
    override method moverseRecto() {
        super()
        if ( self.estaFuera()) { 
            game.removeVisual(self)
            game.removeTickEvent(tickId)
        }
    }
    method initialize() {
        tickId = id.nuevoId("proyectilMago")
        direccionDisparo = personaje.direccion()
        image = "proyectilMago.gif"
    }
}

class ProyectilGusano inherits Proyectil (personaje = gusano) {
    var property tickId
    override method serLanzado() {
        super()
        game.onCollideDo(self, { mago =>
            if (mago.tieneVidas()) { mago.perderVida() }
            game.removeVisual(self)
            game.removeTickEvent(tickId)
        })
        game.onTick(350, tickId, {self.moverseRecto()})
    }
    override method moverseRecto() {
        super()
        if (self.estaFuera()) { 
            game.removeVisual(self)
            game.removeTickEvent(tickId)
        }
    }
    method initialize() {
        tickId = id.nuevoId("proyectilGusano")
        image = "proyectilGusano.gif"
        direccionDisparo = arriba
    }
}

class ProyectilCaracol inherits Proyectil (personaje = caracol) {
    var property tickId
    override method serLanzado() {
        super()
        game.onCollideDo(self, { mago =>
            if (mago.tieneVidas()) {mago.perderVida()}
            game.removeVisual(self)
            game.removeTickEvent(tickId)
        })
        game.onTick(350, tickId, {self.moverseRecto()})
    }
    override method moverseRecto() {
        super()
        if (self.estaFuera()) { 
            game.removeVisual(self)
            game.removeTickEvent(tickId)
        }
    }
    method initialize() {
        tickId = id.nuevoId("proyectilCaracol")
        image = "proyectilCaracol.gif"
        direccionDisparo = caracol.direccion().siguienteCiclo()
    }
}

class ProyectilDemonio inherits Proyectil (personaje = demonio) {
    var property tickId
    override method serLanzado() {
        super()
        game.onCollideDo(self, { mago =>
            if (mago.tieneVidas()) {mago.perderVida() }
            game.removeVisual(self)
            game.removeTickEvent(tickId)
        })
        game.onTick(350, tickId, {self.moverseRecto()})
    }
    override method moverseRecto() {
        super()
        if (self.estaFuera()) { 
            game.removeVisual(self)
            game.removeTickEvent(tickId)
        }
    }
    method initialize() {
        tickId = id.nuevoId("proyectilDemonio")
        image = "proyectilDemonio.gif"
        direccionDisparo = demonio.direccion().siguienteCiclo()
    }
}