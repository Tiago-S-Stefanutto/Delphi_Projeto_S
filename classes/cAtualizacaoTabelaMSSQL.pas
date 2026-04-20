unit cAtualizacaoTabelaMSSQL;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.ComCtrls, RxToolEdit, cCadUsuario, cAtualizacaoBandoDeDados;

type
  TAtualizacaoTableMSSQL = class(TAtualizaBancoDeDados)

  private
    function  TabelaExiste(aNomeTabela:String):Boolean;

  protected

  public
    constructor Create(aConexao:TFDConnection);
    destructor Destroy; override;

    procedure Log;
    procedure Categoria;
    procedure Cliente;
    procedure Produto;
    procedure Vendas;
    procedure VendasItens;
    procedure Usuario;
    procedure AcaoAcesso;
    procedure UsuariosAcaoAcesso;
    procedure ClienteStatus;
    procedure pessoaTipo;
    procedure ClienteObservacao;
    procedure TipoEstoqueProduto;
end;

implementation


{ TAtualizacaoTableMSSQL }

constructor TAtualizacaoTableMSSQL.Create(aConexao: TFDConnection);
begin
  ConexaoDB := aConexao;
  Log;
  Categoria;
  ClienteStatus;
  pessoaTipo;
  Cliente;
  ClienteObservacao;
  TipoEstoqueProduto;
  Produto;
  Vendas;
  VendasItens;
  Usuario;
  AcaoAcesso;
  UsuariosAcaoAcesso;
end;

destructor TAtualizacaoTableMSSQL.Destroy;
begin
  inherited;
end;

procedure TAtualizacaoTableMSSQL.Log;
begin
  IF NOT TabelaExiste('LogSistema') then
  begin
    ExecutaDiretoBancoDeDados(
    'CREATE TABLE LogSistema ( '+
    'logId INT IDENTITY(1,1) PRIMARY KEY, '+
    'dataHora DATETIME NOT NULL DEFAULT GETDATE(), '+
    'usuarioId INT, '+
    'usuarioNome VARCHAR(100), '+
    'tela VARCHAR(100), '+
    'acao VARCHAR(50), '+
    'descricao VARCHAR(255) '+
    ') '
    );

    // Índices
    ExecutaDiretoBancoDeDados(
      'CREATE INDEX IDX_Log_DataHora ON LogSistema(dataHora)'
    );

    ExecutaDiretoBancoDeDados(
      'CREATE INDEX IDX_Log_Usuario ON LogSistema(usuarioId)'
    );

    ExecutaDiretoBancoDeDados(
      'CREATE INDEX IDX_Log_Tela ON LogSistema(tela)'
    );

    ExecutaDiretoBancoDeDados(
      'CREATE INDEX IDX_Log_Usuario_Data ON LogSistema(usuarioId, dataHora)'
    );
  end;
end;

function TAtualizacaoTableMSSQL.TabelaExiste(aNomeTabela: String): Boolean;
Var Qry:TFDQuery;
Begin
  Try
    Result:=False;
    Qry:=TFDQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' SELECT OBJECT_ID (:NomeTabela) As ID ');
    Qry.ParamByName('NomeTabela').AsString:=aNomeTabela;
    Qry.Open;

    if Qry.FieldByName('ID').AsInteger>0 then
       Result:=True;

  Finally
    Qry.Close;
    if Assigned(Qry) then
       FreeAndNil(Qry);
  End;
end;

procedure TAtualizacaoTableMSSQL.pessoaTipo;
begin
  if not TabelaExiste('pessoaTipo') then
  begin
    ExecutaDiretoBancoDeDados(
    ' CREATE TABLE pessoaTipo (  '+
    ' pessoaTipoId int PRIMARY KEY, '+
    ' descricao varchar(20) '+
    ' ) '
    );
  end;
  ExecutaDiretoBancoDeDados(
  'IF NOT EXISTS (SELECT 1 FROM pessoaTipo) '+
  'BEGIN '+
  ' INSERT INTO pessoaTipo  (pessoaTipoId, descricao) VALUES '+
  ' (1, ''Física''), '+
  ' (2, ''Jurídica'') '+
  'END'
  );

end;

procedure TAtualizacaoTableMSSQL.Usuario;
Var oUsuario:TUsuario;
begin
  if not TabelaExiste('usuarios') then
  begin
    ExecutaDiretoBancoDeDados(
      'CREATE TABLE usuarios ( '+
      '	 usuarioId int identity(1,1) not null, '+
      '	 nome varchar(50) not null, '+
      '	 senha varchar(40) not null, '+
      '	 PRIMARY KEY (usuarioId) '+
      '	) '
    );
  end;

  Try
    oUsuario:=TUsuario.Create(ConexaoDB);
    oUsuario.nome:='admin';
    oUsuario.senha:='admin';
    if not oUsuario.UsuarioExiste(oUsuario.nome) then
      oUsuario.Inserir;
  Finally
    if Assigned(oUsuario) then
       FreeAndNil(oUsuario);
  End;
end;


