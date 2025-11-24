import wollok.game.*
import movimientos.*
import menus.*
import config.*
import proyectiles.*
import corazones.*

class Visual {
    var property image
    var property position
}

class Personaje inherits Visual {
    var property vidas
    var property direccion
    method morir()
    method atacar()
    method resetearVidas()
    method resetearPosicion()
    method mostrarCorazones()
    method puedeMoverseA(pos) = !juegoPorNiveles.nivelActual().enemigoVivoEn(self.position()) and !self.hayColumna(direccion.siguiente(self.position()))
    method perderVida() { vidas = (vidas - 1).max(0) }
    method mirarA(unaDireccion) {
        if(self.puedeMoverseA(unaDireccion.siguiente(self.position()))) { direccion = unaDireccion }
    }
    method moverA(unaDireccion) {
        if(!menuPausa.menuPausaAbierto()) {
            self.mirarA(unaDireccion)
            if (self.puedeMoverseA(unaDireccion.siguiente(self.position()))) {
                self.position(unaDireccion.siguiente(self.position()))
            }
        }
    }
    method hayColumna(pos) = juegoPorNiveles.nivelActual().columnas().any({c => c.position() == pos})
    method resetear() { 
        self.resetearPosicion() 
        self.resetearVidas()
        direccion = izquierda
    }
    method estaMuerto() = vidas == 0
    method tieneVidas() = vidas > 0
}


object mago inherits Personaje (direccion = abajo) {
    var indice = 0
    const property corazones = [corazonM1, corazonM2, corazonM3]
    const property corazonesVacios = [corazonVacioM1, corazonVacioM2, corazonVacioM3]
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
    override method puedeMoverseA(pos) = super(pos) && juegoPorNiveles.nivelActual().puedeMoverseA(pos)
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
    override method perderVida() {
        super()
        game.removeVisual(corazones.get(indice))
        game.addVisual(corazonesVacios.get(indice))
        indice += 1
        if (self.estaMuerto()) { self.morir() }
    }
    override method mostrarCorazones() { corazones.forEach({c => game.addVisual(c)}) }
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

object gusano inherits Enemigo (direccion = izquierda) {
    var indice = 0
    const property corazones = [corazonG1, corazonG2, corazonG3]
    const property corazonesVacios = [corazonVacioG1, corazonVacioG2, corazonVacioG3]
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
    override method resetearPosicion() { position = game.at(8, 3) }
    override method resetearVidas() { vidas = 3 }
    override method perderVida() {
        super()
        game.removeVisual(corazones.get(indice))
        game.addVisual(corazonesVacios.get(indice))
        indice += 1
        if (self.estaMuerto()) { self.morir() }
    }
    override method morir() { juegoPorNiveles.pasarASiguienteNivel() }
    override method mostrarCorazones() { corazones.forEach({c => game.addVisual(c)}) }
    method initialize() {
        image = direccion.imageGusano()
        position = game.at(8, 3)
        vidas = 3
    }
}

object caracol inherits Enemigo (direccion = izquierda) {
    var indice = 0
    const property corazones = [corazonC1, corazonC2, corazonC3, corazonC4]
    const property corazonesVacios = [corazonVacioC1, corazonVacioC2, corazonVacioC3, corazonVacioC4]
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
    override method perderVida() {
        super()
        game.removeVisual(corazones.get(indice))
        game.addVisual(corazonesVacios.get(indice))
        indice += 1
        if (self.estaMuerto()) { self.morir() }
    }
    override method resetearPosicion() { position = game.at(8, 3) }
    override method resetearVidas() { vidas = 4 }
    override method morir() { juegoPorNiveles.pasarASiguienteNivel() }
    override method mostrarCorazones() { corazones.forEach({c => game.addVisual(c)}) }
    method initialize() {
        image = direccion.imageCaracol()
        position = game.at(8, 3)
        vidas = 4
    }
}

object demonio inherits Enemigo (direccion = izquierda) {
    var indice = 0
    const property corazones = [corazonD1, corazonD2, corazonD3, corazonD4, corazonD5]
    const property corazonesVacios = [corazonVacioD1, corazonVacioD2, corazonVacioD3, corazonVacioD4, corazonVacioD5]
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
    override method perderVida() {
        super()
        game.removeVisual(corazones.get(indice))
        game.addVisual(corazonesVacios.get(indice))
        indice += 1
        if (self.estaMuerto()) { self.morir() }
    }
    override method resetearPosicion() { position = game.at(8, 3) }
    override method resetearVidas() { vidas = 5 }
    override method morir() { juegoPorNiveles.pasarASiguienteNivel() }
    override method mostrarCorazones() { corazones.forEach({c => game.addVisual(c)}) }
    method initialize() {
        image = direccion.imageDemonio()
        position = game.at(8, 3)
        vidas = 5
    }
}
