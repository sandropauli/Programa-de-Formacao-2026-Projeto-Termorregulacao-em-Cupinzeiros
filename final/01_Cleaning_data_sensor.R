#####################################################################
# Script: 01_Cleaning_data_sensor
# Projeto: Comparação da estabilidade térmica de cupinzeiros em gradientes de dossel do Cerrado
#
# Kathleen Mahra, Kathleen Sena, Matheus Siebra, Sandro Pauli, Sofia Schirmer
# 
# This script aims to process temperature data collected in the field.
# First, the raw temperature data are loaded and plotted.
# Next, the transient period is removed according to a predefined cutoff time.
# Finally, the remaining data are resampled into 20-minute averages. #

# Loading packages#####################################################################
library(tidyverse)
library(plotly)

# 1. Settings and Exact File List
diretorio_base <- "seu diretório"
arquivos <- c(
  "0713_P1_1CA_T1.CSV", "0715_P8_3MA_T1.CSV", "0716_P3_2CA.CSV", 
  "0716_P9_3CA.CSV", "0717_P10_4CA_T2.CSV", "0717_P11_5CA_T1.CSV", 
  "0718_P6_1MA_T2.CSV", "0718_P7_2MA_T1.CSV", "0721_P12_4MA_T1.CSV", 
  "0721_P13_5MA_T2.CSV"
)

# 2. Loop to Generate a Plot for Each File
for (nome_arquivo in arquivos) {
  caminho_arquivo <- file.path(diretorio_base, nome_arquivo)
  
  if (file.exists(caminho_arquivo)) {
    # Load data (Automatically handles mixed delimiters and comma as decimal mark)
    df <- read_delim(caminho_arquivo, show_col_types = FALSE, 
                     locale = locale(decimal_mark = ","))
    
    # Date and Time Processing (using lubridate)
    # Note: ymd_hms assumes Year/Month/Day. If your CSV uses Day/Month/Year, change to dmy_hms
    df <- df %>%
      mutate(DataHora = ymd_hms(paste(Data, Hora))) 
    
    # Plot the T2(C) temperature column if it exists
    if ("T2(C)" %in% colnames(df)) {
      p <- plot_ly(df, x = ~DataHora, y = ~`T2(C)`, type = 'scatter', mode = 'lines', 
                   name = 'T2(C)') %>%
        layout(
          title = paste("Raw Temperature Analysis: <b>", nome_arquivo, "</b>"),
          yaxis = list(title = "Temperature (°C)"),
          xaxis = list(title = "Time"),
          hovermode = "x unified"
        )
      print(p) # Display in the RStudio Viewer
    }
  } else {
    message(paste("Warning: File", nome_arquivo, "not found."))
  }
}


#########################################
# Step 2: Remove Transient Data         #
#########################################

# Dictionary mapping each file (named list in R)
arquivos_horarios <- c(
  "0713_P1_1CA_T1.CSV" = "10:48:00",
  "0715_P8_3MA_T1.CSV" = "11:15:00",
  "0716_P3_2CA.CSV" = "10:35:00",
  "0716_P9_3CA.CSV" = "11:07:00",
  "0717_P10_4CA_T2.CSV" = "12:18:00",
  "0717_P11_5CA_T1.CSV" = "12:22:00",
  "0718_P6_1MA_T2.CSV" = "11:35:00",
  "0718_P7_2MA_T1.CSV" = "12:15:00",
  "0721_P12_4MA_T1.CSV" = "12:30:00",
  "0721_P13_5MA_T2.CSV" = "09:25:00"
)

# LOOP: Process, Plot, and Save
for (nome_arquivo in names(arquivos_horarios)) {
  horario_corte_str <- arquivos_horarios[[nome_arquivo]]
  caminho_arquivo <- file.path(diretorio_base, nome_arquivo)
  
  message("\nProcessando: ", nome_arquivo, " | Horário de corte: ", horario_corte_str)
  
  if (file.exists(caminho_arquivo)) {
    df <- read_delim(caminho_arquivo, show_col_types = FALSE, 
                     locale = locale(decimal_mark = ","))
    
    df <- df %>% mutate(DataHora_Temp = ymd_hms(paste(Data, Hora)))
    
    # Find the first day and set the exact cutoff time
    primeiro_dia <- as.Date(df$DataHora_Temp[1])
    momento_corte <- ymd_hms(paste(primeiro_dia, horario_corte_str))
    
    # Filter
    df_filtrado <- df %>% filter(DataHora_Temp >= momento_corte)
    
    # PLOT TO CHECK THE CUTOFF
    coluna_temp <- if("T2(C)" %in% colnames(df_filtrado)) "T2(C)" else if("T1(C)" %in% colnames(df_filtrado)) "T1(C)" else NULL
    
    if(!is.null(coluna_temp)) {
      p <- plot_ly(df_filtrado, x = ~DataHora_Temp, y = ~.data[[coluna_temp]], 
                   type = 'scatter', mode = 'lines') %>%
        layout(title = paste("CUT Series:", nome_arquivo))
      print(p)
    }
    
    # Remove temporary column before saving
    df_filtrado <- df_filtrado %>% select(-DataHora_Temp)
    
    novo_nome_arquivo <- paste0("cut_", nome_arquivo)
    novo_caminho <- file.path(diretorio_base, novo_nome_arquivo)
    
    # Save (Converting decimal separator to '.' as in the original Python code)
    write_csv(df_filtrado, novo_caminho)
    
    message("-> Saved as: ", novo_nome_arquivo)
    message(sprintf("-> Original rows: %d | Preserved: %d | Removed: %d", 
                    nrow(df), nrow(df_filtrado), nrow(df) - nrow(df_filtrado)))
    
  } else {
    message("-> WARNING: File not found.")
  }
}
message("\nCutoff process completed!")


