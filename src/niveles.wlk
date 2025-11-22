import wollok.game.*
import visuales.*
import menus.*
import movimientos.*

class Nivel inherits Visual (position = game.origin()) {
  var property enemigo
  var property pantalla
  var property iniciado = false
  method iniciarNivel() {
      iniciado = true
      game.addVisual(self)
      mago.resetear()
      enemigo.resetear()
      game.addVisual(mago)
      game.addVisual(enemigo)
      mago.configuracionTeclado()
      enemigo.comboEnemigo(arriba)
    }
    method estaGanado() = enemigo.estaMuerto()
    method enemigoVivoEn(unaPosicion) = enemigo.position() == unaPosicion
}

object nivelUno inherits Nivel {
  method initialize() {
    enemigo = gusano 
    pantalla = pantallaUno
    image = "escenarioUno.png"
  }
}

object nivelDos inherits Nivel {
  method initialize() {
    enemigo = caracol
    pantalla = pantallaDos
    image = "escenarioDos.png"
  }
}

object nivelTres inherits Nivel {
  method initialize() {
    enemigo = demonio
    pantalla = pantallaTres
    image = "escenarioTres.png"
  }
}
