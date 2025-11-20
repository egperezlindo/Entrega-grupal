import wollok.game.*
import visuales.* // Importa a los "actores"
import mago.*
import movimientos.* // son los movimientos para el mago :p
import musica.* // importa obj musicaDeFondo
import menus.* // importa menus (pausa, inicio, ganador, perdedor)

object nivel {
    const property enemigosVivos = [avispa, oso, slime, dragon] // resuelto el problema del menuGanador (var => const)
    var property juegoIniciado = false

    method iniciarJuego() { 
        if(!juegoIniciado) {
        juegoIniciado = true
        musicaDeFondo.play()
        game.addVisual(mago)
        game.addVisual(avispa)
        game.addVisual(oso)
        game.addVisual(slime)
        game.addVisual(dragon)
        self.configuracionTeclado()
        self.activarComportamientoDeEnemigos() // #F nucleo el comportamiento de los enemigos en metodos, la idea es activar/desactivar en un futuro menú de pausa
        }
    }
    method iniciarJuegoReiniciado() { //#F
        if(!juegoIniciado) {
        juegoIniciado = true
        //musicaDeFondo.play()
        game.addVisual(mago)
        game.addVisual(avispa)
        game.addVisual(oso)
        game.addVisual(slime)
        game.addVisual(dragon)
        mago.resetearPosicion()
        avispa.estadoInicial()
        oso.estadoInicial()
        slime.estadoInicial()
        dragon.estadoInicial()
        self.configuracionTeclado()
        self.activarComportamientoDeEnemigos() // #F nucleo el comportamiento de los enemigos en metodos, la idea es activar/desactivar en un futuro menú de pausa
        }
    }
    
    method movimientosAleatoriosEnemigos() { enemigosVivos.forEach({ e => e.moverAleatorio() }) }
    method configuracionTeclado() {
        keyboard.w().onPressDo({ mago.moverA(arriba) })
        keyboard.s().onPressDo({ mago.moverA(abajo) }) 
        keyboard.d().onPressDo({ mago.moverA(derecha) })
        keyboard.a().onPressDo({ mago.moverA(izquierda) })
        keyboard.f().onPressDo({ mago.atacar() })
        
        keyboard.p().onPressDo({ menuPausa.abrir()} ) //#F revisar menus.wlk
    }
    method activarComportamientoDeEnemigos() { //#F este metodo enciende el comportamiento de los enemigos
        // movimientos aleatorios de los enemigos
        game.onTick(500.randomUpTo(800), "movimientos", { self.movimientosAleatoriosEnemigos() })
    }

    method desactivarComportamientoDeEnemigos(){ //#F este metodo desactiva el comportamiento de los enemigos
        game.removeTickEvent("movimientos")
    }

    method ganaste() {
        menuGanador.abrir()
    }
    method perdiste() {
        game.clear()
        menuPerdedor.abrir()
    }
    method reinicio(){ //#F
        if(juegoIniciado){
        juegoIniciado = false
        //musicaDeFondo.stop()
        menuInicio.reinicio()
        game.removeVisual(fondoPausa)
        game.removeVisual(mago)
        game.removeVisual(avispa)
        game.removeVisual(oso)
        game.removeVisual(slime)
        game.removeVisual(dragon)
        
        menuInicio.abrirReiniciado()
        }
    }

    method allelements(){
        
    }

    method enemigoDerrotado(enemigo) {
        game.removeVisual(enemigo) // hay q ver lo de la animacion cuando mueren
        enemigosVivos.remove(enemigo)
        if (enemigosVivos.isEmpty()) {
            self.ganaste()
        }
    }
    method noHayEnemigoVivoAhi(posicion) = !(enemigosVivos.map({e => e.position()})).contains(posicion)
    
}