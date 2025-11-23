import wollok.game.*
import visuales.*
import menus.*
import movimientos.*
import config.*
import musica.*

class Nivel inherits Visual (position = game.origin()) {
  var property enemigo
  var property pantalla
  var property musica 
  var property iniciado = false
  method iniciarNivel() {
      game.clear()
      iniciado = true
      game.addVisual(self)
      mago.resetear()
      enemigo.resetear()
      game.addVisual(mago)
      game.addVisual(enemigo)
      mago.configuracionTeclado()
      enemigo.comboEnemigo(arriba)
    }
    method volverAlMenu() {
    iniciado = false
    self.musica().reanudar()
    self.musica().stop()
    game.clear()
    juegoPorNiveles.indice(0)
    menuPausa.menuPausaAbierto(false)
    menuInicio.abrir()
  }
    method estaGanado() = enemigo.estaMuerto()
    method enemigoVivoEn(unaPosicion) = enemigo.position() == unaPosicion
    method posicionMago() = game.at(8,9)
}

object nivelUno inherits Nivel {
  override method posicionMago() = game.at(8,17)
  method initialize() {
    enemigo = gusano 
    pantalla = pantallaUno
    image = "escenarioUno.png"
    musica = musicaNivel1
  }
}

object nivelDos inherits Nivel {
  method initialize() {
    enemigo = caracol
    pantalla = pantallaDos
    image = "escenarioDos.png"
    musica = musicaNivel1 // cambiar
  }
}

object nivelTres inherits Nivel {
  method initialize() {
    enemigo = demonio
    pantalla = pantallaTres
    image = "escenarioTres.png"
    musica = musicaNivel1 // cambiar
  }
}
