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
    method puedeMoverseA(pos) =
        pos.x() >= 0 &&
        pos.y() >= 0 &&
        pos.x() < game.width() &&
        pos.y() < game.height() &&
        not juegoPorNiveles.nivelActual().enemigoVivoEn(self.position())
    
    method atacarA(personaje) {
        personaje.perderVida(self)
        game.sound("punch.wav").play() // cambiar
    }
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
}

class Proyectil inherits Visual (position = direccionDisparo.siguiente(personaje.position())) {
    var property personaje
    const property direccionDisparo = personaje.direccion()
    method serLanzado(haciaPersonaje) {
        game.addVisual(self)
        self.colisionar(haciaPersonaje)
    }
    method moverseRecto() {
        self.position(direccionDisparo.siguiente(self.position()))
        if ( position.y() > game.height()) { //position.x() > game.width() or
            game.removeVisual(self)
        }
    }
    method colisionar(unPersonaje) {
        game.onCollideDo(self, { unPersonaje => unPersonaje.perderVida() })
    }
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
            keyboard.f().onPressDo({self.atacarA(enemigo)})
        }
    }
    override method mirarA(unaDireccion) {
        super(unaDireccion)
        image = unaDireccion.imageMago()  
    }
    override method resetearPosicion() {
        position = game.at(8, 17) // IR VIENDO DE AJUSTAR ESTO SEGUN ESCENARIO, lo ideal sería q aparezca en el medio, o en el medio arriba
    }
    method initialize() {
        image = direccion.imageMago()
        position = game.at(8, 17) 
        vidas = 3
    }
    override method atacarA(unEnemigo) {
        const proyectil = new ProyectilMago()
        game.sound("punch.wav").play() //proyectilMago.serLanzado(personaje)
        proyectil.serLanzado(enemigo) //game.onCollideDo(proyectilMago, {proyectilMago.colisionar(personaje)})
    }
}

class ProyectilMago inherits Proyectil (personaje = mago, image = "proyectilMago.gif") {
    override method serLanzado(haciaPersonaje) {
        super(haciaPersonaje)
        game.onTick(500, "proyectilMago", {self.moverseRecto()})
    }
}

class Enemigo inherits Personaje {
    method comboEnemigo(unaDireccion)
    method moverseEnemigo()
}

object gusano inherits Enemigo { // ES DE PRUEBA LA ESTÉTICA DEL ENEMIGO
    override method comboEnemigo(unaDireccion) { 
        game.onTick(750, "comboGusano", {
            self.moverseEnemigo()
            self.atacarA(mago)
        }) 
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
    override method atacarA(mago) {
        const proyectil = new proyectilGusano()
        game.sound("punch.wav").play() // cambiar sonido 
        proyectil.serLanzado(mago)
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

object proyectilGusano inherits Proyectil (personaje = gusano, image = "proyectilGusano.gif") {
    override method serLanzado(mago) {
        super(mago)
        game.onTick(1500, "proyectilGusano", {self.moverseRecto()})
    }
    override method colisionar(mago) { game.onCollideDo(self, { mago.perderVida() })
    }
}

object caracol inherits Enemigo { // ES DE PRUEBA LA ESTÉTICA DEL ENEMIGO
    var property siguiente = direccion.siguiente(position) // este enemigo se mueve tanto como vertical como horizontal
    override method comboEnemigo(unaDireccion) { 
        game.onTick(1000, "comboCaracol", {
            self.moverseEnemigo()
            self.atacarA(mago)
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
    override method atacarA(mago) {
        const proyectil = new ProyectilCaracol()
        game.sound("punch.wav").play() // cambiar sonido 
        proyectil.serLanzado(mago)
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

class ProyectilCaracol inherits Proyectil (personaje = caracol, image = "proyectilCaracol.gif") {
    override method serLanzado(mago) {
        super(mago)
        game.onTick(1000, "proyectilCaracol", {self.moverseRecto()}) // 
    }
    override method colisionar(mago) { game.onCollideDo(self, { mago.perderVida() })}
}

object demonio inherits Enemigo { // ES DE PRUEBA LA ESTÉTICA DEL ENEMIGO
    var property siguiente = direccion.siguiente(position) // este enemigo se mueve tanto como vertical como horizontal, tmb podria perseguir al mago
    override method comboEnemigo(unaDireccion) { 
        game.onTick(500, "comboCaracol", {
            self.moverseEnemigo()
            self.atacarA(mago)
        })
    }
    override method moverseEnemigo() { // modificar este método segun enemigo
        if(self.puedeMoverseA(siguiente)) { self.position(siguiente) }
        else {
            // self.invertirDireccion()
            self.position(direccion.siguiente(position))
        }
    }
    override method atacarA(mago) {
        const proyectil = new ProyectilDemonio()
        game.sound("punch.wav").play() // cambiar sonido 
        proyectil.serLanzado(mago)
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

class ProyectilDemonio inherits Proyectil (personaje = demonio, image = "proyectilDemonio.gif") {
    override method serLanzado(mago) {
        super(mago)
        game.onTick(500, "proyectilDemonio", {self.moverseRecto()})
    }
    override method colisionar(mago) { game.onCollideDo(self, { mago.perderVida()}) }
}