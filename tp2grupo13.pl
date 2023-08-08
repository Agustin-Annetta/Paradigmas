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

persigue(shenzi, simba).
persigue(shenzi, scar).

persigue(banzai, timon).





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


/*
1) A falta de pochoclos…


Definir los predicados que permitan saber:


a) Qué cucaracha es jugosita: ó sea, hay otra con su mismo tamaño pero ella es más gordita.


?-jugosita(cucaracha(gimeno,12,8)).

Yes

*/

jugosita(cucaracha(UnaCucaracha , UnTamanio , UnPeso)):-
    comio(_ , cucaracha(UnaCucaracha , UnTamanio , UnPeso)),
    comio(_ , cucaracha(OtraCucaracha , UnTamanio , OtroPeso)),
    UnaCucaracha \= OtraCucaracha,
    UnPeso > OtroPeso.



/*
b)

Si un personaje es hormigofílico... (Comió al menos dos hormigas).


?-hormigofilico(X).

X = pumba;

X = simba.
*/

hormigofilico(Personaje):-
    comio(Personaje , hormiga(_)),
    findall(Hormiga , comio(Personaje , Hormiga) , Hormigas),
    length(Hormigas, Total),
    Total >= 2.
    
    

/*

c)

Si un personaje es cucarachofóbico (no comió cucarachas).


?-cucarachofobico(X).

X = simba

*/

cucarachofobico(Personaje):-
    comio(Personaje , _), 
    not(comio(Personaje , cucaracha(_ , _ , _))).


/*


d)

Conocer al conjunto de los picarones. Un personaje es picarón si comió una cucaracha jugosita ó si se come a Remeditos la vaquita. Además, pumba es picarón de por sí.


?-picarones(L).

L = [pumba, timon, simba]

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
2) Pero yo quiero carne…


Aparece en escena el malvado Scar, que persigue a algunos de nuestros amigos. Y a su vez, las hienas Shenzi y Banzai también se divierten...


persigue(scar, timon).

persigue(scar, pumba).

persigue(shenzi, simba).

persigue(shenzi, scar).

persigue(banzai, timon).

Por ejemplo, un día había una hiena distraída y con mucho hambre y amplió su dieta


comio(shenzi,hormiga(conCaraDeSimba)).


Completando la base...


peso(scar, 300).


peso(shenzi, 400).

peso(banzai, 500).


a)

Se quiere saber cuánto engorda un personaje (sabiendo que engorda una cantidad igual a la suma de los pesos de todos los bichos en su menú). Los bichos no engordan.


?-cuantoEngorda(Personaje, Peso).

Personaje= pumba

Peso = 83;

Personaje= timon

Peso = 17;


Personaje= simba


Peso = 10

*/




menu(Personaje , Comidas):-
    comio(Personaje , _), % El personaje tiene que haber comido algo
    findall(Peso , comio(Personaje , Peso) , Comidas).

menu(Personaje , []):- % si no comió ningún bicho tiene que devolver una lista vacía, pero para verificar que sea un personaje comprueba si tiene un peso
    peso(Personaje , _),
    not(( comio(Personaje , _) , findall(Peso , comio(Personaje , Peso) , _))).

peso_Extra([] , []).
peso_Extra([Comida|Comidas] , [Peso|Pesos]):- % Dada una lista con las "comidas", devuelve una nueva con los pesos
    peso(Comida , Peso),
    peso_Extra(Comidas , Pesos).



cuantoEngorda(Personaje, Peso):-
    menu(Personaje , Comidas),
    peso_Extra(Comidas , Pesos),
    sumlist(Pesos, Peso).
    


/*
b) Pero como indica la ley de la selva, cuando un personaje persigue a otro, se lo termina comiendo, y por lo tanto también engorda. Realizar una nueva versión del predicado cuantoEngorda.


?-cuantoEngorda(scar,Peso).

Peso = 150

(es la suma de lo que pesan pumba y timon)



?-cuantoEngorda(shenzi,Peso).

Peso = 502

(es la suma del peso de scar y simba, más 2 que pesa la hormiga)
*/

% Predicado genérico para concatenar listas
conc([], Lista, Lista).
conc(Lista , [] , Lista).
conc([Elemento|RestoLista1], Lista2, [Elemento|Resultado]) :-
    conc(RestoLista1, Lista2, Resultado).

presas(Personaje , Cazados):-
    persigue(Personaje , _),
    findall(Presa , persigue(Personaje , Presa) , Cazados).

presas(Personaje , []):-
    peso(Personaje , _),
    not(persigue(Personaje , _)).

%persigue(scar, timon).
menu2(Personaje , Comidas):-
    presas(Personaje , Cazados),
    menu(Personaje , Bichos),
    conc(Cazados,Bichos,Comidas).


esPersonaje(Personaje):-
    comio(Personaje , _).
esPersonaje(Personaje):-
    persigue(Personaje , _).


cuantoEngorda_2(Personaje, Peso):-
    esPersonaje(Personaje),
    menu2(Personaje , Comidas),
    peso_Extra(Comidas , Pesos),
    sumlist(Pesos, Peso).

/*
c) Ahora se complica el asunto, porque en realidad cada animal antes de comerse a sus víctimas espera a que éstas se alimenten. De esta manera, lo que engorda un animal no es sólo el peso original de sus víctimas, sino también hay que tener en cuenta lo que éstas comieron y por lo tanto engordaron. Hacer una última versión del predicado.


?-cuantoEngorda(scar,Peso).

Peso = 250


(150, que era la suma de lo que pesan pumba y timon, más 83 que se come

pumba y 17 que come timon )


?-cuantoEngorda(shenzi,Peso).

Peso = 762


(502 era la suma del peso de scar y simba, más 2 de la hormiga. A eso se le suman los 250 de todo lo que engorda scar y 10 que engorda simba)
*/

/*
peso_Extra([] , []).
peso_Extra([Comida|Comidas] , [Peso|Pesos]):- % Dada una lista con las "comidas", devuelve una nueva con los pesos
    peso(Comida , Peso),
    peso_Extra(Comidas , Pesos).
*/





/*
3) Para acelerar el plato de comida…

Se quiere saber todas las posibles combinaciones posibles de comidas que puede tener un personaje dado. Se sabe que la comida no es solo lo que comió si no también los animales que persigue.


combinaComidas(Personaje, ListaComidas)
*/




/*
4) Buscando el rey…

Sabiendo que todo animal adora a todo lo que no se lo come o no lo persigue, encontrar al rey. El rey es el animal a quien sólo hay un animal que lo persigue y todos adoran.


Si se agrega el hecho:


persigue(scar, mufasa).


?-rey(R).

R = mufasa.

(sólo lo persigue scar y todos los adoran)
*/




/*
5) Explicar en dónde se usaron y cómo fueron de utilidad los siguientes conceptos:


a. Polimorfismo

b. Recursividad

*/

