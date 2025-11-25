import wollok.game.*
import visuales.*
import menus.*
import corazones.*
import movimientos.*
import config.*
import musica.*

class Nivel inherits Visual (position = game.origin()) {
  var property enemigo
  var property pantalla
  var property musica 
  var property columnas
  var property iniciado = false
  method iniciarNivel() {
      game.clear()
      iniciado = true
      menuPausa.configuracionTeclado()
      menuControles.configuracionTeclado()
      game.addVisual(self)
      self.musica().play()
      mago.resetear()
      game.addVisual(mago)
      mago.mostrarCorazones()
      mago.configuracionTeclado()
      enemigo.resetear()
      game.addVisual(enemigo)
      enemigo.mostrarCorazones()
      enemigo.comboEnemigo()
      self.agregarColumnas()
      self.agregarPinchos()
    }
    method volverAlMenu() {
    iniciado = false
    musica.reanudar()
    musica.stop()
    game.clear()
    juegoPorNiveles.indice(0)
    menuPausa.menuPausaAbierto(false)
    menuInicio.abrir()
    mago.resetearVidas()
    enemigo.resetearVidas()
    self.agregarPinchos()
  }
    method estaGanado() = enemigo.estaMuerto()
    method enemigoVivoEn(unaPosicion) = enemigo.position() == unaPosicion
    method puedeMoverseA(pos) = 
      pos.x() > 3 &&
      pos.y() > 4 &&
      pos.x() < 15 &&
      pos.y() < 16
    method agregarColumnas()
    method agregarPinchos()
}

object nivelUno inherits Nivel {
  override method agregarPinchos() { 
    // hay que hacer que este pincho salga cada x cantidad de segundos dif a los otros niveles
    const pincho = new Pincho()
    game.addVisual(pincho)
    pincho.pinchoAparece()
  }
  override method agregarColumnas() { columnas.forEach({c => game.addVisual(c)}) }
  method initialize() {
    enemigo = gusano 
    pantalla = pantallaUno
    image = "escenarioUno.png"
    musica = musicaNivel1
    columnas = [columna1, columna2, columna3]
  }
}

object nivelDos inherits Nivel {
  override method agregarPinchos() {
    const pincho = new Pincho()
    game.addVisual(pincho)
    pincho.pinchoAparece()
  }
  override method agregarColumnas() { columnas.forEach({c => game.addVisual(c)}) }
  method initialize() {
    enemigo = caracol
    pantalla = pantallaDos
    image = "escenarioDos.png"
    musica = musicaNivel2
    columnas = [columna1, columna2]
  }
}

object nivelTres inherits Nivel {
  override method agregarPinchos() {
    const pincho = new Pincho()
    pincho.pinchoAparece()
  }
  override method agregarColumnas() { columnas.forEach({c => game.addVisual(c)}) }
  method initialize() {
    enemigo = demonio
    pantalla = pantallaTres
    image = "escenarioTres.png"
    musica = musicaNivel3
    columnas = [columna1]
  }
}