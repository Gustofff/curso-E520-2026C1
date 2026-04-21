library(palmerpenguins)
# 1.¿Cuántas filas tiene penguins? ¿Cuántas columnas?
nrow(penguins)
ncol(penguins)
# 2.¿Qué describe la bill_depth_mmvariable en el penguinsmarco de datos? 
#Consulta la ayuda para ?penguinsaveriguarlo.
?penguins
#bill_dep numeric, bill depth (millimeters) describe la profundidad del pico del 
#pingüino, expresada en milímetros.
# 3.Crea un diagrama de dispersión de bill_depth_mmvs.  bill_length_mm. 
#Es decir, crea un diagrama de dispersión con bill_depth_mm en el eje y 
#y bill_length_mmen el eje x. Describe la relación entre estas dos variables.
ggplot(
  data = penguins,
  mapping = aes(x = bill_length_mm, y = bill_depth_mm)
) + 
  geom_point(aes(color = species, shape = species)) +
  geom_smooth(method = "lm", aes(color = species)) +
  labs(
    title = "Bill length and bill depth",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins", 
    x = "Bill length (mm)", 
    y = "Bill depth (mm)",
    color = "Species", 
    shape = "Species"
  )
#rpta: El modelo revela que existe una correlación positiva entre el 
#largo y la profundidad del pico, lo que sugiere que estas dimensiones crecen 
#de manera proporcional dentro de cada grupo taxonómico.               
#4.¿Qué sucede si haces un diagrama de dispersión de speciesvs.  bill_depth_mm? 
#¿Cuál podría ser una mejor opción de geom?
ggplot(data = penguins, mapping = aes(x = species, y = bill_depth_mm)) +
  geom_point(aes(color = species, shape = species))
# a.Los puntos se alinean en franjas verticales porque 
#la variable species solo tiene tres valores posibles. 
#Esto hace que sea casi imposible saber cuántos pingüinos 
#hay en los niveles donde el color es más sólido
ggplot(data = penguins, mapping = aes(x = species, y = bill_depth_mm)) +
  geom_boxplot(aes(fill = species), alpha = 0.7) +
  labs(
    title = "Distribución de la profundidad del pico por especie",
    subtitle = "Comparativa de dispersión y medianas",
    x = "Especie",
    y = "Profundidad del pico (mm)",
    fill = "Especie"
  ) +
  theme_minimal()
# b.El boxplot es más útil al diagrama de dispersión para variables categóricas 
#porque permite comparar no solo la posición (dónde están los datos), sino 
#también la concentración y la asimetría de cada grupo de forma objetiva, 
#resaltando automáticamente los valores atípicos que requieren atención especial.
# 5. ¿Por qué se produce el siguiente error y cómo lo solucionarías?
ggplot(data = penguins) + 
  geom_point()
#rpta: a. No se específico qué columna va en el eje X y cuál en el eje Y y se dejo 
#el paréntesis de ggplot() vacío
# Para arreglarlo, debemos asegurarnos de que las coordenadas x y y estén declaradas,
#ya sea de forma global (dentro de ggplot) o local (dentro de geom_point).
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point()
# 6.¿Qué hace el na.rmargumento en geom_point()? 
#¿Cuál es el valor predeterminado del argumento? 
#Crea un diagrama de dispersión donde uses correctamente este argumento configurado en TRUE.
#El argumento na.rm en geom_point() controla si R debe mostrar una advertencia cuando 
#hay valores faltantes (NA) en los datos. 
#Al establecerlo en TRUE, se eliminan los valores faltantes de forma silenciosa, 
#evitando que aparezcan mensajes de advertencia en el reporte final.
#El valor predeterminado (por defecto) de los argumentos que 
#terminan en rm (como na.rm en geom_point(), mean(), sum(), etc.) es FALSE. 
ggplot(data = penguins, 
       mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point(na.rm = TRUE, aes(color = species)) +
  labs(
    title = "Relación entre longitud del pico y masa corporal",
    subtitle = "Gráfico limpio de advertencias usando na.rm = TRUE",
    x = "Longitud del pico (mm)",
    y = "Masa corporal (g)"
  )
penguins |> 
  filter(is.na(bill_length_mm) | is.na(body_mass_g))
# 7.Añade el siguiente título al gráfico que hiciste en el ejercicio 
#anterior: “Los datos provienen del paquete palmerpenguins”. 
#Sugerencia: Consulta la documentación de labs().
ggplot(data = penguins, 
       mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point(na.rm = TRUE, aes(color = species)) +
  labs(
    title = "Relación entre longitud del pico y masa corporal",
    subtitle = "Gráfico limpio de advertencias usando na.rm = TRUE",
    x = "Longitud del pico (mm)",
    y = "Masa corporal (g)",
    caption = "Los datos provienen del paquete palmerpenguins" # Aquí añadimos la fuente
  )
# 8.¿A qué estética se le debe bill_depth_mmasignar? 
#¿Y se debe asignar a nivel global o a nivel geométrico?
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = bill_depth_mm)) +
  geom_smooth()
# rpta: a.Se le debe asignar a la estética color 
# b. Se debe asignar a nivel geométrico (dentro de geom_point()).
# Al ponerlo solo en geom_point(), los puntos se pintan según su profundidad,
# pero geom_smooth() sigue calculando una única línea de tendencia para todos los datos, 
#tal como se ve en la imagen que quieres recrear.
#9.
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = island)
) +
  geom_point() +
  geom_smooth(se = FALSE)
#10 
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point() +
  geom_smooth()


ggplot() +
  geom_point(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  ) +
  geom_smooth(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  )
# rpta: No se ven diferentes. Esto se debe a que ggplot2 permite
#definir los mapeos de forma global (en la función principal) o local 
#(en cada geom). Dado que en ambos bloques de código se están utilizando las mismas 
#variables para los mismos objetos geométricos, el resultado visual es el mismo, 
#aunque el primer método es preferible por ser más eficiente y menos propenso a errores.  





