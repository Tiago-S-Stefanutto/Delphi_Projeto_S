unit cCadSegmentoCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.ComCtrls, RxToolEdit;

type
  TSegmentoCliente = class
    private
      conexaoDB : TFDConnection;

      F_segmentoClienteId : integer;
      F_descricao : string;
      F_statusId : integer;
    function EstaVinculado: Boolean;

    public

    constructor Create (aConexao : TFDConnection);
    destructor  Destroy; override;

    function  Inserir: Boolean;
    function  Atualizar: Boolean;
    function  Apagar: Boolean;
    function  Selecionar (id : integer): Boolean;

    property  codigo : integer    read F_segmentoClienteId  write F_segmentoClienteId;
    property  descricao: string   read F_descricao          write F_descricao;
    property  statusId: Integer   read F_statusId           write F_statusId;
end;

implementation

{$REGION 'Constructor and Destructor'}
constructor TSegmentoCliente.Create(aConexao : TFDConnection);
begin
  conexaoDB := aConexao;
end;

destructor  TSegmentoCliente.Destroy;
begin
  inherited;
end;
{$ENDREGION}

{$REGION 'CRUD'}
function TSegmentoCliente.Apagar: Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;

  if MessageDlg(
    'Apagar registro?' + sLineBreak +
    'Código: ' + IntToStr(F_segmentoClienteId) + sLineBreak +
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
         'UPDATE segmentoCliente '+
         'SET statusId = 2 '+
         'WHERE segmentoClienteId = :id';

       Qry.ParamByName('id').AsInteger := F_segmentoClienteId;
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
         'DELETE FROM segmentoCliente WHERE segmentoClienteId = :id';

       Qry.ParamByName('id').AsInteger := F_segmentoClienteId;
       Qry.ExecSQL;
     end;
     Result := True;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TSegmentoCliente.Atualizar: Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;

  if F_segmentoClienteId = 0 then Exit;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := ConexaoDB;

    Qry.SQL.Text :=
      'UPDATE segmentoCliente SET ' +
      ' descricao = :descricao, ' +
      ' statusId = :statusId ' +
      'WHERE segmentoClienteId = :id';

    Qry.ParamByName('id').AsInteger := F_segmentoClienteId;
    Qry.ParamByName('descricao').AsString := F_descricao;
    Qry.ParamByName('statusId').AsInteger := F_statusId;

    Qry.ExecSQL;

    Result := True;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TSegmentoCliente.Inserir: Boolean;
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
      'INSERT INTO segmentoCliente (descricao, statusId) ' +
      'OUTPUT INSERTED.segmentoClienteId ' +
      'VALUES (:descricao, :statusId)';

    Qry.ParamByName('descricao').AsString := F_descricao;
    Qry.ParamByName('statusId').AsInteger := F_statusId;

    Qry.Open;
    F_segmentoClienteId := Qry.Fields[0].AsInteger;

    Result := True;
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TSegmentoCliente.Selecionar(id: integer): Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := ConexaoDB;

    Qry.SQL.Text :=
      'SELECT segmentoClienteId, descricao, statusId ' +
      'FROM segmentoCliente WHERE segmentoClienteId = :id';

    Qry.ParamByName('id').AsInteger := id;
    Qry.Open;

    if not Qry.IsEmpty then
    begin
      F_segmentoClienteId := Qry.FieldByName('segmentoClienteId').AsInteger;
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

function TSegmentoCliente.EstaVinculado: Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := ConexaoDB;

    Qry.SQL.Text :=
      'SELECT TOP 1 1 FROM clientes '+
      'WHERE segmentoClienteId = :id';

    Qry.ParamByName('id').AsInteger := F_segmentoClienteId;
    Qry.Open;

    Result := not Qry.IsEmpty;
  finally
    FreeAndNil(Qry);
  end;
end;


end.
