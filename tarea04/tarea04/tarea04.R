library(nycflights13)
library(tidyverse)
install.packages("dm", dependencies = TRUE)
install.packages("dm")
library(dm)
install.packages("Lahman")
library(Lahman)
library(dm)

# 1. Olvidamos dibujar la relación entre weathery airportsen la Figura
# 19.1 . ¿Cuál es la relación y cómo debería aparecer en el diagrama?

weather_con_nombres <- weather %>%
  left_join(airports, by = c("origin" = "faa"))

weather_con_nombres %>%
  select(origin, name, temp, time_hour) %>%
  head()
dm <- dm_from_src(list(
  airports = airports,
  weather = weather
))
#La relación entre weather (clima) y airports (aeropuertos) 
#se establece a través del código del aeropuerto.

clima_unido <- weather %>%
  left_join(airports, by = c("origin" = "faa"))
clima_unido %>%
  select(origin, name, temp, lat, lon) %>%
  head()
modelo_clima <- dm(airports, weather) %>%
dm_add_pk(airports, faa) %>%
dm_add_fk(weather, origin, airports)
dm_draw(modelo_clima)

# 2.weatherSolo contiene información para los tres aeropuertos de origen en Nueva York. 
# Si contuviera registros meteorológicos para todos los aeropuertos de los EE. UU., 
# ¿qué conexión adicional establecería con flights?


# Uniendo el clima del aeropuerto de DESTINO
vuelos_con_clima_dest <- flights %>%
  inner_join(weather, by = c("dest" = "origin", "time_hour" = "time_hour"))
head(vuelos_con_clima_dest)
view(vuelos_con_clima_dest)
# rpta: Si la tabla weather incluyera todos los aeropuertos de EE. UU., 
# se establecería una conexión adicional entre weather$origin y flights$dest 
# (el aeropuerto de llegada). En el diagrama, esto aparecería como una segunda 
# flecha que une ambas tablas, permitiendo cruzar el clima con el destino final de 
# cada vuelo mediante las llaves combinadas de código de aeropuerto (dest) y 
# tiempo (time_hour). Esta relación es fundamental para analizar cómo las condiciones 
# meteorológicas en el punto de aterrizaje afectan la puntualidad y las operaciones, 
# más allá de lo que sucede en el aeropuerto de origen.

# 3.Las variables year, month, day, hour, y origincasi forman una clave compuesta para
# weather, pero hay una hora que tiene observaciones duplicadas. 
# ¿Puedes averiguar qué tiene de especial esa hora?
weather |> 
  count(year, month, day, hour, origin) |> 
  filter(n > 1)
# rpta: La hora especial es la 1:00 AM del 3 de noviembre de 2013. 
# En esta fecha finalizó el horario de verano en EE. UU., por lo que el reloj 
# se atrasó una hora, provocando que la 1:00 AM se repitiera. Esto genera observaciones duplicadas para la misma combinación de variables temporales y de origen, impidiendo que funcionen como una clave primaria perfecta.

# 4.Sabemos que algunos días del año son especiales y que menos personas 
# viajan en avión (por ejemplo, Nochebuena y Navidad). 
# ¿Cómo se podría representar esa información como un marco de datos? 
# ¿Cuál sería la clave primaria? ¿Cómo se conectaría con los marcos de datos existentes?

# a. Creamos el marco de datos de días especiales
festivos <- tibble(
  fecha = as.Date(c("2013-12-24", "2013-12-25", "2013-11-28")),
  festivo = c("Nochebuena", "Navidad", "Acción de Gracias")
)

# b. Conectarlo con la tabla de vuelos
vuelos_con_festivos <- flights |> 
  mutate(fecha_vuelo = as.Date(time_hour)) |> # Creamos la llave para unir
  left_join(festivos, by = c("fecha_vuelo" = "fecha"))

# c. Ver el resultado (los días normales tendrán NA en la columna 'festivo')
vuelos_con_festivos |> 
  filter(!is.na(festivo)) |> 
  select(year, month, day, dest, festivo)
# rpta: La clave primaria sería la columna fecha. Al ser única para cada día del 
# calendario, garantiza que no haya ambigüedad y permite identificar exactamente 
# qué evento ocurre en cada fecha.
# Se conectaría con la tabla flights mediante un left_join. La relación se establece 
# usando la columna fecha de la nueva tabla y la columna time_hour de la tabla de vuelos 
# (previamente convertida a formato fecha). Esto permite que cada vuelo "herede" la etiqueta 
# del festivo correspondiente sin duplicar información innecesariamente.
# 5.Dibuja un diagrama que ilustre las conexiones entre los marcos de datos Batting, 
# People, y Salariesen el paquete Lahman. Dibuja otro diagrama que muestre la relación 
# entre People, Managers, AwardsManagers. ¿Cómo caracterizarías la relación entre los marcos 
# de datos Batting, Pitching, y ?Fielding
# Creamos el modelo de datos
modelo1 <- dm(People, Batting, Salaries) %>%
# Definimos la llave primaria en la tabla maestra
  dm_add_pk(People, playerID) %>%
# Creamos las relaciones (llaves foráneas)
  dm_add_fk(Batting, playerID, People) %>%
  dm_add_fk(Salaries, playerID, People)
