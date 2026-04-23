unit uCadPrimeiroContatoCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Mask, Vcl.ExtCtrls, Vcl.ComCtrls, uDTMConexao, uEnum,
  cCadPrimeiroContatoCliente, System.ImageList, Vcl.ImgList;

type
  TfrmCadPrimeiroContato = class(TfrmTelaHeranca)
    edtId: TLabeledEdit;
    edtDescricao: TLabeledEdit;
    QryStatus: TFDQuery;
    QryStatusstatusId: TIntegerField;
    QryStatusdescricao: TStringField;
    dtsStatus: TDataSource;
    imgStatus: TImageList;
    QryListagemprimeiroContatoClienteId: TFDAutoIncField;
    QryListagemdescricao: TStringField;
    QryListagemstatusId: TIntegerField;
    lblStatus: TLabel;
    lkpStatus: TDBLookupComboBox;
    Label1: TLabel;
    procedure grdListagemDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    oPrimeiroContatoCliente: TPrimeiroContatoCliente;

    function Apagar: Boolean; override;
    function Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean; override;

    function NomeCampoId: string; override;
    function NomeCampoNome: string; override;
    function ValorLogId: string; override;
    function ValorLogNome: string; override;
  public
    { Public declarations }
  end;

var
  frmCadPrimeiroContato: TfrmCadPrimeiroContato;

implementation

{$R *.dfm}

{$REGION 'Override'}
function TfrmCadPrimeiroContato.Apagar: Boolean;
begin
  Result := False;

  if oPrimeiroContatoCliente.Selecionar(QryListagem.FieldByName('primeiroContatoClienteId').AsInteger) then
    Result := oPrimeiroContatoCliente.Apagar;
end;

function TfrmCadPrimeiroContato.Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean;
begin
  Result := False;

  if Trim(edtDescricao.Text) = '' then
  begin
    ShowMessage('Informe a descrição.');
    edtDescricao.SetFocus;
    Exit;
  end;

  if VarIsNull(lkpStatus.KeyValue) then
  begin
    ShowMessage('Selecione um Status.');
    lkpStatus.SetFocus;
    Exit;
  end;

  if edtId.Text <> '' then
    oPrimeiroContatoCliente.codigo := StrToInt(edtId.Text)
  else
    oPrimeiroContatoCliente.codigo := 0;

  oPrimeiroContatoCliente.descricao := edtDescricao.Text;
  oPrimeiroContatoCliente.statusId := lkpStatus.KeyValue;

  if EstadoDoCadastro = ecInserir then
    Result := oPrimeiroContatoCliente.Inserir
  else
    Result := oPrimeiroContatoCliente.Atualizar;

  if Result then
  begin
    QryListagem.Close;
    QryListagem.Open;

    edtId.Text := IntToStr(oPrimeiroContatoCliente.codigo);
  end;
end;

function TfrmCadPrimeiroContato.NomeCampoId: string;
begin
  Result := 'primeiroContatoClienteId';
end;

function TfrmCadPrimeiroContato.NomeCampoNome: string;
begin
  Result := 'descricao';
end;

function TfrmCadPrimeiroContato.ValorLogId: string;
begin
  Result := edtId.Text;
end;

function TfrmCadPrimeiroContato.ValorLogNome: string;
begin
  Result := edtDescricao.Text;
end;
{$ENDREGION}
{ TfrmCadPrimeiroContato }

procedure TfrmCadPrimeiroContato.btnAlterarClick(Sender: TObject);
begin
  if oPrimeiroContatoCliente.Selecionar(QryListagem.FieldByName('primeiroContatoClienteId').AsInteger) then
  begin
    edtId.Text := IntToStr(oPrimeiroContatoCliente.codigo);
    edtDescricao.Text := oPrimeiroContatoCliente.descricao;
    lkpStatus.KeyValue := oPrimeiroContatoCliente.statusId;
  end
  else
  begin
    btnCancelar.Click;
    Abort;
  end;

  inherited;

end;

procedure TfrmCadPrimeiroContato.btnCancelarClick(Sender: TObject);
begin
  inherited;

  if QryListagem.State in dsEditModes then
    QryListagem.Cancel;

  QryListagem.Close;
  QryListagem.Open;

  edtId.Clear;
  edtDescricao.Clear;
  lkpStatus.KeyValue := Null;
end;

procedure TfrmCadPrimeiroContato.btnNovoClick(Sender: TObject);
begin
  inherited;

  if QryListagem.State in dsEditModes then
    QryListagem.Cancel;

  edtId.Clear;
  edtDescricao.Clear;
  lkpStatus.KeyValue := Null;

  edtDescricao.SetFocus;
end;

procedure TfrmCadPrimeiroContato.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  if Assigned(oPrimeiroContatoCliente) then
    FreeAndNil(oPrimeiroContatoCliente);

  QryStatus.Close;
end;

procedure TfrmCadPrimeiroContato.FormCreate(Sender: TObject);
begin
  inherited;

  oPrimeiroContatoCliente := TPrimeiroContatoCliente.Create(dtmPrincipal.ConexaoDB);
  grdListagem.Options := grdListagem.Options - [dgEditing];
  QryListagem.CachedUpdates := False;
  IndiceAtual := 'descricao';

end;

procedure TfrmCadPrimeiroContato.FormShow(Sender: TObject);
begin
  inherited;

  QryStatus.Open;

  if QryListagem.State in dsEditModes then
    QryListagem.Cancel;

  QryListagem.Close;
  QryListagem.Open;
end;

procedure TfrmCadPrimeiroContato.grdListagemDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
var StatusId: Integer;
ImgIndex: Integer;
begin
  inherited;
  if Column.FieldName = 'statusId' then
  begin
    StatusId := Column.Field.AsInteger;

    case StatusId of
      1: ImgIndex := 0; // verde
      2: ImgIndex := 1; // vermelho
    else
      ImgIndex := -1;
    end;

    grdListagem.Canvas.FillRect(Rect);

    // centralizar imagem
    if ImgIndex >= 0 then
      imgStatus.Draw(
        grdListagem.Canvas,
        Rect.Left + (Rect.Width div 2) - 8,
        Rect.Top + (Rect.Height div 2) - 8,
        ImgIndex
      );

  end
  else
    grdListagem.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

end.
