/*
falta preparar movimientos de enemigos:
- avispa: movimientos horizontales entre las posiciones x (3, 17) - posiciones y (17) dispara aguijones o bolitas amarillas cada 1 segundo y medio
- slime: movimientos horizontales y verticales entre las piosiciones x (3, 17) - posiciones y (3, 17) dispara bolitas verdes cada 1 segundo
- dragon: movimientos (puede ser persiguiendote, o puede ser en diagonales)  dispara bolas de fuego cada 0,5 segundos

falta recibir daño al ser impactado por disparo:
- el mago debe perder una vida (tiene 3)
- el enemigo debe perder una vida (tiene 3 la avispa, 4 el slime, 5 el dragón)
- efecto de perder vida al colisionar (tmb si colisiona la bola con el personaje, tiene que removerse)

falta mejorar estética de:
- escenarios (pueden ser todos iguales pero diferentes colores, o pueden ser todos diferentes acorde al enemigo)
- personajes sprites (mas estilo pixelart para que sea facil pedirle a la ia)
- pantallas de carga entre niveles respetando los personajes (puede estar el mago en todas las imagenes con el enemigo en cuestion TIENE QUE DECIR NIVEL (NUM) Y ABAJO LA IMAGEN!)
- menus de inicio, pausa, controles, créditos, perdedor y ganador esteticos respetando el estilo mas pixel art
ELEGIMOS PIXEL ART PORQUE ES MAS ESTETICO, MAS POSIBILIDAD DE ENCONTRAR PNGS, FONDOS, ETC.
usen itchio.com
PUEDEN ser otros personajes pero avisen con tiempo (o sea, que no sea avispa slime dragon o mago)

se le puede añadir un nivel hard, donde el enemigo directamente te persiga para atacarte, y que se mueva/ataque cada 0.5 segundos

arreglar:
colisiona mago con enemigo
a veces no funciona el método iniciarNivel() en cerrar() de menuInicio:
wollok.lang.EvaluationError
        at src.niveles.Nivel.iniciarNivel() [src/niveles.wlk:12]
        at src.menus.menuInicio.cerrar() [src/menus.wlk:23]

wollok.lang.EvaluationError
        at src.visuales.gusano.atacarA(mago) [src/visuales.wlk:125]
*/