# Dibujar el diagrama
dm_draw(modelo1)
# rpta: La relación entre Batting, Pitching y Fielding se define como una 
# relación paralela y complementaria, donde cada tabla actúa como una extensión de la 
# otra para describir distintas facetas del juego. Todas comparten una clave primaria 
# compuesta idéntica (playerID, yearID y stint), lo que permite unirlas horizontalmente 
# para obtener el perfil completo de un jugador en una temporada específica



# 1.Identifica las 48 horas (a lo largo del año) con los mayores retrasos. 
# Compáralas con los weatherdatos. ¿Observas algún patrón?
# Las 48 horas con mayores retrasos y su relación con el clima
# Pra esto, debemos agrupar los vuelos por hora, calcular el retraso promedio y 
# luego unirlo con la tabla weather.
retrasos_48 <- flights |>
  group_by(origin, year, month, day, hour) |>
  summarize(dep_delay = mean(dep_delay, na.rm = TRUE)) |>
  ungroup() |>
  slice_max(dep_delay, n = 48) |>
  inner_join(weather, by = c("origin", "year", "month", "day", "hour"))
retrasos_48 |> 
  select(origin, month, day, hour, dep_delay, temp, wind_speed, visib) |> 
  print(n = 48)
# 2.Imagina que has encontrado los 10 destinos más populares usando este código:
top_dest <- flights |>
  count(dest, sort = TRUE) |>
  head(10)
# La solución:
vuelos_top <- flights |> 
  semi_join(top_dest, by = "dest")

# 3.Las variables year, month, day, hour, y origincasi forman una clave compuesta para 
# weather, pero hay una hora que tiene observaciones duplicadas. 
# ¿Puedes averiguar qué tiene de especial esa hora?
flights |> 
  left_join(weather, by = c("origin", "year", "month", "day", "hour")) |> 
  filter(is.na(temp))
# rpta:No todos tienen datos. A veces hay fallos en los sensores de las estaciones 
# meteorológicas o el registro de la hora del vuelo no coincide exactamente con la medición 
# climática.


# 4.¿Qué tienen en común los números de cola que no tienen un registro coincidente planes? 
flights |> 
  anti_join(planes, by = "tailnum") |> 
  count(carrier, sort = TRUE)
# rpta:Lo que tienen en común los números de cola sin registro coincidente es que 
# pertenecen predominantemente a las aerolíneas American Airlines (AA) y Envoy Air (MQ).


# 5.Agrega una columna que planesliste a todos carrierlos que han volado en ese avión. 
# Podrías esperar que exista una relación implícita entre avión y aerolínea, ya que cada 
# avión es operado por una sola aerolínea. Confirma o refuta esta hipótesis utilizando las 
# herramientas que aprendiste en capítulos anteriores.

aviones_carrier <- flights |>
  filter(!is.na(tailnum)) |> 
  group_by(tailnum) |>
  summarize(n_carriers = n_distinct(carrier)) |>
  filter(n_carriers > 1)
# rpta:La hipótesis se refuta; hay aviones compartidos o transferidos entre aerolíneas.

# 6.Agregue la latitud y la longitud del aeropuerto de origen yflights destino a . 
# ¿Es más fácil renombrar las columnas antes o después de la unión?
# Preparar tablas con nombres claros
aeropuertos_ubicacion <- airports |> select(faa, lat, lon)

vuelos_con_ubicacion <- flights |> 
  # Primera unión para el origen
  left_join(aeropuertos_ubicacion, by = c("origin" = "faa")) |> 
  rename(lat_orig = lat, lon_orig = lon) |> 
  # Segunda unión para el destino
  left_join(aeropuertos_ubicacion, by = c("dest" = "faa")) |> 
  rename(lat_dest = lat, lon_dest = lon)


# 7. Calcula el retraso promedio por destino y luego combina los airportsdatos para mostrar 
# la distribución espacial de los retrasos. Aquí tienes una forma sencilla de dibujar un mapa 
# de Estados Unidos:

retraso_destinos <- flights |> 
  group_by(dest) |> 
  summarize(retraso_prom = mean(arr_delay, na.rm = TRUE)) |> 
  inner_join(airports, by = c("dest" = "faa"))

# Dibujar el mapa
retraso_destinos |> 
  ggplot(aes(x = lon, y = lat, color = retraso_prom)) +
  borders("state") +
  geom_point() +
  coord_quickmap() +
  scale_color_gradient(low = "blue", high = "red") # Azul = poco retraso, Rojo = mucho


# 8.¿Qué ocurrió el 13 de junio de 2013? Dibuja un mapa de los retrasos y luego usa 
# Google para compararlo con la información meteorológica.


vuelos_13_junio <- flights |> 
  filter(year == 2013, month == 6, day == 13) |> 
  group_by(dest) |> 
  summarize(retraso_prom = mean(arr_delay, na.rm = TRUE)) |> 
  inner_join(airports, by = c("dest" = "faa"))

vuelos_13_junio |> 
  ggplot(aes(x = lon, y = lat, size = retraso_prom, color = retraso_prom)) +
  borders("state") +
  geom_point() +
  coord_quickmap()
# rpta:El caso del 13 de junio demuestra que los datos de aviación son, en realidad, 
# un reflejo de eventos climáticos a gran escala.






