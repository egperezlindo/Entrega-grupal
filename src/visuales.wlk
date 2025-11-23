import wollok.game.*
import movimientos.*
import menus.*
import config.*

class Visual {
    var property image
    var property position
}

class Personaje inherits Visual {
    var property vidas
    var property direccion
    method puedeMoverseA(pos) = not juegoPorNiveles.nivelActual().enemigoVivoEn(self.position()) 
    method atacar()
    method perderVida() { vidas = (vidas - 1).max(0) }
    method mirarA(unaDireccion) {
        if(self.puedeMoverseA(unaDireccion.siguiente(self.position()))) { 
            direccion = unaDireccion
        }
    }
    method moverA(unaDireccion) {
        self.mirarA(unaDireccion)
        if (self.puedeMoverseA(unaDireccion.siguiente(self.position()))) {
            self.position(unaDireccion.siguiente(self.position()))
        }
    }
    method resetearPosicion()
    method resetear() { self.initialize() } // cheq
    method estaMuerto() = vidas == 0
    method tieneVidas() = vidas > 0
}

class Proyectil inherits Visual (position = direccionDisparo.siguiente(personaje.position())) {
    var property personaje
    var property direccionDisparo
    method serLanzado() { game.addVisual(self) }
    method moverseRecto() { self.position(direccionDisparo.siguiente(self.position()))}
    method tieneVidas() = false
    method estaFuera()
}

object mago inherits Personaje (direccion = abajo) {
    var property enemigo = juegoPorNiveles.nivelActual().enemigo()
    method posicionDeAtaque() = direccion.siguiente(self.position())
    method configuracionTeclado() {
        if (!menuPausa.menuPausaAbierto()) {
            keyboard.w().onPressDo({self.moverA(arriba)})
            keyboard.s().onPressDo({self.moverA(abajo)})
            keyboard.d().onPressDo({self.moverA(derecha)})
            keyboard.a().onPressDo({self.moverA(izquierda)})
            keyboard.f().onPressDo({self.atacar()})
        }
    }
    override method puedeMoverseA(pos) =
        pos.x() >= 1 &&
        pos.y() >= 1 &&
        pos.x() < 18 &&
        pos.y() < 18 &&
        not juegoPorNiveles.nivelActual().enemigoVivoEn(self.position())
    override method mirarA(unaDireccion) {
        super(unaDireccion)
        image = unaDireccion.imageMago()  
    }
    override method resetearPosicion() {
        position = game.at(8, 17) // IR VIENDO DE AJUSTAR ESTO SEGUN ESCENARIO, lo ideal sería q aparezca en el medio, o en el medio arriba
    }
    override method atacar() {
        const proyectil = new ProyectilMago(enemigo = self.enemigo())
        game.sound("punch.wav").play() //proyectilMago.serLanzado(personaje)
        proyectil.serLanzado() //game.onCollideDo(proyectilMago, {proyectilMago.colisionar(personaje)})
    }
    method initialize() {
        image = direccion.imageMago()
        position = game.at(8, 17) 
        vidas = 3
    }
}

class ProyectilMago inherits Proyectil (personaje = mago) {
    var property contador = 0
    var property tickId = "proyectilMago"
    const property enemigo
    override method serLanzado() {
        super()
        game.onCollideDo(self, { enemigo => 
            self.enemigo().perderVida() 
            game.removeVisual(self)
        })
        game.onTick(350, tickId, {self.moverseRecto()})
    }
    override method moverseRecto() {
        super()
        if ( self.estaFuera()) { 
            game.removeVisual(self)
            game.removeTickEvent("proyectilMago")
        }
    }
    override method estaFuera() = 
        position.x() > game.width() or
        position.x() < 0 or
        position.y() > game.height() or
        position.y() < 0
    method initialize() {
        contador = contador + 1
        tickId = tickId + contador.toString()
        direccionDisparo = personaje.direccion()
        image = "proyectilMago.gif"
    }
}

class Enemigo inherits Personaje {
    method comboEnemigo(unaDireccion)
    method moverseEnemigo()
}

object gusano inherits Enemigo { // ES DE PRUEBA LA ESTÉTICA DEL ENEMIGO
    override method comboEnemigo(unaDireccion) { 
        game.onTick(750, "movimientoGusano", { self.moverseEnemigo() }) 
        game.onTick(1500, "ataqueGusano", { self.atacar() })
    }
    override method moverseEnemigo() {
        const siguiente = direccion.siguiente(position)
        if(self.puedeMoverseA(siguiente)) { self.position(siguiente) }
        else {
            self.invertirDireccion()
            self.position(direccion.siguiente(position))
        }
    }
    method invertirDireccion() {direccion = direccion.contrario() }
    override method puedeMoverseA(pos) = 
        pos.x() >= 3 &&
        pos.y() >= 3 &&
        pos.x() <= 17 &&
        pos.y() <= 17
    override method atacar() {
        const proyectil = new ProyectilGusano()
        game.sound("punch.wav").play() // cambiar sonido 
        proyectil.serLanzado()
    }
    override method resetearPosicion() {
        position = game.at(8, 3) // IR VIENDO DE AJUSTAR ESTO SEGUN ESCENARIO, lo ideal sería q aparezca en el medio, o en el medio arriba
        // puede tener la clase personaje una posicion inicial para ahorrarnos esto!
    }
    method initialize() {
        image = "enemigoUno.png" // nunca se le actualiza la imagen a otra que no sea su reves porque solo se mueve de forma horizontal
        position = game.at(8, 3)
        vidas = 3
        direccion = izquierda
    }
}