procedure TAtualizacaoTableMSSQL.UsuariosAcaoAcesso;
begin
  if not TabelaExiste('usuariosAcaoAcesso') then
    begin
      ExecutaDiretoBancoDeDados(
        'CREATE TABLE usuariosAcaoAcesso( '+
        '	 usuarioId  int NOT NULL, '+
        '	 acaoAcessoId int NOT NULL, '+
        '	 ativo bit not null default 1, '+
        '	 PRIMARY KEY (usuarioId, acaoAcessoId), '+
        '	 CONSTRAINT FK_UsuarioAcaoAcessoUsuario '+
        '	 FOREIGN KEY (usuarioId) references usuarios(usuarioId), '+
        '	 CONSTRAINT FK_UsuarioAcaoAcessoAcaoAcesso '+
        '	 FOREIGN KEY (acaoAcessoId) references acaoAcesso(acaoAcessoId) '+
        '	) '
      );
    end;
end;

procedure TAtualizacaoTableMSSQL.AcaoAcesso;
begin
  IF NOT TabelaExiste('acaoAcesso') then
  begin
    ExecutaDiretoBancoDeDados(
    'CREATE TABLE acaoAcesso ( '+
    '  acaoAcessoId int identity(1,1) not null, '+
    '  descricao varchar (100) not null, '+
    ' chave varchar (60) not null, '+
    ' PRIMARY KEY (acaoAcessoId) ' +
    ' ) '
    );
  end;
end;

procedure TAtualizacaoTableMSSQL.Categoria;
begin
  if not TabelaExiste('categorias') then
  begin
  ExecutaDiretoBancoDeDados(
  '    CREATE TABLE categorias(  '+
	'   categoriasId int IDENTITY(1,1) NOT NULL,  '+
	'   descricao  varchar(30) NULL,  '+
	'   PRIMARY KEY (categoriasId)  '
  );
  end;
end;

procedure TAtualizacaoTableMSSQL.Cliente;
begin
  if not TabelaExiste('clientes') then
  begin
    ExecutaDiretoBancoDeDados(
    'CREATE TABLE clientes( '+
    ' clienteId int IDENTITY(1,1) NOT NULL, '+
    ' nome varchar(60) NULL, '+
    ' endereco varchar(60) null, '+
    ' cidade varchar(50) null, '+
    ' bairro varchar(40) null, '+
    ' estado varchar(2) null, '+
    ' cep varchar(10) null, '+
    ' telefone varchar(14) null, '+
    ' email varchar(100) null, '+
    ' dataNascimento datetime null, '+
    ' clienteStatusId int NOT NULL DEFAULT 1, '+
    ' pessoaTipoId int NOT NULL DEFAULT 1, '+
    ' PRIMARY KEY (clienteId), '+
    ' CONSTRAINT FK_Clientes_Status '+
    ' FOREIGN KEY (clienteStatusId) REFERENCES clienteStatus(clienteStatusId), '+
    ' CONSTRAINT FK_Clientes_PessoaTipo '+
    ' FOREIGN KEY (pessoaTipoId) REFERENCES pessoaTipo(pessoaTipoId) '+
    ')'
    );

  end;
  // adiciona a coluna clienteStatusId se não existir
  ExecutaDiretoBancoDeDados(
  'IF COL_LENGTH(''clientes'', ''clienteStatusId'') IS NULL '+
  'BEGIN '+
  ' ALTER TABLE clientes ADD clienteStatusId int NOT NULL DEFAULT 1 '+
  'END'
  );

  // adiciona a FK clienteStatusId se não existir
   ExecutaDiretoBancoDeDados(
  'IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = ''FK_Clientes_Status'') '+
  'BEGIN '+
  ' ALTER TABLE clientes '+
  ' ADD CONSTRAINT FK_Clientes_Status '+
  ' FOREIGN KEY (clienteStatusId) REFERENCES clienteStatus(clienteStatusId) '+
  'END'
  );

  // adiciona a coluna pessoaTipoId se não existir
  ExecutaDiretoBancoDeDados(
  'IF COL_LENGTH(''clientes'', ''pessoaTipoId'') IS NULL '+
  'BEGIN '+
  ' ALTER TABLE clientes ADD pessoaTipoId int NOT NULL DEFAULT 1 '+
  'END'
  );

  // adiciona FK pessoaTipoId se não existir
  ExecutaDiretoBancoDeDados(
  'IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = ''FK_Clientes_PessoaTipo'') '+
  'BEGIN '+
  ' ALTER TABLE clientes '+
  ' ADD CONSTRAINT FK_Clientes_PessoaTipo '+
  ' FOREIGN KEY (pessoaTipoId) REFERENCES pessoaTipo(pessoaTipoId) '+
  'END'
  );

end;

