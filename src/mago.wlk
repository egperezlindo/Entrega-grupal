import wollok.game.*
import visuales.*
import movimientos.*
import nivel.*

object mago inherits Personaje {
    var puedeMoverse = true //#F Validación para deshabilitar controles en la pausa

    method resetearPosicion() {self.position().at(3, 2)}
    method posicionDeAtaque() = direccion.siguiente(self.position())
    method enemigoEnFrente() = 
    if (!nivel.enemigosVivos().isEmpty()) 
        nivel.enemigosVivos().find({ e => e.position() == self.posicionDeAtaque()})
    method mirarA(unaDireccion) {
        if(puedeMoverse) { 
            direccion = unaDireccion
            image = unaDireccion.image()}
        
    }
    method activarMovimiento() {puedeMoverse = true} //#F
    method desactivarMovimiento() {puedeMoverse = false} //#F
    method moverA(unaDireccion) {
        self.mirarA(unaDireccion)
        if (self.puedeMoverseA(unaDireccion.siguiente(self.position())) and puedeMoverse) {
            self.position(unaDireccion.siguiente(self.position()))
        }
    }
    override method puedeMoverseA(pos) = self.esPosicionCaminable(pos) and nivel.noHayEnemigoVivoAhi(pos)
    method esPosicionCaminable(posicion) {
        const x = posicion.x()
        const y = posicion.y()

        const c1 = (x >= 2 and x <= 8 and y >= 1 and y <= 4)// resuelto el tema del mov. del Mago y de los Enemigos (en su archivo)
        const c2 = (x >= 2 and x <= 8 and y >= 6 and y <= 8)// resuelto el tema del mov. del Mago y de los Enemigos (en su archivo)
        const c3 = (x >= 11 and x <= 17 and y >= 6 and y <= 8)// resuelto el tema del mov. del Mago y de los Enemigos (en su archivo)
        const c4 = (x >= 11 and x <= 17 and y >= 1 and y <= 4)// resuelto el tema del mov. del Mago y de los Enemigos (en su archivo)
        
        // pasillos
        const pasillo1_2 = (x == 4 and y == 5) // conexión C1 a C2
        const pasillo2_3 = (x >= 9 and x <= 10 and y == 7) // conexión C2 a C3
        const pasillo3_4 = (x == 14 and y == 5) // conexión C3 a C4
        
        return c1 or c2 or c3 or c4 or pasillo1_2 or pasillo2_3 or pasillo3_4
    }
    method atacar() {
        if (self.enemigoEnFrente() != null) { // chequear porfa
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
    method vidaTotal() = 100
}