=====================================================================
PROJETO: COMPARAÇÃO DA ESTABILIDADE TÉRMICA DE CUPINZEIROS  EM GRADIENTES DE FITOFISIONOMIAS DO CERRADO - aplicando soluções de hardware aberto em problemas em ecologia


Curso de Campo do Programa de Formação em Ecologia Quantitativa do Instituto Serrapilheira 


Local: Chapada dos Veadeiros, Cavalcante, Goiás, Brasil.


Autores: Kathleen Mahra, Kathleen Sena, Matheus Siebra, Sandro Pauli, Sofia Schirmer


Ano: 2026
=====================================================================


Descrição
----------------
Cupinzeiros atuam como isolantes térmicos, mantendo um ambiente homeostático, em termos de temperatura e umidade, para a atividade dos cupins e seus organismos associados (Ndlovu et al., 2021). Contudo, a estabilidade térmica interna dos cupinzeiros depende de fatores relacionados à sua arquitetura, como também a fatores ambientais externos, como a amplitude térmica do ambiente e a cobertura vegetal (Ndlovu e Pérez-Rodriguez, 2018; Ndlovu et al, 2021). Dessa forma, este projeto tem como objetivo analisar a estabilidade térmica de cupinzeiros do Cerrado por meio de uma comparação da variação diária de temperatura e de umidade do ar e da superfície do solo com a variação interna do cupinzeiro. Para isso, investigamos a relação entre a estabilidade térmica de cupinzeiros de duas fitofisionomias do Cerrado (campo aberto e mata ciliar) e a complexidade da vegetação nos locais em que os cupinzeiros ocorriam, como também a relação entre a estabilidade térmica e os volumes dos cupinzeiros. Nossas perguntas iniciais eram: (i) como a estrutura da vegetação afeta o microclima do interior de cupinzeiros do Cerrado? e (ii) como o volume de cupinzeiros do Cerrado afeta seu microclima interior?. Com base em outros artigos esperávamos que: (i) cupinzeiros em áreas com estrutura de vegetação mais complexa têm menor variação térmica diária, tendo em vista que ambientes mais abertos tendem a apresentar maiores amplitudes térmicas que ambientes fechados e (ii) cupinzeiros com maior volume são melhores isolantes térmicos (perdem/ganham calor mais lentamente) do que os de menor volume, visto que corpos de maior volume possuem uma menor relação superfície/área, tendo menor superfície para trocas de calor. As análises buscam compreender como a temperatura no interior do cupinzeiro varia em relação às condições do ambiente externo, permitindo avaliar a eficiência da estrutura na regulação térmica.


Objetivo
--------------
Investigar a influência de fatores ambientais e estruturais, como a complexidade do dossel, a complexidade do sub-bosque e o volume de cupinzeiros sobre a variação da temperatura interna de cupinzeiros do Cerrado em relação à temperatura externa.


