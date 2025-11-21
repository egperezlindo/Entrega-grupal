import wollok.game.*

class Movimiento {
    method siguiente(pos)
    method imageMago()
    method imageAtaque()
    method imageAvispa()
    method imageSlime()
    method imageDragon()
}
// COMPLETAR CON LAS IMAGENES
object arriba inherits Movimiento {
    override method siguiente(pos) = pos.up(1) 
    override method imageMago() = "magoReves.png"
    override method imageAtaque() = "magoAtaqueArriba.png"
    override method imageAvispa() = ""
    override method imageSlime() = ""
    override method imageDragon() = ""

}

object abajo inherits Movimiento {
    override method siguiente(pos) = pos.down(1) 
    override method imageMago() = "magoFrente.png"
    override method imageAtaque() = "magoAtaqueAbajo.png"
    override method imageAvispa() = ""
    override method imageSlime() = ""
    override method imageDragon() = ""

}

object derecha inherits Movimiento {
    override method siguiente(pos) = pos.right(1)
    override method imageMago() = "magoDerecho.png"
    override method imageAtaque() = "magoAtaqueDer.png"
    override method imageAvispa() = ""
    override method imageSlime() = ""
    override method imageDragon() = ""

}

object izquierda inherits Movimiento {
    override method siguiente(pos) = pos.left(1) 
    override method imageMago() = "magoIzquierdo.png"
    override method imageAtaque() = "magoAtaqueIzq.png"
    override method imageAvispa() = ""
    override method imageSlime() = ""
    override method imageDragon() = ""

}