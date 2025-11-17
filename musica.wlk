import wollok.game.*

object musicaDeFondo {
    const sonido = game.sound("02 - Title Theme.wav")
    method play() {
    sonido.volume(0.2)
    sonido.play()
    }
    method stop() {
    sonido.stop()
    }
}
