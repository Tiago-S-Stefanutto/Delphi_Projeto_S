unit uCadUsuario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.ComCtrls, cCadUsuario, uEnum, uDTMConexao, cAcaoAcesso, System.ImageList, Vcl.ImgList;

type
  TfrmCadUsuario = class(TfrmTelaHeranca)
    edtUsuarioId: TLabeledEdit;
    edtNome: TLabeledEdit;
    QryListagemusuarioId: TFDAutoIncField;
    QryListagemnome: TStringField;
    QryListagemsenha: TStringField;
    QryNivel: TFDQuery;
    dtsNivel: TDataSource;
    lkpNivel: TDBLookupComboBox;
    QryListagemnivelUsuarioId: TIntegerField;
    QryNivelnivelUsuarioId: TIntegerField;
    QryNiveldescricao: TStringField;
    Label1: TLabel;
    lkpStatus: TDBLookupComboBox;
    Label2: TLabel;
    QryStatus: TFDQuery;
    dtsStatus: TDataSource;
    QryStatusstatusUsuarioId: TIntegerField;
    QryStatusdescricao: TStringField;
    QryListagemstatusUsuarioId: TIntegerField;
    imgStatus: TImageList;
    Label4: TLabel;
    Image2: TImage;
    Label3: TLabel;
    lblStatusNome2: TLabel;
    imgStatus2: TImage;
    lblStatusPesquisa2: TLabel;
    lblNomeStatus: TLabel;
    imagemStatus: TImage;
    lblStatusPesquisa: TLabel;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grdListagemDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure lblStatusNome2Click(Sender: TObject);
  private
    { Private declarations }
    FStatusFiltro: Integer;
    oUsuario:Tusuario;
  //function  Gravar(EstadoDoCadastro:TEstadoDoCadastro):Boolean; override;
    function  Apagar:Boolean; override;
    function NomeCampoId: string; override;
    function NomeCampoNome: string; override;
    function ValorLogId: string; override;
    function ValorLogNome: string; override;
  public
    { Public declarations }
    property StatusFiltro: Integer read FStatusFiltro write FStatusFiltro;
  end;

var
  frmCadUsuario: TfrmCadUsuario;

implementation

{$R *.dfm}

{ TfrmCadUsuario }

function TfrmCadUsuario.Apagar: Boolean;
begin
  if oUsuario.Selecionar(QryListagem.FieldByName('usuarioId').AsInteger) then begin
    Result:=oUsuario.Apagar;
  end;
end;

procedure TfrmCadUsuario.btnAlterarClick(Sender: TObject);
begin
  if oUsuario.Selecionar(QryListagem.FieldByName('usuarioID').AsInteger) then begin
     edtUsuarioId.Text:=IntToStr(oUsuario.codigo);
     edtNome.Text     :=oUsuario.nome;
  end
  else begin
    btnCancelar.Click;
    Abort;
  end;

  inherited;

end;

procedure TfrmCadUsuario.btnGravarClick(Sender: TObject);
begin
  if oUsuario.UsuarioExiste(edtNome.Text, oUsuario.codigo) then begin
    MessageDlg('Usuário já cadastrado', mtInformation, [mbok],0);
    edtNome.SetFocus;
    abort;
  end;

  if edtUsuarioId.Text<>EmptyStr then
     oUsuario.codigo:=StrToInt(edtUsuarioId.Text)
  else
     oUsuario.codigo:=0;

  oUsuario.nome := edtNome.Text;
  oUsuario.nivelUsuarioId := lkpNivel.KeyValue;
  oUsuario.statusUsuarioId := lkpStatus.KeyValue;

  inherited;
end;

procedure TfrmCadUsuario.btnNovoClick(Sender: TObject);
begin
  inherited;
  edtNome.SetFocus;
end;

procedure TfrmCadUsuario.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  QryNivel.Close;
  QryStatus.Close;
  if Assigned(oUsuario) then
    FreeAndNil(oUsuario);

end;

procedure TfrmCadUsuario.FormCreate(Sender: TObject);
begin
  inherited;
  oUsuario:=TUsuario.Create(dtmPrincipal.ConexaoDB);
  IndiceAtual:='nome';
end;

procedure TfrmCadUsuario.FormShow(Sender: TObject);
begin
  inherited;
  QryNivel.Open;
  QryStatus.Open;
  btnNovo.Visible := False;
  QryListagem.Close;
  QryListagem.SQL.Text := 'SELECT * FROM usuarios';

  if FStatusFiltro > 0 then
    QryListagem.SQL.Add('WHERE statusUsuarioId = :status');

  if FStatusFiltro > 0 then
    QryListagem.ParamByName('status').AsInteger := FStatusFiltro;

  QryListagem.Open;
end;

procedure TfrmCadUsuario.grdListagemDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
StatusId: Integer;
ImgIndex: Integer;
  begin
  inherited;
   // Status com imagem
  if Column.FieldName = 'statusUsuarioId' then
  begin
    StatusId := Column.Field.AsInteger;

    case StatusId of
      1: ImgIndex := 0;
      2: ImgIndex := 1;
      3: ImgIndex := 2;
    else
      ImgIndex := -1;
    end;

    grdListagem.Canvas.FillRect(Rect);

    if ImgIndex >= 0 then
      imgStatus.Draw(
        grdListagem.Canvas,
        Rect.Left + (Rect.Width div 2) - 8,
        Rect.Top + (Rect.Height div 2) - 8,
        ImgIndex
      );
  end;
end;

procedure TfrmCadUsuario.lblStatusNome2Click(Sender: TObject);
begin
  inherited;

end;

{function TfrmCadUsuario.Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean;
begin
  if EstadoDoCadastro=ecInserir then
    Result:= oUsuario.Inserir
  else if EstadoDoCadastro=ecAlterar then
    Result:= oUsuario.Atualizar;

  if Result and (EstadoDoCadastro = ecInserir) then
    edtUsuarioId.Text := IntToStr(oUsuario.codigo);

    TAcaoAcesso.PreencherUsuariosVsAcoes(dtmPrincipal.ConexaoDB);
end;}



function TfrmCadUsuario.NomeCampoId: string;
begin
  Result := 'usuarioId';
end;

function TfrmCadUsuario.NomeCampoNome: string;
begin
  Result := 'nome';
end;

function TfrmCadUsuario.ValorLogId: string;
begin
  Result := edtUsuarioId.Text;
end;

function TfrmCadUsuario.ValorLogNome: string;
begin
  Result := edtNome.Text;
end;
end.
