import src.musica.*
import src.menus.*
import wollok.game.*
import niveles.*
import visuales.*

object juegoPorNiveles {
  var property nivelesDeJuego = [nivelUno, nivelDos, nivelTres]
  var property indice = 0
  method iniciarJuego() {
    game.width(20)
    game.height(20)
    game.title("Wollok Dungeons")
    game.start()
    menuInicio.abrir()
  }
  method nivelActual() = nivelesDeJuego.get(indice)
  method pasarASiguienteNivel() {
    if (self.nivelActual().estaGanado()) {
      self.nivelActual().musica().stop()
      indice = indice + 1
      if (indice < nivelesDeJuego.size()) {
        self.nivelActual().initialize()
        self.nivelActual().iniciarNivel()
        // self.nivelActual().pantalla.abrir()
      } // else { menuGanador.abrir() }
    }
  }
}
/*
object juegoPorNiveles {
  property niveles = [nivelUno, nivelDos, nivelTres, nivelCuatro, nivelExtra]
  property indice = 0
  property nivelActivo = null

  method registrarNivelActivo(nivel) { nivelActivo = nivel }

  method nivelActual() = niveles.get(indice)

  method iniciarJuego() {
    game.width(15)
    game.height(15) 
    game.start()
    gameController.comenzarMenuNivel()
  }

  # cada tick global
  method onTickGlobal() {
    mago.updateTick()
    Fireball.moverProyectiles()
    FireBreath.mover()
    Pinchos.aplicarSiColisiona(mago)

    if (nivelActivo != null) {
      if (nivelActivo.respondsTo("updateAll")) nivelActivo.updateAll()
    }

    # dibujado
    if (nivelActivo != null && nivelActivo.respondsTo("dibujarExtras")) nivelActivo.dibujarExtras()
    HUD.actualizar()
  }
} */

/*
object gameController {
  var property estado = "inicio"
  var property nivelActualIndex = 0

  method iniciar() {
    game.width(20)
    game.height(10)
    game.title("RPG del Mago")
    game.start()

    pantallaInicio.mostrar()
  }

  method comenzarMenuNivel() {
    estado = "menuNivel"
    pantallasNiveles.mostrar(niveles.get(nivelActualIndex))
  }

  method comenzarNivel() {
    estado = "juego"
    var nivel = niveles.get(nivelActualIndex)
    nivel.iniciarNivel(mago)
    HUD.mostrar()
  }

  method terminarNivel() {
    nivelActualIndex = nivelActualIndex + 1

    if (nivelActualIndex >= niveles.size()) {
      estado = "victoria"
      pantallaVictoria.mostrar()
    } else {
      self.comenzarMenuNivel()
    }
  }

  method cuandoAprietaEspacio() {
    if (estado == "inicio") {
      self.comenzarMenuNivel()
    } else if (estado == "menuNivel") {
      self.comenzarNivel()
    } else if (estado == "victoria") {
      //console.log("Juego terminado")
    }
  }
} */