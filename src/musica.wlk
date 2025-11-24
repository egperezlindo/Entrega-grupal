import wollok.game.*

class Musica {
    var property sonido
    var property archivo
    var property estado = false
    method play() {
        if(!estado) {
            estado = true
            sonido = game.sound(archivo)
            sonido.shouldLoop(true)
            sonido.volume(0.2)
            sonido.play()
        }
    }
    method pausar() { if(estado) { sonido.pause() } }
    method reanudar() { if (estado) {sonido.resume() } }
    method stop() {
        if(estado) {
            estado = false
            sonido.stop()
        }
    }

    method reiniciar() {
        estado = true
        sonido = game.sound(archivo)
        sonido.stop()
        sonido.shouldLoop(true)
        sonido.volume(0.2)
        sonido.play()
    }
}

object musicaDeFondo inherits Musica {
    method initialize() {
        estado = false
        sonido = game.sound("MBMenu.mp3")
        archivo = "MBMenu.MP3"
    }
}

object musicaNivel1 inherits Musica {
    method initialize() {
        estado = false
        sonido = game.sound("MB1.mp3")
        archivo = "MB1.mp3"
    }
}

object musicaNivel2 inherits Musica {
    method initialize() {
        estado = false
        sonido = game.sound("MB2.mp3")
        archivo = "MB2.mp3"
    }
}

object musicaNivel3 inherits Musica {
    method initialize() {
        estado = false
        sonido = game.sound("MB3.mp3")
        archivo = "MB3.mp3"
    }
}