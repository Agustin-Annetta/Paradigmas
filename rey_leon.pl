%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BASE DE CONOCIMIENTOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%comio(Personaje, Bicho)

comio(pumba, vaquitaSanAntonio(gervasia,3)).
comio(pumba, hormiga(federica)).
comio(pumba, hormiga(tuNoEresLaReina)).
comio(pumba, cucaracha(ginger,15,6)).
comio(pumba, cucaracha(erikElRojo,25,70)).

comio(timon, vaquitaSanAntonio(romualda,4)).
comio(timon, cucaracha(gimeno,12,8)).
comio(timon, cucaracha(cucurucha,12,5)).

comio(simba, vaquitaSanAntonio(remeditos,4)).
comio(simba, hormiga(schwartzenegger)).
comio(simba, hormiga(niato)).
comio(simba, hormiga(lula)).

comio(shenzi,hormiga(conCaraDeSimba)). % Punto 2

pesoHormiga(2).


%peso(Personaje, Peso)
peso(pumba, 100).
peso(timon, 50).
peso(simba, 200).

% Punto 2

peso(scar, 300).
peso(shenzi, 400).
peso(banzai, 500).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARTE DE 2A %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Para averiguar el peso de las hormigas no es necesario instanciarlas desde lo particular, pero es convenitente para asegurarse que pertenezcan al universo cerrado

peso(hormiga(UnaHormiga) ,Peso ):-
    comio(_ , hormiga(UnaHormiga)),
    pesoHormiga(Peso).

peso(vaquitaSanAntonio( UnaVaquita , PesoVaquita) , Peso):-
    comio(_ , vaquitaSanAntonio( UnaVaquita , PesoVaquita)),
    Peso is PesoVaquita.

peso(cucaracha(UnaCucaracha , _ , PesoCuca) , Peso):-
    comio(_ , cucaracha(UnaCucaracha , _ , PesoCuca)),
    Peso is PesoCuca.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


persigue(scar, timon).
persigue(scar, pumba).
%persigue(scar, mufasa).  % Punto 4


persigue(shenzi, simba).
persigue(shenzi, scar).

persigue(banzai, timon).





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


/*
1) 

a)
*/

jugosita(cucaracha(UnaCucaracha , UnTamanio , UnPeso)):-
    comio(_ , cucaracha(UnaCucaracha , UnTamanio , UnPeso)),
    comio(_ , cucaracha(OtraCucaracha , UnTamanio , OtroPeso)),
    UnaCucaracha \= OtraCucaracha,
    UnPeso > OtroPeso.



/*
b)
*/

hormigofilico(Personaje):-
    comio(Personaje , hormiga(_)),
    findall(Hormiga , comio(Personaje , Hormiga) , Hormigas),
    length(Hormigas, Total),
    Total >= 2.
    
    

/*
c)
*/

cucarachofobico(Personaje):-
    comio(Personaje , _), 
    not(comio(Personaje , cucaracha(_ , _ , _))).


/*
d)
*/

picaron(pumba).


picaron(Personaje):-
    comio(Personaje , vaquitaSanAntonio(remeditos,_)).


picaron(Personaje):-
    comio(Personaje , cucaracha(UnaCucaracha , _ , _)),
    jugosita(cucaracha(UnaCucaracha , _ , _)).


picarones(ListaPicarones):-
    findall(Personaje , picaron(Personaje) , ListaPicarones).

/*
2) 

a)

*/




menu(Personaje , Comidas):-
    comio(Personaje , _), % El personaje tiene que haber comido algo
    findall(Peso , comio(Personaje , Peso) , Comidas).


peso_Extra([] , []).
peso_Extra([Comida|Comidas] , [Peso|Pesos]):- % Dada una lista con las "comidas", devuelve una nueva con los pesos
    peso(Comida , Peso),
    peso_Extra(Comidas , Pesos).



cuantoEngorda(Personaje, Peso):-
    menu(Personaje , Comidas),
    peso_Extra(Comidas , Pesos),
    sumlist(Pesos, Peso).
    


/*
b) 
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Predicado genérico para concatenar listas %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
conc([], Lista, Lista).
conc(Lista , [] , Lista).
conc([Elemento|RestoLista1], Lista2, [Elemento|Resultado]) :-
    conc(RestoLista1, Lista2, Resultado).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


presas(Personaje , Cazados):-
    persigue(Personaje , _),
    findall(Presa , persigue(Personaje , Presa) , Cazados).

presas(Personaje , []):-
    peso(Personaje , _),
    not(persigue(Personaje , _)).



esPersonaje(Personaje):-
    comio(Personaje , _).
esPersonaje(Personaje):-
    persigue(Personaje , _).



%persigue(scar, timon).
menu2(Personaje , Comidas):-
    esPersonaje(Personaje),   % Para que haya podido comer a alguien primero verifica si es un personaje (Los bichos no comen nada por lo que se los excluye)
    presas(Personaje , Cazados),
    menu(Personaje , Bichos),
    conc(Cazados,Bichos,Comidas).

menu2(Personaje , Comidas):-
    esPersonaje(Personaje),
    presas(Personaje , Comidas),
    not(menu(Personaje , _)). % No tiene que haber comido ningún bicho



cuantoEngorda2(Personaje, Peso):-
    esPersonaje(Personaje),
    menu2(Personaje , Comidas),
    peso_Extra(Comidas , Pesos),
    sumlist(Pesos, Peso).


% Predicado que se usa para evitar valores repetidos cuando se hace la consulta de cuantoEngorda2
cuantoEngordanTodos(Personaje , Peso , Resultados) :- setof((Personaje , Peso), cuantoEngorda2(Personaje , Peso), Resultados).


/*
c)
*/

