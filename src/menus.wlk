import wollok.game.*
import visuales.*
import nivel.*

class Menu inherits Visual (position = game.origin()) {
    method abrir()
    method configuracionTeclado()
    method cerrar()
}
object menuInicio inherits Menu (image = "Menu.png") { //#F
    var property menuInicioAbierto = false //#F

    override method abrir() { //#F Cuando ejecutas el game, el juego se queda en este metodo, esperando la tecla J para iniciar (la tecla J llama a self.cerrar())
        menuInicioAbierto = true

        game.boardGround("Menu.png") //#F de boardGround utilizo la imagen del menu
        keyboard.j().onPressDo({ self.cerrar() })
    }
    override method configuracionTeclado() {}
    override method cerrar() { //#F
        menuInicioAbierto = false

        game.clear() //#F utiliza el game.clear() para intentar remover la imagen del menu pero no la elimina (revisar)
        nivel.iniciarJuego() //#F metodo iniciarJuego() en nivel.wlk
    }
}

object menuPausa inherits Menu (image = "pausa.jpeg") {
    var property menuPausaAbierto = false //#F
    override method abrir() { // #F falta agregar la imagen del menu de pausa y desactivar movimiento del mago
        if(!menuPausaAbierto) {
            menuPausaAbierto = true
            nivel.desactivarComportamientoDeEnemigos() // #F desactiva el movimiento de los enemigos
        }
        else{
            menuPausaAbierto = false
            nivel.activarComportamientoDeEnemigos() // #F activa el movimiento de los enemigos
        }
        
    }
    override method cerrar() {}
    override method configuracionTeclado() {}
}

object menuGanador inherits Menu (image = "ganaste.jpeg") {
    override method abrir() {
        game.clear()
        const gano = game.sound("06 - Victory!.wav")
        gano.volume(0.3)
        game.addVisual(image)
        gano.play()
        self.pararMusicaGanadora(gano)
    }
    override method configuracionTeclado() {}
    override method cerrar() {}
    method pararMusicaGanadora(musica) {game.schedule(5000, {musica.stop()})}
}

object menuPerdedor inherits Menu (image = "perdiste.jpeg") {
    override method abrir() {}
    override method cerrar() {}
    override method configuracionTeclado() {}
}