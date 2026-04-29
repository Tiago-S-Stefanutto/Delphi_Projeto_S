unit uCadProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.ComCtrls, RxToolEdit, RxCurrEdit, cCadProduto, uEnum, uDTMConexao,
  uCadCategorias, cFuncao, uConCategoria, Vcl.Menus, System.StrUtils, Vcl.Imaging.jpeg, PngSpeedButton;

type
  TfrmCadProduto = class(TfrmTelaHeranca)
    edtProdutoId: TLabeledEdit;
    edtNome: TLabeledEdit;
    edtDescricao: TMemo;
    lblDescricao: TLabel;
    edtValor: TCurrencyEdit;
    edtQuantidade: TCurrencyEdit;
    lblValor: TLabel;
    lblQuantidade: TLabel;
    lkpCategoria: TDBLookupComboBox;
    QryCategoria: TFDQuery;
    dtsCategoria: TDataSource;
    F1QryCategoriacategoriasId: TFDAutoIncField;
    F2QryCategoriadescricao: TStringField;
    lblCategoria: TLabel;
    btnCategorias: TSpeedButton;
    btnPesquisarCategoria: TSpeedButton;
    pnlImage: TPanel;
    imgImagem: TImage;
    ppmImage: TPopupMenu;
    CarregarImagem1: TMenuItem;
    LimparImagem1: TMenuItem;
    N1: TMenuItem;
    ImagemProduto: TImage;
    lcbTipoEstoque: TDBLookupComboBox;
    QryTipoEstoque: TFDQuery;
    dtsTipoEstoque: TDataSource;
    btnLegendas: TBitBtn;
    QryListagemprodutoId: TFDAutoIncField;
    QryListagemnome: TStringField;
    QryListagemdescricao: TStringField;
    QryListagemvalor: TFMTBCDField;
    QryListagemquantidade: TFMTBCDField;
    QryListagemcategoriaId: TIntegerField;
    QryListagemfoto: TBlobField;
    QryListagemtipoEstoqueProdutoId: TIntegerField;
    QryListagemdescricaocategoria: TStringField;
    QryListagemsigla: TStringField;
    QryTipoEstoquetipoEstoqueProdutoId: TIntegerField;
    QryTipoEstoquedescricao: TStringField;
    QryTipoEstoquesigla: TStringField;
    QryTipoEstoquepermiteDecimal: TBooleanField;
    QryTipoEstoquecasasDecimais: TIntegerField;
    BalloonHint1: TBalloonHint;
    lblUnidade: TLabel;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCategoriasClick(Sender: TObject);
    procedure btnPesquisarCategoriaClick(Sender: TObject);
    procedure LimparImagem1Click(Sender: TObject);
    procedure CarregarImagem1Click(Sender: TObject);
    procedure QryListagemAfterScroll(DataSet: TDataSet);
    procedure grdListagemDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure btnLegendasMouseEnter(Sender: TObject);
    procedure btnLegendasMouseLeave(Sender: TObject);
    procedure lcbTipoEstoqueClick(Sender: TObject);
  private
    { Private declarations }
    oProduto:TProduto;
    function  Apagar:Boolean; override;
    function  Gravar(EstadoDoCadastro:TEstadoDoCadastro):Boolean; override;
    procedure AtualizarTipoEstoque;
    function NomeCampoId: string; override;
    function NomeCampoNome: string; override;
    function ValorLogId: string; override;
    function ValorLogNome: string; override;
  public
    { Public declarations }
  end;

var
  frmCadProduto: TfrmCadProduto;

implementation

uses  uPrincipal;

{$R *.dfm}


{$REGION 'Override'}

function TfrmCadProduto.Apagar: Boolean;
begin
  if oProduto.Selecionar(QryListagem.FieldByName('produtoId').AsInteger) then begin
     Result:=oProduto.Apagar;
  end;
end;

