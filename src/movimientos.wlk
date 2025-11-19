import wollok.game.*
import mago.*

class Movimiento {
    method siguiente(pos)
    method sprite()
}

object arriba inherits Movimiento {
    override method siguiente(pos) = pos.up(1) 
    override method sprite() { mago.image("magoReves.png") } 
}

object abajo inherits Movimiento {
    override method siguiente(pos) = pos.down(1) 
    override method sprite() { mago.image("magoFrente.png") } 
}

object derecha inherits Movimiento {
    override method siguiente(pos) = pos.right(1)
    override method sprite() { mago.image("magoDerecho.png") } 
}

object izquierda inherits Movimiento {
    override method siguiente(pos) = pos.left(1) 
    override method sprite() { mago.image("magoIzquierdo.png") } 
}