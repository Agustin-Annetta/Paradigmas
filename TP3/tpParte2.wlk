object pou {

	var property edad = 1
	
	var property energia = 10
	
	var property alimentacion = new Alimentacion()
	
	var property estadoInterno = new EstadoInterno (alimentacion = alimentacion)

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
		if (estadoInterno.feliz() && energia < self.energiaInicial()) {
			energia = self.energiaInicial()
		}
	}

	method jugar(juego) {
		self.chequearEnergia()
		estadoInterno.jugo(true)
	}

	method comer(alimento) {
		self.chequearEnergia()
		estadoInterno.comio(true)
		alimentacion.agregarAlimento(alimento)
		const energiaQueAportaAlimento = alimento.energiaQueAporta()
		self.agregarEnergia(energiaQueAportaAlimento)
	
	}

	method baniarse() {
		self.chequearEnergia()
		if (estadoInterno.comio() && estadoInterno.jugo()) {
			estadoInterno.seBanio(true)
			self.agregarEnergia(-2, -2)
		}
	}

	method chequearEnergia() {
		if (self.energia() < self.energiaInicial()) {
			self.energizarse()
			throw new FaltaDeEnergia(message = "La energia es menor al valor inicial")
		}
	}

	method dormir() {
		self.chequearEnergia()
		estadoInterno.durmio(true)
	}

}

class Mascota {

	var property edad
	
	var property energia 
	
	var property alimentacion
	
	var property estadoInterno
	
	method edad(){
		return edad
	}
	
	method energia(){
		return energia
	}
	
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
		if (estadoInterno.feliz() && energia < self.energiaInicial()) {
			energia = self.energiaInicial()
		}
	}

	method jugar(juego) {
		self.chequearEnergia()
		estadoInterno.jugo(true)
	}

	method jugarConPou(juego, pou) {
		self.chequearEnergia()
		pou.chequearEnergia()	
	
		if (!self.estadoInterno().aburrido()) {
			throw new Exception(message = 'El pou no esta aburrido')
		}
		if (self.estadoInterno().aburrido() && pou.feliz() && pou.energia() < self.energia()) {
			throw new Exception(message = 'El pou no puede jugar con otro que este feliz y tenga menos energia')
		}
		
		self.jugar(juego)
		pou.jugar(juego)
	}

	method comer(alimento) {
		self.chequearEnergia()
		estadoInterno.comio(true)
		alimentacion.agregarAlimento(alimento)
		const energiaQueAportaAlimento = alimento.energiaQueAporta()
		self.agregarEnergia(energiaQueAportaAlimento)
	;
	}

	method baniarse() {
		self.chequearEnergia()
		if (estadoInterno.comio() && estadoInterno.jugo()) {
			estadoInterno.seBanio(true)
			self.agregarEnergia(-2, -2)
		}
	}

	method chequearEnergia() {
		if (self.energia() < self.energiaInicial()) {
			self.energizarse()
			throw new FaltaDeEnergia(message = "La energia es menor al valor inicial")
		}
	}

	method dormir() {
		self.chequearEnergia()
		estadoInterno.durmio(true)
	}

}

class Alimentacion {

	var property alimentosConsumidos = []
	var property estaBienAlimentado = false

	;
	
	method agregarAlimento(alimento) {
		alimentosConsumidos.add(alimento)
	}

	method alimentosSaludables() {
		return alimentosConsumidos.filter({ alimento => alimento.esSaludable() })
	;
	}

	method alimentosInsalubres() {
		return alimentosConsumidos.filter({ alimento => not alimento.esSaludable() })
	;
	}

	method tieneAlimentacionSaludable() {
		const totCantidadAlimentos = alimentosConsumidos.size()
		
		if (totCantidadAlimentos == 0){
			return false
		}
		else{
			const cantidadFrituras = self.alimentosInsalubres().filter({ alimento => alimento.esFritura() }).size()
			const porcentajeFrituras = (cantidadFrituras * 100) / totCantidadAlimentos
			return porcentajeFrituras <= 1
		}
	}

}

object pouAdulto inherits Mascota(edad=60, energia=600, alimentacion = new Alimentacion(), estadoInterno = new EstadoInterno(alimentacion=alimentacion)) {
	
	var property cantidadAcciones = 0

	method procesarAccion() {
		if (cantidadAcciones == 5) {
			edad++
			cantidadAcciones = 0
		} else {
			cantidadAcciones++
		}
	}

	override method jugar(juego) {
		self.procesarAccion()
		super(juego)
	}

	override method comer(comida) {
		self.procesarAccion()
		super(comida)
	}

	override method baniarse() {
		self.procesarAccion()
		super()
	}

}

class EstadoInterno {

	var property seBanio = false
	var property jugo = false
	var property durmio = false
	;
	var property comio = false
	;
	var property alimentacion

	;
	
	method constructor(_alimentacion) {
		alimentacion = _alimentacion
	;
	}

	method deplorable() {
		const cantidadAlimentosSaludables = alimentacion.alimentosSaludables().size()
		const alimentosInsalubres = alimentacion.alimentosInsalubres()
		const cantidadFrituras = alimentosInsalubres.filter({ alimento => alimento.esFritura() }).size()
		return cantidadAlimentosSaludables < cantidadFrituras
	}

	method alarmante() {
		const cantidadAlimentosSaludables = alimentacion.alimentosSaludables().size()
		const cantidadAlimentosInsalubres = alimentacion.alimentosInsalubres().size()
		return (cantidadAlimentosSaludables == cantidadAlimentosInsalubres) && not self.feliz()
	;
	}

	method normal() {
		return alimentacion.tieneAlimentacionSaludable() && self.feliz()
	;
	}

	method aburrido() {
		return alimentacion.tieneAlimentacionSaludable() && not self.feliz()
	;
	}

	method feliz() {
		return !seBanio || jugo || durmio || comio
	;
	}

}

class Comida {

	var property energiaQueAporta
	;
	var property esSaludable
	;
	var property objetoDeCoccion

	;

	method energiaQueAporta() {
		if (self.esFritura()) {
			return energiaQueAporta * -1
		} else {
			return energiaQueAporta
		}
	}

	method esFritura() {
		if (objetoDeCoccion == null) {
			return false
		}
		return objetoDeCoccion.esUsadoParaFreir()
	}

}

object sarten {

	method esUsadoParaFreir() {
		return false
	;
	}

}

object freidora {

	method esUsadoParaFreir() {
		return true
	;
	}

}

object plancha {

	method esUsadoParaFreir() {
		return false
	;
	}

}

object olla {

	method esUsadoParaFreir() {
		return false
	;
	}

}

class FaltaDeEnergia inherits Exception {

}
