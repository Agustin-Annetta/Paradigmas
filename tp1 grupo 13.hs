
data Plantas = Plantas {
    nombre :: String,
    vida :: Int,
    solesGenerados :: Int,
    ataque :: Int
} 

--Tipos de plantas--

peaShooter= Plantas "peaShooter" 5 0 2
repeater= Plantas "repeater" 5 0 4
sunflower= Plantas "sunflower" 7 1 0
nut= Plantas "nut" 0 0 100
plantaNueva1= Plantas "planta1" 9 12 18
plantaNueva2=  Plantas "planta2" 6 6 6
cactus= Plantas "cactus" 9 0 0

data Zombies = Zombies {
    nombreZombie :: String,
    accesorios :: Int,
    danio :: Int
}

--Tipos de zombies--

zombieBase= Zombies "zombieBase" 0 1
balloonZombie= Zombies "balloonZombie" 1 1
newspaperZombie= Zombies "newspaper" 1 2
gargantuar= Zombies "gargantuar" 2 30

data LineaDeDefensa = LineaDeDefensa { plantas :: [Plantas], zombies :: [Zombies] }

--Ejemplos de lineas--
linea1 = LineaDeDefensa {
        plantas = [sunflower, sunflower, sunflower],
        zombies = []
        }

linea2 = LineaDeDefensa {
        plantas = [peaShooter, peaShooter, sunflower, nut],
        zombies = [zombieBase, newspaperZombie]
        }

linea3 = LineaDeDefensa {
        plantas = [sunflower, peaShooter],
        zombies = [gargantuar, zombieBase, zombieBase]
        }

--2A--
especialidad :: Plantas -> String
especialidad planta | solesGenerados planta > 0 = "Proveedora"
                    | ataque planta > vida planta= "Atacante"
                    | otherwise = "Defensiva"

--2B--
esPeligroso::Zombies->Bool
esPeligroso zombie = accesorios zombie >1 ||  length(nombreZombie zombie) > 10

--3A--

agregarPlanta :: Plantas -> LineaDeDefensa -> LineaDeDefensa
agregarPlanta planta linea = linea { plantas = plantas linea ++ [planta] }     

agregarZombie :: Zombies -> LineaDeDefensa -> LineaDeDefensa
agregarZombie zombie linea = linea { zombies = zombies linea ++ [zombie] }

--3B--

estaEnPeligro :: LineaDeDefensa -> Bool
estaEnPeligro linea = totalAtaquePlantas linea < totalMordiscosZombies linea || (todosPeligrosos (zombies linea) && hayZombies linea)
  where
    totalAtaquePlantas = sum . map ataque . plantas
    totalMordiscosZombies = sum . map danio . zombies
    todosPeligrosos = all esPeligroso
    hayZombies = not . null . zombies

--3C--

esProveedora:: Plantas -> Bool
esProveedora planta = especialidad planta == "Proveedora"
necesitaSerDefendida :: LineaDeDefensa -> Bool
necesitaSerDefendida linea = all esProveedora (plantas linea)

--4-- 
listaConMasDeDos:: [a]->Bool
listaConMasDeDos (primero:cola)
  |null cola = False
  |otherwise = True

lineaMixta :: LineaDeDefensa -> Bool
lineaMixta linea
  | not (listaConMasDeDos (plantas linea)) = error "Tiene menos de dos elementos"  
  | otherwise = not(any compararEspecialidad (zip (plantas linea) (tail (plantas linea))))
  where
    compararEspecialidad (planta1, planta2) = especialidad planta1 == especialidad planta2
     

atacarZombie :: Zombies -> Plantas -> Plantas
atacarZombie zombie planta = if vidaActual <= 0 then derrotada else planta { vida = vidaActual }
  where
    vidaActual = vida planta - danio zombie
    derrotada = planta { vida = 0 }
  

---------------PARTE 2---------------------------

