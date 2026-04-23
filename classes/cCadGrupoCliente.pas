unit cCadGrupoCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.ComCtrls, RxToolEdit;


type
  TGrupoCliente = class
  private
    ConexaoDB: TFDConnection;

    F_grupoClienteId: Integer;
    F_descricao: string;
    F_statusId: Integer;
    function EstaVinculado: Boolean;

  public
    constructor Create(aConexao: TFDConnection);
    destructor Destroy; override;

    function Inserir: Boolean;
    function Atualizar: Boolean;
    function Apagar: Boolean;
    function Selecionar(id: Integer): Boolean;

    property codigo: Integer read F_grupoClienteId write F_grupoClienteId;
    property descricao: string read F_descricao write F_descricao;
    property statusId: Integer read F_statusId write F_statusId;
  end;

implementation
{$REGION 'Constructor and Destructor'}
constructor TGrupoCliente.Create(aConexao: TFDConnection);
begin
  ConexaoDB := aConexao;
end;

destructor TGrupoCliente.Destroy;
begin
  inherited;
end;
{$ENDREGION}

{$REGION 'CRUD'}
function TGrupoCliente.Inserir: Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;

  if Trim(F_descricao) = '' then
    raise Exception.Create('Informe a descrição.');

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := ConexaoDB;

    Qry.SQL.Text :=
      'INSERT INTO grupoCliente (descricao, statusId) ' +
      'OUTPUT INSERTED.grupoClienteId ' +
      'VALUES (:descricao, :statusId)';

    Qry.ParamByName('descricao').AsString := F_descricao;
    Qry.ParamByName('statusId').AsInteger := F_statusId;

    Qry.Open;
    F_grupoClienteId := Qry.Fields[0].AsInteger;

    Result := True;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TGrupoCliente.Atualizar: Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;

  if F_grupoClienteId = 0 then Exit;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := ConexaoDB;

    Qry.SQL.Text :=
      'UPDATE grupoCliente SET ' +
      ' descricao = :descricao, ' +
      ' statusId = :statusId ' +
      'WHERE grupoClienteId = :id';

    Qry.ParamByName('id').AsInteger := F_grupoClienteId;
    Qry.ParamByName('descricao').AsString := F_descricao;
    Qry.ParamByName('statusId').AsInteger := F_statusId;

    Qry.ExecSQL;

    Result := True;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TGrupoCliente.Apagar: Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;

  if MessageDlg(
    'Apagar registro?' + sLineBreak +
    'Código: ' + IntToStr(F_grupoClienteId) + sLineBreak +
    'Descrição: ' + F_descricao,
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  Qry := TFDQuery.Create(nil);
  try
     Qry.Connection := ConexaoDB;
     if EstaVinculado then
     begin
       // inativa
       Qry.SQL.Text :=
         'UPDATE grupoCliente '+
         'SET statusId = 2 '+
         'WHERE grupoClienteId = :id';

       Qry.ParamByName('id').AsInteger := F_grupoClienteId;
       Qry.ExecSQL;

       ShowMessage(
         'Este registro está vinculado a um cliente.' + sLineBreak +
         'Não pode ser excluído.' + sLineBreak +
         'Status alterado para INATIVO.'
       );
     end
     else  begin
       Qry.Connection := ConexaoDB;

       Qry.SQL.Text :=
         'DELETE FROM grupoCliente WHERE grupoClienteId = :id';

       Qry.ParamByName('id').AsInteger := F_grupoClienteId;
       Qry.ExecSQL;
     end;
     Result := True;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TGrupoCliente.Selecionar(id: Integer): Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := ConexaoDB;

    Qry.SQL.Text :=
      'SELECT grupoClienteId, descricao, statusId ' +
      'FROM grupoCliente WHERE grupoClienteId = :id';

    Qry.ParamByName('id').AsInteger := id;
    Qry.Open;

    if not Qry.IsEmpty then
    begin
      F_grupoClienteId := Qry.FieldByName('grupoClienteId').AsInteger;
      F_descricao := Qry.FieldByName('descricao').AsString;
      F_statusId := Qry.FieldByName('statusId').AsInteger;
      Result := True;
    end;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;
{$ENDREGION}

function TGrupoCliente.EstaVinculado: Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := ConexaoDB;

    Qry.SQL.Text :=
      'SELECT TOP 1 1 FROM clientes '+
      'WHERE grupoClienteId = :id';

    Qry.ParamByName('id').AsInteger := F_grupoClienteId;
    Qry.Open;

    Result := not Qry.IsEmpty;
  finally
    FreeAndNil(Qry);
  end;
end;

end.