procedure TAtualizacaoTableMSSQL.ClienteObservacao;
begin
  if not TabelaExiste('clienteObservacao') then
  begin
    ExecutaDiretoBancoDeDados(
    'CREATE TABLE clienteObservacao ( '+
    '  observacaoClienteId INT IDENTITY(1,1) PRIMARY KEY NOT NULL, '+
    '  clienteId INT NOT NULL,  '+
    '  tipoObservacao INT NOT NULL, '+
    '  observacao VARCHAR(500) NOT NULL, '+
    '  dataRegistro DATETIME DEFAULT GETDATE() NOT NULL,  '+
    '  CONSTRAINT FK_ClienteObs FOREIGN KEY (clienteId) '+
    '    REFERENCES clientes(clienteId), '+
    '  CONSTRAINT CK_TipoObs CHECK (tipoObservacao IN (2,3)) '+
    '); '+
    'CREATE INDEX IDX_cliente_obs_clienteId '+
    'ON clienteObservacao(clienteId); '
    );
  end;
end;

procedure TAtualizacaoTableMSSQL.ClienteStatus;
begin
  if not TabelaExiste('clienteStatus') then
  begin
    ExecutaDiretoBancoDeDados(
    '   Create TABLE clienteStatus(   '+
    ' clienteStatusId int PRIMARY KEY,   '+
    ' descricao varchar(20)  '+
    ' ) '
    );
  end;

  ExecutaDiretoBancoDeDados(
  'IF NOT EXISTS (SELECT 1 FROM clienteStatus) '+
  'BEGIN '+
  ' INSERT INTO clienteStatus (clienteStatusId, descricao) VALUES '+
  ' (1, ''Ativo''), '+
  ' (2, ''Bloqueado''), '+
  ' (3, ''Atenção''), '+
  ' (4, ''Inativo''), '+
  ' (5, ''Prospecto'') '+
  'END'
  );
end;

procedure TAtualizacaoTableMSSQL.TipoEstoqueProduto;
begin
  if not TabelaExiste('tipoEstoqueProduto') then
  begin
    ExecutaDiretoBancoDeDados(
      'CREATE TABLE tipoEstoqueProduto ( '+
      ' tipoEstoqueProdutoId INT PRIMARY KEY, '+
      ' descricao VARCHAR(30) NOT NULL, '+
      ' sigla VARCHAR(10) NOT NULL, '+
      ' permiteDecimal BIT NOT NULL, '+
      ' casasDecimais INT NOT NULL '+
      ' )'
    );
  end;

  ExecutaDiretoBancoDeDados(
    'IF NOT EXISTS (SELECT 1 FROM tipoEstoqueProduto) '+
    'BEGIN '+
    ' INSERT INTO tipoEstoqueProduto '+
    ' (tipoEstoqueProdutoId, descricao, sigla, permiteDecimal, casasDecimais) VALUES '+
    ' (1, ''Unidade'', ''UN'', 0, 0), '+
    ' (2, ''Quilograma'', ''KG'', 1, 3), '+
    ' (3, ''Tonelada'', ''T'', 1, 3), '+
    ' (4, ''Litro'', ''L'', 1, 3), '+
    ' (5, ''Metro'', ''M'', 1, 2), '+
    ' (6, ''Caixa'', ''CX'', 0, 0); '+
    'END'
  );
end;

procedure TAtualizacaoTableMSSQL.Produto;
begin
  if not TabelaExiste('produtos') then
  begin
    ExecutaDiretoBancoDeDados(
  '    CREATE TABLE produtos(    '+
	'	produtoId int IDENTITY(1,1) NOT NULL,  '+
	'	nome varchar(60) NULL,  '+
	'	descricao varchar(255) null,  '+
  ' foto varbinary(max),  '+
	'	valor decimal(18,5) default 0.00000 null,  '+
	'	quantidade decimal(18,5) default 0.00000 null,  '+
	'	categoriasId int null,  '+
	'	PRIMARY KEY (produtoId),  '+
	'	CONSTRAINT FK_ProdutosCategorias  '+
	'	FOREIGN KEY (categoriasId) references categorias(categoriasId)  '+
	') '
    );
  end;
end;


procedure TAtualizacaoTableMSSQL.Vendas;
begin
  if not TabelaExiste('vendas') then
  begin
    ExecutaDiretoBancoDeDados(
  '    Create table vendas (  '+
	'  vendaId int identity(1,1) not null,  '+
	'  clienteId int not null,  '+
	' dataVenda datetime default getdate(),  '+
	' totalVenda decimal(18,5) default 0.00000,  '+
	'  PRIMARY KEY (vendaId), '+
	'  CONSTRAINT FK_VendasClientes FOREIGN KEY (clienteId)  '+
	'	REFERENCES clientes(clienteId)  '+
	')  '
    );
  end;
end;

procedure TAtualizacaoTableMSSQL.VendasItens;
begin
  if not TabelaExiste('vendasItens') then
  begin
    ExecutaDiretoBancoDeDados(
  '    Create table vendasItens (  '+
	'  vendaId int not null,  '+
	'  produtoId int not null,   '+
	'  valorUnitario decimal (18,5) default 0.00000,  '+
	'  quantidade decimal (18,5) default 0.00000,    '+
	'  totalProduto decimal (18,5) default 0.00000,   '+
	'  PRIMARY KEY (vendaId,produtoId),  '+
	'  CONSTRAINT FK_VendasItensProdutos FOREIGN KEY (produtoId)  '+
	'	REFERENCES produtos(produtoId)  '+
	')  '
    );
  end;
end;
end.

