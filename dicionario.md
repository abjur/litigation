## processos

- id: identificacao do processo
- num: numero do processo (CNJ)
- num_dep: numero do processo por dependencia (casos de distribuicao por dependencia)
- vara: nome da vara
- juiz: juiz responsavel pelo processo
- classe: classe processual
- assunto: assunto do processo
- classificacao: 0=Sumário, 1=Ordinário, 2=Execução
- vl_causa: valor da causa
- dt_distribuicao: data de distribuicao
- dt_mov: data do ultimo movimento, em dias (NA se processo nao foi arquivado)
- tempo: tempo do processo

## partes

- id: identificacao do processo (foreign key)
- id_pessoa: id da pessoa (interno do sistema)
- tipo_parte: autor ou réu
- endereco: endereco da parte