##################################################
# Step 3: Resampling (20-Minute Averages)       #
##################################################

# SETTINGS
padrao_arquivos <- list.files(diretorio_base, pattern = "^cut_.*\\.CSV$", full.names = TRUE)
margem_aceitavel <- 20

# LOOP: Calculate Averages, Plot, and Save
for (caminho_arquivo in padrao_arquivos) {
  nome_arquivo <- basename(caminho_arquivo)
  message("\nProcessando médias para: ", nome_arquivo)
  
  # 1. Load the data
  df <- read_csv(caminho_arquivo, show_col_types = FALSE)
  
  # 2. Create datetime
  df <- df %>% mutate(DataHora = ymd_hms(paste(Data, Hora)))
  
  # 3. Time adjustment (-10 min) and grouping
  df_media <- df %>%
    mutate(DataHora_Shifted = DataHora - minutes(10),
           Periodo = floor_date(DataHora_Shifted, "20 mins")) %>%
    group_by(Periodo) %>%
    summarise(
      across(where(is.numeric), ~ mean(.x, na.rm = TRUE)),
      Contagem = n(), # Equivalent to the .count() function in Pandas
      .groups = "drop"
    ) %>%
    filter(!is.na(Periodo)) # Remove empty groups
  
  # 4. Logic for discarding incomplete intervals at the beginning and end
  if (nrow(df_media) > 0) {
    tamanho_maximo <- max(df_media$Contagem, na.rm = TRUE)
    limite_minimo <- tamanho_maximo - margem_aceitavel
    
    # Check the first row
    if (df_media$Contagem[1] < limite_minimo) {
      df_media <- df_media[-1, ]
      message("-> First average discarded (incomplete).")
    }
    
    # Check the last row
    n_linhas <- nrow(df_media)
    if (n_linhas > 0 && df_media$Contagem[n_linhas] < limite_minimo) {
      df_media <- df_media[-n_linhas, ]
      message("-> Last average discarded (incomplete).")
    }
  }
  
  # 5. Restore the actual time (+20 min) and recreate Date and Time columns
  df_media <- df_media %>%
    mutate(DataHora_Final = Periodo + minutes(20),
           Data = format(DataHora_Final, "%Y/%m/%d"),
           Hora = format(DataHora_Final, "%H:%M:%S")) %>%
    mutate(across(where(is.numeric), ~ round(.x, 2)))
  
  # PLOT TO CHECK THE AVERAGES
  coluna_temp <- if("T2(C)" %in% colnames(df_media)) "T2(C)" else if("T1(C)" %in% colnames(df_media)) "T1(C)" else NULL
  
  if(!is.null(coluna_temp) && nrow(df_media) > 0) {
    p <- plot_ly(df_media, x = ~DataHora_Final, y = ~.data[[coluna_temp]], 
                 type = 'scatter', mode = 'lines+markers') %>%
      layout(title = paste("20-Minute Average:", nome_arquivo))
    print(p)
  }
  
  # 6. Clean auxiliary columns and organize the order for saving
  df_salvar <- df_media %>%
    select(Data, Hora, everything(), -Periodo, -Contagem, -DataHora_Final)
  
  novo_nome_arquivo <- paste0("mean20_", str_replace(nome_arquivo, "cut_", ""))
  novo_caminho <- file.path(diretorio_base, novo_nome_arquivo)
  
  write_csv(df_salvar, novo_caminho)
  
  message("-> Salvo como: ", novo_nome_arquivo, " | Total de médias: ", nrow(df_salvar))
}

message("\nProcessing completed!")