any(Predicado, Lista) :-
    member(Elemento, Lista),
    call(Predicado, Elemento).

esCazador(Personaje):-
    persigue(Personaje , _).

comeCazadores(Personaje):-
    presas(Personaje , Presas),
    any(esCazador  ,Presas).

cuantoEngordaPresa([], 0).
cuantoEngordaPresa([Presa|Presas], PesoTotal) :-
    cuantoEngordaPresa(Presas, PesoPresas),
    cuantoEngorda(Presa, PesoPresa),
    PesoTotal is PesoPresas + PesoPresa.

cuantoEngorda3(Personaje , Peso):-
    esPersonaje(Personaje),
    not(comeCazadores(Personaje)), % Si no come a animales que a su vez comen animales, significa que es igual a sumar cuantoEngorda2, con lo que comió cada uno de los animales
    cuantoEngorda2(Personaje , PesoBase),
    presas(Personaje , Presas),
    cuantoEngordaPresa(Presas , PesoPresas),
    Peso is PesoPresas + PesoBase.



    
cuantoEngorda3(Personaje , Peso):-
    esPersonaje(Personaje),
    comeCazadores(Personaje),
    cuantoEngorda2(Personaje , PesoBase), %Calcula el peso directo de los animales/bichos que se come él
    presas(Personaje , Presas),
    cuantoEngordaPresa2(Presas , PesoPresas),
    Peso is PesoPresas + PesoBase.

cuantoEngordaPresa2([],0).
cuantoEngordaPresa2([Presa|Presas] , PesoTotal):-
    esCazador(Presa),
    cuantoEngordaPresa2(Presas , PesoPresas),
    cuantoEngorda3(Presa, PesoPresa),
    PesoTotal is PesoPresas + PesoPresa.

cuantoEngordaPresa2([Presa|Presas] , PesoTotal):-
    not(esCazador(Presa)),
    cuantoEngordaPresa2(Presas , PesoPresas),
    cuantoEngorda(Presa, PesoPresa),
    PesoTotal is PesoPresas + PesoPresa.




cuantoEngordanTodos3(Personaje , Peso , Resultados) :- setof((Personaje , Peso), cuantoEngorda3(Personaje , Peso), Resultados).

/*
3) Para acelerar el plato de comida…

Se quiere saber todas las posibles combinaciones posibles de comidas que puede tener un personaje dado. Se sabe que la comida no es solo lo que comió si no también los animales que persigue.


combinaComidas(Personaje, ListaComidas)
*/

combinaComidas(Personaje , ListaComidas):-
    menu2(Personaje , ListaComidas).



/*
4) 
*/

loPersiguen(Personaje , Lista):-
    esPersonaje(Personaje),
    findall(Cazador , persigue(Cazador , Personaje) , Lista).

adoraA(Adorado , Adorador):-
    esPersonaje(Adorado),
    esPersonaje(Adorador),
    Adorado \= Adorador,
    not(comio(Adorado , Adorador)).
adoraA(Adorado , Adorador):-
    esPersonaje(Adorado),
    esPersonaje(Adorador),
    Adorado \= Adorador,
    not(persigue(Adorado , Adorador)).

rey(Personaje):-
    loPersiguen(Personaje , Perseguidores),
    length(Perseguidores , CantidadPerseguidores),
    CantidadPerseguidores is 1,
    forall(esPersonaje(Animal), adoraA(Personaje , Animal)).
    





/*
5) Explicar en dónde se usaron y cómo fueron de utilidad los siguientes conceptos:


a. Polimorfismo

El polimorfismo se utilizó en varias ocasiones dentro de este trabajo. La primera de ellas fue para poder calcular el peso de los distintos bichos, ya que se emplea el mismo predicado "peso"
que se utiliza también para obtener el peso de los distintos personajes dentro de la base de conocimientos. Esto lo que permite es poder generalizar diferentes métodos de cálculo de peso dentro de 
un mismo predicado, facilitando considerablemente el trabajo a la hora de obtener la suma de los pesos de lo que come un personaje, utilizando el predicado cuantoEngorda().




b. Recursividad

La recursividad también se emplea en más de una ocasión, como por ejemplo cuando se emplea el predicado peso_Extra(). Este mismo recibe como parámetros una lista de
Comidas (las cuales pueden ser tanto bichos como personajes) y una lista numérica correspondiente a los pesos de cada una. Para poder "obtener" los pesos de cada comida se emplea la recursividad,
partiendo las listas en cabeza y cola. Luego de eso se establece la relación entre la cabeza de ambas listas (la  cual está dada por el predicado peso), para finalmente llamar de forma recursiva al mismo predicado, pero 
cuyos parámetros ahora son las colas de ambas listas. Es importante aclarar que se contempla que para cuando una de las listas es vacía, la otra tiene que estarlo también de forma obligatoria.
*/

