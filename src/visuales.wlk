import wollok.game.*
import movimientos.*
import menus.*
import config.*
import proyectiles.*
import corazones.*

class Visual {
    var property image
    var property position
    method tieneVidas() = false
}

class Personaje inherits Visual {
    var property vidas
    var property direccion
    method morir()
    method atacar()
    method resetearPosicion()
    method mostrarCorazones()
    method puedeMoverseA(pos) = 
    juegoPorNiveles.nivelActual().puedeMoverseA(pos) and
    !juegoPorNiveles.nivelActual().enemigoVivoEn(self.position()) and 
    !self.hayColumna(pos)
    method perderVida() { vidas = (vidas - 1).max(0) }
    method mirarA(unaDireccion) { direccion = unaDireccion }
    method moverA(unaDireccion) {
        if(!menuPausa.abierto()) {
            self.mirarA(unaDireccion)
            if (self.puedeMoverseA(unaDireccion.siguiente(self.position()))) {
                self.position(unaDireccion.siguiente(self.position()))
            }
            else { direccion = unaDireccion }
        }
    }
    method hayColumna(pos) = juegoPorNiveles.nivelActual().columnas().any({c => c.position() == pos})
    method resetear() { 
        self.resetearPosicion() 
        direccion = izquierda
    }
    method estaMuerto() = vidas == 0
    method resetearVidas() { self.mostrarCorazones() } 
    override method tieneVidas() = vidas > 0
}


object mago inherits Personaje (direccion = abajo) {
    const property corazones = [corazonM1, corazonM2, corazonM3]
    const property corazonesVacios = [corazonVacioM1, corazonVacioM2, corazonVacioM3]
    var property enemigo = juegoPorNiveles.nivelActual().enemigo()
    method posicionDeAtaque() = direccion.siguiente(self.position())
    method configuracionTeclado() {
        if (!menuPausa.abierto()) {
            keyboard.w().onPressDo({self.moverA(arriba)})
            keyboard.s().onPressDo({self.moverA(abajo)})
            keyboard.d().onPressDo({self.moverA(derecha)})
            keyboard.a().onPressDo({self.moverA(izquierda)})
            keyboard.f().onPressDo({self.atacar()})
        }
    }
    override method mirarA(unaDireccion) {
        super(unaDireccion)
        image = direccion.imageMago()  
    }
    override method resetearPosicion() { position = game.at(8,9) }
    override method resetearVidas() { 
        super()
        vidas = 3 
    }
    override method atacar() {
        if(!menuPausa.abierto()) {
            const proyectil = new ProyectilMago(enemigo = self.enemigo())
            idMago.actualizarUltimoID()
            image = direccion.imageAtaque()
            game.sound("punch.wav").play()
            proyectil.serLanzado()
        }
    }
    override method morir() { juegoPorNiveles.nivelActual().volverAlMenu() self.resetearVidas() }
    override method perderVida() {
        super()
        self.mostrarCorazones()
        if (self.estaMuerto()) { self.morir() }
    }
    override method mostrarCorazones() {
        (corazones + corazonesVacios).forEach({c => game.removeVisual(c)})
        (0..2).forEach({i =>
        if (i < vidas) game.addVisual(corazones.get(i))
        else game.addVisual(corazonesVacios.get(i))})
    }
    method initialize() {
        image = direccion.imageMago()
        position = game.at(8,9)
        vidas = 3
    }
}

class Enemigo inherits Personaje {
    method comboEnemigo()
    method moverseEnemigo()
    method invertirDireccion()
}

