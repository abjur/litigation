library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(lubridate)

#------------------------------------------------------------------------------
# geocoding
data("partes", package = 'litigation')
cnefe_sp <- readRDS('data/cnefe_sp.rds')

# partes_sp %>% count(fl, sort = T) %>% data.frame() %>% head(100) %>%
#   with(fl) %>%
#   sprintf("'%s', '',", .) %>%
#   cat(sep = '\n')

dict_tipo <- rbind(
  c('AVENIDA', 'AVENIDA'),
  c('RUA', 'RUA'),
  c('PRACA', 'PRACA'),
  c('CIDADE', ''),
  c('AV.', 'AVENIDA'),
  c('ALAMEDA', 'ALAMEDA'),
  c('AV', 'AVENIDA'),
  c('TRAVESSA', 'TRAVESSA'),
  c('R', 'RUA'),
  c('CALCADA', ''),
  c('R.', 'RUA'),
  c('PCA', 'PRACA'),
  c('ESTRADA', 'ESTRADA'),
  c('TRAV.', 'TRAVESSA'),
  c('LARGO', 'LARGO'),
  c('ALFREDO', ''),
  c('VIADUTO', 'VIADUTO'),
  c('AL', 'ALAMEDA'),
  c('AL.', 'ALAMEDA'),
  c('PC.', 'PRACA'),
  c('R:', 'RUA'),
  c('TRAV', 'TRAVESSA'),
  c('PCA.', 'PRACA'),
  c('AV:', 'AVENIDA'),
  c('RODOVIA', 'RODOVIA'),
  c('CODIGO', ''),
  c('ZAVENIDA', 'AVENIDA'),
  c('AMADOR', ''),
  c('ZRUA', 'RUA'),
  c('CALCADAS', ''),
  c('PC', 'PRACA'),
  c('VIA', 'VIA'),
  c('NUCLEO', ''),
  c('TV', 'TRAVESSA'),
  c('ROQUE', ''),
  c('BOA', ''),
  c('ZZZAVENIDA', 'AVENIDA'),
  c('TV.', 'TRAVESSA'),
  c('OLIVEIRA', ''),
  c('SBS', ''),
  c('PCA.ALFREDO', 'PRACA'),
  c('SETOR', ''),
  c('QUADRA', ''),
  c('PR.', 'PRACA'),
  c('VOLUNTARIOS', ''),
  c('RUA:', 'RUA'),
  c('PONTE', ''),
  c('AL.PEDRO', 'ALAMEDA'),
  c('XV', ''),
  c('AVENIDA.', 'AVENIDA'),
  c('AL.RIO', 'ALAMEDA'),
  c('AVENIDAS', 'AVENIDA'),
  c('SCS', ''),
  c('CONJUNTO', ''),
  c('TAVESSA', 'TRAVESSA'),
  c('PARQUE', 'PARQUE'),
  c('RUA.', 'RUA'),
  c('PRCA', 'PRACA'),
  c('NUC', ''),
  c('PEDRO', ''),
  c('MARIA', ''),
  c('PROFESSOR', ''),
  c('LGO', 'LARGO'),
  c('PRACO', 'PRACA'),
  c('ZAV.', 'AVENIDA'),
  c('A', 'AVENIDA'),
  c('PENHA', ''),
  c('R:BOA', 'RUA')
) %>% data.frame(stringsAsFactors = FALSE) %>%
  setNames(c('fl', 'tipo_do_logradouro'))

partes_sp <- partes %>%
  tbl_df() %>%
  mutate(endereco = toupper(endereco)) %>%
  mutate(endereco = gsub('R\\. ?', 'R. ', endereco)) %>%
  mutate(endereco = gsub('AV\\. ?', 'AV. ', endereco)) %>%
  separate(endereco, c('fl', 'endereco'), sep = ' ', extra = 'merge') %>%
  left_join(dict_tipo, 'fl') %>%
  mutate(tipo_do_logradouro = ifelse(is.na(tipo_do_logradouro),
                                     '', tipo_do_logradouro)) %>%
  select(-fl) %>%
  separate(endereco, c('nome_do_logradouro', 'numero_no_logradouro',
                       'bairro', 'municipio'), sep = ',', extra = 'merge')

saveRDS(partes_sp, 'data/partes_sp_parcial.rds')

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------

# ASSOCIACAO DO BAIRRO
partes_sp <- readRDS('data/partes_sp_parcial.rds')
partes_sp_distinct <- distinct(partes_sp, 
                               nome_do_logradouro,
                               numero_no_logradouro,
                               bairro,
                               municipio,
                               tipo_do_logradouro)

cnefe_unite <- cnefe_sp %>%
  unite(rua, nome_do_logradouro, nm_distrito, sep = ', ') %>%
  mutate(rua = gsub('(, )+', ', ', rua)) %>%
  mutate(rua = gsub(' +', ' ', rua)) %>%
  select(rua, codigo_do_setor, situacao_do_setor) %>%
  distinct(rua) %>%
  filter(!is.na(rua))

partes_sp_unite <- partes_sp_distinct %>%
  filter(str_detect(municipio, 'SAO PAULO-SP') | is.na(municipio)) %>%
  unite(rua, nome_do_logradouro, bairro, municipio, sep = ', ') %>%
  mutate(rua = gsub(', *SAO PAULO-SP', '', rua)) %>%
  mutate(rua = gsub('(, )+', ', ', rua)) %>%
  mutate(rua = gsub(' +', ' ', rua)) %>%
  select(rua, id, id_pessoa, tipo_parte) %>%
  distinct(rua) %>%
  filter(!is.na(rua))

#------------------------------------------------------------------------------
# calculando stringdist de todos os endereços
a <- partes_sp_unite$rua
b <- cnefe_unite$rua
library(stringdist)
f <- function(i) {
  saveRDS(stringdist(a[i], b), sprintf('data-raw/distances2/%05d.rds', i))
}
i <- 1:length(a)
i2 <- sprintf('data-raw/distances2/%05d.rds', i)
i <- i[!file.exists(i2)]

# demora approx 9 horas e trava o pc
system.time({
  plyr::l_ply(i, f, .progress = 'text')
})

# pegando 10 endereços mais próximos e guardando em base
end_proximos <- data_frame(arq = dir('data-raw/distances', full.names = TRUE), 
                           id = as.numeric(gsub('[^0-9]', '', arq))) %>%
  group_by(id, arq) %>%
  do({
    end_a <- a[.$id]
    end_b <- readRDS(.$arq)
    s <- sort(end_b, index.return = TRUE)
    d <- data_frame(rua_partes = end_a, 
                    rua_cnefe = b[head(s$ix, 1)], 
                    dist = head(s$x, 1))
    d
  }) %>%
  ungroup()
saveRDS(end_proximos, file = 'data/end_proximos.rds')

end_proximos %>%
  mutate(dist = as.factor(dist)) %>%
  ggplot(aes(x = dist)) +
  geom_bar()

end_proximos %>%
  filter(dist < 10) %>%
  sample_n(10)


#------------------------------------------------------------------------------




















