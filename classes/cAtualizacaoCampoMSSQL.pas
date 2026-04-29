unit cAtualizacaoCampoMSSQL;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.ComCtrls, RxToolEdit, cAtualizacaoBandoDeDados;

type
  TAtualizacaoCampoMSSQL = class(TAtualizaBancoDeDados)

  private
    function  CampoExisteNaTabela(aNomeTabela, aCampo: string): Boolean;
    procedure Versao1;

  protected

  public
    constructor Create(aConexao:TFDConnection);
    destructor Destroy; override;

  end;

implementation

{ TAtualizacaoCampoMSSQL }

function TAtualizacaoCampoMSSQL.CampoExisteNaTabela(aNomeTabela, aCampo: string): Boolean;
var Qry:TFDQuery;
begin
  try
    Result:=False;
    Qry:=TFDQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT COUNT (COLUMN_NAME)AS Qtde  ');
    Qry.SQL.Add('  FROM INFORMATION_SCHEMA.COLUMNS  ');
    Qry.SQL.Add(' WHERE LOWER(TABLE_NAME) = :Tabela  ');
    Qry.SQL.Add('  AND LOWER(COLUMN_NAME) = :Campo  ');
    Qry.ParamByName('Tabela').AsString := LowerCase(aNomeTabela);
    Qry.ParamByName('Campo').AsString := LowerCase(aCampo);
    Qry.Open;

    if Qry.FieldByName('Qtde').AsInteger>0 then
      Result:=True;
  finally
    Qry.Close;
    if Assigned (Qry) then
      FreeAndNil(Qry);
  end;
end;

procedure TAtualizacaoCampoMSSQL.Versao1;
begin
  if not CampoExisteNaTabela('produtos','foto') then
  begin
    ExecutaDiretoBancoDeDados('alter table produtos add foto varbinary(max) ');

  end;

  if not CampoExisteNaTabela('clientes','cnpj') then
  begin
    ExecutaDiretoBancoDeDados('alter table clientes add cnpj varchar(14) ');
  end;

  if not CampoExisteNaTabela('clientes','cpf') then
  begin
    ExecutaDiretoBancoDeDados('alter table clientes add cpf varchar(11) ');
  end;

  if not CampoExisteNaTabela('usuarios','senhaSalt') then
  ExecutaDiretoBancoDeDados('alter table usuarios add senhaSalt varchar(64)');

  if not CampoExisteNaTabela('usuarios','nivelUsuarioId') then
  begin
    ExecutaDiretoBancoDeDados('ALTER TABLE usuarios ADD nivelUsuarioId INT NOT NULL DEFAULT 3');

    ExecutaDiretoBancoDeDados('ALTER TABLE usuarios '+
                              ' CONSTRAINT FK_usuario_nivel '+
                              ' FOREIGN KEY (nivelUsuarioId) '+
                              ' REFERENCES nivelUsuario(nivelUsuarioId)');
  end;

  if not CampoExisteNaTabela('clientes', 'numeroCasa') then
  begin
    ExecutaDiretoBancoDeDados('ALTER TABLE clientes ADD numeroCasa VARCHAR(20)');
  end;

  // 1. CAMPO
  if not CampoExisteNaTabela('produtos','tipoEstoqueProdutoId') then
  begin
    ExecutaDiretoBancoDeDados(
      'ALTER TABLE produtos ADD tipoEstoqueProdutoId INT NOT NULL DEFAULT 1'
    );
  end;

  // Fk
  ExecutaDiretoBancoDeDados(
  'IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = ''FK_Produto_TipoEstoque'') '+
  'BEGIN '+
  ' ALTER TABLE produtos '+
  ' ADD CONSTRAINT FK_Produto_TipoEstoque '+
  ' FOREIGN KEY (tipoEstoqueProdutoId) '+
  ' REFERENCES tipoEstoqueProduto(tipoEstoqueProdutoId) '+
  'END'
  );

  // 3. CHECK (independente também)
  ExecutaDiretoBancoDeDados(
  'IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = ''CK_TipoEstoque_Decimal'') '+
  'BEGIN '+
  ' ALTER TABLE tipoEstoqueProduto ADD CONSTRAINT CK_TipoEstoque_Decimal '+
  ' CHECK ( '+
  ' (permiteDecimal = 0 AND casasDecimais = 0) OR '+
  ' (permiteDecimal = 1 AND casasDecimais > 0) '+
  ' ) '+
  'END'
  );

end;

constructor TAtualizacaoCampoMSSQL.Create(aConexao: TFDConnection);
begin
  ConexaoDB := aConexao;

  Versao1;
end;

destructor TAtualizacaoCampoMSSQL.Destroy;
begin

  inherited;
end;



end.
