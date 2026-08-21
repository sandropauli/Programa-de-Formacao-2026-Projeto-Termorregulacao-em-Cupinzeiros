#####################################################################
# Script: 02_Canopy_and_understory_analysis
# Projeto: Comparação da estabilidade térmica de cupinzeiros em gradientes de dossel do Cerrado
#
# Kathleen Mahra, Kathleen Sena, Matheus Siebra, Sandro Pauli, Sofia Schirmer
# 
# This script aims to measure canopy and understory cover. 
# First, the image resolution (number of pixels) is reduced to decrease processing time. 
# Next, the canopy and understory cover measurements are performed.
# Before starting the analyses, the canopy image files must follow the naming convention P01_dos, P02_dos, P03_dos, and so on. 
# The understory image files must follow the naming convention P01_sub1, P01_sub2, P01_sub3, P01_sub4, P02_sub1, P02_sub2, and so forth.

# Loading packages

library(bwimage)
library(ggplot2)
library(magick)

#### Understory ####

#directory with the original images
setwd("seu diretorio")

#creates a folder to store the reduced images
if (!dir.exists("reduced_img")) dir.create("reduced_img")

(files_names= dir())

for(i in seq_along(files_names)){

  img <- image_read(files_names[i])

  img_red <- image_resize(img, "500")

  image_write(
    img_red,
    path = paste0("reduced_img/", basename(files_names[i])) 
  )                                                         
}

#directory with the reduced images
setwd("seu diretório")

(files_names= dir())

image_processing <- function(i, channel = "b") {
  img <- threshold_color(
    filename = files_names[i],
    channel = channel
  )

  image(
    t(img)[, nrow(img):1],
    col = c("white", "black"),
    xaxt = "n",
    yaxt = "n"
  )

  return(img)
}

understory_cover <- function(channel = "b",
                               arquivo_saida = "understory_data.csv") {

  # Image processing
  imagens <- lapply(seq_along(files_names), function(i) {
    image_processing(i, channel = channel)
  })

  # Calculates the understory cover
  cobertura <- sapply(imagens, denseness_total)

  # Mean of the images
  cobertura_media <- tapply(
    cobertura,
    ceiling(seq_along(cobertura) / 4),
    mean
  )

  # Creates the data frame
  dados <- data.frame(
    point = paste0("P", seq_along(cobertura_media)),
    cobertura_subbosque = as.numeric(cobertura_media)
  )

  # Saves the CSV
  write.table(
    dados,
    file = arquivo_saida,
    sep = "\t",
    row.names = FALSE
  )

  return(dados)
}

data_usc <- understory_cover(
  channel = "b",
  arquivo_saida = "understory_cover.csv"
)

#### Canopy ####

#directory with the original images
setwd("seu diretorio")

## Reducing the pixels of the images 

#creates a folder to store the reduced images
if (!dir.exists("reduced_img")) dir.create("reduced_img")

(files_names= dir())

for(i in seq_along(files_names)){

  img <- image_read(files_names[i])

  img_red <- image_resize(img, "500")

  image_write(
    img_red,
    path = paste0("reduced_img/", basename(files_names[i]))
  )
}

#directory with the reduced images
setwd("seu diretorio/reduced_img")

(files_names= dir())

image_processing <- function(i, channel = "b") {
  img <- threshold_color(
    filename = files_names[i],
    channel = channel
  )

  image(
    t(img)[, nrow(img):1],
    col = c("white", "black"),
    xaxt = "n",
    yaxt = "n"
  )

  return(img)
}

canopy_cover <- function(channel = "b",
                               arquivo_saida = "dossel_data.csv") {

  # Image processing
  imagens <- lapply(seq_along(files_names), function(i) {
    image_processing (i, channel = channel)
  })

  # Calculates the canopy cover
  cobertura <- sapply(imagens, denseness_total)

  # Creates data frame
  dados <- data.frame(
    point = paste0("P", seq_along(cobertura)),
    cobertura_dossel = as.numeric(cobertura)
  )

  # Saves the CSV
  write.table(
    dados,
    file = arquivo_saida,
    sep = "\t",
    row.names = FALSE
  )

  return(dados)

  print(dados)
}

data_cc <- canopy_cover()(
  channel = "b",
  arquivo_saida = "canopy_cover.csv"
)

