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

comio(shenzi,hormiga(conCaraDeSimba)). 

pesoHormiga(2). 

%peso(Personaje, Peso) 
peso(pumba, 100). 
peso(timon, 50). 
peso(simba, 200). 
peso(scar, 300). 
peso(shenzi, 400). 
peso(banzai, 500). 


%1) a) Qué cucaracha es jugosita: ó sea, hay otra con su mismo tamaño pero ell es más gordita. 

mismoTamanio(Cucaracha1, Cucaracha2):-((_,Tamanio1,_)==(_,Tamanio2,_)).
esMasGorda(Cucaracha1, Cucaracha2):-((_,_,Peso1)>(_,_,Peso2)).

jugosita(Cucaracha):-mismoTamanio(Cucaracha, OtraCucaracha), esMasGorda(Cucaracha, OtraCucaracha).


%b) Si un personaje es hormigofílico... (Comió al menos dos hormigas). 

hormigofilico(Personaje):-
    comio(Personaje,hormiga(Hormiga1)),comio(Personaje, hormiga(Hormiga2)).

%c) Si un personaje es cucarachofóbico (no comió cucarachas). 

cucarachofóbico(Personaje):-not(comio(Personaje,cucaracha)).

%d) Conocer al conjunto de los picarones. Un personaje es picarón si comió una cucaracha jugosita ó si se come a Remeditos la vaquita. Además, pumba es picarón de por sí. 

%%%%%         2         %%%%%

persigue(scar, timon). 
persigue(scar, pumba). 
persigue(shenzi, simba). 
persigue(shenzi, scar). 
persigue(banzai, timon).
persigue(scar, mufasa).  

%a) Se quiere saber cuánto engorda un personaje (sabiendo que engorda una cantidad igual a la suma de los pesos de todos los bichos en su menú). Los bichos no engordan. 

cuantoEngorda(Personaje, Peso):-

%b) Pero como indica la ley de la selva, cuando un personaje persigue a otro, se lo termina comiendo, y por lo tanto también engorda. Realizar una nueva versión del predicado cuantoEngorda.

cuantoEngorda2(Personaje, Peso):- 

%3)Se quiere saber todas las posibles combinaciones posibles de comidas que puede tener un personaje dado. Se sabe que la comida no es solo lo que comió si no también los animales que persigue.

combinaComidas(Personaje, ListaComidas)

%4) Buscando el rey… Sabiendo que todo animal adora a todo lo que no se lo come o no lo persigue, encontrar al rey. El rey es el animal a quien sólo hay un animal que lo persigue y todos adoran

rey(Personaje):-
