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
    var property musica = musicaDeFondo
    var property menuInicioAbierto = false 
    override method abrir() {
        musica.play()
        menuInicioAbierto = true
        game.addVisual(self)
        self.configuracionTeclado()
        menuPausa.initialize()
    }
    override method configuracionTeclado() {
        keyboard.space().onPressDo({self.cerrar()})
        if(menuInicioAbierto) {keyboard.c().onPressDo({ menuControles.abrir()})}
        }
    override method cerrar() {
        menuInicioAbierto = false
        game.removeVisual(self)
        musica.stop()
        juegoPorNiveles.nivelActual().iniciarNivel()
    }
    method initialize() {
        musica = musicaDeFondo
        image = "inicio.jpg"
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
        if(!menuInicio.menuInicioAbierto())keyboard.p().onPressDo({self.abrir()})
        if(menuPausaAbierto){keyboard.m().onPressDo({ juegoPorNiveles.nivelActual().volverAlMenu()})}
        if(menuPausaAbierto){keyboard.c().onPressDo({ menuControles.abrir()})}
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
    var property menuControlesAbierto = false
    override method abrir() {
        if(!menuControlesAbierto and menuPausa.menuPausaAbierto()){
            menuControlesAbierto = true
            game.addVisual(self)
            self.configuracionTeclado()
        }
        else if(!menuControlesAbierto and menuInicio.menuInicioAbierto()){
            menuControlesAbierto = true
            game.addVisual(self)
            self.configuracionTeclado()
        }
        else{
            menuControlesAbierto = false
            game.removeVisual(self)
        }
    }
    override method configuracionTeclado() { keyboard.c().onPressDo({self.abrir()}) }
    override method cerrar() {}
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