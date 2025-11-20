import wollok.game.*
import mago.*

class Movimiento {
    method siguiente(pos)
    method sprite()
    method image()
}

object arriba inherits Movimiento {
    override method siguiente(pos) = pos.up(1) 
    override method sprite() { mago.mirarA(self) } 
    override method image() = "magoReves.png"
}

object abajo inherits Movimiento {
    override method siguiente(pos) = pos.down(1) 
    override method sprite() { mago.mirarA(self) } 
    override method image() = "magoFrente.png"
}

object derecha inherits Movimiento {
    override method siguiente(pos) = pos.right(1)
    override method sprite() { mago.mirarA(self) } 
    override method image() = "magoDerecho.png"
}

object izquierda inherits Movimiento {
    override method siguiente(pos) = pos.left(1) 
    override method sprite() { mago.mirarA(self) } 
    override method image() = "magoIzquierdo.png"
}