# Preparación de la refactorización

# Descargar los archivos que se encuentran en la siguiente liga:
# https://www.coneval.org.mx/Medicion/MP/Documents/Programas_calculo_pobreza_18/R_2018.zip

# Automáticamente crea el directorio "R_2018" en donde se encuentran los demás
# documentos. Convertiremos todos los archivos dbf a rds.

# Primero, creamos los directorios en donde trabajaremos:
dir.create("bases_de_datos")
dir.create("bases")
dir.create("base_final")

# Luego, importamos los dbf y los transformamos a rds.
library(foreign)

a = read.dbf("R_2018/Bases de datos/concentradohogar.dbf", as.is = T)
saveRDS(a, "bases_de_datos/concentradohogar.rds")

b = read.dbf("R_2018/Bases de datos/gastoshogar.dbf", as.is = T)
saveRDS(b, "bases_de_datos/gastoshogar.rds")

c = read.dbf("R_2018/Bases de datos/gastospersona.dbf", as.is = T)
saveRDS(c, "bases_de_datos/gastospersona.rds")

d = read.dbf("R_2018/Bases de datos/hogares.dbf", as.is = T)
saveRDS(d, "bases_de_datos/hogares.rds")

e = read.dbf("R_2018/Bases de datos/ingresos.dbf", as.is = T)
saveRDS(e, "bases_de_datos/ingresos.rds")

f = read.dbf("R_2018/Bases de datos/poblacion.dbf", as.is = T)
saveRDS(e, "bases_de_datos/poblacion.rds")

g = read.dbf("R_2018/Bases de datos/trabajos.dbf", as.is = T)
saveRDS(e, "bases_de_datos/trabajos.rds")

h = read.dbf("R_2018/Bases de datos/viviendas.dbf", as.is = T)
saveRDS(e, "bases_de_datos/viviendas.rds")

# Comprobamos archivos
list.files("bases_de_datos/")

# Finalmente, copiamos los documentos de referencia al directorio principal
# o en su propio directorio.

rm(list = ls())
gc()

