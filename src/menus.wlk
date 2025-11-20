import src.musica.*
import wollok.game.*
import visuales.*
import nivel.*
import mago.*

class Menu inherits Visual (position = game.origin()) {
    method abrir()
    method cerrar()
    method configuracionTeclado()
}
object menuInicio inherits Menu (image = "Menu_resized.png") { 
    var property menuInicioAbierto = false 

    override method abrir() { 
        game.addVisual(fondoIni)
        keyboard.j().onPressDo({ self.cerrar() })
    }
    override method configuracionTeclado() {}
    override method cerrar() {
        menuInicioAbierto = false

        game.removeVisual(fondoIni)
        nivel.iniciarJuego() 
    }
}

object menuPausa inherits Menu (image = "pausa.jpeg") {
    var property menuPausaAbierto = false 
    override method abrir() { 
        if(!menuPausaAbierto) {
            menuPausaAbierto = true
            mago.desactivarMovimiento()
            nivel.desactivarComportamientoDeEnemigos()
            game.addVisual(fondoPausa)
            keyboard.p().onPressDo({self.abrir()})
        }
        else{
            menuPausaAbierto = false
            mago.activarMovimiento()
            nivel.activarComportamientoDeEnemigos()
            game.removeVisual(fondoPausa)
            musicaDeFondo.reanudar()
            keyboard.p().onPressDo({self.cerrar()})
            keyboard.r().onPressDo({nivel.reiniciar()})
        }  
        
    }
    override method cerrar() {}
    override method configuracionTeclado() {}
}

object menuGanador inherits Menu (image = "menuWin.png") {
    override method abrir() {
        game.clear()
        const gano = game.sound("06 - Victory!.wav")
        musicaDeFondo.stop()
        gano.volume(0.3)
        game.addVisual(fondoGano)
        gano.play()
        self.pararMusicaGanadora(gano)
    }
    override method cerrar() {}
    override method configuracionTeclado() {}
    method pararMusicaGanadora(musica) {game.schedule(5000, {musica.stop()})}
}

object menuPerdedor inherits Menu (image = "menuReiniciar.png") {
    
    method initialize() {
        position = game.at(6, 4) 
    }

    override method abrir() {
        musicaDeFondo.stop()
        game.addVisual(self)
        keyboard.r().onPressDo({ self.reiniciarDesdeMenu() })
    }

    method reiniciarDesdeMenu() {
        game.removeVisual(self)
        nivel.volverAlMenu() 
    }
    
    override method cerrar() {} 
    override method configuracionTeclado() {}
}

object fondoIni {
    method image() = "Menu_resized.png"
    const property position = game.at(1,0)
}
object fondoGano {
    method image() = "menuWin.png"
    const property position = game.at(5,3)
}
object fondoPausa {
    method image() = "menuPausaTrans.png"
    const property position = game.at(3,2)
}

object fondoPerdio {
    method image() = "perdiste.jpeg"
    const property position = game.at(0,0)
}