--1--
--A) Si se consultara si una linea con infinita cantidad de zombies base el programa se ejecutaria infinitamente.
--Estaria sumando el daño o fijandose si los zombies son peligrosos hasta cancelar la ejecucion. Lo hemos probado
--con la siguiente lista:

-- listaBase = repeat zombieBase
{-
lineaInfinita = LineaDeDefensa {
        plantas = [sunflower, peaShooter],
        zombies = repeat zombieBase
        }
-}

--B) Si se consultara sobre si una linea con infinita cantidad de PeaShooters si necesita ser defendida
-- el programa estaria calculando infinitamente si cada planta de la lista es proveedora de soles ya que nunca
--encontraria un resultado negativo. En cambio si se hiciera lo mismo en una linea de infinitos sunflowers devolveria
--False luego de analizar la primer planta.

--2--

--Se agrego en la declaracion de las plantas

--3--
type Horda = [(Zombies, LineaDeDefensa)]

type Jardin = [LineaDeDefensa]

agregarHorda :: Jardin -> Horda -> Jardin
agregarHorda jardin horda = jardin ++ hordas
  where
    hordas = map snd horda

--4--
rondaDeAtaque :: Plantas -> Zombies -> Int -> (Plantas, Zombies)
rondaDeAtaque planta zombie numMordiscos = (plantaAtacada, zombieAtacante)
  where
    plantaAtacada = foldl atacarZombie planta (replicate numMordiscos zombie)
    zombieAtacante = foldl atacarPlanta zombie (replicate numMordiscos planta)    

--5A--
plantaMurio :: Plantas -> Bool
plantaMurio planta = vida planta <= 0

--5B--
zombieMurio :: Zombies -> Bool
zombieMurio zombie = vida zombie <= 0

--6--
ataqueSistematico :: [Plantas] -> Zombies -> [Plantas]
ataqueSistematico plantas zombie = foldl atacarZombie plantas (replicate numMordiscos zombie)
  where
    numMordiscos = length plantas

--7--
{-
resultadoDeAtaque :: LineaDeDefensa -> Horda -> LineaDeDefensa
resultadoDeAtaque linea horda = foldl (\defensa (zombie, _) -> atacarLinea zombie defensa) linea ataques
  where
    ataques = takeWhile (\(_, defensa) -> not (lineaVacia defensa || zombiesVacios defensa)) horda

atacarLinea :: Zombies -> LineaDeDefensa -> LineaDeDefensa
atacarLinea zombie linea = foldl (\defensa planta -> atacarZombie zombie planta) linea (reverse (plantasVivas linea))

lineaVacia :: LineaDeDefensa -> Bool
lineaVacia linea = null (plantasVivas linea)

zombiesVacios :: LineaDeDefensa -> Bool
zombiesVacios linea = null (zombiesVivos linea)
-}
--8--
theZombiesAteYourBrains :: Jardin -> Horda -> Bool
theZombiesAteYourBrains jardin horda = all lineaVacia defensas
  where
    defensas = map snd horda

--9--
tieneMenosLetras :: Zombies -> LineaDeDefensa -> Bool
tieneMenosLetras zombie linea = all (\z -> length (nombre z) < length (nombre zombie)) (zombiesVivos linea)

--10--
{-
--A)Si la lista contiene el elemento h devuelve el primer 
elemento de todos los que cumplan con la funcion m con h de parametro,de la lista original.
 Si no se cumple desvuelve el primer elemento de p
-}

--B)No pudimos encontrar una forma mas facil de hacerlo operando con tail pero termino siendo mucho mas dificil.

--C)Si la lista es infinita va a buscar si tiene algun h hasta encontrarlo y luego aplica filter a la lista hasta encontrar un elemento
--que es el unico que necesitamos y se continua ejecutando correctamente.


--11--

nivelSupervivencia :: LineaDeDefensa -> Int
nivelSupervivencia linea = (\linea -> (sum (vida plantas linea ))-(sum (danio zombies linea)))
