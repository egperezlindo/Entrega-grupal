import wollok.game.*
import movimientos.*
import menus.*
import config.*
import proyectiles.*

class Visual {
    var property image
    var property position
}

class Personaje inherits Visual {
    var property vidas
    var property direccion
    method puedeMoverseA(pos) = not juegoPorNiveles.nivelActual().enemigoVivoEn(self.position()) 
    method atacar()
    method perderVida() { 
        vidas = (vidas - 1).max(0)
        if (self.estaMuerto()) { self.morir() }
    }
    method mirarA(unaDireccion) {
        if(self.puedeMoverseA(unaDireccion.siguiente(self.position()))) { 
            direccion = unaDireccion
        }
    }
    method moverA(unaDireccion) {
        if(!menuPausa.menuPausaAbierto()){
            self.mirarA(unaDireccion)
        if (self.puedeMoverseA(unaDireccion.siguiente(self.position()))) {
            self.position(unaDireccion.siguiente(self.position()))
        }
    }
        
    }
    method resetearPosicion()
    method resetearVidas()
    method resetear() { 
        self.resetearPosicion() 
        self.resetearVidas()
        direccion = izquierda
    }
    method estaMuerto() = vidas == 0
    method tieneVidas() = vidas > 0
    method morir()
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
        super(pos) &&
        pos.x() >= 1 &&
        pos.y() >= 1 &&
        pos.x() < 18 &&
        pos.y() < 18
    override method mirarA(unaDireccion) {
        super(unaDireccion)
        image = direccion.imageMago()  
    }
    override method resetearPosicion() { position = game.at(8, 17) }
    override method resetearVidas() { vidas = 3 }
    override method atacar() {
        if(!menuPausa.menuPausaAbierto()) {
            const proyectil = new ProyectilMago(enemigo = self.enemigo())
            image = direccion.imageAtaque()
            game.sound("punch.wav").play()
            proyectil.serLanzado()
        }
    }
    override method morir() { juegoPorNiveles.nivelActual().volverAlMenu() }
    method initialize() {
        image = direccion.imageMago()
        position = juegoPorNiveles.nivelActual().posicionMago()
        vidas = 3
    }
}

class Enemigo inherits Personaje {
    method comboEnemigo()
    method moverseEnemigo()
    method invertirDireccion()
}

object gusano inherits Enemigo (direccion = izquierda) { // ES DE PRUEBA LA ESTÉTICA DEL ENEMIGO
    override method comboEnemigo() { 
        game.onTick(750, "movimientoGusano", { self.moverseEnemigo() }) 
        game.onTick(1500, "ataqueGusano", { self.atacar() })
    }
    override method moverseEnemigo() {
        const siguiente = direccion.siguiente(position)
        self.mirarA(direccion)
        if (!menuPausa.menuPausaAbierto()) {
            if (self.puedeMoverseA(siguiente)) { self.position(siguiente) }
            else {
                self.invertirDireccion()
                self.position(direccion.siguiente(position))
            }
        }
    }
    override method invertirDireccion() { direccion = direccion.contrario() }
    override method puedeMoverseA(pos) =
        pos.x() >= 3 &&
        pos.y() >= 3 &&
        pos.x() <= 17 &&
        pos.y() <= 17
    override method mirarA(unaDireccion) {
        super(unaDireccion)
        image = unaDireccion.imageGusano()
    }
    override method atacar() {
        if(!menuPausa.menuPausaAbierto()) {
            const proyectil = new ProyectilGusano()
            game.sound("punch.wav").play() // cambiar sonido 
            proyectil.serLanzado()
        }
    }
    override method resetearPosicion() {
        position = game.at(8, 3) // IR VIENDO DE AJUSTAR ESTO SEGUN ESCENARIO, lo ideal sería q aparezca en el medio, o en el medio arriba
        // puede tener la clase personaje una posicion inicial para ahorrarnos esto!
    }
    override method resetearVidas() {
        vidas = 3
    }
    override method morir() { juegoPorNiveles.pasarASiguienteNivel() }
    method initialize() {
        image = direccion.imageGusano()
        position = game.at(8, 3)
        vidas = 3
    }
}

object caracol inherits Enemigo (direccion = izquierda) {
    override method comboEnemigo() { 
        game.onTick(650, "movimientoCaracol", { self.moverseEnemigo() }) 
        game.onTick(1500, "ataqueCaracol", { self.atacar() })
    }
    override method moverseEnemigo() {
        const siguiente = direccion.siguiente(position)
        if (!menuPausa.menuPausaAbierto()) {
            if (self.puedeMoverseA(siguiente)) { 
                self.mirarA(direccion)
                self.position(siguiente) 
            }
            else { 
                self.invertirDireccion() 
                self.position(direccion.siguiente(position)) 
            }
        }
    }
    override method invertirDireccion() { direccion = direccion.siguienteCiclo() }
    override method puedeMoverseA(pos) =
        pos.x() >= 3 &&
        pos.y() >= 3 &&
        pos.x() <= 17 &&
        pos.y() <= 17
    override method mirarA(unaDireccion) {
        super(unaDireccion)
        image = unaDireccion.imageCaracol()
    }
    override method atacar() {
        const proyectil = new ProyectilCaracol()
        game.sound("punch.wav").play() // cambiar sonido 
        proyectil.serLanzado()
    }
    override method resetearPosicion() {
        position = game.at(8, 3)
    }
    override method resetearVidas() {
        vidas = 4
    }
    override method morir() { juegoPorNiveles.pasarASiguienteNivel() }
    method initialize() {
        image = direccion.imageCaracol()
        position = game.at(8, 3)
        vidas = 4
    }
}

object demonio inherits Enemigo (direccion = izquierda) {
    override method comboEnemigo() { 
        game.onTick(500, "movimientoDemonio", { self.moverseEnemigo() }) 
        game.onTick(1500, "ataqueDemonio", { self.atacar() })
    }
    override method moverseEnemigo() {
        const siguiente = direccion.siguiente(position)
        if (!menuPausa.menuPausaAbierto()) {
            if (self.puedeMoverseA(siguiente)) { self.position(siguiente) }
            else {
                self.invertirDireccion()
                self.position(direccion.siguiente(position)) 
            }
        }
    }
    override method invertirDireccion() { direccion = direccion.siguienteCiclo() }
    override method puedeMoverseA(pos) =
        pos.x() >= 3 &&
        pos.y() >= 3 &&
        pos.x() <= 17 &&
        pos.y() <= 17
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
        position = game.at(8, 3)
    }
    override method resetearVidas() {
        vidas = 5
    }
    override method morir() { juegoPorNiveles.pasarASiguienteNivel() }
    method initialize() {
        image = direccion.imageDemonio()
        position = game.at(8, 3)
        vidas = 5
    }
}