function TfrmCadProduto.Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean;
begin
  if edtProdutoId.Text<>EmptyStr then
     oProduto.codigo:=StrToInt(edtProdutoId.Text)
  else
     oProduto.codigo:=0;

  oProduto.nome                 :=edtNome.Text;
  oProduto.descricao            :=edtDescricao.Text;
  oProduto.categoriaId          :=lkpCategoria.KeyValue;
  oProduto.valor                :=edtValor.Value;
  oProduto.quantidade           :=edtQuantidade.Value;
  oProduto.tipoEstoqueProdutoId :=lcbTipoEstoque.KeyValue;
  if imgImagem.Picture.Bitmap.Empty then
    oProduto.Foto.Assign(nil)
  else
    oProduto.Foto.Assign(imgImagem.Picture);

  if (EstadoDoCadastro=ecInserir) then
     Result:=oProduto.Inserir
  else if (EstadoDoCadastro=ecAlterar) then
     Result:=oProduto.Atualizar;

  if Result and (EstadoDoCadastro = ecInserir) then
    edtProdutoId.Text := IntToStr(oProduto.codigo);
end;

function TfrmCadProduto.NomeCampoId: string;
begin
  Result := 'produtoId';
end;

function TfrmCadProduto.NomeCampoNome: string;
begin
  Result := 'nome';
end;

function TfrmCadProduto.ValorLogId: string;
begin
  Result := edtProdutoId.Text;
end;

function TfrmCadProduto.ValorLogNome: string;
begin
  Result := edtNome.Text;
end;

{$ENDREGION}

procedure TfrmCadProduto.grdListagemDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;

  if Column.FieldName = 'tipoEstoqueProdutoId' then
  begin
    grdListagem.Canvas.FillRect(Rect);
    grdListagem.Canvas.TextOut(
      Rect.Left + 2,
      Rect.Top + 2,
      QryListagem.FieldByName('sigla').AsString  // exibe a sigla no lugar do id
    );
  end
  else
    grdListagem.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;


procedure TfrmCadProduto.AtualizarTipoEstoque;
var
  PermiteDecimal : Boolean;
  CasasDecimais  : Integer;
begin
  if VarIsNull(lcbTipoEstoque.KeyValue) then Exit;

  QryTipoEstoque.First;
  while not QryTipoEstoque.Eof do
  begin
    if QryTipoEstoque.FieldByName('tipoEstoqueProdutoId').AsInteger = lcbTipoEstoque.KeyValue then
    begin
      PermiteDecimal := QryTipoEstoque.FieldByName('permiteDecimal').AsBoolean;
      CasasDecimais  := QryTipoEstoque.FieldByName('casasDecimais').AsInteger;
      Break;
    end;
    QryTipoEstoque.Next;
  end;

  edtQuantidade.MinValue := 0;

  if PermiteDecimal then
    edtQuantidade.DecimalPlaces := CasasDecimais
  else
  begin
    edtQuantidade.DecimalPlaces := 0;
    edtQuantidade.Value := Int(edtQuantidade.Value);
  end;
end;

procedure TfrmCadProduto.lcbTipoEstoqueClick(Sender: TObject);
begin
  inherited;
  AtualizarTipoEstoque;
end;

procedure TfrmCadProduto.LimparImagem1Click(Sender: TObject);
begin
  inherited;
  TFuncao.LimparImagem(imgImagem);
end;

procedure TfrmCadProduto.QryListagemAfterScroll(DataSet: TDataSet);
var
  BlobField: TBlobField;
  Stream: TStream;
begin
  inherited;

  try
    if QryListagem.Active and not QryListagem.IsEmpty then
    begin
      BlobField := QryListagem.FieldByName('foto') as TBlobField;

      if not BlobField.IsNull then
      begin
        Stream := QryListagem.CreateBlobStream(BlobField, bmRead);
        try
          ImagemProduto.Picture.LoadFromStream(Stream);
          ImagemProduto.Visible := True;
        finally
          Stream.Free;
        end;
      end
      else
        ImagemProduto.Visible := False;
    end;
  except
    ImagemProduto.Visible := False;
  end;