object gusano inherits Enemigo (direccion = izquierda) {
    const property corazones = [corazonG1, corazonG2, corazonG3]
    const property corazonesVacios = [corazonVacioG1, corazonVacioG2, corazonVacioG3]
    override method comboEnemigo() { 
        game.onTick(750, "movimientoGusano", { self.moverseEnemigo() }) 
        game.onTick(1350, "ataqueGusano", { self.atacar() })
    }
    override method moverseEnemigo() {
        const siguiente = direccion.siguiente(position)
        self.mirarA(direccion)
        if (!menuPausa.abierto()) {
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
        pos.y() >= 2 &&
        pos.x() <= 16 &&
        pos.y() <= 17
    override method mirarA(unaDireccion) {
        super(unaDireccion)
        image = unaDireccion.imageGusano()
    }
    override method atacar() {
        if(!menuPausa.abierto()) {
            const proyectil = new ProyectilGusano()
            idGusano.actualizarUltimoID()
            game.sound("punch.wav").play() // cambiar sonido 
            proyectil.serLanzado()
        }
    }
    override method resetearPosicion() { position = game.at(8, 2) }
    override method resetearVidas() { 
        super()
        vidas = 3 
    }
    override method perderVida() {
        super()
        self.mostrarCorazones()
        if (self.estaMuerto()) { self.morir() }
    }
    override method mostrarCorazones() {
        (corazones + corazonesVacios).forEach({c => game.removeVisual(c)})
        (0..2).forEach({i =>
        if (i < vidas) game.addVisual(corazones.get(i))
        else game.addVisual(corazonesVacios.get(i))})
    }
    override method morir() { juegoPorNiveles.pasarASiguienteNivel() }
    method initialize() {
        image = direccion.imageGusano()
        position = game.at(8, 2)
        vidas = 3
    }
}

object caracol inherits Enemigo (direccion = izquierda) {
    const property corazones = [corazonC1, corazonC2, corazonC3, corazonC4]
    const property corazonesVacios = [corazonVacioC1, corazonVacioC2, corazonVacioC3, corazonVacioC4]
    override method comboEnemigo() { 
        game.onTick(650, "movimientoCaracol", { self.moverseEnemigo() }) 
        game.onTick(1250, "ataqueCaracol", { self.atacar() })
    }
    override method moverseEnemigo() {
        const siguiente = direccion.siguiente(position)
        if (!menuPausa.abierto()) {
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
        pos.x() >= 1 &&
        pos.y() >= 2 &&
        pos.x() <= 17 &&
        pos.y() <= 17
    override method mirarA(unaDireccion) {
        super(unaDireccion)
        image = unaDireccion.imageCaracol()
    }
    override method atacar() {
        if(!menuPausa.abierto()) {
            const proyectil = new ProyectilCaracol()
            idCaracol.actualizarUltimoID()
            game.sound("punch.wav").play() // cambiar sonido 
            proyectil.serLanzado()
        }
        
    }
    override method resetearPosicion() { position = game.at(8, 2) }
    override method resetearVidas() { 
        super()
        vidas = 4 
    }
    override method perderVida() {
        super()
        self.mostrarCorazones()
        if (self.estaMuerto()) { self.morir() }
    }
    override method mostrarCorazones() {
        (corazones + corazonesVacios).forEach({c => game.removeVisual(c)})
        (0..3).forEach({i =>
        if (i < vidas) game.addVisual(corazones.get(i))
        else game.addVisual(corazonesVacios.get(i))})
    }
    override method morir() { juegoPorNiveles.pasarASiguienteNivel() }
    method initialize() {
        image = direccion.imageCaracol()
        position = game.at(8, 2)
        vidas = 4
    }
}

object demonio inherits Enemigo (direccion = izquierda) {
    const property corazones = [corazonD1, corazonD2, corazonD3, corazonD4, corazonD5]
    const property corazonesVacios = [corazonVacioD1, corazonVacioD2, corazonVacioD3, corazonVacioD4, corazonVacioD5]
    override method comboEnemigo() { 
        game.onTick(500, "movimientoDemonio", { self.moverseEnemigo() }) 
        game.onTick(1100, "ataqueDemonio", { self.atacar() })
    }
    override method moverseEnemigo() {
        const siguiente = direccion.siguiente(position)
        if (!menuPausa.abierto()) {
            if (self.puedeMoverseA(siguiente)) { self.position(siguiente) }
            else {
                self.invertirDireccion()
                self.position(direccion.siguiente(position)) 
            }
        }
    }
    override method invertirDireccion() { direccion = direccion.siguienteCiclo() }
    override method puedeMoverseA(pos) =
        pos.x() >= 1 &&
        pos.y() >= 2 &&
        pos.x() <= 17 &&
        pos.y() <= 17
    override method atacar() {
        if(!menuPausa.abierto()) {
            const proyectil = new ProyectilDemonio()
            idDemonio.actualizarUltimoID()
            game.sound("punch.wav").play() // cambiar sonido 
            proyectil.serLanzado()
        }
        
    }
    override method mirarA(unaDireccion) {
        if(self.puedeMoverseA(unaDireccion)) { 
            super(unaDireccion)
            image = unaDireccion.imageDragon() // ojo
        }
    }
    override method resetearPosicion() { position = game.at(8, 2) }
    override method resetearVidas() { 
        super()
        vidas = 5 
    }
    override method morir() { juegoPorNiveles.pasarASiguienteNivel() }
    override method perderVida() {
        super()
        self.mostrarCorazones()
        if (self.estaMuerto()) { self.morir() }
    }
    override method mostrarCorazones() {
        (corazones + corazonesVacios).forEach({c => game.removeVisual(c)})
        (0..4).forEach({i =>
        if (i < vidas) game.addVisual(corazones.get(i))
        else game.addVisual(corazonesVacios.get(i))})
    }
    method initialize() {
        image = direccion.imageDemonio()
        position = game.at(8, 2)
        vidas = 5
    }
}

const columna1 = new Visual(image = "columna.png", position = game.at(12,11))
const columna2 = new Visual(image = "columna.png", position = game.at(6,10))
const columna3 = new Visual(image = "columna.png", position = game.at(10,7))

class Pincho inherits Visual (position = game.center()) {
  var property segundos 
  var property tickId
  method movete() {
    if(!menuPausa.abierto()){
        game.removeVisual(self)
        const x = 3.randomUpTo(game.width()-5).truncate(0)
        const y = 4.randomUpTo(game.height()-4).truncate(0)
        position = game.at(x,y)
        game.addVisual(self)
    } 
  }
  method ponerse() {
    game.onCollideDo(self, { mago => if (mago.tieneVidas()) { mago.perderVida() }})
    game.onTick(5000, tickId, { self.movete() })
  }
  method aparece() {
    game.addVisual(self)
    self.ponerse()
  }
  method initialize() {
    tickId = idPincho.nuevoId("movPincho")
    image = "spikes.gif"
  }
}

const idPincho = new ID()