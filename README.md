# Wollok Game - 6bits

## Clases
- **Personaje**: Es la clase abstracta con los atributos position, vida, dmg (daño), defensa, y métodos en común entre el mago y los diferentes enemigos

- **Enemigo**: Hereda los atributos de la clase personaje, y hay tres tipos de enemigos (objetos) que heredan de esta clase enemigo. oso, avispa o slime (definir cantidad)

- **Pocion**: Tiene tres atributos, recuperaVida, recuperaMana, recuperaDefensa. Solo puede ser tomada por el mago

- **Armadura**: Defensa con sub clases pechera, casco, botas (si alcanza el tiempo)

## Objetos

- **Héroe (mago)**: Hereda los atributos de la clase personaje, y tiene mana (var), armaduras (clase), arma (única o lista de armas), poder de ataque (obtenes del arma en uso), tomar poción (son limitadas, cura vida)

- **Cofre**: otorga objetos al descubrirlo, brinda las tres armaduras

- **Jefe (dragón)**: Hereda todo de la clase personaje

- **Báculo**: Arma única del mago. (Habría que hacer armas para los enemigos si alcanza el tiempo)

## La batalla
Los enemigos tipo guardian de puerta. En un solo escenario. Dividido en cámaras. Se mata a uno y se avanza al siguiente (Avispa -> Oso -> Slime)

Después de matar los primeros tres enemigos, ingresa a la cámara del dragón, previo a la batalla del dragón se aparece un cofre con un casco, un par de botas, una pechera y un báculo mejorado (generando un upgrade en el mago). El mago se arma y pelea con el boss

Héroe se acerca al enemigo, al no poder pasar, apreta tecla que inicia batalla. Se genera la batalla (posiblemente los detalles de la batalla se visualicen en un hud, como el pegar,  defenderse, perdida de vida y gaste de mana).
La batalla es por turnos, iniciando la misma el jugador. Las unicas tres acciones posibles de todos los personajes, sean enemigos o el jugador son: pegar, defenderse, recuperar (vida o vida mas mana)

Las interacciones de la batalla, harán que el jugador se vea obligado a tener que elegir entres las diferentes acciones y no repetirlas indefinidamente

## Ataques 
- El mago cuenta con tres ataques posibles: pegar con báculo (quitas vida), bola de fuego (quita vida) o paralizar (próximo turno enemigo no se mueve)

- El enemigo solo las acciones dichas previamente, si nos da el tiempo se da mas profundidad en las especialidades de cada enemigo

- El jefe si tiene especialidad, puede hacer acciones dichas previamente, los ataques son: pegar con espada, golpe de lava, y asustar.

## HUD
El hud va a tener un cuadro que indica todas las acciones, como por ejemplo: no te podes mover, hay una pared de piedra, o hay un emigo tapando el camino

Lo mismo durante la batalla, nos informa de lo que sucede, ejemplo: "golpeaste a lobo por 15", "gastaste 2 de mana", "lobo te ataca por 20", "pasas a la cámara", "abriste un cofre", etc.

Va a ver una imagen del jugador donde se lo verá con o sin las armaduras. La barra de vida que contará de 4 instancias definidas por colores(verde, amarillo, naranja, rojo), y otra barra de mana tambien con 4 instancias, iguales a los colores. 

## Escenario
El escenario, será un png, para definir el límite posible de jugador en el escenario se restará casilleros de los límites propios de la ventana (si es un 10x10, el jugador se puede mover en un 9x9)

64 px x 80 px tamaño promedio de jugadores

# Extra
Queda por definir si además debajo de cada personaje, en el mapa se proyecta una barrita de vida (también con 4 estados tanto enemigos como jugador)