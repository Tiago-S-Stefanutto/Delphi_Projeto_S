# 🛒 Sistema de Vendas — Delphi VCL + FireDAC + SQL Server

> Sistema completo de gestão comercial desenvolvido em Delphi (VCL), com arquitetura em camadas, herança visual, controle de estoque, geração de relatórios e sistema de acesso por usuário.

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Tecnologias Utilizadas](#tecnologias-utilizadas)
3. [Arquitetura do Projeto](#arquitetura-do-projeto)
4. [Estrutura de Pastas](#estrutura-de-pastas)
5. [Módulos do Sistema](#módulos-do-sistema)
6. [Banco de Dados](#banco-de-dados)
7. [Tela Herdada (Base)](#tela-herdada-base)
8. [Autenticação e Controle de Acesso](#autenticação-e-controle-de-acesso)
9. [Módulo de Vendas](#módulo-de-vendas)
10. [Relatórios](#relatórios)
11. [Gráficos e Dashboard](#gráficos-e-dashboard)
12. [Configuração e INI File](#configuração-e-ini-file)
13. [Log do Sistema](#log-do-sistema)
14. [Como Configurar e Executar](#como-configurar-e-executar)
15. [Dependências Externas](#dependências-externas)

---

## Visão Geral

O **Sistema de Vendas** é uma aplicação desktop Windows desenvolvida em **Delphi (VCL)**, voltada para pequenas e médias empresas que necessitam gerenciar clientes, produtos, pedidos de venda, estoque e relatórios gerenciais.

### Funcionalidades Principais

- Cadastro completo de **Clientes** com status (Ativo, Bloqueado, Atenção, Inativo, Prospecto)
- Cadastro de **Produtos** com fotos, categorias e tipo de estoque
- **Pedido de Vendas** com cálculo automático e baixa de estoque
- **Relatórios** exportáveis em PDF e Excel (via FortesReport)
- **Dashboard** com gráficos de vendas, estoque e produtos mais vendidos
- **Controle de Acesso** por usuário e ações configuráveis
- **Log** completo de auditoria das operações
- **Observações de Clientes** com motivação de status (bloqueio, atenção etc.)
- Atualização automática da estrutura do banco de dados

---

## Tecnologias Utilizadas

| Tecnologia | Versão / Detalhe |
|---|---|
| **Delphi** | RAD Studio (compatível com XE7+) |
| **VCL** | Visual Component Library (desktop Windows) |
| **FireDAC** | Camada de acesso a dados |
| **SQL Server** | Banco de dados relacional (MSSQL) |
| **FortesReport** | Geração de relatórios (PDF, XLS, XLSX) |
| **RxLib / JvLib** | Componentes auxiliares (edição de datas, moeda etc.) |
| **ACBr** | Componentes fiscais (referenciados no `.dproj`) |
| **Boss** | Gerenciador de dependências Delphi (`modules/`) |

---

## Arquitetura do Projeto

O projeto segue uma **arquitetura em camadas** com separação clara entre:

```
┌──────────────────────────────────────────────┐
│              Camada de Apresentação           │
│  Forms VCL: Cadastros, Processos, Relatórios  │
└──────────────────┬───────────────────────────┘
                   │
┌──────────────────▼───────────────────────────┐
│              Camada de Negócio                │
│  Classes: TCategoria, TCliente, TVenda, etc.  │
└──────────────────┬───────────────────────────┘
                   │
┌──────────────────▼───────────────────────────┐
│              Camada de Dados                  │
│  FireDAC: TFDQuery, TFDConnection (MSSQL)     │
└──────────────────────────────────────────────┘
```

### Padrão de Herança Visual

Todas as telas de cadastro herdam de `TfrmTelaHeranca`, que fornece:
- Grid de listagem com pesquisa dinâmica
- Botões padrão (Novo, Alterar, Cancelar, Gravar, Apagar, Fechar)
- Navegador de registros (`TDBNavigator`)
- Abas "Listagem" e "Manutenção"
- Ordenação por clique no cabeçalho da coluna
- Persistência de layout de colunas no arquivo `.INI`

---

## Estrutura de Pastas

```
/
├── Cadastro/                  # Forms de cadastro de entidades
│   ├── uCadCategorias.pas/.dfm
│   ├── uCadCliente.pas/.dfm
│   ├── uCadProduto.pas/.dfm
│   ├── uCadUsuario.pas/.dfm
│   └── uCadAcaoAcesso.pas/.dfm
│
├── classes/                   # Camada de negócio (POO)
│   ├── cCadCategoria.pas
│   ├── cCadCliente.pas
│   ├── cCadProduto.pas
│   ├── cCadUsuario.pas
│   ├── cProdutoVenda.pas      # Regras de venda e estoque
│   ├── cControleEstoque.pas   # Baixa/retorno de estoque
│   ├── cUsuarioLogado.pas     # Controle de acesso por chave
│   ├── cAcaoAcesso.pas
│   ├── cArquivoIni.pas        # Leitura/escrita do INI
│   ├── cFuncao.pas            # Funções utilitárias
│   ├── cAtualizacaoBandoDeDados.pas
│   ├── cAtualizacaoTabelaMSSQL.pas
│   └── cAtualizacaoCampoMSSQL.pas
│
├── consulta/                  # Forms de consulta (lookup)
│   ├── uConCategoria.pas/.dfm
│   ├── uConClientes.pas/.dfm
│   └── uConProdutos.pas/.dfm
│
├── DataModule/                # Módulos de dados
│   ├── uDTMConexao.pas/.dfm   # Conexão principal com o banco
│   ├── uDtmVenda.pas/.dfm     # Queries e ClientDataSet de vendas
│   ├── uDtmGrafico.pas/.dfm   # Queries para gráficos/dashboard
│   └── uFrmAtualizaDB.pas     # Tela de atualização do banco
│
├── Heranca/                   # Telas base para herança
│   ├── uTelaHeranca.pas/.dfm
│   ├── uTelaHerancaConsulta.pas/.dfm
│   ├── uTelaHerancaPesquisa.pas/.dfm
│   ├── uEnum.pas              # Enumerações globais
│   └── uFuncaoCriptografia.pas
│
├── Login/                     # Autenticação e acesso
│   ├── uLogin.pas/.dfm
│   ├── uAlterarSenha.pas/.dfm
│   └── uUsuarioVsAcoes.pas/.dfm
│
├── Log_Registros/             # Auditoria
│   ├── cLog.pas
│   └── uLogSistema.pas/.dfm
│
├── ObservacaoClientes/        # Observações vinculadas a status
│   └── uObservacaoClientes.pas/.dfm
│
├── processo/                  # Processo de venda
│   └── uProVenda.pas/.dfm
│
├── Relatório/                 # Relatórios gerenciais
│   ├── uRelCategoria.pas/.dfm
│   ├── uRelCliente.pas/.dfm
│   ├── uRelClienteFicha.pas/.dfm
│   ├── uRelProduto.pas/.dfm
│   ├── uRelProdutoComCategoria.pas/.dfm
│   ├── uRelProVenda.pas/.dfm
│   ├── uRelVendaPorData.pas/.dfm
│   └── uSelecionarData.pas/.dfm
│
├── Criptografia/              # Utilitário de criptografia isolado
│   └── uCriptografia.pas/.dfm
│
├── Win32/Debug/
│   └── Vendas.INI             # Configurações de conexão e layout
│
├── uPrincipal.pas             # Form principal (menu)
├── Vendas.dpr                 # Arquivo principal do projeto
└── Vendas.dproj               # Arquivo de projeto MSBuild
```

---

## Módulos do Sistema

### 1. Cadastro de Categorias (`uCadCategorias`)

Gerencia as categorias de produtos.

**Campos:** `categoriasId` (PK, auto-incremento), `descricao` (até 30 chars)

**Classe de negócio:** `TCategoria` (`cCadCategoria.pas`)

**SQL principal:**
```sql
SELECT categoriasId, descricao FROM categorias
```

---

### 2. Cadastro de Clientes (`uCadCliente`)

Cadastro completo de clientes com status visual diferenciado por ícone colorido na grid.

**Campos:**
| Campo | Tipo | Detalhe |
|---|---|---|
| `clienteId` | AutoInc | Chave primária |
| `nome` | String(60) | Nome do cliente |
| `endereco` | String(60) | Endereço |
| `bairro` | String(40) | Bairro |
| `cidade` | String(50) | Cidade |
| `estado` | String(2) | UF |
| `cep` | String(10) | CEP com busca automática |
| `telefone` | String(14) | Com máscara formatada |
| `email` | String(100) | E-mail |
| `dataNascimento` | DateTime | Data de nascimento |
| `clienteStatusId` | Integer | Status (FK) |
| `pessoaTipoId` | Integer | Pessoa Física ou Jurídica |
| `cpfCnpj` | String | CPF ou CNPJ com máscara dinâmica |

**Status de Clientes:**

| ID | Status | Ícone | Comportamento na Venda |
|---|---|---|---|
| 1 | Ativo | 🟢 Verde | Venda permitida |
| 2 | Bloqueado | 🔵 Azul | Venda bloqueada + exibe observação |
| 3 | Atenção | 🔵 Azul claro | Venda com aviso + exibe observação |
| 4 | Inativo | ⚫ Cinza | Venda permitida (muda para Ativo ao salvar) |
| 5 | Prospecto | 🟣 Roxo | Venda permitida (muda para Ativo ao salvar) |

**Busca de CEP:** O botão de lupa ao lado do campo CEP consulta automaticamente o endereço via serviço externo, preenchendo logradouro, bairro, cidade e estado.

**Classe de negócio:** `TCliente` (`cCadCliente.pas`)

---

### 3. Cadastro de Produtos (`uCadProduto`)

Gerencia o portfólio de produtos com suporte a imagem, categoria e tipo de estoque.

**Campos:**
| Campo | Tipo | Detalhe |
|---|---|---|
| `produtoId` | AutoInc | Chave primária |
| `nome` | String(60) | Nome do produto |
| `descricao` | Memo(255) | Descrição detalhada |
| `valor` | BCD(18,5) | Preço de venda |
| `quantidade` | BCD(18,5) | Estoque atual |
| `categoriaId` | Integer | FK para categorias |
| `foto` | Blob | Imagem do produto |
| `tipoEstoqueProdutoId` | Integer | FK para tipoEstoqueProduto |

**Tipo de Estoque:** Define se o produto permite decimais e quantas casas decimais são usadas (ex: produtos vendidos por kg vs. unidade).

**Classe de negócio:** `TProduto` (`cCadProduto.pas`)

---

### 4. Cadastro de Usuários (`uCadUsuario`)

Gerencia os usuários do sistema. As senhas são armazenadas de forma criptografada (módulo `uFuncaoCriptografia`).

**Campos:** `usuarioId`, `nome` (até 50 chars), `senha` (até 40 chars, armazenada criptografada)

**Nota:** O SQL no `.dfm` apresenta um erro de concatenação (falta espaço antes do `from`). Verificar antes de usar:
```sql
-- Incorreto (como está no fonte):
select usuarioId, nome, senhafrom usuarios
-- Correto:
SELECT usuarioId, nome, senha FROM usuarios
```

---

### 5. Ação de Acesso (`uCadAcaoAcesso`)

Cadastra as ações disponíveis no sistema que podem ser liberadas ou bloqueadas por usuário.

**Campos:** `acaoAcessoId`, `descricao` (até 100 chars), `chave` (até 60 chars)

A `chave` é usada para identificar unicamente a permissão no código, no formato `NomeDaTelaOuModulo_NomeDoBotao`.

---

## Banco de Dados

### Diagrama das Principais Tabelas

```
categorias ──────────────── produtos
  categoriasId (PK)          produtoId (PK)
  descricao                  nome
                             descricao
                             valor
                             quantidade ◄── controle por TControleEstoque
                             categoriaId (FK → categorias)
                             foto (Blob)
                             tipoEstoqueProdutoId (FK → tipoEstoqueProduto)

clientes ──────────────────── vendas ──────────── vendasItens
  clienteId (PK)               vendaId (PK)        vendaId (FK)
  nome                         clienteId (FK)       produtoId (FK)
  endereco / cidade / ...       dataVenda           valorUnitario
  clienteStatusId (FK)         totalVenda          quantidade
  pessoaTipoId (FK)                                totalProduto

clienteObservacao              usuarios ──────────── usuariosAcaoAcesso
  clienteObservacaoId (PK)      usuarioId (PK)        usuarioId (FK)
  clienteId (FK)                nome                  acaoAcessoId (FK)
  tipoObservacao                senha (criptografada)  ativo (Boolean)
  observacao
  dataRegistro                 acaoAcesso             logSistema
                                acaoAcessoId (PK)      logId (PK)
                                descricao              dataHora
                                chave                  usuarioId
                                                       usuarioNome
tipoEstoqueProduto                                     tela
  tipoEstoqueProdutoId (PK)                            acao
  descricao                                            descricao
  sigla
  permiteDecimal
  casasDecimais

clienteStatus        pessoaTipo
  clienteStatusId      pessoaTipoId
  descricao            descricao
```

### Conexão com o Banco

Configurada via `uDTMConexao` usando **FireDAC** com driver MSSQL:

```ini
# Win32/Debug/Vendas.INI
[SERVER]
TipoDataBase=MSSQL
HostName=.\SERVERCURSO
Port=1433
OSAuthent=Yes
User=admin
Password=admin
Database=vendas
```

A autenticação Windows (`OSAuthent=Yes`) é suportada. Para autenticação SQL Server, definir `OSAuthent=No` e informar `User` e `Password`.

---

## Tela Herdada (Base)

`TfrmTelaHeranca` é o coração visual do sistema. Todos os formulários de cadastro e processo herdam dela.

### Comportamentos Herdados

**Pesquisa Dinâmica:**
- Detecta automaticamente o tipo do campo (`String`, `Integer`, `Float`, `DateTime`)
- Para strings: usa `LIKE :VALOR` com `%texto%`
- Para inteiros: usa `= :VALOR` com validação
- Para datas: suporta `BETWEEN :dataInicio AND :dataFim`
- O índice de pesquisa é definido pela propriedade `IndiceAtual`

**Persistência de Layout:**
- As larguras e ordem das colunas da grid são salvas no arquivo `.INI`
- Seção: `[NomeDoForm_NumeroDoMonitor_Grid]`
- Restauradas automaticamente no próximo acesso

**Grid Estilizada:**
- Linhas alternadas em cores (cinza claro / branco)
- Linha selecionada em roxo pastel (`RGB(220, 200, 255)`)
- Títulos centralizados e em branco sobre fundo cinza
- Ordenação por clique no título da coluna

**Controle de Estado:**
```delphi
TEstadoDoCadastro = (ecInserir, ecAlterar, ecNenhum)
```

**Métodos Abstratos (override obrigatório):**
```delphi
function Apagar: Boolean; virtual; abstract;
function Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean; virtual; abstract;
function NomeCampoId: string; virtual; abstract;
function NomeCampoNome: string; virtual; abstract;
function ValorLogId: string; virtual; abstract;
function ValorLogNome: string; virtual; abstract;
```

### Tela Herdada de Consulta

`TfrmTelaHenrancaConsulta` é usada nos formulários de lookup (seleção rápida de registros). Possui apenas o grid e campo de pesquisa, sem botões de CRUD. Propriedades de retorno:
- `aIniciarPesquisaId`: inicia posicionado no ID informado
- `aRetornarIdSelecionado`: retorna o ID selecionado ao fechar

### Tela Herdada de Pesquisa

`TfrmTelaHerancaPesquisa` herda de `TfrmTelaHeranca` e oculta todos os botões de edição, sendo usada para formulários somente de consulta.

---

## Autenticação e Controle de Acesso

### Login

O form de login (`uLogin`) solicita usuário e senha. A senha é criptografada antes de ser comparada com o banco. O objeto `oUsuarioLogado` (global) armazena os dados do usuário logado.

### Verificação de Permissão

A classe `TUsuarioLogado` possui o método estático:

```delphi
class function TenhoAcesso(
  aUsuarioId: Integer;
  aChave: string;
  aConexao: TFDConnection
): Boolean;
```

**SQL de verificação:**
```sql
SELECT usuarioId
FROM usuariosAcaoAcesso
WHERE usuarioId = :usuarioId
  AND acaoAcessoId = (
    SELECT TOP 1 acaoAcessoId FROM acaoAcesso WHERE chave = :chave
  )
  AND ativo = 1
```

**Uso no código:**
```delphi
if not TUsuarioLogado.TenhoAcesso(
  oUsuarioLogado.codigo,
  self.Name + '_' + TBitBtn(Sender).Name,
  DtmPrincipal.ConexaoDB
) then
begin
  MessageDlg('Usuário sem permissão', mtWarning, [mbOK], 0);
  Abort;
end;
```

### Gestão de Permissões

O form `uUsuarioVsAcoes` exibe dois grids lado a lado:
- Esquerdo: lista de usuários
- Direito: todas as ações disponíveis, marcando quais estão ativas para o usuário selecionado

Duplo clique em uma ação alterna seu estado (`ativo = 1/0`) via `UPDATE` direto com transação.

### Alterar Senha

O form `uAlterarSenha` exige a senha atual antes de permitir a troca, com confirmação da nova senha.

---

## Módulo de Vendas

O processo de venda (`uProVenda`) é o módulo mais complexo do sistema, herdando de `TfrmTelaHeranca`.

### Fluxo de uma Venda

```
1. Selecionar Cliente
       │
       ▼
2. Validar Status do Cliente
   ├── Ativo (1)     → Prossegue
   ├── Bloqueado (2) → BLOQUEADO + exibe observação
   ├── Atenção (3)   → Aviso + prossegue
   ├── Inativo (4)   → Prossegue (vira Ativo ao salvar)
   └── Prospecto (5) → Prossegue (vira Ativo ao salvar)
       │
       ▼
3. Informar Data da Venda
       │
       ▼
4. Adicionar Produtos ao TClientDataSet
   ├── Selecionar produto (lookup ou consulta)
   ├── Definir valor unitário (pré-preenchido)
   ├── Definir quantidade (respeita tipo de estoque: inteiro/decimal)
   ├── Validação: quantidade > estoque → alerta com opção de continuar
   └── Calcular total do produto
       │
       ▼
5. Totalizar Venda (soma de todos os itens)
       │
       ▼
6. Gravar
   ├── INSERT em vendas (OUTPUT inserted.vendaId)
   ├── INSERT em vendasItens (para cada item)
   ├── BaixarEstoque (UPDATE produtos SET quantidade -= :qtde)
   ├── Se cliente era Inativo/Prospecto → UPDATE clienteStatusId = 1
   └── Gerar e exibir relatório da venda (PreviewModal)
```

### Arquitetura de Dados da Venda

```
TdtmVenda (DataModule)
├── QryCliente     → SELECT clienteId, nome, clienteStatusId FROM clientes
├── QryProdutos    → SELECT produtoId, nome, valor, quantidade, foto FROM produtos
├── QryTipoEstoque → SELECT tipoEstoqueProdutoId, permiteDecimal, casasDecimais FROM tipoEstoqueProduto
├── cdsItensVenda  → TClientDataSet in-memory
│   ├── produtoId
│   ├── nomeProduto
│   ├── quantidade
│   ├── valorUnitario
│   └── valorTotalProduto
└── OnItemVendaChange → evento para atualizar imagem do produto
```

### Controle de Estoque

A classe `TControleEstoque` gerencia a movimentação de estoque:

```delphi
// Baixa de estoque (ao incluir/alterar item)
UPDATE produtos SET quantidade = quantidade - :qtdeBaixa WHERE produtoId = :produtoId

// Retorno de estoque (ao excluir/alterar item)
UPDATE produtos SET quantidade = quantidade + :qtdeRetorno WHERE produtoId = :produtoId
```

Todas as operações são encapsuladas em transações (`StartTransaction / Commit / Rollback`).

### Observações de Clientes

O form `uObservacaoClientes` permite registrar observações textuais vinculadas a um cliente. O campo `tipoObservacao` (valores 2 e 3) indica observações relacionadas a status de bloqueio/atenção, que são exibidas automaticamente ao tentar vender para clientes nesses status.

---

## Relatórios

Todos os relatórios utilizam o componente **FortesReport** e suportam exportação para:
- 📄 **PDF** (`TRLPDFFilter`)
- 📊 **Excel XLS** (`TRLXLSFilter`)
- 📊 **Excel XLSX** (`TRLXLSXFilter`)

| Relatório | Classe | Descrição |
|---|---|---|
| Categorias | `TfrmRelCategoria` | Listagem de todas as categorias |
| Clientes | `TfrmRelCliente` | Listagem de clientes (nome, e-mail, telefone) |
| Ficha do Cliente | `TfrmRelClienteFicha` | Ficha completa com todos os dados do cliente |
| Produtos | `TfrmRelProduto` | Listagem de produtos com valor e quantidade |
| Produtos por Categoria | `TfrmRelProdutoComCategoria` | Agrupado por categoria com totais |
| Vendas | `TfrmRelProVenda` | Detalhe de venda(s) com itens e totais |
| Vendas por Data | `TfrmRelVendaPorData` | Vendas filtradas por intervalo de datas |

### Seleção de Período

O form `uSelecionarData` é um diálogo reutilizável para escolha de período. Ao abrir, inicializa automaticamente com o primeiro e último dia do mês atual (`StartOfTheMonth` / `EndOfTheMonth`).

Validações:
- Data final não pode ser anterior à data inicial
- Ambas as datas são obrigatórias

---

## Gráficos e Dashboard

O DataModule `TdtmGrafico` contém as queries pré-configuradas para alimentar os gráficos:

### Queries Disponíveis

**Estoque de Produtos (Top 17, ordem crescente):**
```sql
SELECT TOP 17
  CONVERT(VARCHAR, produtoId) + ' - ' + nome AS Label,
  quantidade AS Value
FROM produtos
ORDER BY quantidade ASC
```

**Valor de Venda por Cliente (últimos 7 dias):**
```sql
SELECT CONVERT(VARCHAR, vendas.clienteId) + ' - ' + clientes.nome AS Label,
       SUM(vendas.totalVenda) AS Value
FROM Vendas
INNER JOIN clientes ON clientes.clienteId = vendas.clienteId
WHERE vendas.dataVenda BETWEEN CONVERT(DATE, GETDATE()-7) AND CONVERT(DATE, GETDATE())
GROUP BY Vendas.clienteId, clientes.Nome
```

**Produtos Mais Vendidos (Top 10):**
```sql
SELECT TOP 10
  CONVERT(VARCHAR, vi.produtoId) + ' - ' + p.nome AS Label,
  SUM(vi.totalProduto) AS Value
FROM vendasItens AS vi
INNER JOIN produtos AS p ON p.produtoId = vi.produtoId
GROUP BY vi.produtoId, p.nome
```

**Vendas na Última Semana:**
```sql
SELECT vendas.dataVenda AS Label, SUM(vendas.totalvenda) AS Value
FROM vendas
WHERE vendas.dataVenda BETWEEN CONVERT(DATE, GETDATE()-7) AND CONVERT(DATE, GETDATE())
GROUP BY vendas.dataVenda
```

---

## Configuração e INI File

O arquivo `Vendas.INI` (gerado automaticamente na pasta do executável) armazena:

### Seção `[SERVER]`

```ini
[SERVER]
TipoDataBase=MSSQL
HostName=.\SERVERCURSO
Port=1433
OSAuthent=Yes
User=admin
Password=admin
Database=vendas
```

### Seções de Layout da Grid

Para cada form com grid, o layout das colunas é persistido no formato:

```ini
[NomeForm_NroMonitor_Grid]
Col_0_Width=74
Col_0_Order=0
Col_0_Field=nomeDoField
Col_1_Width=305
...
```

A classe `TArquivoIni` (`classes/cArquivoIni.pas`) abstrai toda leitura e escrita no INI:

```delphi
TArquivoIni.LerIni('SERVER', 'HostName');
TArquivoIni.AtualizarIni('SERVER', 'HostName', 'novo.servidor');
```

---

## Log do Sistema

O módulo de log (`Log_Registros/cLog.pas` + `uLogSistema`) registra todas as operações de CRUD realizadas no sistema.

### Estrutura da Tabela `logSistema`

```sql
logId        -- AutoInc, PK
dataHora     -- DateTime do evento
usuarioId    -- ID do usuário que realizou a ação
usuarioNome  -- Nome snapshot do usuário
tela         -- Nome do formulário
acao         -- Ação realizada (Inserir, Alterar, Apagar etc.)
descricao    -- Detalhes (ex: "ID: 42 - Nome: Produto X")
```

O form `uLogSistema` herda de `TfrmTelaHeranca` e exibe o log com filtro por intervalo de datas.

---

## Atualização do Banco de Dados

O sistema possui um mecanismo de atualização automática da estrutura do banco de dados via:

- `TcAtualizacaoBandoDeDados` — orquestra o processo de atualização
- `TcAtualizacaoTabelaMSSQL` — cria/verifica tabelas no SQL Server
- `TcAtualizacaoCampoMSSQL` — adiciona/verifica campos nas tabelas

Isso permite que novas versões do sistema atualizem o schema do banco sem intervenção manual.

---

## Como Configurar e Executar

### Pré-requisitos

- Delphi RAD Studio (versão compatível com `ProjectVersion 18.4`)
- SQL Server (local ou rede) com banco `vendas` criado
- Pacotes FortesReport instalados no IDE
- Pacotes RxLib / JvLib instalados no IDE
- Componentes ACBr (se forem utilizados recursos fiscais)

### Passo a Passo

1. **Clonar o repositório** e abrir `Vendas.dproj` no Delphi

2. **Configurar a conexão** editando `Win32/Debug/Vendas.INI`:
   ```ini
   [SERVER]
   TipoDataBase=MSSQL
   HostName=SEU_SERVIDOR\INSTANCIA
   Port=1433
   OSAuthent=No       ; ou Yes para autenticação Windows
   User=sa
   Password=SuaSenha
   Database=vendas
   ```

3. **Criar o banco de dados** `vendas` no SQL Server e executar os scripts de criação das tabelas (não incluídos no repositório — gerar via engenharia reversa ou solicitar ao responsável)

4. **Compilar** o projeto (`Ctrl+F9` ou `Project > Build`)

5. **Executar** (`F9`) — o sistema solicitará login na primeira tela

### Usuário Padrão

O sistema requer um usuário previamente cadastrado na tabela `usuarios`. Inserir manualmente no banco:

```sql
INSERT INTO usuarios (nome, senha) VALUES ('Admin', 'SENHA_CRIPTOGRAFADA')
```

> A senha deve ser criptografada pelo algoritmo implementado em `uFuncaoCriptografia.pas`.

---

## Dependências Externas

| Dependência | Finalidade | Onde é usada |
|---|---|---|
| **FortesReport** | Geração de relatórios | `Relatório/` — todos os forms |
| **RxLib** (RxCurrEdit, RxToolEdit, RxGIF) | Campos de moeda, datas e GIF animado | `processo/`, `DataModule/`, `Relatório/` |
| **JvLib** | Componentes complementares | Referenciado no `.dproj` |
| **ACBr** | Componentes fiscais brasileiros | Referenciado no `.dproj` (pode não ser utilizado) |
| **NiceGridXE** | Grid aprimorada | Referenciado no `.dproj` |
| **Boss** | Gerenciador de pacotes Delphi | Pasta `modules/` (ignorada pelo `.gitignore`) |

---

### Boas Práticas Adotadas
- Uso de `try/finally` para garantir liberação de objetos (`FreeAndNil`)
- Transações explícitas (`StartTransaction / Commit / Rollback`) em todas as operações de escrita
- Separação de responsabilidades entre classes de negócio e formulários VCL
- Persistência de layout de grid melhora a usabilidade entre sessões

### Pontos de Melhoria Sugeridos
- Implementar hash seguro para senhas (ex: SHA-256 com salt) em substituição ao algoritmo atual
- Centralizar strings de SQL em constantes ou arquivos de recurso
- Adicionar testes unitários para as classes de negócio
- Considerar migração para REST API para possibilitar acesso mobile

---

## Licença

Este projeto é de uso educacional/interno. Consulte o responsável pelo repositório para informações sobre licenciamento e redistribuição.

---

*Documentação gerada com base na análise do código-fonte do projeto `Vendas.dproj` — Sistema de Gestão Comercial em Delphi VCL.*
