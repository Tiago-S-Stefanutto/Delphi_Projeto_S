unit cCadRegiaoCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.ComCtrls, RxToolEdit;

type
  TRegiaoCliente = class
  private
    conexaoDB : TFDConnection;

    F_regiaoClienteId : integer;
    F_descricao : string;
    F_statusId : Integer;
    function EstaVinculado: Boolean;

  public
    constructor Create(aConexao: TFDConnection);
    destructor Destroy; override;

    function Inserir: Boolean;
    function Atualizar: Boolean;
    function Apagar: Boolean;
    function Selecionar(id: Integer): Boolean;

    property codigo : integer     read F_regiaoClienteId  write  F_regiaoClienteId;
    property descricao : string   read  F_descricao       write F_descricao;
    property  statusId : integer  read F_statusId         write F_statusId;

end;

implementation

{ TRegiaoCliente }

{$REGION 'Constructor and Destructor'}
constructor TRegiaoCliente.Create(aConexao: TFDConnection);
begin
  ConexaoDB := aConexao;
end;

destructor TRegiaoCliente.Destroy;
begin
  inherited;
end;

{$ENDREGION}

{$REGION 'CRUD'}
function TRegiaoCliente.Apagar: Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;

  if MessageDlg(
    'Apagar registro?' + sLineBreak +
    'Código: ' + IntToStr(F_regiaoClienteId) + sLineBreak +
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
         'UPDATE regiaoCliente '+
         'SET statusId = 2 '+
         'WHERE regiaoClienteId = :id';

       Qry.ParamByName('id').AsInteger := F_regiaoClienteId;
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
         'DELETE FROM regiaoCliente WHERE regiaoClienteId = :id';

       Qry.ParamByName('id').AsInteger := F_regiaoClienteId;
       Qry.ExecSQL;
    end;
    Result := True;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TRegiaoCliente.Atualizar: Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;

  if F_regiaoClienteId = 0 then Exit;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := ConexaoDB;

    Qry.SQL.Text :=
      'UPDATE regiaoCliente SET ' +
      ' descricao = :descricao, ' +
      ' statusId = :statusId ' +
      'WHERE regiaoClienteId = :id';

    Qry.ParamByName('id').AsInteger := F_regiaoClienteId;
    Qry.ParamByName('descricao').AsString := F_descricao;
    Qry.ParamByName('statusId').AsInteger := F_statusId;

    Qry.ExecSQL;

    Result := True;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TRegiaoCliente.Inserir: Boolean;
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
      'INSERT INTO regiaoCliente (descricao, statusId) ' +
      'OUTPUT INSERTED.regiaoClienteId ' +
      'VALUES (:descricao, :statusId)';

    Qry.ParamByName('descricao').AsString := F_descricao;
    Qry.ParamByName('statusId').AsInteger := F_statusId;

    Qry.Open;
    F_regiaoClienteId := Qry.Fields[0].AsInteger;

    Result := True;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TRegiaoCliente.Selecionar(id: Integer): Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := ConexaoDB;

    Qry.SQL.Text :=
      'SELECT regiaoClienteId, descricao, statusId ' +
      'FROM regiaoCliente WHERE regiaoClienteId = :id';

    Qry.ParamByName('id').AsInteger := id;
    Qry.Open;

    if not Qry.IsEmpty then
    begin
      F_regiaoClienteId := Qry.FieldByName('regiaoClienteId').AsInteger;
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

function TRegiaoCliente.EstaVinculado: Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := ConexaoDB;

    Qry.SQL.Text :=
      'SELECT TOP 1 1 FROM clientes '+
      'WHERE regiaoClienteId = :id';

    Qry.ParamByName('id').AsInteger := F_regiaoClienteId;
    Qry.Open;

    Result := not Qry.IsEmpty;
  finally
    FreeAndNil(Qry);
  end;
end;

end.
