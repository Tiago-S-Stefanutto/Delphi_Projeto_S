unit uCadSegmentoCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Mask, Vcl.ExtCtrls, Vcl.ComCtrls, uDTMConexao, uEnum,
  cCadSegmentoCliente, System.ImageList, Vcl.ImgList;

type
  TfrmCadSegmentoCliente = class(TfrmTelaHeranca)
    QryStatus: TFDQuery;
    QryStatusstatusId: TIntegerField;
    QryStatusdescricao: TStringField;
    dtsStatus: TDataSource;
    imgStatus: TImageList;
    edtId: TLabeledEdit;
    edtDescricao: TLabeledEdit;
    lkpStatus: TDBLookupComboBox;
    lblStatus: TLabel;
    QryListagemsegmentoClienteId: TFDAutoIncField;
    QryListagemdescricao: TStringField;
    QryListagemstatusId: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure grdListagemDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);

  private
    { Private declarations }
    oSegmentoCliente: TSegmentoCliente;

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
  frmCadSegmentoCliente: TfrmCadSegmentoCliente;

implementation

{$R *.dfm}

{ TfrmCadSegmentoCliente }

{ TfrmCadSegmentoCliente }

{$REGION 'Override'}
function TfrmCadSegmentoCliente.Apagar: Boolean;
begin
  Result := False;

  if oSegmentoCliente.Selecionar(QryListagem.FieldByName('segmentoClienteId').AsInteger) then
    Result := oSegmentoCliente.Apagar;
end;

function TfrmCadSegmentoCliente.Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean;
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
    oSegmentoCliente.codigo := StrToInt(edtId.Text)
  else
    oSegmentoCliente.codigo := 0;

  oSegmentoCliente.descricao := edtDescricao.Text;
  oSegmentoCliente.statusId := lkpStatus.KeyValue;

  if EstadoDoCadastro = ecInserir then
    Result := oSegmentoCliente.Inserir
  else
    Result := oSegmentoCliente.Atualizar;

  if Result then
  begin
    QryListagem.Close;
    QryListagem.Open;

    edtId.Text := IntToStr(oSegmentoCliente.codigo);
  end;
end;

procedure TfrmCadSegmentoCliente.grdListagemDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
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

function TfrmCadSegmentoCliente.NomeCampoId: string;
begin
  Result := 'segmentoClienteId';
end;

function TfrmCadSegmentoCliente.NomeCampoNome: string;
begin
  Result := 'descricao';
end;

function TfrmCadSegmentoCliente.ValorLogId: string;
begin
  Result := edtId.Text;
end;

function TfrmCadSegmentoCliente.ValorLogNome: string;
begin
  Result := edtDescricao.Text;
end;
{$ENDREGION}

procedure TfrmCadSegmentoCliente.btnAlterarClick(Sender: TObject);
begin
  if oSegmentoCliente.Selecionar(QryListagem.FieldByName('segmentoClienteId').AsInteger) then
  begin
    edtId.Text := IntToStr(oSegmentoCliente.codigo);
    edtDescricao.Text := oSegmentoCliente.descricao;
    lkpStatus.KeyValue := oSegmentoCliente.statusId;
  end
  else
  begin
    btnCancelar.Click;
    Abort;
  end;

  inherited;
end;

procedure TfrmCadSegmentoCliente.btnCancelarClick(Sender: TObject);
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

procedure TfrmCadSegmentoCliente.btnNovoClick(Sender: TObject);
begin
  inherited;

  if QryListagem.State in dsEditModes then
    QryListagem.Cancel;

  edtId.Clear;
  edtDescricao.Clear;
  lkpStatus.KeyValue := Null;

  edtDescricao.SetFocus;
end;

procedure TfrmCadSegmentoCliente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  if Assigned(oSegmentoCliente) then
    FreeAndNil(oSegmentoCliente);

  QryStatus.Close;
end;

procedure TfrmCadSegmentoCliente.FormCreate(Sender: TObject);
begin
  inherited;

  oSegmentoCliente := TSegmentoCliente.Create(dtmPrincipal.ConexaoDB);
  grdListagem.Options := grdListagem.Options - [dgEditing];
  QryListagem.CachedUpdates := False;
  IndiceAtual := 'descricao';

end;


procedure TfrmCadSegmentoCliente.FormShow(Sender: TObject);
begin
  inherited;

  QryStatus.Open;

  if QryListagem.State in dsEditModes then
    QryListagem.Cancel;

  QryListagem.Close;
  QryListagem.Open
end;

end.
