/*
ARREGLAR:
- proyectiles del caracol y demonio deben cambiar de posición antes que él
- arreglar posiciones de los pinchos y columnas
- completar el archivo con testeos válidos
- arreglar error de los pinchos:
    wollok.lang.EvaluationError
        at src.visuales.Pincho.ponerPincho() [src/visuales.wlk:297]
        at If [src/visuales.wlk:304]
        at src.visuales.Pincho.pinchoAparece() [src/visuales.wlk:302]
        at src.niveles.nivelUno.agregarPinchos() [src/niveles.wlk:61]
        at src.niveles.Nivel.iniciarNivel() [src/niveles.wlk:31]
        at src.menus.menuInicio.cerrar() [src/menus.wlk:30]

falta mejorar estética de:
- pantallas de carga, menu perdedor y ganador
- sonidos al atacar, recibir daño, pisar, etc.
- obstaculos

se le puede añadir un nivel hard, donde el enemigo directamente persiga para al mago
*/