import wollok.game.*
import visuales.* // Importa a los "actores"
import mago.*
import movimientos.* // son los movimientos para el mago :p
import musica.* // importa obj musicaDeFondo
import menus.* // importa menus (pausa, inicio, ganador, perdedor)

object nivel {
    var property enemigosVivos = [avispa, oso, slime, dragon]
    method inicio() {
        
    }
    method iniciarJuego() {
        musicaDeFondo.play() // por temas con la API de Chrome, la música no se activa hasta que el jugador haga algo
        game.boardGround("escenario.png")
        game.addVisual(mago)
        game.addVisual(avispa)
        game.addVisual(oso)
        game.addVisual(slime)
        game.addVisual(dragon)
        self.configuracionTeclado()
        
        // movimientos aleatorios de los enemigos
        game.onTick(500.randomUpTo(800), "movimientos", { self.movimientosEnemigos() })
    }
    method movimientosEnemigos() { enemigosVivos.forEach({ e => e.realizarTurno() }) }
    method activarComportamientoDeEnemigos() { //#F este metodo enciende el comportamiento de los enemigos
        // movimientos aleatorios de los enemigos
        game.onTick(500.randomUpTo(800), "movimientos", { self.movimientosEnemigos() })
    }

    method desactivarComportamientoDeEnemigos(){ //#F este metodo desactiva el comportamiento de los enemigos
        game.removeTickEvent("movimientos")
    }
    method configuracionTeclado() {
        keyboard.w().onPressDo({ mago.moverA(arriba) })
        keyboard.s().onPressDo({ mago.moverA(abajo) }) 
        keyboard.d().onPressDo({ mago.moverA(derecha) })
        keyboard.a().onPressDo({ mago.moverA(izquierda) })
        keyboard.f().onPressDo({ mago.atacar() })
        keyboard.p().onPressDo({ menuPausa.abrir()} )
    }
    method ganaste() {
        game.clear()
        menuGanador.abrir()
    }
    method perdiste() {
        if (mago.vida() == 0) {
            game.removeVisual(mago)
            game.clear()
            menuPerdedor.abrir()
        }
        
    }
     method enemigoDerrotado(enemigo) {
        game.say(self, "¡Lo mataste!")
        game.removeVisual(enemigo) // hay q ver lo de la animacion cuando mueren
        enemigosVivos.remove(enemigo)
        if (enemigosVivos.isEmpty()) {
            self.ganaste()
        }
    }
    method noHayEnemigoVivoAhi(posicion) = !(enemigosVivos.map({e => e.position()})).contains(posicion)
}