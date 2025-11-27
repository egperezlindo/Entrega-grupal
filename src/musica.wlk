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
    method pausar() { if(estado) {sonido.pause()}}
    method reanudar() {if(estado && sonido != null) {sonido.resume()}
}
    method stop() {
        if(estado) {
            estado = false
            sonido.stop()
        }
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
        sonido = game.sound("clintEastwood.mp3")
        archivo = "clintEastwood.mp3"
    }
}

object musicaNivel2 inherits Musica {
    method initialize() {
        estado = false
        sonido = game.sound("clintEastwood.mp3")
        archivo = "clintEastwood.mp3"
    }
}

object musicaNivel3 inherits Musica {
    method initialize() {
        estado = false
        sonido = game.sound("clintEastwood.mp3")
        archivo = "clintEastwood.mp3"
    }
}

object musicaGanadora inherits Musica {
    method initialize() {
        estado = false
        sonido = game.sound("memoryReboot.mp3")
        archivo = "memoryReboot.mp3"
    }
}

object musicaPerdedora inherits Musica {
    method initialize() {
        estado = false
        sonido = game.sound("afterDark.mp3")
        archivo = "afterDark.mp3"
    }
}