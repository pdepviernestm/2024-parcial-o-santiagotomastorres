class Persona
{
    var edad
    const emociones = []

    method cumplirAnios() {edad += 1}

    method esAdolescente() = edad.between(12, 18)

    method agregarEmocion(emocion) = emociones.add(emocion)

    method estaPorExplotar() = emociones.all({emocion => emocion.puedeLiberarse()})

    method vivirEvento(evento) // que una persona viva un evento quiere decir que sus emociones sufren las consecuencias del evento
    {
        emociones.map({emocion => emocion.vivirEvento(evento)})
    }
}

class Evento
{
    const property impacto
    const property descripcion


}

class Emocion
{   var property intensidad
    var valorParaIntensidadElevada = 10 // es un ejemplo a modo de prueba

    var puedeLiberarseEnProximoEvento = true

    var property eventosExperimentados

    method cambiarValorParaSerElevada(nuevoValor)
    {
        valorParaIntensidadElevada = nuevoValor
    }

    method cambiarIntensidad(nuevoValor)
    {
            intensidad = nuevoValor
    }


    method tieneIntensidadElevada() = intensidad > valorParaIntensidadElevada

    // Como Desagrado y Temor se liberan igual los hago como base aca y a las que se liberan distinto les hago override
    method puedeLiberarse() = self.tieneIntensidadElevada() and eventosExperimentados > intensidad 
    and puedeLiberarseEnProximoEvento // lo agrego en todas porque dice que una vez liberadas no se liberan en el siguiente evento


    method liberarse(evento) 
    { 
        self.cambiarIntensidad(intensidad - evento.impacto())
        puedeLiberarseEnProximoEvento = false

    }

    method vivirEvento(evento)
    {   
        if (self.puedeLiberarse()) {self.liberarse(evento)}
        eventosExperimentados += 1

        
    }
}

class Furia inherits Emocion(intensidad=100)
{
    
    const palabrotas = []

    method aprenderPalabrota(palabrota) = palabrotas.add(palabrota)

    method olvidarPalabrota(palabrota) = palabrotas.remove(palabrota)

    override method puedeLiberarse() = self.tieneIntensidadElevada() and self.conocePalabrotaDeMasDeSiete() and puedeLiberarseEnProximoEvento

    method conocePalabrotaDeMasDeSiete() = palabrotas.any({palabra => palabra.size() > 7})

    override method liberarse(evento)
    {
        self.cambiarIntensidad(intensidad - evento.impacto())
        self.olvidarPalabrota(palabrotas.first())
        puedeLiberarseEnProximoEvento = false

    }

}

class Alegria inherits Emocion()
{
    override method puedeLiberarse() = self.tieneIntensidadElevada() and ((eventosExperimentados % 2) == 0) and puedeLiberarseEnProximoEvento
    
    override method liberarse(evento)
    {
        self.cambiarIntensidad((intensidad - evento.impacto()).abs())
        puedeLiberarseEnProximoEvento = false

    }

}

class Tristeza inherits Emocion()
{
    var causa = "melancolia"

     override method puedeLiberarse() = self.tieneIntensidadElevada() and causa != "melancolia" and puedeLiberarseEnProximoEvento

     override method liberarse(evento)
     {
        causa = evento.descripcion()
        self.cambiarIntensidad(intensidad - evento.impacto())
        puedeLiberarseEnProximoEvento = false

     }
}

class Ansiedad inherits Emocion()
{
    var situacionesAnsiosasAcumuladas

    override method puedeLiberarse() = situacionesAnsiosasAcumuladas > intensidad and puedeLiberarseEnProximoEvento

    override method liberarse(evento)
    {
        situacionesAnsiosasAcumuladas = 0 // se tranquiliza y su contador de situaciones ansiosas se vuelve 0
        self.cambiarIntensidad(intensidad - evento.impacto())
        puedeLiberarseEnProximoEvento = false


    }
}

/* Utilizo la herencia ya que las emociones tienen caracteristicas comunes; pero cada una sabe 
como saber si puede liberarse y de ser el caso como hacerlo. Ante el mismo mensaje de liberarse ante un evento cada emocion
sabe como debe hacerlo y lo hacen de forma distinta, es ahi donde se aplica el polimorfismo
 */

class Grupo
{
    const personas = #{}

    method vivirEventoGrupal(evento)
    {
        personas.map({persona => persona.vivirEvento(evento)})
    }

}
