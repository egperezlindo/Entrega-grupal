import wollok.game.*
import visuales.*
import movimientos.*
import nivel.*

object mago inherits Personaje {
    var puedeMoverse = true
    method resetearPosicion() {
        self.position(game.at(3, 2)) 
    }
    method posicionDeAtaque() = direccion.siguiente(self.position())

    method enemigoEnFrente() {
        if (nivel.enemigosVivos().isEmpty()) 
            return null
            
        return nivel.enemigosVivos().findOrElse({ e => e.position() == self.posicionDeAtaque() }, { return null })
    }
    method mirarA(unaDireccion) {
        if(puedeMoverse) { 
            direccion = unaDireccion
            image = unaDireccion.image()
        }
    }
    method activarMovimiento() {puedeMoverse = true}
    method desactivarMovimiento() {puedeMoverse = false} 
    method moverA(unaDireccion) {
        self.mirarA(unaDireccion)
        if (self.puedeMoverseA(unaDireccion.siguiente(self.position())) and puedeMoverse) {
            self.position(unaDireccion.siguiente(self.position()))
        }
    }
    method esPosicionCaminable(posicion) {
        const x = posicion.x()
        const y = posicion.y()

        const c1 = (x >= 2 and x <= 8 and y >= 1 and y <= 4)
        const c2 = (x >= 2 and x <= 8 and y >= 6 and y <= 8)
        const c3 = (x >= 11 and x <= 17 and y >= 6 and y <= 8)
        const c4 = (x >= 11 and x <= 17 and y >= 1 and y <= 4)
        
        const pasillo1_2 = (x == 4 and y == 5)
        const pasillo2_3 = (x >= 9 and x <= 10 and y == 7)
        const pasillo3_4 = (x == 14 and y == 5) 
        
        return c1 or c2 or c3 or c4 or pasillo1_2 or pasillo2_3 or pasillo3_4
    }
    override method recibirDaño(enemigo) { 
        super(enemigo) 
        if (vida == 0) {nivel.magoDerrotado()}
    }
    override method puedeMoverseA(pos) = self.esPosicionCaminable(pos) and nivel.noHayEnemigoVivoAhi(pos)
    override method vidaTotal() = 100
    override method atacar() {
        if (self.enemigoEnFrente() != null) {
            image = direccion.imageAtaque()
            self.enemigoEnFrente().recibirDaño(self)
            game.sound("punch.wav").play()
            if (self.enemigoEnFrente().vida() == 0) {
                game.say(self, "¡Lo mataste!")
                game.sound("8_bit_chime_positive.wav").play()
                nivel.enemigoDerrotado(self.enemigoEnFrente())
            }
        }
    }
    method initialize() {
        image = direccion.image()
        position = game.at(3, 2) 
        vida = 100
        daño = 15
    }
}