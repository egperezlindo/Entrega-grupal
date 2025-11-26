import config.*
import musica.*
import visuales.*
import wollok.game.*

class Menu inherits Visual {
    method abrir()
    method cerrar()
    method configuracionTeclado()
}

object menuInicio inherits Menu {
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
        image = "inicio.jpg"
        position = game.at(0,0)
    }
}

object menuPausa inherits Menu () {
    var property abierto = false 
    override method abrir() { 
        if(!abierto) {
            abierto = true
            game.addVisual(self)
            juegoPorNiveles.nivelActual().musica().pausar()
            self.configuracionTeclado()
        } else {
            abierto = false
            game.removeVisual(self)
            juegoPorNiveles.nivelActual().musica().reanudar()
        }
    }
    override method cerrar() {}
    override method configuracionTeclado() {
        if(!menuInicio.abierto())keyboard.p().onPressDo({self.abrir()})
        if(abierto) { keyboard.m().onPressDo({ juegoPorNiveles.nivelActual().volverAlMenu()}) }
        if(abierto) { keyboard.c().onPressDo({menuControles.abrir()}) }
    }
    method initialize() {
        self.configuracionTeclado()
        image = "pausa.png"
        position = game.at(-1,0)
    }
}

object menuGanador inherits Menu (image = "ganar.jpeg", position = game.at(0,0)) {
    var property abierto = false 
    var property musica = musicaGanadora
    override method abrir() {
        abierto = true
        game.clear()
        juegoPorNiveles.nivelActual().musica().stop()
        game.addVisual(self)
        musica.play()
        self.configuracionTeclado()
    }
    override method cerrar() {
        abierto = false
        game.removeVisual(self)
        musica.stop()
    }
    override method configuracionTeclado() {
       keyboard.space().onPressDo({ 
        self.cerrar()
        juegoPorNiveles.nivelActual().volverAlMenu() 
       })
    }
}

object menuPerdedor inherits Menu (image = "perder.png", position = game.at(0,0)) {
    var property abierto = false 
    var property musica = musicaPerdedora
    override method abrir() {
        abierto = true
        game.clear()
        musicaDeFondo.stop()
        musica.play()
        game.addVisual(self)
        self.configuracionTeclado()
    }
    override method cerrar() {
        abierto = false
        game.removeVisual(self)
        musica.stop()
    }
    override method configuracionTeclado() {
       keyboard.space().onPressDo({ 
        self.cerrar()
        juegoPorNiveles.nivelActual().volverAlMenu() 
       })
    }
}

object menuControles inherits Menu (image = "controles.png", position = game.at(0,0)){ 
    var property abierto = false
    override method abrir() {
        if(!abierto and menuPausa.abierto()){
            abierto = true
            game.addVisual(self)
            self.configuracionTeclado()
        }
        else if(!abierto and menuInicio.abierto()){
            abierto = true
            game.addVisual(self)
            self.configuracionTeclado()
        }
        else{
            abierto = false
            game.removeVisual(self)
        }
    }
    override method configuracionTeclado() { keyboard.c().onPressDo({self.abrir()}) }
    override method cerrar() {}
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