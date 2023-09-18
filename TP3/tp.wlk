object EstadosDeAnimo {
	var property seBanio = false
	var property jugo = false
	var property durmio = false;
	var property comio = false;
	
	method seRie() {
		return seBanio == false || jugo || durmio || comio;
	}
}


object Pou {
	var property edad = 1
	var property energia = 100
	var property salud = EstadoDeSalud
	var property alimentacion = Alimentacion
	var property estadosDeAnimo = EstadosDeAnimo
	
	
	method energiaInicial() {
		return edad * 10
	}
	
	method agregarEnergia(energiaExtraQueConsume) {
		energia += (-1) + energiaExtraQueConsume
	}
	
	method agregarEnergia(energiaExtraQueConsume, energiaBase) {
		energia += energiaBase + energiaExtraQueConsume
	}
	
	
	method energizarse() {
		if(estadosDeAnimo.seRie() && energia < self.energiaInicial()) {
			energia = self.energiaInicial()	
		}
	}
	
	method jugar(juego) {
		estadosDeAnimo.jugo(true)
	}
	
	method comer(alimento) {
		estadosDeAnimo.comio(true)
		alimentacion .agregarAlimento(alimento)
		const energiaQueAportaAlimento = alimento.energiaQueAporta()
		self.agregarEnergia(energiaQueAportaAlimento);
	}
	
	method baniarse() {
		if(estadosDeAnimo.comio() && estadosDeAnimo.jugo()) {			
			estadosDeAnimo.seBanio(true)
			self.agregarEnergia(-2, -2)
		}
	}
	
	method dormir() {
		estadosDeAnimo.durmio(true)
	}
	
}

object Alimentacion {
	var property alimentosConsumidos = []
	var property estaBienAlimentado = false;
	
	method agregarAlimento(alimento) {
		alimentosConsumidos.add(alimento)
	}
	
	method alimentosSaludables() {
		return alimentosConsumidos.filter({ alimento => alimento.esSaludable()});
	}
	
	method alimentosInsalubres() {
		return alimentosConsumidos.filter({ alimento => not alimento.esSaludable()});
	}
	
	method tieneAlimentacionSaludable() {
		const totCantidadAlimentos = alimentosConsumidos.size();
		const cantidadFrituras = self.alimentosInsalubres().filter({ alimento => alimento == Fritura }).size()
		const porcentajeFrituras = (cantidadFrituras * 100) / totCantidadAlimentos
		return porcentajeFrituras <= 1
	}
}

object EstadoDeSalud {
	var property alimentacion = Alimentacion
	var property estadosDeAnimo = EstadosDeAnimo
	
	
	method obtenerEstado() {
		if(self.deplorable()) {
			return 'deplorable'
		}
		
		if(self.alarmante()) {
			return 'alarmante'
		}
		
		if(self.normal()) {
			return 'normal'
		}
		
		if(self.aburrido()) {
			return 'aburrido'
		}
		
		return 'undefined'
	}
	
	
	method deplorable() {
		const cantidadAlimentosSaludables = alimentacion.alimentosSaludables().size()
		const alimentosInsalubres = alimentacion.alimentosInsalubres()
		const cantidadFrituras = alimentosInsalubres.filter({ alimento => alimento == Fritura }).size()
		return cantidadAlimentosSaludables < cantidadFrituras
	}
	
	method alarmante() {
		const cantidadAlimentosSaludables = alimentacion.alimentosSaludables().size()
		const cantidadAlimentosInsalubres = alimentacion.alimentosInsalubres().size()
		return (cantidadAlimentosSaludables == cantidadAlimentosInsalubres) && not estadosDeAnimo.seRie();
	}
	
	method normal() {
		return alimentacion.tieneAlimentacionSaludable() && estadosDeAnimo.seRie();
	}
	
	method aburrido() {
		return alimentacion.tieneAlimentacionSaludable() && not estadosDeAnimo.seRie();
	}
}

object Fruta {
	method esSaludable() = true
	method energiaQueAporta(){
		return 1	
	}
} 

object Verdura {
	method esSaludable() = true
	method energiaQueAporta(){
		return 1	
	}
}

object Bebida {
	method esSaludable() = true
	method energiaQueAporta(){
		return 0.5
	}
}

object Fritura {
	method esSaludable() = false
	method energiaQueAporta(){
		return -0.2	
	}
}

object Carne {
	method esSaludable() = true
	method energiaQueAporta(){
		return 0
	}
}


