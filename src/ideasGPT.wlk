/*
falta preparar movimientos de enemigos:
- demonio: movimientos (puede ser persiguiendote, o puede ser en diagonales) dispara bolas de fuego cada 0,5 segundos

falta mejorar estética de:
- escenarios (pueden ser todos iguales pero diferentes colores, o pueden ser todos diferentes acorde al enemigo)
- personajes sprites (mas estilo pixelart para que sea facil pedirle a la ia)
- pantallas de carga entre niveles respetando los personajes (puede estar el mago en todas las imagenes con el enemigo en cuestion TIENE QUE DECIR NIVEL (NUM) Y ABAJO LA IMAGEN!)
- menus de inicio, créditos, perdedor y ganador esteticos respetando el estilo mas pixel art
- sonidos al atacar, recibir daño, pisar, etc.
PUEDEN ser otros personajes pero avisen con tiempo (o sea, que no sea avispa slime dragon o mago)
se le puede añadir un nivel hard, donde el enemigo directamente te persiga para atacarte, y que se mueva/ataque cada 0.5 segundos

Clase vida (hay que instanciar una para cada personaje)

class Vida inherits Visual {
  property maxVidas = 3
  property actuales = 3
  method perder() {
    if (actuales > 0) actuales = actuales - 1
  }
  method estaVivo() = actuales > 0
  method reset() { actuales = maxVidas }
}

*/