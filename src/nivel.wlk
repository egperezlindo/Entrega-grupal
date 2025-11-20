import wollok.game.*
import visuales.*
import mago.*
import movimientos.*
import musica.* 
import menus.* 
import dificultades.*

object nivel {
    var property dificultad = normal
    var property enemigosVivos = [avispa, oso, slime, dragon] 
    var property juegoIniciado = false


    var teclasConfiguradas = false

    
 method iniciarJuego() { 
        if(!juegoIniciado) {
            juegoIniciado = true
            musicaDeFondo.play() 
            
            game.addVisual(mago)
            game.addVisual(avispa)
            game.addVisual(oso)
            game.addVisual(slime)
            game.addVisual(dragon)
            
            if (!teclasConfiguradas) {
                self.configuracionTeclado()
                teclasConfiguradas = true
            }
            // -----------------------

            self.activarComportamientoDeEnemigos() 
        } 
    }
    method movimientosAleatoriosEnemigos() { enemigosVivos.forEach({ e => e.realizarTurno() }) }
    method configuracionTeclado() {
        keyboard.w().onPressDo({ mago.moverA(arriba) })
        keyboard.s().onPressDo({ mago.moverA(abajo) }) 
        keyboard.d().onPressDo({ mago.moverA(derecha) })
        keyboard.a().onPressDo({ mago.moverA(izquierda) })
        keyboard.f().onPressDo({ mago.atacar() })
        keyboard.p().onPressDo({ menuPausa.abrir()} )
    }
    method activarComportamientoDeEnemigos() { 
        game.onTick(500.randomUpTo(800), "movimientos", { self.movimientosAleatoriosEnemigos() })
    }

    method desactivarComportamientoDeEnemigos(){ 
        game.removeTickEvent("movimientos")
    }

    method ganaste() {
        menuGanador.abrir()
    }
    method perdiste() {
        menuPerdedor.abrir()
    }
    method enemigoDerrotado(enemigo) {
        game.removeVisual(enemigo)
        enemigosVivos.remove(enemigo)
        if (enemigosVivos.isEmpty()) {
            self.ganaste()
        }
    }
    method magoDerrotado() {
        mago.desactivarMovimiento()
        self.desactivarComportamientoDeEnemigos()
        

        self.perdiste()
    }
    method noHayEnemigoVivoAhi(posicion) = !(enemigosVivos.map({e => e.position()})).contains(posicion)
    method reiniciar() {
        if(juegoIniciado) {
            game.removeVisual(fondoPausa)
            game.removeVisual(mago)
            game.removeVisual(avispa)
            game.removeVisual(oso)
            game.removeVisual(slime)
            game.removeVisual(dragon)

            juegoIniciado = false


            musicaDeFondo.stop()

            mago.curarse(mago.vidaTotal())
            avispa.curarse(avispa.vidaTotal())
            oso.curarse(oso.vidaTotal())
            slime.curarse(slime.vidaTotal())
            dragon.curarse(dragon.vidaTotal())

            self.iniciarJuego()
        }
    }

    method reiniciarDespuesDeMuerte() {
        juegoIniciado = false
        musicaDeFondo.stop()

        mago.curarse(mago.vidaTotal())
        avispa.curarse(avispa.vidaTotal())
        oso.curarse(oso.vidaTotal())
        slime.curarse(slime.vidaTotal())
        dragon.curarse(dragon.vidaTotal())
        
        self.iniciarJuego()
    }

    method volverAlMenu() {
        if (game.hasVisual(mago)) game.removeVisual(mago)
        if (game.hasVisual(avispa)) game.removeVisual(avispa)
        if (game.hasVisual(oso)) game.removeVisual(oso)
        if (game.hasVisual(slime)) game.removeVisual(slime)
        if (game.hasVisual(dragon)) game.removeVisual(dragon)

        juegoIniciado = false
        musicaDeFondo.stop()

        enemigosVivos = [avispa, oso, slime, dragon]

        mago.curarse(mago.vidaTotal())
        mago.resetearPosicion()
        mago.activarMovimiento()
        
        avispa.curarse(avispa.vidaTotal())
        oso.curarse(oso.vidaTotal())
        slime.curarse(slime.vidaTotal())
        dragon.curarse(dragon.vidaTotal())

        menuInicio.abrir()
    }
}