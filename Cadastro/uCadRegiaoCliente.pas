unit uCadRegiaoCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Mask, Vcl.ExtCtrls, Vcl.ComCtrls, uDTMConexao, uEnum,
  cCadRegiaoCliente, System.ImageList, Vcl.ImgList;

type
  TfrmCadRegiaoCliente = class(TfrmTelaHeranca)
    QryStatus: TFDQuery;
    QryStatusstatusId: TIntegerField;
    QryStatusdescricao: TStringField;
    dtsStatus: TDataSource;
    imgStatus: TImageList;
    lkpStatus: TDBLookupComboBox;
    lblStatus: TLabel;
    edtDescricao: TLabeledEdit;
    edtId: TLabeledEdit;
    QryListagemregiaoClienteId: TFDAutoIncField;
    QryListagemdescricao: TStringField;
    QryListagemstatusId: TIntegerField;
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
    oRegiaoCliente: TRegiaoCliente;

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
  frmCadRegiaoCliente: TfrmCadRegiaoCliente;

implementation

{$R *.dfm}

{ TfrmCadRegiaoCliente }

{$REGION 'Override'}
function TfrmCadRegiaoCliente.Apagar: Boolean;
begin
  Result := False;

  if oRegiaoCliente.Selecionar(QryListagem.FieldByName('regiaoClienteId').AsInteger) then
    Result := oRegiaoCliente.Apagar;
end;

function TfrmCadRegiaoCliente.Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean;
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
    oRegiaoCliente.codigo := StrToInt(edtId.Text)
  else
    oRegiaoCliente.codigo := 0;

  oRegiaoCliente.descricao := edtDescricao.Text;
  oRegiaoCliente.statusId := lkpStatus.KeyValue;

  if EstadoDoCadastro = ecInserir then
    Result := oRegiaoCliente.Inserir
  else
    Result := oRegiaoCliente.Atualizar;

  if Result then
  begin
    QryListagem.Close;
    QryListagem.Open;

    edtId.Text := IntToStr(oRegiaoCliente.codigo);
  end;
end;

function TfrmCadRegiaoCliente.NomeCampoId: string;
begin
  Result := 'regiaoClienteId';
end;

function TfrmCadRegiaoCliente.NomeCampoNome: string;
begin
  Result := 'descricao';
end;

function TfrmCadRegiaoCliente.ValorLogId: string;
begin
  Result := edtId.Text;
end;

function TfrmCadRegiaoCliente.ValorLogNome: string;
begin
  Result := edtDescricao.Text;
end;
{$ENDREGION}

procedure TfrmCadRegiaoCliente.grdListagemDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
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

procedure TfrmCadRegiaoCliente.btnAlterarClick(Sender: TObject);
begin
  if oRegiaoCliente.Selecionar(QryListagem.FieldByName('regiaoClienteId').AsInteger) then
  begin
    edtId.Text := IntToStr(oRegiaoCliente.codigo);
    edtDescricao.Text := oRegiaoCliente.descricao;
    lkpStatus.KeyValue := oRegiaoCliente.statusId;
  end
  else
  begin
    btnCancelar.Click;
    Abort;
  end;

  inherited;
end;

procedure TfrmCadRegiaoCliente.btnCancelarClick(Sender: TObject);
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

procedure TfrmCadRegiaoCliente.btnNovoClick(Sender: TObject);
begin
  inherited;

  if QryListagem.State in dsEditModes then
    QryListagem.Cancel;

  edtId.Clear;
  edtDescricao.Clear;
  lkpStatus.KeyValue := Null;

  edtDescricao.SetFocus;

end;

procedure TfrmCadRegiaoCliente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  if Assigned(oRegiaoCliente) then
    FreeAndNil(oRegiaoCliente);

  QryStatus.Close;

end;

procedure TfrmCadRegiaoCliente.FormCreate(Sender: TObject);
begin
  inherited;

  oRegiaoCliente := TRegiaoCliente.Create(dtmPrincipal.ConexaoDB);
  grdListagem.Options := grdListagem.Options - [dgEditing];
  QryListagem.CachedUpdates := False;
  IndiceAtual := 'descricao';

end;

procedure TfrmCadRegiaoCliente.FormShow(Sender: TObject);
begin
  inherited;

  QryStatus.Open;

  if QryListagem.State in dsEditModes then
    QryListagem.Cancel;

  QryListagem.Close;
  QryListagem.Open;
end;

end.
