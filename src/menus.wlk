import wollok.game.*
import visuales.*

class Menu inherits Visual (position = game.origin()) {
    method abrir()
    method configuracionTeclado()
}
object menuInicio inherits Menu (image = "inicio.jpeg") {
    override method abrir() {}
    override method configuracionTeclado() {}
    
}

object menuPausa inherits Menu (image = "pausa.jpeg") {
    var property abierto = false
    override method abrir() {
        abierto = true // para que el mago no se siga moviendo cuando estas en pausa
    }
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
    method pararMusicaGanadora(musica) {game.schedule(5000, {musica.stop()})}
}

object menuPerdedor inherits Menu (image = "perdiste.jpeg") {
    override method abrir() {}
    override method configuracionTeclado() {}
}