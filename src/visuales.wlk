import wollok.game.*
import movimientos.*
import menus.*
import config.*

class Visual {
    var property image
    var property position
}

class Personaje inherits Visual {
    var property vidas = 3
    var property direccion = abajo
    var property proyectil
    method puedeMoverseA(pos) = 
        pos.x() >= 0 &&
        pos.y() >= 0 &&
        pos.x() < game.width() &&
        pos.y() < game.height()
    method atacarA(personaje) {
        personaje.perderVida(self)
        game.sound("punch.wav").play() // cambiar
    }
    method perderVida(personaje) { vidas = (vidas - 1).max(0) }
    method mirarA(unaDireccion) {
        if(self.puedeMoverseA(unaDireccion)) { 
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
}

class Proyectil inherits Visual (position = personaje.direccion().siguiente(personaje.position())) {
    var property personaje
    method serLanzado(haciaPersonaje) {
        game.addVisual(self)
        self.moverseRecto()
        self.colisionar(haciaPersonaje)
    }
    method moverseRecto() {
        self.position(personaje.direccion().siguiente(self.position()))
        if (position.x() > game.width() or position.y() > game.height()) {
            game.removeVisual(self)
        }
    }
    method colisionar(unPersonaje) {
        game.whenCollideDo(self, {
            unPersonaje.perderVida()
            unPersonaje.resetearPosicion()
        })
    }
}

object mago inherits Personaje (proyectil = proyectilMago) {
    var property enemigo = juegoPorNiveles.nivelActual().enemigo()
    method posicionDeAtaque() = direccion.siguiente(self.position())
    override method mirarA(unaDireccion) {
        if(self.puedeMoverseA(unaDireccion)) { 
            super(unaDireccion)
            image = unaDireccion.imageMago()
        }
    }
    method configuracionTeclado() {
        if (!menuPausa.menuPausaAbierto()) {
            keyboard.w().onPressDo({self.moverA(arriba)})
            keyboard.s().onPressDo({self.moverA(abajo)})
            keyboard.d().onPressDo({self.moverA(derecha)})
            keyboard.a().onPressDo({self.moverA(izquierda)})
            keyboard.f().onPressDo({self.atacarA(enemigo)})
        }
    }
    override method resetearPosicion() {
        position = game.at(3,2) // IR VIENDO DE AJUSTAR ESTO SEGUN ESCENARIO, lo ideal sería q aparezca en el medio, o en el medio arriba
    }
    method initialize() {
        image = direccion.imageMago()
        position = game.at(3, 2) 
        vidas = 3
    }
}

object proyectilMago inherits Proyectil (personaje = mago, image = "completar") {
    override method serLanzado(haciaPersonaje) {
        super(haciaPersonaje)
        game.onTick(1500, "proyectilMago", {self.moverseRecto()})
    }
}

class Enemigo inherits Personaje {
    method comboEnemigo(unaDireccion)
    method moverseEnemigo() { self.atacarA(mago) }
}

object avispa inherits Enemigo (proyectil = proyectilAvispa) {
    override method comboEnemigo(unaDireccion) { game.onTick(1500, "comboAvispa", {self.moverseEnemigo()}) }
    override method moverseEnemigo() {
        super()
        if (position.x() == 3) { self.moverA(derecha) } // este método puede mejorarse
        if (position.x() == 17) { self.moverA(izquierda) }
    }
    override method puedeMoverseA(pos) = 
        pos.x() >= 3 &&
        pos.y() >= 3 &&
        pos.x() <= 17 &&
        pos.y() <= 17
    override method atacarA(personaje) {
        proyectil.serLanzado()
        game.sound("punch.wav").play() // cambiar sonido 
    }
    override method resetearPosicion() {
        position = game.at(10, 17) // IR VIENDO DE AJUSTAR ESTO SEGUN ESCENARIO, lo ideal sería q aparezca en el medio, o en el medio arriba
        // puede tener la clase personaje una posicion inicial para ahorrarnos esto!
    }
    method initialize() {
        image = "avispaFrente.png" // nunca se le actualiza la imagen a otra que no sea su reves porque solo se mueve de forma horizontal
        position = game.at(10, 17)
    }
}

object proyectilAvispa inherits Proyectil (personaje = mago, image = "completar") {
    override method serLanzado(haciaPersonaje) {
        super(haciaPersonaje)
        game.onTick(1500, "proyectilAvispa", {self.moverseRecto()})
    }
}

object slime inherits Enemigo (proyectil = proyectilSlime) {
    override method comboEnemigo(unaDireccion) { game.onTick(1000, "comboSlime", {self.moverseEnemigo()})}
    override method moverseEnemigo() {
        super()
        // pensar en resolver este método. que se mueva por los bordes. (vertical y horizontalmente) EL SUPER YA HACE QUE ATAQUE
    }
    override method mirarA(unaDireccion) {
        if(self.puedeMoverseA(unaDireccion)) { 
            super(unaDireccion)
            image = unaDireccion.imageSlime()
        }
    }
    override method resetearPosicion() {
        position = game.at(10,17) // IR VIENDO DE AJUSTAR ESTO SEGUN ESCENARIO, lo ideal sería q aparezca en el medio, o en el medio arriba
    }
    method initialize() {
        image = "slimeIzquierdo.png"
        position = game.at(10, 17)
        vidas = 4
    }
}

object proyectilSlime inherits Proyectil (personaje = mago, image = "completar") {
    override method serLanzado(haciaPersonaje) {
        super(haciaPersonaje)
        game.onTick(1000, "proyectilSlime", {self.moverseRecto()}) // 
    }
}

object dragon inherits Enemigo (proyectil = proyectilDragon) {
    override method comboEnemigo(unaDireccion) { game.onTick(1000, "comboDragon", {self.moverseEnemigo()})}
    override method moverseEnemigo() {
        super()
        // pensar en resolver este método. que se mueva por los bordes. (vertical y horizontalmente O QUE SIGA AL MAGO) EL SUPER YA HACE QUE ATAQUE
    }
    override method mirarA(unaDireccion) {
        if(self.puedeMoverseA(unaDireccion)) { 
            super(unaDireccion)
            image = unaDireccion.imageDragon()
        }
    }
    override method resetearPosicion() {
        position = game.at(10, 17) // IR VIENDO DE AJUSTAR ESTO SEGUN ESCENARIO, lo ideal sería q aparezca en el medio, o en el medio arriba
    }
    method initialize() {
        image = "dragonIzquierdo.png"
        position = game.at(10, 17) 
        vidas = 5
    }
}

object proyectilDragon inherits Proyectil (personaje = mago, image = "completar") {
    override method serLanzado(haciaPersonaje) {
        super(haciaPersonaje)
        game.onTick(500, "proyectilDragon", {self.moverseRecto()})
    }
}