unit uCadGrupoCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Mask, Vcl.ExtCtrls, Vcl.ComCtrls, uDTMConexao, uEnum,
  cCadGrupoCliente, System.ImageList, Vcl.ImgList;

type
  TfrmCadGrupoCliente = class(TfrmTelaHeranca)
    edtDescricao: TLabeledEdit;
    edtId: TLabeledEdit;
    lkpStatus: TDBLookupComboBox;
    lblStatus: TLabel;
    QryStatus: TFDQuery;
    dtsStatus: TDataSource;
    QryStatusstatusId: TIntegerField;
    QryStatusdescricao: TStringField;
    QryListagemgrupoClienteId: TFDAutoIncField;
    QryListagemdescricao: TStringField;
    QryListagemstatusId: TIntegerField;
    imgStatus: TImageList;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure grdListagemDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);

  private
    oGrupoCliente: TGrupoCliente;

    function Apagar: Boolean; override;
    function Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean; override;

    function NomeCampoId: string; override;
    function NomeCampoNome: string; override;
    function ValorLogId: string; override;
    function ValorLogNome: string; override;

  public
  end;

var
  frmCadGrupoCliente: TfrmCadGrupoCliente;

implementation

{$R *.dfm}

{$REGION 'Override'}

function TfrmCadGrupoCliente.Apagar: Boolean;
begin
  Result := False;

  if oGrupoCliente.Selecionar(QryListagem.FieldByName('grupoClienteId').AsInteger) then
    Result := oGrupoCliente.Apagar;
end;

function TfrmCadGrupoCliente.Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean;
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
    oGrupoCliente.codigo := StrToInt(edtId.Text)
  else
    oGrupoCliente.codigo := 0;

  oGrupoCliente.descricao := edtDescricao.Text;
  oGrupoCliente.statusId := lkpStatus.KeyValue;

  if EstadoDoCadastro = ecInserir then
    Result := oGrupoCliente.Inserir
  else
    Result := oGrupoCliente.Atualizar;

  if Result then
  begin
    QryListagem.Close;
    QryListagem.Open;

    edtId.Text := IntToStr(oGrupoCliente.codigo);
  end;
end;

function TfrmCadGrupoCliente.NomeCampoId: string;
begin
  Result := 'grupoClienteId';
end;

function TfrmCadGrupoCliente.NomeCampoNome: string;
begin
  Result := 'descricao';
end;

function TfrmCadGrupoCliente.ValorLogId: string;
begin
  Result := edtId.Text;
end;

function TfrmCadGrupoCliente.ValorLogNome: string;
begin
  Result := edtDescricao.Text;
end;

{$ENDREGION}

procedure TfrmCadGrupoCliente.grdListagemDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
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

procedure TfrmCadGrupoCliente.btnAlterarClick(Sender: TObject);
begin
  if oGrupoCliente.Selecionar(QryListagem.FieldByName('grupoClienteId').AsInteger) then
  begin
    edtId.Text := IntToStr(oGrupoCliente.codigo);
    edtDescricao.Text := oGrupoCliente.descricao;
    lkpStatus.KeyValue := oGrupoCliente.statusId;
  end
  else
  begin
    btnCancelar.Click;
    Abort;
  end;

  inherited;
end;

procedure TfrmCadGrupoCliente.btnNovoClick(Sender: TObject);
begin
  inherited;

  if QryListagem.State in dsEditModes then
    QryListagem.Cancel;

  edtId.Clear;
  edtDescricao.Clear;
  lkpStatus.KeyValue := Null;

  edtDescricao.SetFocus;
end;

procedure TfrmCadGrupoCliente.btnCancelarClick(Sender: TObject);
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

procedure TfrmCadGrupoCliente.FormCreate(Sender: TObject);
begin
  inherited;

  oGrupoCliente := TGrupoCliente.Create(dtmPrincipal.ConexaoDB);
  grdListagem.Options := grdListagem.Options - [dgEditing];
  QryListagem.CachedUpdates := False;
  IndiceAtual := 'descricao';
end;

procedure TfrmCadGrupoCliente.FormShow(Sender: TObject);
begin
  inherited;

  QryStatus.Open;

  if QryListagem.State in dsEditModes then
    QryListagem.Cancel;

  QryListagem.Close;
  QryListagem.Open;
end;

procedure TfrmCadGrupoCliente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  if Assigned(oGrupoCliente) then
    FreeAndNil(oGrupoCliente);

  QryStatus.Close;
end;

end.
