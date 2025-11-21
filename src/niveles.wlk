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
    }
    method estaGanado() = enemigo.estaMuerto()
}

object nivelUno inherits Nivel {
  method initialize() {
    enemigo = avispa 
    pantalla = pantallaUno
    image = "escenarioUno.jpg"
  }
}

object nivelDos inherits Nivel {
  method initialize() {
    enemigo = slime
    pantalla = pantallaDos
    image = ""
  }
}

object nivelTres inherits Nivel {
  method initialize() {
    enemigo = dragon
    pantalla = pantallaTres
    image = ""
  }
}
