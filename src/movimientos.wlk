import wollok.game.*

class Movimiento {
    method siguiente(pos)
    method contrario()
    method siguienteCiclo()
    method imageMago()
    method imageAtaque()
    method imageGusano()
    method imageCaracol()
    method imageDemonio()
}

object arriba inherits Movimiento {
    override method siguiente(pos) = pos.up(1) 
    override method contrario() = abajo
    override method siguienteCiclo() = derecha
    override method imageMago() = "magoReves.png"
    override method imageAtaque() = "magoRevesAtaque.png"
    override method imageGusano() = "gusanoDer.png"
    override method imageCaracol() = "caracolDer.png"
    override method imageDemonio() = "demonioDer.png"
}

object abajo inherits Movimiento {
    override method siguiente(pos) = pos.down(1) 
    override method contrario() = arriba
    override method siguienteCiclo() = izquierda
    override method imageMago() = "magoFrente.png"
    override method imageAtaque() = "magoFrenteAtaque.png"
    override method imageGusano() = "gusanoIzq.png"
    override method imageCaracol() = "caracolIzq.png"
    override method imageDemonio() = "demonioIzq.png"
}

object derecha inherits Movimiento {
    override method siguiente(pos) = pos.right(1)
    override method contrario() = izquierda
    override method siguienteCiclo() = abajo
    override method imageMago() = "magoDerecho.png"
    override method imageAtaque() = "magoDerAtaque.png"
    override method imageGusano() = "gusanoDer.png"
    override method imageCaracol() = "caracolDer.png"
    override method imageDemonio() = "demonioDer.png"
}

object izquierda inherits Movimiento {
    override method siguiente(pos) = pos.left(1) 
    override method contrario() = derecha
    override method siguienteCiclo() = arriba
    override method imageMago() = "magoIzquierdo.png"
    override method imageAtaque() = "magoIzqAtaque.png"
    override method imageGusano() = "gusanoIzq.png"
    override method imageCaracol() = "caracolIzq.png"
    override method imageDemonio() = "demonioIzq.png"
}