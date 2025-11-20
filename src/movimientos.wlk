import wollok.game.*
import mago.*

class Movimiento {
    method siguiente(pos)
    method image()
    method imageAtaque()
}

object arriba inherits Movimiento {
    override method siguiente(pos) = pos.up(1) 
    override method image() = "magoReves.png"
    override method imageAtaque() = "magoAtaqueArriba.png"
}

object abajo inherits Movimiento {
    override method siguiente(pos) = pos.down(1) 
    override method image() = "magoFrente.png"
    override method imageAtaque() = "magoAtaqueAbajo.png"
}

object derecha inherits Movimiento {
    override method siguiente(pos) = pos.right(1)
    override method image() = "magoDerecho.png"
    override method imageAtaque() = "magoAtaqueDer.png"
}

object izquierda inherits Movimiento {
    override method siguiente(pos) = pos.left(1) 
    override method image() = "magoIzquierdo.png"
    override method imageAtaque() = "magoAtaqueIzq.png"
}