unit uObservacaoClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.ComCtrls, RxToolEdit, uEnum, uDTMConexao, uDtmVenda;

type
  TfrmObservacaoCliente = class(TForm)
    mmObservacao: TMemo;
    lblTitulo: TLabel;
    btnSalvar: TBitBtn;
    btnFechar: TBitBtn;
    procedure btnSalvarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
  private
    { Private declarations }
    FclienteId: integer;
    FTipoObs: Integer;
  public
    { Public declarations }
    property ClienteId: Integer read FClienteId write FClienteId;
    property TipoObs: Integer read FTipoObs write FTipoObs;

  end;

var
  frmObservacaoCliente: TfrmObservacaoCliente;

implementation

{$R *.dfm}

procedure TfrmObservacaoCliente.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmObservacaoCliente.btnSalvarClick(Sender: TObject);
var Qry: TFDQuery;
begin
  if Trim(mmObservacao.Lines.Text) = '' then
  begin
    MessageDlg('Digite uma observação.', mtWarning, [mbOK], 0);
    Exit;
  end;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := dtmPrincipal.ConexaoDB;

    Qry.SQL.Text :=
      'INSERT INTO clienteObservacao (clienteId, tipoObservacao, observacao) '+
      'VALUES (:clienteId, :tipoObservacao, :observacao)';

    Qry.ParamByName('clienteId').AsInteger := FClienteId;
    Qry.ParamByName('tipoObservacao').AsInteger := FTipoObs;
    Qry.ParamByName('observacao').AsString := mmObservacao.Lines.Text;

    Qry.ExecSQL;

    ModalResult := mrOk;
  finally
    Qry.Free;
  end;
end;

end.
