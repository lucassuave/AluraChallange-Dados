# AluraChallange-Dados
Nesse projeto, será desenvolvido para o banco digital internacional Alura Ca$h um conjunto de análises e modelos de machine learning supervisionados, para auxiliar na tomada de decisão para concessão de crédito.

## Dicionário de dados por tabela

### dados_mutuarios

Tabela contendo os dados pessoais de cada solicitante

| Feature | Característica |
| --- | --- |
|`mutuario_id`|ID da pessoa solicitante|
| `mutuario_idade` | Idade da pessoa - em anos - que solicita empréstimo |
| `mutuario_renda` | Salário anual da pessoa solicitante |
| `mutuario_moradia_status` | Situação da propriedade que a pessoa possui: *Alugada*, *Própria*, *Hipotecada* e *Outros casos* |
| `mutuario_tempo_trabalhado` | Tempo - em anos - que a pessoa trabalhou |

### emprestimos

Tabela contendo as informações do empréstimo solicitado

| Feature | Característica |
| --- | --- |
|`emprestimo_id`|ID da solicitação de empréstico de cada solicitante|
| `emprestimo_intencao` | Motivo do empréstimo: *Pessoal*, *Educacional*, *Tratamento de Saude*, *Empreendimento*, *Reforma residencial*, *Pagamento de débitos* |
| `emprestimo_nota` | Pontuação de empréstimos, por nível variando de `A` a `G` |
| `emprestimo_total` | Valor total do empréstimo solicitado |
| `emprestimo_taxa` | Taxa de juros |
| `emprestimo_status` | Possibilidade de inadimplência |
| `emprestimo_margem_renda` | Renda percentual entre o *valor total do empréstimo* e o *salário anual* |


### historicos_banco

Histório de emprétimos de cada cliente

| Feature | Característica |
| --- | --- |
|`hist_id`|ID do histórico de cada solicitante|
| `hist_inadiplencia` | Indica se a pessoa já foi inadimplente: sim (`1`) e não (`0`) |
| `hist_anos_conta` | Tempo - em anos - desde a primeira solicitação de crédito ou aquisição de um cartão de crédito |

### id

Tabela que relaciona os IDs de cada informação da pessoa solicitante

| Feature | Característica |
| --- | --- |
|`mutuario_id`|ID da pessoa solicitante|
|`emprestimo_id`|ID da solicitação de empréstico de cada solicitante|
|`hist_id`|ID do histórico de cada solicitante|
