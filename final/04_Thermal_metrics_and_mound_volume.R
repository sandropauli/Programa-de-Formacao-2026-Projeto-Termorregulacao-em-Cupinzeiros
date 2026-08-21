#####################################################################
# Script: 04_Thermal_metrics_and_mound_volume
# Projeto: Comparação da estabilidade térmica de cupinzeiros em gradientes de dossel do Cerrado
#
# Kathleen Mahra, Kathleen Sena, Matheus Siebra, Sandro Pauli, Sofia Schirmer
# 
# This script aims to quantify thermal lag and thermal damping between
# temperature sensors T1 and T2 installed in termite mounds.
# First, the script identifies the sampling point, treatment, and
# environmental type from the file name.
# Next, the first day of valid temperature data is selected for each
# sampling point. Daily thermal amplitudes are calculated for T1 and T2.
# Thermal damping is quantified as the ratio between the thermal
# amplitude of T2 and the thermal amplitude of T1:
#
#     Damping ratio = Amp_T2 / Amp_T1
#
# The script then identifies the temperature peak of T1 during the
# daytime period (08:00–18:00) and searches for the T2 temperature peak
# within a 10-hour window following the T1 peak.
#
# Thermal lag is calculated as the time difference, in minutes, between
# the T1 and T2 temperature peaks.
#
# The script also calculates the absolute temperature difference between
# the T1 and T2 peaks and the mean absolute temperature difference
# throughout the day.
#
# Main variables:
#
# Amp_T1: Daily thermal amplitude of T1.
# Amp_T2: Daily thermal amplitude of T2.
# Razao_Amortecimento: Thermal damping ratio (Amp_T2 / Amp_T1).
# Tempo_Pico_T1: Time of the T1 temperature peak.
# Temp_Max_T1: Maximum T1 temperature.
# Tempo_Pico_T2: Time of the T2 temperature peak.
# Temp_Max_T2: Maximum T2 temperature.
# Atraso_Minutos: Thermal lag between the T1 and T2 temperature peaks,
#                 expressed in minutes.
# Modulo_Delta_T_Pico: Absolute difference between the T1 and T2
#                      temperature peaks (|Max T1 - Max T2|).
# Modulo_Delta_T_Medio: Mean absolute temperature difference between
#                       T1 and T2 throughout the day.
#
# The resulting thermal metrics are joined with the termite mound
# dataset using the treatment/mound identifier.
#
# The final dataset is saved as "Dados_finais.csv".
#
####################################################
# Loading packages
tabela_atrasos<-NULL
for (i in seq_along(dados)) {
  
  df_raw <- dados[[i]]
  
  caminho_arquivo <- arquivos_cut[i]
  nome_arquivo <- basename(caminho_arquivo)
  
  # Identifiers
  id_ponto <- str_extract(nome_arquivo, "P[0-9]+")
  tratamento_codigo <- str_extract(nome_arquivo, "[0-9]*[M|C]A[0-9]*")
  tipo_ambiente <- ifelse(str_detect(tratamento_codigo, "MA"), "Mata", "Campo")
  id_completo <- paste0(id_ponto, "_", tratamento_codigo)
  
  # SAFETY CHECK: If this point has already been processed, skip it
  if (id_completo %in% tabela_atrasos$ID_Completo) next
  
  # Validate columns
  if (!all(c("Data", "Hora", "T1(C)", "T2(C)") %in% names(df_raw))) next
  
  # Process date/time robustly and remove NAs
  df_proc <- df_raw %>%
    mutate(
      DataHora = parse_date_time(paste(Data, Hora), orders = c("ymd HMS", "dmy HMS", "ymd HM", "dmy HM")),
      Data_Date = as.Date(DataHora)
    ) %>%
    filter(!is.na(DataHora), !is.na(`T1(C)`), !is.na(`T2(C)`))
  
  if (nrow(df_proc) == 0) next
  
  # Select strictly the first day
  primeiro_dia <- unique(df_proc$Data_Date)[1]
  df_dia <- df_proc %>% filter(Data_Date == primeiro_dia)
  
  if (nrow(df_dia) < 10) next
  
  # ------------------------------------------------------------------
  # Daily amplitude 
  # ------------------------------------------------------------------
  max_t1_dia <- max(df_dia$`T1(C)`, na.rm = TRUE)
  min_t1_dia <- min(df_dia$`T1(C)`, na.rm = TRUE)
  amp_t1     <- max_t1_dia - min_t1_dia
  
  max_t2_dia <- max(df_dia$`T2(C)`, na.rm = TRUE)
  min_t2_dia <- min(df_dia$`T2(C)`, na.rm = TRUE)
  amp_t2     <- max_t2_dia - min_t2_dia
  
  # Dimensionless thermal damping ratio (A = Amp_T2 / Amp_T1)
  razao_amortecimento <- ifelse(amp_t1 > 0, amp_t2 / amp_t1, NA)
  
  # ------------------------------------------------------------------
  # Calculate temperature peaks, thermal lag and absolute differences
  # ------------------------------------------------------------------
  
  # T1 peak (daytime filter between 08:00 and 18:00)
  df_diurno <- df_dia %>% filter(hour(DataHora) >= 8 & hour(DataHora) <= 18)
  if (nrow(df_diurno) == 0) df_diurno <- df_dia
  
  idx_t1 <- which.max(df_diurno$`T1(C)`)
  tempo_t1 <- df_diurno$DataHora[idx_t1]
  max_t1 <- df_diurno$`T1(C)`[idx_t1]
  
  # T2 peak (expanded window up to 10 hours after T1)
  df_pos_t1 <- df_dia %>% 
    filter(DataHora >= tempo_t1 & DataHora <= (tempo_t1 + hours(10)))
  
  if (nrow(df_pos_t1) > 0) {
    idx_t2 <- which.max(df_pos_t1$`T2(C)`)
    tempo_t2 <- df_pos_t1$DataHora[idx_t2]
    max_t2 <- df_pos_t1$`T2(C)`[idx_t2]
    
    atraso_min <- as.numeric(difftime(tempo_t2, tempo_t1, units = "mins"))
    
    modulo_delta_t_pico  <- abs(max_t1 - max_t2)                      # Absolute difference between temperature peaks (|Max T1 - Max T2|)
    modulo_delta_t_medio <- mean(abs(df_dia$`T1(C)` - df_dia$`T2(C)`)) # Mean absolute temperature difference throughout the day
    
    if (atraso_min >= 0) {
      tabela_atrasos <- bind_rows(
        tabela_atrasos,
        tibble(
          Arquivo = nome_arquivo,
          Ponto = id_ponto,
          Tratamento = tratamento_codigo,
          Tipo_Ambiente = tipo_ambiente,
          ID_Completo = id_completo,
          Data = primeiro_dia,
          Tempo_Pico_T1 = tempo_t1,
          Temp_Max_T1 = max_t1,
          Tempo_Pico_T2 = tempo_t2,
          Temp_Max_T2 = max_t2,
          Amp_T1 = round(amp_t1, 2),
          Amp_T2 = round(amp_t2, 2),
          Atraso_Minutos = round(atraso_min, 2),
          Razao_Amortecimento = round(razao_amortecimento, 4),
          Modulo_Delta_T_Pico = round(modulo_delta_t_pico, 2),    # |Max T1 - Max T2|
          Modulo_Delta_T_Medio = round(modulo_delta_t_medio, 2)   # Mean |T1 - T2| throughout the day
        )
      )
    }
  }
}

# Calculate volume
data <- read.csv("Dados_finais.csv")
names(data)
data$mound_volume <- (2/3) * pi *
  data$mound_height_cm *
  (data$maj_diameter_cm / 2) *
  (data$min_diameter_cm / 2)
# Combine datasets
data <- data[, c(1:10, which(names(data) == "mound_volume"))]
data_final <- data %>%
  left_join(tabela_atrasos, by = c("mound_id" = "Tratamento"))
data_final
write_csv(data_final, "Data_processed.csv")