end;

procedure TfrmCadProduto.btnCategoriasClick(Sender: TObject);
begin
  inherited;
  TFuncao.CriarForm(TfrmCadCategorias, oUsuarioLogado, dtmPrincipal.ConexaoDB);
  QryCategoria.Refresh;
end;

procedure TfrmCadProduto.btnLegendasMouseEnter(Sender: TObject);
begin
  inherited;
  BalloonHint1.ShowHint(btnLegendas);
end;

procedure TfrmCadProduto.btnLegendasMouseLeave(Sender: TObject);
begin
  inherited;
  BalloonHint1.HideHint;
end;

procedure TfrmCadProduto.btnAlterarClick(Sender: TObject);
begin

  if oProduto.Selecionar(QryListagem.FieldByName('produtoId').AsInteger) then begin
     edtProdutoId.Text        :=IntToStr(oProduto.codigo);
     edtNome.Text             :=oProduto.nome;
     edtDescricao.Text        :=oProduto.descricao;
     lkpCategoria.KeyValue    :=oProduto.categoriaId;
     edtValor.value           :=oProduto.valor;
     edtQuantidade.value      :=oProduto.quantidade;
     lcbTipoEstoque.KeyValue  :=oProduto.tipoEstoqueProdutoId;
     AtualizarTipoEstoque;
     imgimagem.Picture.Assign(oProduto.foto);
  end
  else begin
    btnCancelar.Click;
    Abort;
  end;


  inherited;

end;

procedure TfrmCadProduto.btnNovoClick(Sender: TObject);
begin
  inherited;
  lcbTipoEstoque.KeyValue := 1;
  edtValor.Value := 0;
  edtQuantidade.Value := 0;
  lkpCategoria.KeyValue := Null;
  edtNome.SetFocus;

end;

procedure TfrmCadProduto.btnPesquisarCategoriaClick(Sender: TObject);
begin
  inherited;
  frmConCategorias:=TfrmConCategorias.Create(Self);

  if lkpCategoria.KeyValue<>null then
    frmConCategorias.aIniciarPesquisaId:=lkpCategoria.KeyValue;

  frmConCategorias.ShowModal;

  if frmConCategorias.aRetornarIdSelecionado<>Unassigned then // Não Atribuido
    lkpCategoria.KeyValue:=frmConCategorias.aRetornarIdSelecionado;

  frmConCategorias.Release;
end;

procedure TfrmCadProduto.CarregarImagem1Click(Sender: TObject);
begin
  inherited;
  TFuncao.CarregarImagem(imgImagem);
end;

procedure TfrmCadProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  QryCategoria.Close;
  QryTipoEstoque.Close;
  if Assigned(oProduto) then
    FreeAndNil(oProduto);
end;

procedure TfrmCadProduto.FormCreate(Sender: TObject);
begin
  inherited;
  oProduto  :=TProduto.Create(dtmPrincipal.ConexaoDB);

  IndiceAtual:='nome';
end;

procedure TfrmCadProduto.FormShow(Sender: TObject);
var
  HintText: string;
begin
  inherited;
  QryCategoria.Open;
  QryTipoEstoque.Open;

  // Monta a legenda das siglas
  HintText := '';
  QryTipoEstoque.First;
  while not QryTipoEstoque.Eof do
  begin
    HintText := HintText +
      QryTipoEstoque.FieldByName('sigla').AsString + ' = ' +
      QryTipoEstoque.FieldByName('descricao').AsString + #13#10;
    QryTipoEstoque.Next;
  end;

  HintText := HintText + #13#10#13#10;
  BalloonHint1.Description := HintText;
  BalloonHint1.Title       := 'Tipos de Estoque';
end;

end.
