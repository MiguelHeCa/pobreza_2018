# PROGRAMA PARA LA MEDICIÓN DE LA POBREZA 2018

# Todas las bases de datos del Modelo Estadístico 2018 para la continuidad del 
# MCS-ENIGH pueden ser obtenidas en la página de internet del INEGI,
# www.inegi.org.mx, y están en *.dbf. 

# Previamente, esas bases de datos fueron convertidas a *.rds, cuyo programa
# se encuentra en 'conversion_dbf_a_rds.R'.

# Este programa debe ser utilizado con la versión de R 3.4.1 o superior

# En este programa se utilizan las siguientes bases:
# Base hogares: hogares.rds
# Base población:poblacion.rds
# Base de ingresos: ingresos.rds
# Base de concentrado: concentradohogar.rds
# Base de trabajos: trabajos.rds
# Base de viviendas: viviendas.rds
# Bases de no monetario: gastospersona.rds y gastoshogar.rds

# En este programa se utilizan dos tipos de archivos: 
# * bases originales: es el directorio donde se encuentran las bases del Modelo
# Estadístico 2018 para la continuidad del MCS-ENIGH.
# * bases generadas: se guardan las bases de datos generadas por el programa.
# Estos se ubican en las siguientes carpetas:

# 1) Bases originales: "~/bases_de_datos"
# 2) Bases generadas: "~/bases"

# Se instalan y cargan los paquetes a utilizar en el programa
library(data.table)

# limpiar entorno de trabajo
rm(list = ls())

# Indicadores de Privación Social -----------------------------------------

# I. Carencia por rezago educativo ----------------------------------------

pob = as.data.table(readRDS("bases_de_datos/poblacion.rds"))

# Población objeto: no se incluye a huéspedes ni trabajadores domésticos
poblacion_ = pob[!parentesco %in% c(400:499, 700:799)]

columnas_c = c("asis_esc", "nivelaprob", "gradoaprob", "antec_esc", "hablaind")
poblacion_[, (columnas_c) := lapply(.SD, as.numeric), .SDcols = columnas_c]

# Año de nacimiento
a_med = 2018
poblacion_[, anac_e := a_med - edad]

# Inasistencia escolar (se reporta para personas de 3 años o más)
poblacion_[asis_esc == 1, inas_esc := 0]
poblacion_[asis_esc == 2, inas_esc := 1]

# Nivel educativo
# Primaria incompleta o menos
poblacion_[nivelaprob < 2 |
             (nivelaprob == 2 & gradoaprob < 6), niv_ed := 0]

# Primaria completa o secundaria incompleta
poblacion_[(nivelaprob == 2 & gradoaprob == 6) |
             (nivelaprob == 3 & gradoaprob < 3) |
             (nivelaprob %in% 5:6 & gradoaprob < 3 & antec_esc == 1),
           niv_ed := 1]

# Secundaria completa o mayor nivel educativo
poblacion_[(nivelaprob == 3 & gradoaprob == 3) |
             (nivelaprob == 4) |
             (nivelaprob %in% 5:6 & antec_esc == 1 & gradoaprob >= 3) |
             (nivelaprob %in% 5:6 & antec_esc >= 2) |
             (nivelaprob >= 7),
           niv_ed := 2]

# Indicador de carencia por rezago educativo

# Se considera en situación de carencia por rezago educativo 
# a la población que cumpla con alguno de los siguientes criterios:

# 1. Se encuentra entre los 3 y los 15 años y no ha terminado la educación 
#    obligatoria (secundaria terminada) o no asiste a la escuela.
# 2. Tiene una edad de 16 años o más, su año de nacimiento aproximado es 1981 
#    o anterior, y no dispone de primaria completa.
# 3. Tiene una edad de 16 años o más, su año de nacimiento aproximado es 1982 
#    en adelante, y no dispone de primaria secundaria completa.

poblacion_[(edad >= 3 & edad <= 15) & inas_esc == 1 & (niv_ed %in% 0:1) |
             (edad >= 16) & (anac_e >= 1982) & (niv_ed == 0 | niv_ed == 1) |
             (edad >= 16) & (anac_e <= 1981) & (niv_ed == 0),
           ic_rezedu := 1]
poblacion_[(edad >= 0 & edad <= 2) |
             (edad >= 3 & edad <= 15) & inas_esc == 0 |
             (edad >= 3 & edad <= 15) & inas_esc == 1 & (niv_ed == 2) |
             (edad >= 16) & (anac_e >= 1982) & (niv_ed == 2) |
             (edad >= 16) & (anac_e <= 1981) & (niv_ed == 1 | niv_ed == 2),
           ic_rezedu := 0]

# Población indígena
poblacion_[(edad>=3 & hablaind==1), hli :=  1]
poblacion_[(edad>=3 & hablaind==2), hli :=  0]

selec_col = c("folioviv", "foliohog", "numren", "parentesco", "edad",
              "anac_e", "inas_esc", "niv_ed", "ic_rezedu", "hli")

setorderv(poblacion_, selec_col[1:3])
poblacion_[, ..selec_col]

fwrite(poblacion_, "bases/ic_rezedu18.csv")
saveRDS(poblacion_, "bases/ic_rezedu18.rds")

rm(list = ls())

# II. Carencia por acceso a los servicios de salud ------------------------


# III. Carencia por acceso a la seguridad social --------------------------


# IV. Carencia por calidad y espacios en la vivienda ----------------------


# V. Carencia por acceso a los servicios básicos en la vivienda -----------


# VI. Carencia por acceso a la alimentacion -------------------------------


# VII. Pobreza por Ingresos -----------------------------------------------


# VIII. Pobreza -----------------------------------------------------------