Coleta e processamento de dados
--------------------------------------------------
Foram coletados dados de 5 cupinzeiros de uma área de transição de Cerrado campo limpo na Fazenda Miraflores e 5 cupinzeiros de uma área de mata ciliar na RPPN Vale das Araras. Através de sensores construídos por nós, foram obtidos dados diários de temperatura e umidade dentro e fora dos cupinzeiros em um período de seis dias. Dois sistemas baseados em um Arduino UNO foram construídos, integrando cada: três sensores de temperatura e umidade (DHT-11) instalados na superfície do solo, no ar e no interior do cupinzeiro, um sensor de umidade do solo (HW-080), um relógio de tempo real (RTC DF-1307) e um módulo leitor de cartão SD. Os sensores foram programados para captar a temperatura e a umidade a cada 5 segundos, mas houve desvios. Foram registradas 269440,9 ± 159949,4 (média ±  desvio padrão) medidas por dia de coleta. Posteriormente, os dados foram processados a fim de remover os valores correspondentes ao período de instalação e retirada dos sensores dos cupinzeiros e, então, convertidos em uma média em janelas de 20 minutos. Ao final, obtivemos 65 ± 4,8 medidas.
A fim de avaliar a estabilidade térmica dos cupinzeiros em diferentes complexidades de vegetação e com diferentes volumes, calculamos duas métricas: ΔT e amortecimento. ΔT corresponde à diferença média entre a temperatura externa e a temperatura interna () do cupinzeiro, enquanto o amortecimento corresponde à razão entre a amplitude da temperatura interna e a amplitude da temperatura externa (. Dessa forma, quanto menor o valor de amortecimento, melhor isolante térmico é o cupinzeiro.
Medidas de altura (cm), circunferência maior (cm), circunferência média (cm), circunferência menor (cm), diâmetro maior (cm) e diâmetro menor (cm) foram coletadas para todos os cupinzeiros analisados. A fim de calcular o volume dos cupinzeiros, os valores de altura, diâmetro maior e diâmetro menor foram empregados na equação de volume de um semi-elipsoide: , em que a é a altura, b é o semi-eixo maior e c é o semi-eixo menor. Além de dados estruturais, para cada cupinzeiro foram coletados exemplares de cupins soldados e operários para posterior identificação à nível de família.
Para dados de complexidade ambiental, foram registradas para cada cupinzeiro quatro fotografias da cobertura do dossel e do sub-bosque com o auxílio de um pano branco. Posteriormente, a resolução das fotografias foi reduzida a fim de diminuir o tempo de processamento. Então, as fotografias foram convertidas em pixels pretos e brancos. A cobertura do dossel e do sub-bosque para cada cupinzeiro foi acessada através da média das proporções de pixels pretos de suas respectivas fotografias.
Para a validação dos sensores confeccionados, foi realizado um processo de validação utilizando um sensor comercial (Kestrel 5000), com medidas simultâneas de 10 em 10 minutos dos dados do sensor de temperatura e umidade para posterior comparação. O sensor de umidade do solo também foi validado. Sua calibração foi realizada com solo e água coletados em ambas as fitofisionomias. Para cada 150 g de solo, 10 mL de água foram adicionados e a umidade registrada repetidamente até que o solo saturasse. O processo foi realizado para cada fitofisionomia separadamente.
Uma regressão beta foi empregada a fim de avaliar as relações entre o amortecimento e a cobertura do dossel, o amortecimento e a cobertura do sub-bosque, e o amortecimento e o volume dos cupinzeiros. Nas regressões beta, o amortecimento foi a variável resposta e a cobertura do dossel, a cobertura do sub-bosque e o volume, as variáveis preditoras. Paralelamente, as relações entre ΔT e a cobertura do dossel, ΔT e a cobertura do sub-bosque e ΔT e o volume foram testadas através de uma regressão linear, em que ΔT foi a variável resposta.


Resultados
-----------------
Os cupins coletados dos cupinzeiros analisados no campo aberto e na mata pertencem a duas subfamílias: Nasutitermitinae e Syntermitinae. No campo aberto, coletamos apenas espécimes da subfamília Nasutitermitinae, enquanto na mata coletamos espécimes de ambas as subfamílias.
A análise dos dados processados dos sensores indicam uma menor variação diária na temperatura interna em comparação com a temperatura externa em cupinzeiros de ambas as áreas. A variação diária na umidade também é menor no interior dos cupinzeiros de ambas as áreas, com alta umidade durante o dia. Contudo, a temperatura registrada pelos sensores foi menor na mata do que no campo aberto (do ambiente e no interior dos cupinzeiros), enquanto a umidade foi maior.
Não houve relação significativa entre o amortecimento térmico e a complexidade da vegetação (cobertura do dossel (pseudo-R² = 0,086, p-valor = 0,312) e cobertura do sub-bosque pseudo-R² = 0,085, p-valor = 0,356)), nem entre o amortecimento térmico e o volume do cupinzeiro (pseudo-R² = 0,098, p-valor = 0,333). Embora o efeito seja fraco, cupinzeiros de campo aberto apresentaram menores valores de amortecimento térmico, indicando uma possível maior eficiência em manter estável sua temperatura interna. Os cupinzeiros de ambas as áreas apresentaram volumes aproximados, mas cupinzeiros de campo aberto apresentaram menores valores de amortecimento térmico.
Também não houve relação significativa entre o |ΔT| médio diário e a complexidade da vegetação (cobertura do dossel (R² = 0,187, p-valor = 0,211) e cobertura do sub-bosque (R² = 0,002, p-valor = 0,903)), nem entre o |ΔT| médio diário e o volume do cupinzeiro (R² = 0,003, p-valor = 0,889). Cupinzeiros de campo aberto apresentarem maiores diferenças entre a temperatura interna e a temperatura externa com menor cobertura de dossel. O efeito da cobertura do sub-bosque no |ΔT| médio diário é muito baixo, assim como o efeito do volume do cupinzeiro no |ΔT| médio diário. 


Estrutura do repositório
-------------------------------------
O projeto está organizado da seguinte forma:
* data: dados brutos coletados pelos sensores (raw) e tratados (processed). Os nomes dos arquivos indicam o mês, o dia, o ponto, o cupinzeiro e o sensor (exemplo - “0713_P1_1CA_T1.CSV”);
* figures: gráficos produzidos pelas regressões beta (“Fig1_Amortecimento_vs_Cobertura.png”) e regressões lineares (“Fig2_Modulo_DeltaT_vs_Cobertura.png”; “Fig3_Efeito_Volume_Termorregulacao.pg”);
* output: resultados finais (“Final_data.csv”) e metadados (“Metadata.csv”);
* scripts: código para processamento de dados, análises e modelagem (“01_Cleaning_data_sensor.R”; “02_Canopy_and_understory_analysis”; “03_Microclimate_analysis.R”, “04_Thermal_metrics_and_mound_volume.R” e “05_Statistical_analysis.R”). Rode os scripts na ordem numérica para chegar aos resultados em output e figures;
* README.md: este arquivo.


Variáveis Utilizadas
-----------------------------


