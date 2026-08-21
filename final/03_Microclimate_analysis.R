#####################################################################
# Script: 03_Microclimate_analysis
# Projeto: Comparação da estabilidade térmica de cupinzeiros em gradientes de dossel do Cerrado
#
# Kathleen Mahra, Kathleen Sena, Matheus Siebra, Sandro Pauli, Sofia Schirmer
# 
# This script aims to calculate microclimate temperature metrics
# from data collected using Tamanduino temperature sensors.
#
# First, the temperature difference between sensors T1 and T2 is calculated.
# Next, descriptive statistics are calculated for each temperature sensor,
# including mean, maximum, minimum, thermal amplitude, standard deviation,
# and coefficient of variation.
# The temperature difference between T1 and T2 is also summarized using
# the same descriptive metrics.
#
# The script processes all CSV files located in the specified folder.
# The sampling point is automatically identified from the file name
# using the pattern "P" followed by a number (e.g., P1, P2, P3).
#
# The final results are combined into a single data frame, rounded to
# three decimal places, and saved as "Metricas_microclima.csv".
#
# Variable definitions:
# T1_mean: Mean temperature recorded by sensor T1.
# T1_max: Maximum temperature recorded by sensor T1.
# T1_min: Minimum temperature recorded by sensor T1.
# T1_thermal_amplitude: Difference between maximum and minimum T1 temperature.
# T1_SD: Standard deviation of temperature recorded by sensor T1.
# T1_CV: Coefficient of variation of T1 temperature (%).
#
# T2_mean: Mean temperature recorded by sensor T2.
# T2_max: Maximum temperature recorded by sensor T2.
# T2_min: Minimum temperature recorded by sensor T2.
# T2_thermal_amplitude: Difference between maximum and minimum T2 temperature.
# T2_SD: Standard deviation of temperature recorded by sensor T2.
# T2_CV: Coefficient of variation of T2 temperature (%).
#
# Delta_T1_T2: Temperature difference between T1 and T2 (T1 - T2).
# Delta_mean: Mean temperature difference between T1 and T2.
# Delta_max: Maximum temperature difference between T1 and T2.
# Delta_min: Minimum temperature difference between T1 and T2.
# Delta_amplitude: Difference between maximum and minimum Delta_T1_T2.
# Delta_SD: Standard deviation of the temperature difference.
# Delta_CV: Coefficient of variation of the temperature difference (%).
##################################
# Loading packages
library(dplyr)
library(lubridate)
library(stringr)

analisa_microclima <- function(dados){
  dados <- dados %>%
    mutate(
      Delta_T1_T2 = T1.C. - T2.C.
    )
  
  metricas <- data.frame(
    T1_media = mean(dados$T1.C., na.rm = TRUE),
    T1_max = max(dados$T1.C., na.rm = TRUE),
    T1_min = min(dados$T1.C., na.rm = TRUE),
    T1_Amplitude_termica = diff(range(dados$T1.C., na.rm = TRUE)),
    T1_SD = sd(dados$T1.C., na.rm = TRUE),
    T1_CV = 100 * sd(dados$T1.C., na.rm = TRUE) /
      mean(dados$T1.C., na.rm = TRUE),
    T2_media = mean(dados$T2.C., na.rm = TRUE),
    T2_max = max(dados$T2.C., na.rm = TRUE),
    T2_min = min(dados$T2.C., na.rm = TRUE),
    T2_Amplitude_termica = diff(range(dados$T2.C., na.rm = TRUE)),
    T2_SD = sd(dados$T2.C., na.rm = TRUE),
    T2_CV = 100 * sd(dados$T2.C., na.rm = TRUE) /
      mean(dados$T2.C., na.rm = TRUE),
    
    Delta_media = mean(dados$Delta_T1_T2, na.rm = TRUE),
    Delta_max = max(dados$Delta_T1_T2, na.rm = TRUE),
    Delta_min = min(dados$Delta_T1_T2, na.rm = TRUE),
    Delta_amplitude = diff(range(dados$Delta_T1_T2, na.rm = TRUE)),
    Delta_SD = sd(dados$Delta_T1_T2, na.rm = TRUE),
    Delta_CV = 100 * sd(dados$Delta_T1_T2, na.rm = TRUE) /
      abs(mean(dados$Delta_T1_T2, na.rm = TRUE))
    
  )
  
  return(metricas)
  
}

# Folder containing the Tamanduino files
pasta <- "C:/Users/mathe/Desktop/Curso de campo Serrapilheira/Dados Tamanduino"


arquivos <- list.files(
  path = pasta,
  pattern = "\\.csv$|\\.CSV$",
  full.names = TRUE
)

resultado_final <- data.frame()

for(arquivo in arquivos){
  
  dados <- read.csv(arquivo)
  metricas <- analisa_microclima(dados)
  nome <- basename(arquivo)
  
  # Ponto: Sampling point identified from the file name
  ponto <- str_extract(nome, "P\\d+")
  
  metricas$Ponto <- ponto
  resultado_final <- bind_rows(resultado_final, metricas)
  
}

resultado_final <- resultado_final %>%
  select(Ponto, everything())

resultado_final <- resultado_final %>%
  mutate(across(where(is.numeric), round, 3))

write.csv(resultado_final,
          "Metricas_microclima.csv",
          row.names = FALSE)