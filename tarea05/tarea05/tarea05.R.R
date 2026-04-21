#cargamos librerias
library(tidyverse)
library(lubridate)
library(readr)
library(dplyr)
library(ggplot2)
library(janitor)
#importamos

anac_2019 <- read_csv2(file.choose())
anac_2020 <- read_csv2(file.choose())
anac_2021 <- read_csv2(file.choose())
anac_2022 <- read_csv2(file.choose())
anac_2023 <- read_csv2(file.choose())
anac_2024 <- read_csv2(file.choose())
anac_2025 <- read_csv2(file.choose())

lista_tablas <- list(anac_2019, anac_2020, anac_2021, anac_2022, anac_2023, anac_2024, anac_2025)

vuelos_total <- lista_tablas %>%
  map(~ mutate(.x, across(everything(), as.character))) %>%
  bind_rows() %>%
  clean_names()

colnames(vuelos_total)
vuelos_total <- bind_rows(anac_2019, anac_2020, anac_2021, anac_2022, anac_2023, anac_2024, anac_2025)

#convertimos la columna fecha y creamos el resumen
vuelos_mensual <- vuelos_total %>%
  mutate(fecha_dt = as.Date(fecha)) %>% 
  group_by(mes_anio = floor_date(fecha_dt, "month")) %>%
  summarise(cantidad = n())

print(colnames(vuelos_total))

vuelos_mensual <- vuelos_total %>%
  mutate(fecha_dt = dmy(fecha_utc)) %>% # Usamos dmy() porque ANAC suele venir como día-mes-año
  group_by(mes_anio = floor_date(fecha_dt, "month")) %>%
  summarise(cantidad = n())
#generamos el gráfico final

ggplot(vuelos_mensual, aes(x = mes_anio, y = cantidad)) +
  geom_line(color = "darkblue", size = 1) +
  labs(title = "Evolución Mensual de Vuelos en Argentina (2019-2025)",
       subtitle = "Impacto y Recuperación Pandemia COVID-19",
       x = "Año", y = "Cantidad de Vuelos") +
  theme_minimal()


#Respuestas

#1.¿Qué se observa en la pandemia?
#En el gráfico se observa una caída abrupta y casi vertical a comienzos de 2020.
#El volumen de vuelos mensuales pasó de aproximadamente 50,000 a menos de 5,000 en 
#el momento más crítico (abril/mayo 2020). Esto representa una parálisis casi total de 
#la industria comercial debido a las restricciones sanitarias y el cierre de fronteras.
#2.¿Cuánto tiempo se tarda en recuperar flujos pre-pandemia?
#Si observamos la línea de base de 2019 (cerca de los 50,000 vuelos), 
#la serie muestra que la recuperación no fue inmediata. Recién hacia finales de 2023 y 
#principios de 2024 la curva vuelve a consolidarse de manera sostenida por encima de los 
#niveles previos a la crisis. Esto indica un periodo de recuperación de aproximadamente 3 a 4 años.
#3.¿Diferencias en los patrones?
#Antes de la pandemia, la serie mostraba una estabilidad relativa. En la fase de recuperación 
#(2021-2023), se observa una pendiente de crecimiento positiva constante pero con mayor 
#volatilidad. Además, los picos estacionales (vacaciones de verano e invierno) parecen 
#haberse acentuado en los últimos años, lo que sugiere un cambio en la dinámica de viajes 
#post-pandemia, posiblemente traccionada por el turismo interno.






























































