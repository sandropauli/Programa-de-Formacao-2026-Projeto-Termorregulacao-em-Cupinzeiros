# ==============================================================================
# Script: 05_Statistical_analysis
# Projeto: Comparação da estabilidade térmica de cupinzeiros em gradientes de dossel do Cerrado
#
# Kathleen Mahra, Kathleen Sena, Matheus Siebra, Sandro Pauli, Sofia Schirmer
# 
# This script evaluates the effects of vegetation cover and termite mound
# volume on thermal regulation.
#
# The analyses investigate whether canopy cover, understory cover, and
# termite mound volume are associated with thermal damping and the mean
# absolute temperature difference between T1 and T2.
#
# Section 1 evaluates the effect of vegetation cover:
# - Canopy cover vs. thermal damping ratio
# - Understory cover vs. thermal damping ratio
# - Canopy cover vs. mean absolute temperature difference
# - Understory cover vs. mean absolute temperature difference
#
# Section 2 evaluates the effect of termite mound volume:
# - Mound volume vs. thermal damping ratio
# - Mound volume vs. mean absolute temperature difference
#
# Statistical models:
# - Beta regression is used to evaluate the thermal damping ratio.
# - Linear regression is used to evaluate the mean absolute temperature
#   difference between T1 and T2.
#
# Main response variables:
# Razao_Amortecimento: Thermal damping ratio, calculated as Amp_T2 / Amp_T1.
# Modulo_Delta_T_Medio: Mean absolute temperature difference between T1
#                       and T2 throughout the day.
#
# Main explanatory variables:
# canopy_cover: Percentage of canopy cover.
# understory_cover: Percentage of understory cover.
# mound_volume: Termite mound volume, expressed in liters.
#
# The vegetation type is represented by the variable "vegetation_type"
# and is used to distinguish between Campo_aberto and Mata.
#
# The sampling points are identified using "mound_id".
#
# The script generates three figures:
# Fig1_Amortecimento_vs_Cobertura.png
# Fig2_Modulo_DeltaT_vs_Cobertura.png
# Fig3_Efeito_Volume_Termorregulacao.png
#
# Loading packages
# ==============================================================================

library(ggplot2)
library(ggrepel)
library(patchwork)
library(betareg)

# Global aesthetic settings
cores_ambientes   <- c("Campo_aberto" = "#d95f02", "Mata" = "#2ca02c")
rotulos_ambientes <- c("Campo_aberto" = "Campo", "Mata" = "Mata")
formas_ambientes  <- c("Campo_aberto" = 16, "Mata" = 17)


# ==============================================================================
# Analysis 1: EFFECT OF VEGETATION COVER (CANOPY AND UNDERSTORY) on thermal damping
# ==============================================================================

# --- 1.1 Thermal Damping Ratio ~ canopy cover ---
m1_beta <- betareg(Razao_Amortecimento ~ canopy_cover, data = data_final)
summary_m1 <- summary(m1_beta)

m2_beta <- betareg(Razao_Amortecimento ~ understory_cover, data = data_final)
summary_m2 <- summary(m2_beta)

p1_val <- summary_m1$coefficients$mean["canopy_cover", "Pr(>|z|)"]
r1_sq  <- summary_m1$pseudo.r.squared

p2_val <- summary_m2$coefficients$mean["understory_cover", "Pr(>|z|)"]
r2_sq  <- summary_m2$pseudo.r.squared

label_m1 <- paste0("Beta Regression\nPseudo-R² = ", round(r1_sq, 3), "\np = ", ifelse(p1_val < 0.001, "< 0.001", round(p1_val, 3)))
label_m2 <- paste0("Beta Regression\nPseudo-R² = ", round(r2_sq, 3), "\np = ", ifelse(p2_val < 0.001, "< 0.001", round(p2_val, 3)))

p1_amort_cob <- ggplot(data_final, aes(x = canopy_cover, y = Razao_Amortecimento)) +
  geom_smooth(method = "glm", method.args = list(family = quasibinomial), se = TRUE, color = "gray30", fill = "gray80", alpha = 0.4) +
  geom_point(aes(color = vegetation_type, shape = vegetation_type), size = 3.5, alpha = 0.85) +
  geom_text_repel(aes(label = mound_id), size = 3.5, show.legend = FALSE) +
  annotate("text", x = Inf, y = Inf, label = label_m1, hjust = 1.1, vjust = 1.2, size = 3.8, fontface = "italic") +
  scale_color_manual(values = cores_ambientes, labels = rotulos_ambientes) +
  scale_shape_manual(values = formas_ambientes, labels = rotulos_ambientes) +
  labs(x = "Canopy Cover (%)", y = expression("Thermal Damping"), color = "Vegetation", shape = "Vegetation") +
  theme_classic(base_size = 13)

