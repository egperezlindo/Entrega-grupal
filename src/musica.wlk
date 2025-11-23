import wollok.game.*

class Musica{
    var property sonido
    var property estado

    method play() {
           if(!estado){
            estado = true
            sonido.shouldLoop(true)
            sonido.volume(0.2)
            sonido.play()
           }
    }
    method pausar() {
        if(estado){sonido.pause()}
        
    }
    method reanudar(){
        if(estado){sonido.resume()}
        
        
    }
    method stop() {
        if(estado){
            estado = false
            sonido.stop()
        }
        
    }

    method reiniciar() {
        sonido.stop()
        sonido.shouldLoop(true)
        sonido.volume(0.2)
        sonido.play()
    }
}
object musicaDeFondo inherits Musica{
    method initialize() {
        estado = false
        sonido = game.sound("MenuMBM.MP3")
    }
}

object musicaNivel1 inherits Musica{
    method initialize() {
        estado = false
        sonido = game.sound("clintEastwood.mp3")
    }
}