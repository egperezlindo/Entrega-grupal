import src.musica.*
import wollok.game.*
import visuales.*
import nivel.*
import mago.*



class Menu inherits Visual (position = game.origin()) {
    method abrir()
    method abrirReiniciado() {}
    method cerrarReiniciado() {}
    method cerrar()
    method configuracionTeclado()
}
object menuInicio inherits Menu (image = "Menu_resized.png") { //#F
    var property menuInicioAbierto = false //#F
    var juegoReiniciado = false

    override method abrir() { //#F Cuando ejecutas el game, el juego se queda en este metodo, esperando la tecla J para iniciar (la tecla J llama a self.cerrar())
        if(!juegoReiniciado) {
            menuInicioAbierto = true

            game.addVisual(fondoIni)//game.boardGround("Menu_resized.png") //#F de boardGround utilizo la imagen del menu
            keyboard.j().onPressDo({ self.cerrar() })
        }
        else{
            menuInicioAbierto = true

            keyboard.j().onPressDo({ self.cerrarReiniciado()})
        }
        
    }
    override method cerrarReiniciado() {
        menuInicioAbierto = false

        game.removeVisual(fondoIni)
    }
    override method configuracionTeclado() {}
    method reinicio() {juegoReiniciado = true}
    override method cerrar() { //#F
        if(!juegoReiniciado){
            menuInicioAbierto = false

            game.removeVisual(fondoIni)//game.clear() //#F utiliza el game.clear() para intentar remover la imagen del menu pero no la elimina (revisar)
            nivel.iniciarJuego() //#F metodo iniciarJuego() en nivel.wlk
        }else{
            menuInicioAbierto = false
            juegoReiniciado = false

            game.removeVisual(fondoIni)
            nivel.iniciarJuegoReiniciado()
        }
        

        
    }
}

object menuPausa inherits Menu (image = "pausa.jpeg") {
    var property menuPausaAbierto = false //#F
    override method abrir() { // #F falta agregar la imagen del menu de pausa y desactivar movimiento del mago
        if(!menuPausaAbierto) {
            menuPausaAbierto = true
            mago.desactivarMovimiento()
            nivel.desactivarComportamientoDeEnemigos() // #F desactiva el movimiento de los enemigos
            musicaDeFondo.pausar()
            game.addVisual(fondoPausa)
            keyboard.p().onPressDo({self.abrir()})
            //keyboard.m().onPressDo({menuInicio.abrir()})
        }
        else{
            menuPausaAbierto = false
            mago.activarMovimiento()
            nivel.activarComportamientoDeEnemigos() // #F activa el movimiento de los enemigos
            game.removeVisual(fondoPausa)
            musicaDeFondo.reanudar()
            keyboard.p().onPressDo({self.cerrar()})
            keyboard.r().onPressDo({nivel.reinicio()})
        }  
        
    }
    override method cerrar() {}
    override method configuracionTeclado() {}
}

// resuelto el problema del menuGanador no displayeado; ver resolucion en archivo niveles => obj nivel => lista
object menuGanador inherits Menu (image = "ganaste.jpeg") {
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

object menuPerdedor inherits Menu (image = "perdiste.jpeg") {
    override method abrir() {}
    override method cerrar() {}
    override method configuracionTeclado() {}
}

object fondoIni { //objeto de fondo de inicio
    method image() = "Menu_resized.png"
    const property position = game.at(0,0)
}
object fondoGano { //objeto de fondo de gano
    method image() = "ganaste.jpeg"
    const property position = game.at(0,0)
}
object fondoPausa { //objeto de fondo de pausa
    method image() = "menuPausaTrans.png"
    const property position = game.at(0,0)
}