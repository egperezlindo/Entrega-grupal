import wollok.game.*

class Movimiento {
    method siguiente(pos)
    method contrario()
    method imageMago()
    method imageAtaque()
    method imageGusano()
    method imageCaracol()
    method imageDemonio()
}
// COMPLETAR CON LAS IMAGENES
object arriba inherits Movimiento {
    override method siguiente(pos) = pos.up(1) 
    override method contrario() = abajo
    override method imageMago() = "magoReves.png"
    override method imageAtaque() = "magoRevesAtaque.png"
    override method imageGusano() = "enemigoUno.png"
    override method imageCaracol() = "enemigoDos.png"
    override method imageDemonio() = "enemigoTres.png"
}

object abajo inherits Movimiento {
    override method siguiente(pos) = pos.down(1) 
    override method contrario() = arriba
    override method imageMago() = "magoFrente.png"
    override method imageAtaque() = "magoFrenteAtaque.png"
    override method imageGusano() = "enemigoUno.png"
    override method imageCaracol() = "enemigoDos.png"
    override method imageDemonio() = "enemigoTres.png"
}

object derecha inherits Movimiento {
    override method siguiente(pos) = pos.right(1)
    override method contrario() = izquierda
    override method imageMago() = "magoDerecho.png"
    override method imageAtaque() = "magoDerAtaque.png"
    override method imageGusano() = "enemigoUno.png"
    override method imageCaracol() = "enemigoDos.png"
    override method imageDemonio() = "enemigoTres.png"
}

object izquierda inherits Movimiento {
    override method siguiente(pos) = pos.left(1) 
    override method contrario() = derecha
    override method imageMago() = "magoIzquierdo.png"
    override method imageAtaque() = "magoIzqAtaque.png"
    override method imageGusano() = "enemigoUno.png"
    override method imageCaracol() = "enemigoDos.png"
    override method imageDemonio() = "enemigoTres.png"
}