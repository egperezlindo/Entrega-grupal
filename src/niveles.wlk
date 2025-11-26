import menus.*
import config.*
import musica.*
import visuales.*
import corazones.*
import movimientos.*
import proyectiles.*
import wollok.game.*

class Nivel inherits Visual (position = game.origin()) {
  const enemigos = [gusano, caracol, demonio]
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
      self.agregarPincho()
    }
    method volverAlMenu() {
    iniciado = false
    musica.stop()
    game.clear()
    mago.resetearVidas()
    enemigos.forEach({e => e.resetearVidas()})
    juegoPorNiveles.indice(0)
    menuPausa.abierto(false)
    menuInicio.abrir()
    
  }
    method estaGanado() = enemigo.estaMuerto()
    method enemigoVivoEn(unaPosicion) = enemigo.position() == unaPosicion
    method agregarColumnas()
    method agregarPincho()
}

object nivelUno inherits Nivel {
  override method agregarPincho() {
    const pincho = new Pincho(segundos = 5000)
    idPincho.actualizarUltimoID()
    pincho.aparece()
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
  override method agregarPincho() {
    const pincho = new Pincho(segundos = 3000)
    idPincho.actualizarUltimoID()
    pincho.aparece()
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
  override method agregarPincho() {
    const pincho = new Pincho(segundos = 2000)
    idPincho.actualizarUltimoID()
    pincho.aparece()
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