# EDA em dados meteorológicos do INMET

Dados vêm do BDMEP: https://bdmep.inmet.gov.br/ . Segui as instruções lá selecionando uma estação convencional em João Pessoa, Campina Grande e Patos - PB, e solicitando dados diários desde 2011. 

Os dados brutos estão em `data/raw`. O código em `transform` faz ETL e o coloca em `data/`.

Colunas nos dados prontos: 

[1] "cidade"                                  
[2] "Data Medicao"                            
[3] "INSOLACAO TOTAL, DIARIO(h)"              
[4] "PRECIPITACAO TOTAL, DIARIO(mm)"          
[5] "TEMPERATURA MAXIMA, DIARIA(°C)"          
[6] "TEMPERATURA MEDIA COMPENSADA, DIARIA(°C)"
[7] "TEMPERATURA MINIMA, DIARIA(°C)"          
[8] "UMIDADE RELATIVA DO AR, MEDIA DIARIA(%)" 
[9] "VENTO, VELOCIDADE MEDIA DIARIA(m/s)"