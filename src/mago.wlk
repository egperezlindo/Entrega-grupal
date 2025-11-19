import wollok.game.*
import visuales.*
import movimientos.*
import nivel.*

object mago inherits Personaje {
    method posicionDeAtaque() = direccion.siguiente(self.position())
    method enemigoEnFrente() = 
    if (!nivel.enemigosVivos().isEmpty()) 
        nivel.enemigosVivos().find({ e => e.position() == self.posicionDeAtaque()})
    method esPosicionCaminable(posicion) {
        const x = posicion.x()
        const y = posicion.y()

        const c1 = (x >= 2 and x <= 7 and y >= 2 and y <= 4)
        const c2 = (x >= 2 and x <= 7 and y >= 6 and y <= 9)
        const c3 = (x >= 11 and x <= 18 and y >= 6 and y <= 9)
        const c4 = (x >= 11 and x <= 18 and y >= 2 and y <= 4)
        
        // pasillos
        const pasillo1_2 = (x == 4 and y == 5) // conexión C1 a C2
        const pasillo2_3 = (x >= 9 and x <= 10 and y == 7) // conexión C2 a C3
        const pasillo3_4 = (x == 14 and y == 5) // conexión C3 a C4
        
        return c1 or c2 or c3 or c4 or pasillo1_2 or pasillo2_3 or pasillo3_4
    }
    override method puedeMoverseA(pos) = self.esPosicionCaminable(pos) and nivel.noHayEnemigoVivoAhi(pos)
    override method vidaMáxima() = 100
    override method atacar() {
        if (self.enemigoEnFrente() != null) { // chequear porfa
            self.enemigoEnFrente().recibirDaño(self)
            game.sound("punch.wav").play()
            if (self.enemigoEnFrente().vida() == 0) {
                game.sound("8_bit_chime_positive.wav").play()
                nivel.enemigoDerrotado(self.enemigoEnFrente())
            }
        }
    }
    override method mirarA(unaDireccion) {
        super(unaDireccion) 
        unaDireccion.sprite()
    }
    method initialize() {
        image = "magoFrente.png"
        position = game.at(3, 2) 
        vida = 100
        daño = 15
    }
}