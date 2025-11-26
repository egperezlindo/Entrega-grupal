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
    var property abierto = false 
    override method abrir() {
        musica.play()
        abierto = true
        game.addVisual(self)
        self.configuracionTeclado()
        menuPausa.initialize()
    }
    override method configuracionTeclado() {
        keyboard.space().onPressDo({self.cerrar()})
        if(abierto) {keyboard.c().onPressDo({ menuControles.abrir()})}
        }
    override method cerrar() {
        abierto = false
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
    var property abierto = false 
    override method abrir() { 
        if(!abierto) {
            abierto = true
            game.addVisual(self)
            juegoPorNiveles.nivelActual().musica().pausar()
            self.configuracionTeclado()
        }
        else{
            abierto = false
            game.removeVisual(self)
            juegoPorNiveles.nivelActual().musica().reanudar()
        }
    }
    override method cerrar() {}
    override method configuracionTeclado() {
        if(!menuInicio.abierto())keyboard.p().onPressDo({self.abrir()})
        if(abierto){keyboard.m().onPressDo({ juegoPorNiveles.nivelActual().volverAlMenu()})}
        if(abierto){keyboard.c().onPressDo({ menuControles.abrir()})}
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
        if(!menuControlesAbierto and menuPausa.abierto()){
            menuControlesAbierto = true
            game.addVisual(self)
            self.configuracionTeclado()
        }
        else if(!menuControlesAbierto and menuInicio.abierto()){
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