/* TODO ES CHATGPT IGNORAR pero no borrar :)
object nivelExtra inherits Nivel {
  initialize() {
    enemigo = dragonAnciano
    dificultad = 6
    nombre = "Nivel Final"
  }
}


# --- NIVEL UNO: SPAWN, LOGICA, HUD, TECLAS ---
object nivelUno {
  property iniciado = false

  method iniciar() {
    # ajustar tablero
    game.width(BOARD_WIDTH)
    game.height(BOARD_HEIGHT)
    game.title("Nivel 1 - Mago vs Avispa")
    game.start()

    # posiciones iniciales
    mago.posicion = game.at(7,7)
    mago.vida.reset()

    avispa.posicion = game.at(12,7)
    avispa.vida.reset()

    # pinchos: definí las celdas donde quieres pinchos
    Pinchos.colocarVarias([game.at(5,5), game.at(6,5), game.at(8,9), game.at(10,10)])

    iniciado = true

    # dibujado personalizado por tick
    game.onTick { self.tick() }   # si tu Wollok Game usa Scheduler.every en vez de onTick, adaptá
    # manejo de teclas
    game.whenKeyPressed("w") { if (iniciado) { mago.moverA(north); self.afterMove() } }
    game.whenKeyPressed("s") { if (iniciado) { mago.moverA(south); self.afterMove() } }
    game.whenKeyPressed("a") { if (iniciado) { mago.moverA(west); self.afterMove() } }
    game.whenKeyPressed("d") { if (iniciado) { mago.moverA(east); self.afterMove() } }

    # lanzar bola con F
    game.whenKeyPressed("f") { if (iniciado) { 
        # lanzamos en la dirección en la que mira el mago; por ahora asumimos east por defecto
        # Podés mejorar guardando 'direccionActual' cuando movés
        var dir = east
        mago.lanzarBola(dir)
    } }

    # tecla para forzar turno/comprobación (útil para debug)
    game.whenKeyPressed("t") { if (iniciado) self.tick() }
  }

  method afterMove() {
    # aplicar daños por pinchos
    Pinchos.aplicarSiColisiona(mago)
    # chequeos rápidos
    if (!mago.vida.estaVivo()) {
      console.log("El mago murió. Reinicia el nivel.")
      iniciado = false
      # mostrar mensaje o volver al menu
    }
  }

  method tick() {
    # actualizaciones por tick
    mago.updateTick()
    avispa.updateTick()

    # mover proyectiles (bola de fuego)
    Fireball.moverProyectiles()

    # pintar todo
    self.dibujarEscena()

    # Si la avispa murió, hecho del nivel: pasar a siguiente nivel
    if (avispa.posicion == null) {
      console.log("Avispa derrotada! Nivel completado.")
      # aquí llamar al manejador de niveles para avanzar
      iniciado = false
    }
  }

  method dibujarEscena() {
    game.clear()

    # suelo / grid opcional
    # game.drawGrid()  # si tu API lo tiene

    # dibujar pinchos
    Pinchos.dibujar()

    # dibujar personaje y corazones encima (corazones ocupan celdas justo arriba)
    if (mago.posicion != null) {
      game.drawImage(mago.imagen, mago.posicion)
      # corazones sobre mago
      var offsetX = mago.posicion.x()
      var y = mago.posicion.y() - 1
      for (c in mago.corazones()) {
        # protegemos que y >= 1
        if (y >= 1) {
          game.drawImage(c, game.at(offsetX, y))
          offsetX = offsetX + 1
        }
      }
    }

    # dibujar enemigo y sus corazones
    if (avispa.posicion != null) {
      game.drawImage(avispa.imagen, avispa.posicion)
      var ox = avispa.posicion.x()
      var cy = avispa.posicion.y() - 1
      for (hc in avispa.corazones()) {
        if (cy >= 1) {
          game.drawImage(hc, game.at(ox, cy))
          ox = ox + 1
        }
      }
    }

    # dibujar proyectiles
    Fireball.dibujar()

    # (Opcional) texto de vidas numéricas para debug
    game.drawText("Vidas Mago: " + mago.vida.actuales, 10, 10)
    game.drawText("Vidas Avispa: " + (if (avispa.posicion != null) avispa.vida.actuales else 0), 300, 10)
  }
}
program iniciarNivelUno {
  nivelUno.iniciar()
}

//Extras (mago, vida, hud, etc...)
class Vida {
  property maxVidas = 3
  property actuales = 3

  method perder() {
    if (actuales > 0) actuales = actuales - 1
  }

  method estaVivo() = actuales > 0
  method resetear() { actuales = maxVidas }
}

class Personaje {
  property nombre = "Personaje"
  property posicion = game.at(1,1)
  property imagen = "mago.png"
  property vida = new Vida()
  property invulnerableTicks = 0   //ticks de invulnerabilidad para pinchos
  property invulnerableDuration = 6 // cuantos ticks dura

  method position() = posicion
  method image() = imagen

  // moverA con chequeo de borde (no pasa por el borde)
  method moverA(direccion) {
    var nueva = direccion.siguiente(posicion)
    if (puedeMoverA(nueva)) {
      posicion = nueva
    }
  }

  method puedeMoverA(pos) {
    // no puede moverse en el borde (x e y entre 1 y BOARD_WIDTH-1? 
    //en el pedido dijiste "no podría moverse en el borde del tablero" 
    // entendemos que celdas 1..15 y borde = 1 ó 15 no transitable
    pos.x() > 1 && pos.x() < BOARD_WIDTH && pos.y() > 1 && pos.y() < BOARD_HEIGHT
  }

  method perderVida() {
    if (invulnerableTicks > 0) return
    vida.perder()
    invulnerableTicks = invulnerableDuration
    self.animRecibirGolpe()
    if (!vida.estaVivo()) morir()
  }

  method updateTick() {
    if (invulnerableTicks > 0) invulnerableTicks = invulnerableTicks - 1
  }

  method animRecibirGolpe() {
    //parpadeo simple: cambiamos la imagen temporalmente (reemplazala si querés)
    var original = imagen
    imagen = "magoAttack.png" // si no tenés, dejalo igual o pon "hit.png"
    Scheduler.after(150) { imagen = original }
  }

  method morir() {
    //animación o cambio de imagen
    imagen = "rip.png"
  }

  // devuelve lista de imágenes de corazones a dibujar
  method corazones() {
    var lista = []
    for (i in 1..vida.actuales) {
      lista.add("heart.png")
    }
    return lista
  }
}

object mago inherits Personaje {
  initialize() {
    nombre = "Mago"
    posicion = game.at(7,7)
    imagen = "mago.png"
    vida = new Vida()
    vida.maxVidas = 3
    vida.actuales = 3
  }

  method lanzarBola(direccion) {
    Fireball.lanzarDesde(self, direccion)
  }
}

object avispa inherits Personaje {
  initialize() {
    nombre = "Avispa"
    posicion = game.at(12,7)
    imagen = "avispa.png"
    vida = new Vida()
    vida.maxVidas = 2
    vida.actuales = 2
  }

  method morir() {
    //animación de muerte: explosion y luego desaparecer
    imagen = "explosion.png"
    Scheduler.after(400) {
      # la "muerte real" la manejamos con la propiedad posicion = null (no dibujar)
      posicion = null
    }
  }
}

//pinchos
object pincho {
    var position = game.at(5,5)
    var image = "pincho.png"

    method colisionaCon(personaje) = personaje.position == position

    method aplicarDanoSiColisiona(pj) {
        if(colisionaCon(pj)) pj.perderVida()
    }
}

object Pinchos {
  property lista = []  //lista de posiciones con pinchos

  method colocarVarias(posiciones) {
    lista = posiciones
  }

  method dibujar() {
    for (p in lista) {
      if (p != null) game.drawImage("pincho.png", p)
    }
  }

  method aplicarSiColisiona(personaje) {
    if (personaje.posicion == null) return
    for (p in lista) {
      if (p.equals(personaje.posicion)) {
        personaje.perderVida()
        //romper aquí si querés que el pincho solo haga daño una vez:
        //lista.remove(p) 
      }
    }
  }
}

method realizarTurno() {
        if (self.estaCercaDelMago()) { self.atacarA(mago) }
        else { self.moverseEnDireccionAlMago() }
    }
method moverseEnDireccionAlMago() {
    const difX = mago.position().x() - position.x()
    const difY = mago.position().y() - position.y()
    if (difX.abs() > difY.abs()) {
        if (difX > 0) { self.moverseALaDerecha() } 
        else { self.moverseALaIzquierda() }
    } 
    else {
        if (difY > 0) { self.moverseAlNorte() } 
        else {self.moverseAlSur() }
        }
    }
method estaCercaDelMago() = self.position().distance(mago.position()) <= 1
method activarComportamientoDeEnemigos() { 
        game.onTick(500.randomUpTo(800), "movimientos", { self.movimientosAleatoriosEnemigos() })
    }

    method desactivarComportamientoDeEnemigos(){ 
        game.removeTickEvent("movimientos")
    }
    method enemigoEnFrente() {
        if (nivel.enemigosVivos().isEmpty()) // arreglar urg
            return null
            
        return nivel.enemigosVivos().findOrElse({ e => e.position() == self.posicionDeAtaque() }, { return null })
    }

//--- PROYECTILES (bola de fuego) ---
object Fireball {
  property proyectiles = []  # cada proyectil: {pos: Position, dir: Direction, owner: Personaje, damage: int}

  method lanzarDesde(owner, direccion) {
    var start = direccion.siguiente(owner.posicion)
    # si la celda inicial está fuera del tablero, no crear
    if (!estaDentro(start)) return
    proyectiles.add({pos: start, dir: direccion, owner: owner, damage: 1})
  }

  method estaDentro(pos) {
    pos != null && pos.x() >= 1 && pos.x() <= BOARD_WIDTH && pos.y() >= 1 && pos.y() <= BOARD_HEIGHT
  }

  method moverProyectiles() {
    var nuevos = []
    for (proj in proyectiles) {
      //colisión contra enemigo (solo chequeo con avispa en este nivel; podés ampliar)
      if (avispa.posicion != null && proj.pos.equals(avispa.posicion) && proj.owner != avispa) {
        // daño
        avispa.perderVida() # resta una vida visual del enemigo
        // podés convertir daño en afectar vida.actuales directamente:
        avispa.vida.perder()
        avispa.animRecibirGolpe()
        //No añadimos el proyectil (desaparece) y hacemos anim muerte si corresponde
        if (!avispa.vida.estaVivo()) {
          avispa.morir()
        }
      }

      //avanzar proyectil
      var siguiente = proj.dir.siguiente(proj.pos)
      if (estaDentro(siguiente)) {
        proj.pos = siguiente
        nuevos.add(proj)
      } else {
        # sale del tablero: desaparece
      }
    }
    proyectiles = nuevos
  }

  method dibujar() {
    for (p in proyectiles) {
      game.drawImage("fireball.png", p.pos)
    }
  }
}

//Clase vida
class Vida {
  property maxVidas = 3
  property actuales = 3

  method perder() {
    if (actuales > 0) actuales = actuales - 1
  }

  method estaVivo() = actuales > 0
  method reset() { actuales = maxVidas }
}

*/