class ProyectilGusano inherits Proyectil (personaje = gusano) {
    var property contador = 0
    var property tickId = "proyectilGusano"
    override method serLanzado() {
        super()
        game.onTick(500, tickId, {self.moverseRecto()})
        game.onCollideDo(self, { mago =>
            if (mago.tieneVidas()) {
                mago.perderVida() 
                game.removeVisual(self)
            }   
        })
    }
    override method moverseRecto() {
        super()
        if ( self.estaFuera() ) { 
            game.removeVisual(self)
            game.removeTickEvent("proyectilGusano")
        }
    }
    override method estaFuera() = 
        position.x() > game.width() or
        position.x() < 0 or
        position.y() > game.height() or
        position.y() < 0
    method initialize() {
        image = "proyectilGusano.gif"
        direccionDisparo = arriba
        contador = contador + 1
        tickId = tickId + contador.toString()
    }
}

object caracol inherits Enemigo { // ES DE PRUEBA LA ESTÉTICA DEL ENEMIGO
    var property siguiente = direccion.siguiente(position) // este enemigo se mueve tanto como vertical como horizontal
    override method comboEnemigo(unaDireccion) { 
        game.onTick(1000, "comboCaracol", {
            self.moverseEnemigo()
            self.atacar()
        })
    }
    override method moverseEnemigo() { // modificar este método segun enemigo
        if(self.puedeMoverseA(siguiente)) { self.position(siguiente) }
        else {
            // self.invertirDireccion()
            self.position(direccion.siguiente(position))
        }
    }
    override method mirarA(unaDireccion) {
        if(self.puedeMoverseA(unaDireccion)) { 
            super(unaDireccion)
            image = unaDireccion.imageSlime()
        }
    }
    override method atacar() {
        const proyectil = new ProyectilCaracol()
        game.sound("punch.wav").play() // cambiar sonido 
        proyectil.serLanzado()
    }
    override method resetearPosicion() {
        position = game.at(10,17) // IR VIENDO DE AJUSTAR ESTO SEGUN ESCENARIO, lo ideal sería q aparezca en el medio, o en el medio arriba
    }
    method initialize() {
        image = "enemigoDos.png"
        position = game.at(10, 17)
        vidas = 4
        direccion = izquierda
    }
}

class ProyectilCaracol inherits Proyectil (personaje = caracol) {
    var property contador = 0
    var property tickId = "proyectilCaracol"
    override method serLanzado() {
        super()
        game.onTick(400, tickId, {self.moverseRecto()})
        game.onCollideDo(self, { mago =>
            if (mago.tieneVidas()) {
                mago.perderVida() 
                game.removeVisual(self)
            }   
        })
    }
    override method moverseRecto() {
        super()
        if ( position.y()-1 == game.height()) { 
            game.removeVisual(self)
            game.removeTickEvent("proyectilCaracol")
        }
    }
    override method estaFuera() = 
        position.x() > game.width() or
        position.x() < 0 or
        position.y() > game.height() or
        position.y() < 0
    method initialize() {
        direccionDisparo = arriba // setear dependiendo del mov
        image = "proyectilCaracol.gif"
        contador = contador + 1
        tickId = tickId + contador.toString()
    }
}

object demonio inherits Enemigo { // ES DE PRUEBA LA ESTÉTICA DEL ENEMIGO
    var property siguiente = direccion.siguiente(position) // este enemigo se mueve tanto como vertical como horizontal, tmb podria perseguir al mago
    override method comboEnemigo(unaDireccion) { 
        game.onTick(500, "comboCaracol", {
            self.moverseEnemigo()
            self.atacar()
        })
    }
    override method moverseEnemigo() { // modificar este método segun enemigo
        if(self.puedeMoverseA(siguiente)) { self.position(siguiente) }
        else {
            // self.invertirDireccion()
            self.position(direccion.siguiente(position))
        }
    }
    override method atacar() {
        const proyectil = new ProyectilDemonio()
        game.sound("punch.wav").play() // cambiar sonido 
        proyectil.serLanzado()
    }
    override method mirarA(unaDireccion) {
        if(self.puedeMoverseA(unaDireccion)) { 
            super(unaDireccion)
            image = unaDireccion.imageDragon() // ojo
        }
    }
    override method resetearPosicion() {
        position = game.at(10, 17) // IR VIENDO DE AJUSTAR ESTO SEGUN ESCENARIO, lo ideal sería q aparezca en el medio, o en el medio arriba
    }
    method initialize() {
        image = "enemigoTres.png"
        position = game.at(10, 17) 
        vidas = 5
        direccion = izquierda
    }
}

class ProyectilDemonio inherits Proyectil (personaje = demonio) {
    var property contador = 0
    var property tickId = "proyectilDemonio"
    override method serLanzado() {
        super()
        game.onTick(500, tickId, {self.moverseRecto()})
        game.onCollideDo(self, { mago =>
            if (mago.tieneVidas()) {
                mago.perderVida() 
                game.removeVisual(self)
            }   
        })
    }
    override method moverseRecto() {
        super()
        if ( position.y()-1 == game.height()) { 
            game.removeVisual(self)
            game.removeTickEvent("proyectilDemonio")
        }
    }
    override method estaFuera() = 
        position.x() > game.width() or
        position.x() < 0 or
        position.y() > game.height() or
        position.y() < 0
    method initialize() {
        contador = contador + 1
        tickId = tickId + contador.toString()
        direccionDisparo = arriba // setear dependiendo del mov
        image = "proyectilDemonio.gif"
    }
}