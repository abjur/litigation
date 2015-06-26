load('data/processos.RData')
load('data/assuntos.RData')

assuntos <- tbl_df(assuntos) %>%
  select(id = cdProcesso, assunto = deassunto)
processos$dtMovimento <- as.Date(processos$dtMovimento)
processos$DataDistribuicao <- as.Date(processos$DataDistribuicao)
processos <- tbl_df(processos) %>%
  filter(nmVara %in% c('1ª Vara Cível', '2ª Vara Cível', '3ª Vara Cível',
                       '1ª Vara do Juizado\nEspecial Cível')) %>%
  filter(Arquivado == 1) %>%
  rename(id = cdprocesso) %>%
  left_join(assuntos, 'id') %>%
  select(id,
         num = NumeroProcesso,
         num_dep = NumeroProcessodep,
         vara = nmVara,
         juiz = JuizAtual,
         classificacao = Classificacao,
         classe = Classe,
         assunto,
         vl_causa = vlcausa,
         dt_distribuicao = DataDistribuicao,
         dt_mov = dtMovimento,
         tempo = Tempo)

load('data/partes.RData')
load('data/enderecos.RData')
enderecos <- tbl_df(enderecos) %>%
  select(id_pessoa = cdpessoa, endereco) %>%
  filter(!is.na(endereco))
partes <- tbl_df(partes) %>%
  filter(TpParte != 4) %>%
  mutate(tipo_parte = ifelse(TpParte == 1, 'autor', 'reu')) %>%
  select(id = cdProcesso, 
         id_pessoa = cdPessoa,
         tipo_parte) %>%
  left_join(enderecos, 'id_pessoa') %>%
  filter(!is.na(endereco)) %>%
  mutate(endereco = gsub('N\\?', '', endereco)) %>%
  semi_join(processos, 'id')

# enderecos_autor_unique <- partes %>%
#   filter(tipo_parte == 'autor') %>%
#   distinct(endereco) %>%
#   mutate(endereco = gsub(' +', ' ', endereco),
#          endereco = tolower(tjsp::rm_accent(endereco)),
#          endereco = gsub('\\-sp$', ', sp', endereco),
#          endereco = gsub('\\-df$', ', df', endereco),
#          endereco = gsub('\\-rj$', ', rj', endereco),
#          endereco = gsub('\\-go$', ', go', endereco),
#          endereco = gsub('\\-rs$', ', rs', endereco)) %>%
#   distinct(endereco)

save(processos, file = 'data/processos.rda', compress = 'bzip2')
save(partes, file = 'data/partes.rda', compress = 'bzip2')
write.csv2(processos, 'data-raw/processos.csv')
write.csv2(partes, 'data-raw/partes.csv')

#------------------------------------------------------------------------------


total_pessoas <- read.csv2('data-raw/Pessoa13_SP1.csv', as.is = TRUE,
                           na.strings = 'X',
                           colClasses = c('character')) %>%
  tbl_df() %>%
  mutate_each(funs(as.integer), starts_with('V')) %>%
  mutate(
    total5 = V039 + V040 + V041 + V042 + V043 + V044 + V045 + V046 + 
      V047 + V048 + V049 + V050 + V051 + V052 + V053 + V054 + V055 + 
      V056 + V057 + V058 + V059 + V060 + V061 + V062 + V063 + V064 + 
      V065 + V066 + V067 + V068 + V069 + V070 + V071 + V072 + V073 + 
      V074 + V075 + V076 + V077 + V078 + V079 + V080 + V081 + V082 + 
      V083 + V084 + V085 + V086 + V087 + V088 + V089 + V090 + V091 + 
      V092 + V093 + V094 + V095 + V096 + V097 + V098 + V099 + V100 + 
      V101 + V102 + V103 + V104 + V105 + V106 + V107 + V108 + V109 + 
      V110 + V111 + V112 + V113 + V114 + V115 + V116 + V117 + V118 + 
      V119 + V120 + V121 + V122 + V123 + V124 + V125 + V126 + V127 + 
      V128 + V129 + V130 + V131 + V132 + V133 + V134
  ) %>%
  select(cod = Cod_setor, total5)

educ <- read.csv2('data-raw/Pessoa01_SP1.csv', as.is = TRUE,
                  na.strings = 'X',
                  colClasses = c('character')) %>%
  tbl_df() %>%
  mutate_each(funs(as.integer), starts_with('V')) %>%
  select(cod = Cod_setor, situacao = Situacao_setor, alfab5 = V001) %>%
  inner_join(total_pessoas, 'cod') %>%
  mutate(prop = alfab5 / total5) %>%
  mutate(prop_cat = cut(prop, c(0, 0.9, 0.95, 1.0)))

#------------------------------------------------------------------------------

renda <- read.csv2('data-raw/DomicilioRenda_SP1.csv', as.is = TRUE,
                   na.strings = 'X',
                   colClasses = c('character')) %>%
  tbl_df() %>%
  select(-X) %>%
  mutate_each(funs(as.integer), starts_with('V')) %>%
  select(cod = Cod_setor, situacao = Situacao_setor,
         sal_0 = V014, sal_0.125 = V005, sal_0.25 = V006, 
         sal_0.5 = V007, sal_1 = V008, sal_2 = V009,
         sal_3 = V010, sal_5 = V011, sal_10 = V012, sal_inf = V013) %>%
  mutate(sal_1 = sal_0 + sal_0.125 + sal_0.25 + sal_0.5 + sal_1,
         sal_5 = sal_2 + sal_3 + sal_5,
         sal_inf = sal_10 + sal_inf) %>%
  select(cod, situacao, sal_1, sal_5, sal_inf) %>%
  mutate(total = sal_1 + sal_5 + sal_inf,
         prop_1 = sal_1 / total, 
         prop_5 = sal_5 / total, 
         prop_inf = sal_inf / total)
