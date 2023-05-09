
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

lineaMixta :: LineaDeDefensa -> Bool
lineaMixta linea
  | length (plantas linea) < 2 = False
  | otherwise = any especialidadDiferente (zip (plantas linea) (tail $ plantas linea))
  where
    especialidadDiferente (planta1, planta2) = especialidad planta1 /= especialidad planta2

--5--

atacarZombie :: Zombies -> Plantas -> Plantas
atacarZombie zombie planta = if vidaActual <= 0 then derrotada else planta { vida = vidaActual }
  where
    vidaActual = vida planta - danio zombie
    derrotada = planta { vida = 0 }