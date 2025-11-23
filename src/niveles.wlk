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
      iniciado = true
      self.musica().play()
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
  
  method volverAlMenu() {
    iniciado = false
    self.musica().reanudar()
    self.musica().stop()
    game.clear()
    juegoPorNiveles.indice(0)
    menuPausa.menuPausaAbierto(false)
    menuInicio.abrir()
}
}

object nivelUno inherits Nivel {


  method initialize() {
    musica = musicaNivel1
    enemigo = gusano 
    pantalla = pantallaUno
    image = "escenarioUno.png"
  }
}

object nivelDos inherits Nivel {
  method initialize() {
    musica = "//llenar"
    enemigo = caracol
    pantalla = pantallaDos
    image = "escenarioDos.png"
  }
}

object nivelTres inherits Nivel {
  method initialize() {
    musica = "//llenar"
    enemigo = demonio
    pantalla = pantallaTres
    image = "escenarioTres.png"
  }
}
