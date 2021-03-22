library(tidyverse)

le_cidade = function(arquivo) {
    read_delim(
        here::here(arquivo),
        delim = ";",
        skip = 10,
        na = c("", "NA", "null"),
        col_types = cols(
            `Data Medicao` = col_date(format = ""),
            `INSOLACAO TOTAL, DIARIO(h)` = col_number(),
            `PRECIPITACAO TOTAL, DIARIO(mm)` = col_number(),
            `TEMPERATURA MAXIMA, DIARIA(°C)` = col_number(),
            `TEMPERATURA MEDIA COMPENSADA, DIARIA(°C)` = col_number(),
            `TEMPERATURA MINIMA, DIARIA(°C)` = col_number(),
            `UMIDADE RELATIVA DO AR, MEDIA DIARIA(%)` = col_number(),
            `VENTO, VELOCIDADE MEDIA DIARIA(m/s)` = col_number(),
            X9 = col_skip()
        )
    )
}

jp = le_cidade("data/raw/dados_82798_D_2001-01-01_2021-03-21.csv")
cg = le_cidade("data/raw/dados_82795_D_2001-01-01_2021-03-21.csv")
pt = le_cidade("data/raw/dados_82791_D_2001-01-01_2021-03-21.csv")

juntas = bind_rows(
    `João Pessoa` = jp,
    `Campina Grande` = cg,
    Patos = pt,
    .id = "cidade"
)

adaptado = juntas %>%
    rename(
        data = `Data Medicao`,
        insolacao = `INSOLACAO TOTAL, DIARIO(h)`,
        precipitacao = `PRECIPITACAO TOTAL, DIARIO(mm)`,
        temp_max = `TEMPERATURA MAXIMA, DIARIA(°C)`,
        temp_media = `TEMPERATURA MEDIA COMPENSADA, DIARIA(°C)`,
        temp_min = `TEMPERATURA MINIMA, DIARIA(°C)`,
        umidade = `UMIDADE RELATIVA DO AR, MEDIA DIARIA(%)`,
        vento = `VENTO, VELOCIDADE MEDIA DIARIA(m/s)`
    ) 

adaptado %>%
    write_csv(here::here("data/tempo-jp-cg-pt.csv"))

adaptado %>% 
    filter(lubridate::year(data) >= 2021) %>% 
    write_csv(here::here("data/tempo-jp-cg-pt-2021.csv"))