p2_amort_cob <- ggplot(data_final, aes(x = understory_cover, y = Razao_Amortecimento)) +
  geom_smooth(method = "glm", method.args = list(family = quasibinomial), se = TRUE, color = "gray30", fill = "gray80", alpha = 0.4) +
  geom_point(aes(color = vegetation_type, shape = vegetation_type), size = 3.5, alpha = 0.85) +
  geom_text_repel(aes(label = mound_id), size = 3.5, show.legend = FALSE) +
  annotate("text", x = Inf, y = Inf, label = label_m2, hjust = 1.1, vjust = 1.2, size = 3.8, fontface = "italic") +
  scale_color_manual(values = cores_ambientes, labels = rotulos_ambientes) +
  scale_shape_manual(values = formas_ambientes, labels = rotulos_ambientes) +
  labs(x = "Understory Cover (%)", y = NULL, color = "Vegetation", shape = "Vegetation") +
  theme_classic(base_size = 13)

figura_amortecimento_beta <- p1_amort_cob + p2_amort_cob + 
  plot_layout(guides = "collect") + 
  plot_annotation(tag_levels = "A") &
  theme(legend.position = "bottom")

ggsave("Fig1_Amortecimento_vs_Cobertura.png", plot = figura_amortecimento_beta, width = 10, height = 5, dpi = 300)


# --- Mean Absolute Delta T  ~ canopy cover ---
m1_delta <- lm(Modulo_Delta_T_Medio ~ canopy_cover, data = data_final)
summary_m1_delta <- summary(m1_delta)

m2_delta <- lm(Modulo_Delta_T_Medio ~ understory_cover, data = data_final)
summary_m2_delta <- summary(m2_delta)

p1_val_d <- summary_m1_delta$coefficients[2, 4]
r1_sq_d  <- summary_m1_delta$r.squared

p2_val_d <- summary_m2_delta$coefficients[2, 4]
r2_sq_d  <- summary_m2_delta$r.squared

label_m1_d <- paste0("R² = ", round(r1_sq_d, 3), "\np = ", ifelse(p1_val_d < 0.001, "< 0.001", round(p1_val_d, 3)))
label_m2_d <- paste0("R² = ", round(r2_sq_d, 3), "\np = ", ifelse(p2_val_d < 0.001, "< 0.001", round(p2_val_d, 3)))

p1_delta_cob <- ggplot(data_final, aes(x = canopy_cover, y = Modulo_Delta_T_Medio)) +
  geom_smooth(method = "lm", se = TRUE, color = "gray30", fill = "gray80", alpha = 0.4) +
  geom_point(aes(color = vegetation_type, shape = vegetation_type), size = 3.5, alpha = 0.85) +
  geom_text_repel(aes(label = mound_id), size = 3.5, show.legend = FALSE) +
  annotate("text", x = Inf, y = Inf, label = label_m1_d, hjust = 1.1, vjust = 1.2, size = 3.8, fontface = "italic") +
  scale_color_manual(values = cores_ambientes, labels = rotulos_ambientes) +
  scale_shape_manual(values = formas_ambientes, labels = rotulos_ambientes) +
  labs(x = "Canopy Cover (%)", y = expression("|" * Delta * "T" * "| Daily Mean (°C)"), color = "Vegetation", shape = "Vegetation") +
  theme_classic(base_size = 13)

p2_delta_cob <- ggplot(data_final, aes(x = understory_cover, y = Modulo_Delta_T_Medio)) +
  geom_smooth(method = "lm", se = TRUE, color = "gray30", fill = "gray80", alpha = 0.4) +
  geom_point(aes(color = vegetation_type, shape = vegetation_type), size = 3.5, alpha = 0.85) +
  geom_text_repel(aes(label = mound_id), size = 3.5, show.legend = FALSE) +
  annotate("text", x = Inf, y = Inf, label = label_m2_d, hjust = 1.1, vjust = 1.2, size = 3.8, fontface = "italic") +
  scale_color_manual(values = cores_ambientes, labels = rotulos_ambientes) +
  scale_shape_manual(values = formas_ambientes, labels = rotulos_ambientes) +
  labs(x = "Understory Cover (%)", y = NULL, color = "Vegetation", shape = "Vegetation") +
  theme_classic(base_size = 13)

