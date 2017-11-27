## processos

- id: litigation id (internal)
- num: litigation number (official)
- num_dep: dependent litigation number, when litigation has dependencies
- vara: lower court
- juiz: judge
- classe: litigation class
- assunto: litigation subject
- classificacao: litigation type. 0=Summary, 1=Ordinary, 2=Execution
- vl_causa: case value
- dt_distribuicao: filing date
- dt_mov: date of last movement
- tempo: litigation time until last movement, in days (is NA when litigation is not archived)

## partes

- id: litigation id
- id_pessoa: person id (internal)
- tipo_parte: person type. autor=plaintiff, reu=defendant
- endereco: person address


