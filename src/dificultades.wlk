import nivel.*
import visuales.*

class Dificultad {
    method vidaEnemigo(base)
    method dañoEnemigo(base)
    method curacionEnemigo(base)
}

object facil inherits Dificultad {
    override method vidaEnemigo(base) = base - 20
    override method dañoEnemigo(base) = base - 3
    override method curacionEnemigo(base) = base + 10
}

object normal inherits Dificultad {
    override method vidaEnemigo(base) = base
    override method dañoEnemigo(base) = base
    override method curacionEnemigo(base) = base
}

object dificil inherits Dificultad {
    override method vidaEnemigo(base) = base + 20
    override method dañoEnemigo(base) = base + 5
    override method curacionEnemigo(base) = base - 10
}