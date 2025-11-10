//import Prueba-Game.Personajes2.*
//este archivo es como el paso a "limpio" del archivo personajes2
object mago {
    var image = ""
    var property position = game.origin()
    //estadisticas
    var property vida = 100
    var property mana = 100
    var dmg = 1.randomUpTo(5)
    var def = 10
    //
    const property pociones = []
    //const property acciones = [atacar,defenderse,curarse,bajarDefensas]

    method def() = def
    method dmg() = dmg
    method iniciarCombateCon(enemigo) {
        game.say(self, "Veamos si te aguantas este FireBall")
        game.say(enemigo, "¡Ven aquí, Mago estúpido!")

    }
    //acciones
    method atacarA(enemigo) {
        enemigo.recibirAtaque(self.dmg())
    }
    method defenderse() {
        self.def()+5
    }
    method curarse() {
        if(self.vida() < 100 or self.mana() < 100) {
            pociones.first().recuperaVida().min(100)
            pociones.first().recuperaMana().min(100)
            pociones.remove(pociones.first())
        }
    }
    method bajarDefensasDe(enemigo) {
        enemigo.defensaReducida(self.dmg())
    }
    //
    method recibirAtaqueDe(enemigo) {
        vida = vida - enemigo.ataque().max(0)
    }
}

class Enemigo {
    var image
    var property position
    var property vida
    var property energia
    var dmg
    var def
    const property acciones = [atacar,defenderse,curarse,buffarse]
    
    method recibirAtaque(daño) {vida = vida - daño}
    method defensaReducida(daño) {def = def - daño}
    method ataque() = dmg
    method seDefiende() {def = def + 2}
    method seDejaDeDefender() {def = def - 2}
    method seCura() {
        dmg = dmg - 3
        vida = vida + 3
        return 
        self.ataque()
    }
    method recuperaSuDmg() {dmg = dmg + 3}
    method aumentarDmg() {dmg = dmg * 0.3}
    method hacerAlgo() {acciones.randomize().first()}
}

object atacar {
    method atacaA(enemigo,personaje) {
        personaje.recibirAtaqueDe(enemigo.ataque())
    }
}
object defenderse {
    method defenderse(enemigo) {
        enemigo.seDefiende()
    }
}
object curarse {
    method curarse(enemigo,objeto,personaje) {
        enemigo.seCura()
        objeto.atacaA(enemigo, personaje)
        enemigo.recuperaSuDmg()
    }
}
object buffarse {
    method buffarse(enemigo) {
        enemigo.aumentarDmg()
    }
}

class Pocion {
    var numeroDePocion

    method recuperaVida() = 6
    method recuperaMana() = 4
}