| Variável                            | Tipo             | Descrição                                                                        |
| ------------------------------ |  -------------- | ----------------------------------------------------------------- |
| X                                       |  Inteiro         | Número sequencial da planilha                                     |           
| date                                   |  Data            | Data da amostragem                                                      |
| sampling_day                   | Inteiro          | Dia do mês em que a amostragem aconteceu                |
| mound_id                         | Categoria     | Código de identificação do cupinzeiro                          |
| vegetation_type                | Categoria     | Tipo de vegetação onde o cupinzeiro foi amostrado     |
| mound_height_cm           |  Numérico    | Altura máxima do cupinzeiro                                        |
| maj_diameter_cm            | Numérico     | Diâmetro máximo do cupinzeiro                                   |
| min_diameter_cm            | Numérico     | Diâmetro mínimo do cupinzeiro                                    |
| canopy_cover                  | Numérico      | Proporção da cobertura do dossel no local de 
                                                                    amostragem                                                                   |
| understory_cover             | Numérico      | Proporção da cobertura do sub-bosque no 
                                                                    local de amostragem                                                      |
| mound_volume                 | Numérico     | Volume estimado do cupinzeiro                                    |
| Arquivo                            |  Categoria     | Nome do arquivo de temperatura associado 
                                                                     ao cupinzeiro                                                                |
| Ponto                                | Categoria      | Identificação do ponto de amostragem                         |
| Tipo_ambiente                 | Categoria      | Categoria ambiental ampla                                            |
|ID_completo                     | Categoria      | Código de identificação completo combinando 
                                                                     ponto de amostragem e cupinzeiro                              |
| Data                                 | Data               | Data associada ao registro de temperatura                   |
| Tempo_Pico_T1              | Data/tempo    | Tempo em que a temperatura máxima foi 
                                                                      alcançada no cupinzeiro                                              |
| Temp_Max_T1                | Numérico      | Temperatura máxima registrada no cupinzeiro             |
| Tempo_Pico_T2              | Data/tempo    | Tempo em que a temperatura máxima do 
                                                                     ambiente foi atingida                                                    |
| Temp_Max_T2                 | Numérico     | Temperatura máxima do ambiente registrada               |
| Amp_T1                           | Numérico     | Amplitude térmica do cupinzeiro                                  |
| Amp_T2                           | Numérico     | Amplitude térmica do ambiente                                    |
| Atraso_Minutos               | Numérico     | Diferença de tempo entre o pico de temperatura       
                                                                   do ambiente e o pico de temperatura 
                                                                   do cupinzeiro                                                                  |
| Razao_Amortecimento    | Numérico      | Razão entre a amplitude térmica do cupinzeiro 
                                                                    e a amplitude térmica do ambiente                                |
| Modulo_Delta_T_Pico    | Numérico      | Diferença absoluta entre a temperatura 
                                                                    máxima do cupinzeiro e a temperatura máxima 
                                                                    do ambiente                                                                   |
| Modulo_Delta_T_Medio  | Numérico     | Diferença absoluta entre a temperatura média 
                                                                     do cupinzeiro e a temperatura média do 
                                                                     ambiente                                                                       |


Estrutura dos Dados
-------------------------------
Os dados estão organizados em uma planilha única em formato wide, em que cada linha corresponde a um cupinzeiro. No total, a planilha conta com 10 registros (cupinzeiros), sendo 5 em cada fitofisionomia.
Cada linha combina três fontes de informação: (i) identificação de cupinzeiros e sensores, (ii) dados morfométricos e ambientais coletados em campo e processados posteriormente e (iii) dados derivados de estabilidade térmica.
1. Identificação: ‘date’, ‘sampling_day’, ‘mound_id’, ‘vegetation_type’, ‘Ponto’, ‘Tipo_Ambiente’, “ID_Completo’, ‘Data’.
2. Dados morfométricos e ambientais:
      * Medidas morfométricas: ‘mound_height_cm’, ‘maj_diameter_cm’, min_diameter_cm’, ‘mound_volume’;
      * Complexidade ambiental: ‘canopy_cover’, ‘understory_cover’.
3. Dados derivados de estabilidade térmica: 
* Picos de temperatura: ‘Tempo_Pico_T1’, ‘Temp_Max_T’, ‘Tempo_Pico_T2’, ‘Temp_Max_T2’, 
* Amplitude térmica: ‘Amp_T1’, ‘Amp_T2’, 
* Métricas de estabilidade térmica: ‘Atraso_Minutos’, ‘Razao_Amortecimento’, ‘Modulo_Delta_T_Pico’, ‘Modulo_Delta_T_Medio’.
A planilha final não inclui os dados brutos e processados de temperatura e umidade registrados pelos sensores, apenas as métricas calculadas a partir desses dados.


Referências
-------------------


Ndlovu, M. e Pérez-Rodríguez, A. Temperature fluctuations inside savanna termite mounds: Do size and plant shade matter?. Journal of Thermal Biology, v. 74, p. 23-28, 2018.


Ndlovu, M., Nampa, G., Joseph, G. S., Seymour, C. L. Plant shade enhances thermoregulation of internal environments in Trinervitermes trinervoides mounds. Journal of Thermal Biology, n. 100, n. 6054,  p. 1-7, 2021.