figura_modulo_delta_t <- p1_delta_cob + p2_delta_cob + 
  plot_layout(guides = "collect") + 
  plot_annotation(tag_levels = "A") &
  theme(legend.position = "bottom")

ggsave("Fig2_Modulo_DeltaT_vs_Cobertura.png", plot = figura_modulo_delta_t, width = 10, height = 5, dpi = 300)


# ==============================================================================
# Analysis 2: EFFECT OF TERMITE MOUND VOLUME (THERMAL DAMPING + DELTA T)
# ==============================================================================

# --- Thermal Damping Ratio ~ Mound Volume  ---
m1_beta_vol <- betareg(Razao_Amortecimento ~ mound_volume, data = data_final)
summary_m1_vol <- summary(m1_beta_vol)

p1_val_vol <- summary_m1_vol$coefficients$mean["mound_volume", "Pr(>|z|)"]
r1_sq_vol  <- summary_m1_vol$pseudo.r.squared

label_m1_vol <- paste0("Beta Regression\nPseudo-R² = ", round(r1_sq_vol, 3), "\np = ", ifelse(p1_val_vol < 0.001, "< 0.001", round(p1_val_vol, 3)))

p1_amort_vol <- ggplot(data_final, aes(x = mound_volume, y = Razao_Amortecimento)) +
  geom_smooth(method = "glm", method.args = list(family = quasibinomial), se = TRUE, color = "gray30", fill = "gray80", alpha = 0.4) +
  geom_point(aes(color = vegetation_type, shape = vegetation_type), size = 3.5, alpha = 0.85) +
  geom_text_repel(aes(label = mound_id), size = 3.5, show.legend = FALSE) +
  annotate("text", x = Inf, y = Inf, label = label_m1_vol, hjust = 1.1, vjust = 1.2, size = 3.8, fontface = "italic") +
  scale_color_manual(values = cores_ambientes, labels = rotulos_ambientes) +
  scale_shape_manual(values = formas_ambientes, labels = rotulos_ambientes) +
  labs(
    x = expression("Termite Mound Volume (L)"),
    y = expression("Thermal Damping"),
    color = "Vegetation", shape = "Vegetation"
  ) +
  theme_classic(base_size = 13)


# --- Mean Absolute Delta T ~ Mound Volume ---
m_delta_vol <- lm(Modulo_Delta_T_Medio ~ mound_volume, data = data_final)
summary_m_vol <- summary(m_delta_vol)

p_val_vol <- summary_m_vol$coefficients["mound_volume", "Pr(>|t|)"]
r_sq_vol  <- summary_m_vol$r.squared

label_delta_vol <- paste0("R² = ", round(r_sq_vol, 3), "\np = ", ifelse(p_val_vol < 0.001, "< 0.001", round(p_val_vol, 3)))

p2_delta_med_vol <- ggplot(data_final, aes(x = mound_volume, y = Modulo_Delta_T_Medio)) +
  geom_smooth(method = "lm", se = TRUE, color = "gray30", fill = "gray80", alpha = 0.4) +
  geom_point(aes(color = vegetation_type, shape = vegetation_type), size = 3.5, alpha = 0.85) +
  geom_text_repel(aes(label = mound_id), size = 3.5, show.legend = FALSE) +
  annotate("text", x = Inf, y = Inf, label = label_delta_vol, hjust = 1.1, vjust = 1.2, size = 3.8, fontface = "italic") +
  scale_color_manual(values = cores_ambientes, labels = rotulos_ambientes) +
  scale_shape_manual(values = formas_ambientes, labels = rotulos_ambientes) +
  labs(
    x = expression("Termite Mound Volume (L)"),
    y = expression("|" * Delta * "T" * "| Daily Mean (°C)"),
    color = "Vegetation", shape = "Vegetation"
  ) +
  theme_classic(base_size = 13)

figura_volume <- p1_amort_vol + p2_delta_med_vol + 
  plot_layout(guides = "collect") + 
  plot_annotation(tag_levels = "A") &
  theme(legend.position = "bottom")

print(figura_volume)

ggsave("Fig3_Efeito_Volume_Termorregulacao.png", plot = figura_volume, width = 10, height = 5, dpi = 300)
