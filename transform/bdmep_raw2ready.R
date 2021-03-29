library(tidyverse)
library(lubridate)

le_cidade_raw = function(arquivo){
    read_csv2(
        here::here(arquivo),
        skip = 1,
        col_types = cols(
            Data = col_date(format = "%d/%m/%Y"),
            `Hora (UTC)` = col_character(),
            `Temp. [Hora] (C)` = col_number(),
            `Umi. (%)` = col_number(),
            `Pressao (hPa)` = col_number(),
            `Vel. Vento (m/s)` = col_number(),
            `Dir. Vento (m/s)` = col_number(),
            `Nebulosidade (Decimos)` = col_number(),
            `Insolacao (h)` = col_number(),
            `Temp. Max. [Diaria] (h)` = col_number(),
            `Temp. Min. [Diaria] (h)` = col_number(),
            `Chuva [Diaria] (mm)` = col_number(),
            X13 = col_skip()
        )
    )
}

cg = le_cidade_raw("data/raw/CAMPINA GRANDE (82795).csv")
pt = le_cidade_raw("data/raw/PATOS (82791).csv")
jp = le_cidade_raw("data/raw/JOAO PESSOA (82798).csv")

juntas = bind_rows(
    `João Pessoa` = jp,
    `Campina Grande` = cg,
    Patos = pt,
    .id = "cidade"
)

# Data = col_character(),
# `Hora (UTC)` = col_character(),
# `Temp. [Hora] (C)` = col_number(),
# `Umi. (%)` = col_number(),
# `Pressao (hPa)` = col_number(),
# `Vel. Vento (m/s)` = col_character(),
# `Dir. Vento (m/s)` = col_number(),
# `Nebulosidade (Decimos)` = col_character(),
# `Insolacao (h)` = col_character(),
# `Temp. Max. [Diaria] (h)` = col_number(),
# `Temp. Min. [Diaria] (h)` = col_number(),
# `Chuva [Diaria] (mm)` = col_character(),

adaptado = juntas %>%
    mutate(semana = lubridate::floor_date(Data, unit= "weeks")) %>% 
    group_by(cidade, semana) %>% 
    summarise(
        temp_max = max(`Temp. Max. [Diaria] (h)`, na.rm = T), 
        temp_media = mean(`Temp. [Hora] (C)`, na.rm = T), 
        temp_min = min(`Temp. Min. [Diaria] (h)`, na.rm = T),
        vento_medio = mean(`Vel. Vento (m/s)`, na.rm = T),
        vento_max = max(`Vel. Vento (m/s)`, na.rm = T),
        umidade = mean(`Umi. (%)`, na.rm = T),
        chuva = sum(`Chuva [Diaria] (mm)`, na.rm = T), 
        .groups = "drop") %>% 
    mutate_if(is.numeric, list(~na_if(., Inf))) %>% 
    mutate_if(is.numeric, list(~if_else(is.nan(.), NA_real_, .))) %>% 
    mutate_if(is.numeric, list(~na_if(., -Inf))) %>% 
    mutate(ano = year(semana), mes = month(semana))

adaptado %>%
    write_csv(here::here("data/tempo-jp-cg-pt.csv"))

adaptado %>% 
    filter(lubridate::year(semana) == 2019) %>% 
    write_csv(here::here("data/tempo-jp-cg-pt-2019.csv"))
