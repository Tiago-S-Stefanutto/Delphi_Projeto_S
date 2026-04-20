unit cLog;

interface
uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.ComCtrls, RxToolEdit;

  type
    TLog = class

  private
    ConexaoDB: TFDConnection;

    F_usuarioId     : Integer;
    F_usuarioNome   : string;
    F_tela          : string;
    F_acao          : string;
    F_descricao     : string;


  public
    constructor Create(aConexao:TFDConnection);
    destructor Destroy; override;
    function Inserir(aGerenciarTransacao: Boolean = True):Boolean;

  published
    property usuarioId     :Integer    read F_usuarioId        write F_usuarioId;
    property usuarioNome   :string     read F_usuarioNome      write F_usuarioNome;
    property tela          :string     read F_tela             write F_tela;
    property acao          :string     read F_acao             write F_acao;
    property descricao     :string     read F_descricao        write F_descricao;


end;
implementation

{$region 'Constructor and Destructor'}
constructor TLog.Create(aConexao:TFDConnection);
begin
  //recebe a conexão com o banco
  ConexaoDB:=aConexao;
end;

destructor TLog.Destroy;
begin
  inherited;
end;

{$endRegion}

function TLog.Inserir(aGerenciarTransacao: Boolean = True): Boolean;
var Qry: TFDQuery;
begin
  try
    Result := True;
    Qry := TFDQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' INSERT INTO LogSistema (usuarioId, '+
                '                         usuarioNome, '+
                '                         tela, '+
                '                         acao, '+
                '                         descricao) '+
                ' VALUES                 (:usuarioId, '+
                '                         :usuarioNome, '+
                '                         :tela, '+
                '                         :acao, '+
                '                         :descricao)' );
    Qry.ParamByName('usuarioId').AsInteger        :=Self.F_usuarioId;
    Qry.ParamByName('usuarioNome').AsString       :=Self.F_usuarioNome;
    Qry.ParamByName('tela').AsString              :=Self.F_tela;
    Qry.ParamByName('acao').AsString              :=Self.F_acao;
    Qry.ParamByName('descricao').AsString         :=Self.F_descricao;

     if aGerenciarTransacao then
      if not ConexaoDB.InTransaction then
        ConexaoDB.StartTransaction;

    Try
      Qry.ExecSQL;

      if aGerenciarTransacao then
        ConexaoDB.Commit;
    Except
       on E: Exception do
      begin
        if aGerenciarTransacao and ConexaoDB.InTransaction then
          ConexaoDB.Rollback;
        ShowMessage('Erro ao gravar log: ' + E.Message);
        Result := False;
      end;
    End;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

end.
