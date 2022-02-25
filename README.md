# Prueba_resuelve
Resuelve backend prueba.
Este proyecto intenta dar una solución sencilla al ejercicio planteado por [Resuelve](https://github.com/resuelve): [prueba-ing-backend](https://github.com/resuelve/prueba-ing-backend).
## Solución
Puedes ingresar dos archivos JSON. 
El primero deberá contener la información de Nivel y goles/mes, estos valores son opcionales,  ejemplo:

```json
    [
      {"level": "A", "value": 5},
      {"level": "B", "value": 10},
      {"level": "C", "value": 15},
      {"level": "Cuauh", "value": 20}
    ]
```
Si no se ingresa un json tomará la información previa:

| Nivel |Goles/mes|
| ------------- |:-------------:| 
|A |5|
|B |10|
|C |15|
|Cuauh |20|

El segundo es necesario para obtener un resultado, debe ingresarse un json con la siguiente estructura:
```json
{
   "jugadores" : [  
      {  
         "nombre":"Juan Perez",
         "nivel":"C",
         "goles":10,
         "sueldo":50000,
         "bono":25000,
         "sueldo_completo":null,
         "equipo":"rojo"
      },
      {  
         "nombre":"EL Cuauh",
         "nivel":"Cuauh",
         "goles":30,
         "sueldo":100000,
         "bono":30000,
         "sueldo_completo":null,
         "equipo":"azul"
      },
      {  
         "nombre":"Cosme Fulanito",
         "nivel":"A",
         "goles":7,
         "sueldo":20000,
         "bono":10000,
         "sueldo_completo":null,
         "equipo":"azul"
      },
      {  
         "nombre":"El Rulo",
         "nivel":"B",
         "goles":9,
         "sueldo":30000,
         "bono":15000,
         "sueldo_completo":null,
         "equipo":"rojo"
      }
   ]
}
```
El resultado incluye un valor calculado de `sueldo_completo` y `goles_minimos` con la siguiente estructura:

```json
{
   "jugadores": [
      {  
         "nombre":"El Rulo",
         "goles_minimos":10,
         "goles":9,
         "sueldo":30000,
         "bono":15000,
         "sueldo_completo": 14250,
         "equipo":"rojo"
      }
   ]
}
```

# Iniciando
    Se utilizó Elixir + phoenix + TailwindCSS para la realización de este proyecto, en un sistema Windows 11x64
    y Elixir 1.12.3 (compilado con Erlang/OTP 22)
## Ejecución   

Para iniciar su servidor Phoenix:

  * Instala las dependencias con `mix deps.get`
  * Inicie el 'endpoint' de Phoenix con `mix phx.server` o dentro de  IEx con `iex -S mix phx.server`
  * Ahora puedes visitar [`localhost:4000`](http://localhost:4000) desde tu navegador.

¿Listo para funcionar en producción? Por favor [consulte nuestras guías de implementación](https://hexdocs.pm/phoenix/deployment.html).

## Aprende más

  * Website oficial: https://www.phoenixframework.org/
  * Guías: https://hexdocs.pm/phoenix/overview.html
  * Documentación: https://hexdocs.pm/phoenix
  * Foro: https://elixirforum.com/c/phoenix-forum
  * Fuente: https://github.com/phoenixframework/phoenix
