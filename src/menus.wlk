import src.musica.*
import wollok.game.*
import visuales.*
import config.*

class Menu inherits Visual {
    method abrir()
    method cerrar()
    method configuracionTeclado()
}

object menuInicio inherits Menu{
    const property musicaMenu = musicaDeFondo
    var property menuInicioAbierto = false 
    override method abrir() { 
        menuInicioAbierto = true
        game.addVisual(self)
        self.configuracionTeclado()
        menuPausa.initialize()
    }
    override method configuracionTeclado() { keyboard.space().onPressDo({self.cerrar()}) }
    override method cerrar() {
        menuInicioAbierto = false
        game.removeVisual(self)
        juegoPorNiveles.nivelActual().iniciarNivel()
    }
    method initialize() {
        image = "inicio.jpeg"
        position = game.at(0,0)
    }
}

object menuPausa inherits Menu {
    var property menuPausaAbierto = false 
    override method abrir() { 
        if(!menuPausaAbierto) {
            menuPausaAbierto = true
            game.addVisual(self)
            juegoPorNiveles.nivelActual().musica().pausar()
            self.configuracionTeclado()
        }
        else{
            menuPausaAbierto = false
            game.removeVisual(self)
            juegoPorNiveles.nivelActual().musica().reanudar()
        }
    }
    override method cerrar() {}
    override method configuracionTeclado() {
        keyboard.p().onPressDo({self.abrir()})
        if(menuPausaAbierto){keyboard.m().onPressDo({ juegoPorNiveles.nivelActual().volverAlMenu()})}
    }
    method initialize(){
        self.configuracionTeclado()
        image = "pausa.png"
        position = game.at(-1,0)
    }
}

object menuGanador inherits Menu (image = "menuWin.png", position = game.at(0,0)) {
    override method abrir() {
        game.clear()
        const gano = game.sound("06 - Victory!.wav")
        musicaDeFondo.stop()
        gano.volume(0.3)
        game.addVisual(image)
        gano.play()
        self.pararMusicaGanadora(gano)
    }
    override method cerrar() {}
    override method configuracionTeclado() {} // faltaria que vuelva al inicio, o los créditos :)
    method pararMusicaGanadora(musica) {game.schedule(5000, {musica.stop()})}
}

object menuPerdedor inherits Menu (image = "menuReiniciar.png", position = game.at(0,0)) {
    override method abrir() {
        musicaDeFondo.stop()
        game.addVisual(self)
        self.configuracionTeclado()
    }
    method reiniciarDesdeMenu() {
        // game.removeVisual(self)
        // nivel.volverAlMenu() 
    }
    override method cerrar() {} 
    override method configuracionTeclado() {
        keyboard.r().onPressDo({ self.reiniciarDesdeMenu() }) // chequear esto al perder
    }
}

object menuControles inherits Menu { 
    override method abrir() { 
        game.addVisual(self)
        self.configuracionTeclado()
    }
    override method configuracionTeclado() { keyboard.space().onPressDo({self.cerrar()}) }
    override method cerrar() {
        game.removeVisual(self)
        menuPausa.abrir() // chequear si los controles se ven al inicio en la pausa, o en las dos
    }
    method initialize() {
        image = "controles.png"
        position = game.at(0,0)
    }
}

object pantallaUno inherits Menu (position = game.origin(), image = "completar") {
    override method abrir() {
        game.addVisual(self)
        self.configuracionTeclado()
    }
    override method cerrar() {
        game.removeVisual(self)
        juegoPorNiveles.nivelActual().iniciarNivel()
    }
    override method configuracionTeclado() {keyboard.space().onPressDo({self.cerrar()})}
}

object pantallaDos inherits Menu (position = game.origin(), image = "completar") {
    override method abrir() {
        game.addVisual(self)
        game.removeVisual(juegoPorNiveles.nivelActual().image())
        self.configuracionTeclado()
    }
    override method cerrar() {
        game.removeVisual(self)
        juegoPorNiveles.nivelActual().iniciarNivel()
    }
    override method configuracionTeclado() { keyboard.space().onPressDo({self.cerrar()})}
}

object pantallaTres inherits Menu (position = game.origin(), image = "completar") {
    override method abrir() {
        game.addVisual(self)
        self.configuracionTeclado()
    }
    override method cerrar() {
        game.removeVisual(self)
        juegoPorNiveles.nivelActual().iniciarNivel()
    }
    override method configuracionTeclado() {keyboard.space().onPressDo({self.cerrar()})}
}