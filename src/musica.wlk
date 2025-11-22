import wollok.game.*

object musicaDeFondo {
    const sonido = game.sound("clintEastwood.mp3")
    method play() {
        sonido.shouldLoop(true)
        sonido.volume(0.2)
        sonido.play()   
    }
    method pausar() {
        sonido.pause()
    }
    method reanudar(){
        sonido.resume()
    }
    method stop() {
        sonido.stop()
    }
}