unit uProVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.ComCtrls, uDTMConexao, uDtmVenda, RxCurrEdit, RxToolEdit, uEnum,
  cProdutoVenda, uRelProVenda, uCadCliente,cFuncao, uConClientes, cUsuarioLogado,
  uConProdutos, uObservacaoClientes;

type
  TfrmProVenda = class(TfrmTelaHeranca)
    QryListagemvendaId: TFDAutoIncField;
    QryListagemclienteId: TIntegerField;
    QryListagemnome: TStringField;
    QryListagemdataVenda: TSQLTimeStampField;
    QryListagemtotalVenda: TFMTBCDField;
    edtVendaId: TLabeledEdit;
    lblCliente: TLabel;
    lkpCliente: TDBLookupComboBox;
    lblDataVenda: TLabel;
    edtDataVenda: TDateEdit;
    pnl1: TPanel;
    pnl2: TPanel;
    pnl3: TPanel;
    pnl4: TPanel;
    lblValor: TLabel;
    edtValorTotal: TCurrencyEdit;
    dbGridItensVenda: TDBGrid;
    Label1: TLabel;
    lkpProduto: TDBLookupComboBox;
    lblProduto: TLabel;
    edtValorUnitario: TCurrencyEdit;
    edtQuantidade: TCurrencyEdit;
    btnAdicionarItem: TBitBtn;
    btnApagarItem: TBitBtn;
    lblValorUnitario: TLabel;
    lblQuantidade: TLabel;
    lblTotaldoProduto: TLabel;
    btnClientes: TSpeedButton;
    btnPesquisarClientes: TSpeedButton;
    edtDataInicio: TDateEdit;
    edtDataFinal: TDateEdit;
    Label2: TLabel;
    Label3: TLabel;
    btnPesquisarProduto: TSpeedButton;
    edtTotalProduto: TCurrencyEdit;
    ImagemProduto: TImage;
    pnlImagem: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnAdicionarItemClick(Sender: TObject);
    procedure lkpProdutoExit(Sender: TObject);
    procedure edtQuantidadeExit(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnApagarItemClick(Sender: TObject);
    procedure dbGridItensVendaDblClick(Sender: TObject);
    procedure btnClientesClick(Sender: TObject);
    procedure btnPesquisarClientesClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnPesquisarProdutoClick(Sender: TObject);
    procedure lkpClienteCloseUp(Sender: TObject);
    procedure lkpProdutoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    SelectOriginal:string;
    dtmVenda:TdtmVenda;
    oVenda:TVenda;
    FPodeVender: Boolean;

    function TotalizarProduto(valorUnitario, Quantidade: Double): Double;
    procedure LimparComponentesItem;
    procedure LimparCds;
    procedure CarregarRegistrosSelecionados;
    function TotalizarVenda: Double;
    procedure CarregarImagemProduto(Sender: TObject);
    procedure AtualizarTipoEstoque;
    procedure ValidarstatusCliente;
    function ValorLogId: string; override;
    function ValorLogNome: string; override;
  public
    { Public declarations }
    function  Gravar(EstadoDoCadastro:TEstadoDoCadastro):Boolean; override;
    function  Apagar:Boolean; override;
    function NomeCampoId: string; override;
    function NomeCampoNome: string; override;
  end;

var
  frmProVenda: TfrmProVenda;

implementation

uses uPrincipal;

{$REGION 'Override'}

function TfrmProVenda.Apagar: Boolean;
begin
  Result := oVenda.Apagar(QryListagem.FieldByName('vendaId').AsInteger);
end;

function TfrmProVenda.NomeCampoId: string;
begin
  Result := 'vendaId';
end;

function TfrmProVenda.NomeCampoNome: string;
begin
  Result := 'nome';
end;

function TfrmProVenda.ValorLogId: string;
begin
  Result := edtVendaId.Text;
end;

function TfrmProVenda.ValorLogNome: string;
begin
  Result := lkpCliente.Text;
end;

function  TfrmProVenda.Gravar(EstadoDoCadastro: TEstadoDoCadastro) : Boolean;
var Status: integer;
Qry: TFDQuery;
obs: string;
begin

  Status := dtmVenda.QryCliente.FieldByName('clienteStatusId').AsInteger;

  if dtmVenda.cdsItensVenda.RecordCount = 0 then
  begin
    MessageDlg('A venda precisa de pelo menos um produto.', mtWarning, [mbOK], 0);
    Result:= false;
    lkpProduto.SetFocus;
    Abort;
  end;

  {$REGION 'Observação'}

   Obs := '';
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := dtmPrincipal.ConexaoDB;
    Qry.SQL.Text :=
      'SELECT TOP 1 observacao '+
      'FROM clienteObservacao '+
      'WHERE clienteId = :clienteId '+
      'AND tipoObservacao IN (2,3) '+
      'ORDER BY dataRegistro DESC';

    Qry.ParamByName('clienteId').AsInteger :=
      dtmVenda.QryCliente.FieldByName('clienteId').AsInteger;

    Qry.Open;

    if not Qry.IsEmpty then
      Obs := Qry.FieldByName('observacao').AsString;

  finally
    if Assigned (Qry) then
        FreeAndNil(Qry);
  end;

  {$ENDREGION}


  if not FPodeVender then
  begin
    MessageDlg('O Status atual do cliente não permite que essa venda possa ser feita.'+ sLineBreak +
    Obs,
    mtError, [mbOK], 0);
    lkpCliente.SetFocus;
    Abort ;
  end;

  if edtVendaId.Text<>EmptyStr then
    oVenda.VendaId:=StrToInt(edtVendaId.Text)
  else
      oVenda.VendaId:=0;

    oVenda.ClienteId      :=lkpCliente.KeyValue;
    oVenda.DataVenda      :=edtDataVenda.Date;
    oVenda.TotalVenda     :=edtValorTotal.Value;

  if (EstadoDoCadastro=ecInserir) then
    oVenda.VendaId := oVenda.Inserir(dtmVenda.cdsItensVenda)
  else if (EstadoDoCadastro=ecAlterar) then
    oVenda.Atualizar(dtmVenda.cdsItensVenda);

  if Result and (EstadoDoCadastro = ecInserir) then
    edtVendaId.Text := IntToStr(oVenda.VendaId);

    frmRelProVenda:=TfrmRelProVenda.Create(Self);
    frmRelProVenda.QryVenda.Close;
    frmRelProVenda.QryVenda.ParamByName('VendaId').AsInteger:= oVenda.VendaId;
    frmRelProVenda.QryVenda.Open;

    frmRelProVenda.QryVendaItens.Close;
    frmRelProVenda.QryVendaItens.ParamByName('VendaId').AsInteger:= oVenda.VendaId;
    frmRelProVenda.QryVendaItens.Open;

    if Status in [4,5] then
    begin
      Qry := TFDQuery.Create(nil);
      try
        Qry.Connection := dtmPrincipal.ConexaoDB;

        Qry.SQL.Text :=
          'UPDATE clientes ' +
          'SET clienteStatusId = :clienteStatusId ' +
          'WHERE clienteId = :clienteId';

        Qry.ParamByName('clienteStatusId').AsInteger := 1; // Ativo
        Qry.ParamByName('clienteId').AsInteger := lkpCliente.KeyValue;

        Qry.ExecSQL;
      finally
        if Assigned (Qry) then
        FreeAndNil(Qry);
      end;
    end;

    frmRelProVenda.Relatorio.PreviewModal;
    frmRelProVenda.Release;

    Result:=True;
end;

{$ENDREGION}

procedure TfrmProVenda.lkpClienteCloseUp(Sender: TObject);
begin
  ValidarstatusCliente;
end;


procedure TfrmProVenda.AtualizarTipoEstoque;
var
  PermiteDecimal : Boolean;
  CasasDecimais  : Integer;
  TipoEstoqueId  : Integer;
begin
  if dtmVenda.QryProdutos.IsEmpty then Exit;

  TipoEstoqueId := dtmVenda.QryProdutos.FieldByName('tipoEstoqueProdutoId').AsInteger;

  dtmVenda.QryTipoEstoque.First;
  while not dtmVenda.QryTipoEstoque.Eof do
  begin
    if dtmVenda.QryTipoEstoque.FieldByName('tipoEstoqueProdutoId').AsInteger = TipoEstoqueId then
    begin
      PermiteDecimal := dtmVenda.QryTipoEstoque.FieldByName('permiteDecimal').AsBoolean;
      CasasDecimais  := dtmVenda.QryTipoEstoque.FieldByName('casasDecimais').AsInteger;
      Break;
    end;
    dtmVenda.QryTipoEstoque.Next;
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

procedure TfrmProVenda.lkpProdutoClick(Sender: TObject);
begin
  inherited;
  AtualizarTipoEstoque;
end;

procedure TfrmProVenda.lkpProdutoExit(Sender: TObject);
begin
  inherited;
  AtualizarTipoEstoque;
  if TDBLookupComboBox(Sender).KeyValue<>Null then begin
  edtValorUnitario.Value:=dtmVenda.QryProdutos.FieldByName('valor').AsFloat;
  edtQuantidade.Value:=1;
  edtTotalProduto.Value:=TotalizarProduto(edtValorUnitario.Value, edtQuantidade.Value);
  end;
end;

procedure TfrmProVenda.ValidarstatusCliente;
var Status: integer;
  Obs: String;
  Qry: TFDQuery;
begin
  inherited;
  FPodeVender := True;
  if not dtmVenda.QryCliente.Locate('clienteId', lkpCliente.KeyValue, []) then
    Exit;
  Status := dtmVenda.QryCliente.FieldByName('clienteStatusId').AsInteger;


  // Pega a ultima observação se existir
  Obs := '';
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := dtmPrincipal.ConexaoDB;
    Qry.SQL.Text :=
      'SELECT TOP 1 observacao '+
      'FROM clienteObservacao '+
      'WHERE clienteId = :clienteId '+
      'AND tipoObservacao IN (2,3) '+
      'ORDER BY dataRegistro DESC';

    Qry.ParamByName('clienteId').AsInteger :=
      dtmVenda.QryCliente.FieldByName('clienteId').AsInteger;

    Qry.Open;

    if not Qry.IsEmpty then
      Obs := Qry.FieldByName('observacao').AsString;

  finally
    if Assigned (Qry) then
        FreeAndNil(Qry);
  end;

  case Status of
    //Ativo
    1: FPodeVender := True;

    //Bloqueado
    2:
    begin
      MessageDlg('O cliente selecionado está com o Status Bloqueado.' + sLineBreak +
        Obs,
        mtError, [mbOK], 0);
      FPodeVender := False;
    end;

    //Atenção
    3:
    begin
      MessageDlg('O cliente selecionado está com o Status Atenção.'+ sLineBreak +
        Obs,
        mtWarning, [mbOK], 0);
      FPodeVender := True;
    end;

    //Inativo
    4:
    begin
      //MessageDlg('O cliente selecionado está com o Status Inativo.', mtInformation, [mbOK], 0);
      FPodeVender := True;
    end;

    //Prospecto
    5:
    begin
      //MessageDlg('O cliente selecionado está com o Status Prospecto.', mtInformation, [mbOK], 0);
      FPodeVender := True;
    end;
  end;

end;


{$R *.dfm}


procedure TfrmProVenda.btnAlterarClick(Sender: TObject);
begin
  inherited;


  if oVenda.Selecionar(QryListagem.FieldByName('vendaId').AsInteger, dtmVenda.cdsItensVenda) then begin
    edtVendaId.Text       :=IntToStr(oVenda.VendaId);
    lkpCliente.KeyValue   :=oVenda.ClienteId;
    edtDataVenda.Date     :=oVenda.DataVenda;
    edtValorTotal.Value   :=oVenda.TotalVenda;
    ValidarstatusCliente;
  end
  else begin
    btnCancelar.Click;
    Abort ;
  end;

end;

procedure TfrmProVenda.btnApagarItemClick(Sender: TObject);
begin
  inherited;
  if lkpProduto.KeyValue=Null then  begin
    MessageDlg('Selecione o Produto a ser excluído' ,mtInformation,[mbOK],0);
    dbGridItensVenda.SetFocus;
    Abort ;
  end;

  if dtmVenda.cdsItensVenda.Locate('produtoId', lkpProduto.KeyValue, []) then begin
    dtmVenda.cdsItensVenda.Delete;
    edtTotalProduto.Value:=TotalizarVenda;
    LimparComponentesItem;
  end;

end;

procedure TfrmProVenda.btnCancelarClick(Sender: TObject);
begin
  inherited;
  LimparCds;
end;

procedure TfrmProVenda.btnClientesClick(Sender: TObject);
begin
  inherited;

  TFuncao.CriarForm(TTfrmCadCliente, oUsuarioLogado, dtmPrincipal.ConexaoDB);
  dtmVenda.QryCliente.Refresh;
end;

procedure TfrmProVenda.btnGravarClick(Sender: TObject);
begin
  inherited;
  LimparCds;
end;

procedure TfrmProVenda.btnNovoClick(Sender: TObject);
begin
  inherited;
  edtDataVenda.Date:=Date;
  lkpCliente.KeyValue := null;
  lkpProduto.KeyValue := null;
  edtValorUnitario.Value := 0;
  edtQuantidade.Value := 0;
  lkpCliente.SetFocus;
  LimparCds;
end;

procedure TfrmProVenda.btnPesquisarClick(Sender: TObject);
var CondicaoData: string;
    TemInicio: Boolean;
    TemFim: Boolean;
    I: Integer;
    TipoCampo: TFieldType;
    NomeCampo: String;
    WhereOrAnd: String;
    CondicaoSQL: String;
    Valor: String;
    FS: TFormatSettings;
begin
  if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo,
     self.Name + '_' + TBitBtn(Sender).Name, DtmPrincipal.ConexaoDB) then
  begin
    MessageDlg('Usuário: ' + oUsuarioLogado.nome +
      ', não tem permissão de acesso', mtWarning, [mbOK], 0);
    Abort;
  end;

  Valor        := Trim(mskPesquisar.Text);
  TemInicio    := edtDataInicio.Date > 0;
  TemFim       := edtDataFinal.Date > 0;
  CondicaoSQL  := '';
  CondicaoData := '';
  NomeCampo    := '';
  TipoCampo    := ftUnknown;


  if (Valor = '') and (not TemInicio) and (not TemFim) then
  begin
    QryListagem.Close;
    QryListagem.SQL.Clear;
    QryListagem.SQL.Add(SelectOriginal);
    QryListagem.Open;
    Exit;
  end;

  if Valor <> '' then
  begin
    for I := 0 to QryListagem.FieldCount - 1 do
    begin
      if QryListagem.Fields[I].FieldName = IndiceAtual then
      begin
        TipoCampo := QryListagem.Fields[I].DataType;
        if QryListagem.Fields[I].Origin <> '' then
        begin
          if Pos('.', QryListagem.Fields[I].Origin) > 0 then
            NomeCampo := QryListagem.Fields[I].Origin
          else
            NomeCampo := QryListagem.Fields[I].Origin + '.' +
                         QryListagem.Fields[I].FieldName;
        end
        else
          NomeCampo := QryListagem.Fields[I].FieldName;
        Break;
      end;
    end;

    if NomeCampo <> '' then
    begin
      case TipoCampo of
        ftString, ftWideString:
          CondicaoSQL := ' WHERE ' + NomeCampo + ' LIKE :VALOR';

        ftInteger, ftSmallint, ftAutoInc:
          begin
            if not TryStrToInt(Valor, I) then
            begin
              MessageDlg('Digite um número válido', mtWarning, [mbOK], 0);
              Exit;
            end;
            CondicaoSQL := ' WHERE ' + NomeCampo + ' = :VALOR';
          end;

        ftFloat, ftCurrency, ftFMTBcd, ftBCD:
          CondicaoSQL := ' WHERE ' + NomeCampo + ' = :VALOR';

        ftDate, ftDateTime:
          CondicaoSQL := ' WHERE ' + NomeCampo + ' = :VALOR';
      end;
    end;
  end;

  if TemInicio and TemFim then
    CondicaoData := 'vendas.dataVenda BETWEEN :dataInicio AND :dataFim'
  else if TemInicio then
    CondicaoData := 'vendas.dataVenda >= :dataInicio'
  else if TemFim then
    CondicaoData := 'vendas.dataVenda <= :dataFim';


  if CondicaoData <> '' then
  begin
    if CondicaoSQL <> '' then
      CondicaoData := ' AND ' + CondicaoData
    else
      CondicaoData := ' WHERE ' + CondicaoData;
  end;

  QryListagem.Close;
  QryListagem.SQL.Text := SelectOriginal + ' ' + CondicaoSQL + ' ' + CondicaoData;

  if (Valor <> '') and (QryListagem.Params.FindParam('VALOR') <> nil) then
  begin
    case TipoCampo of
      ftString, ftWideString:
        QryListagem.ParamByName('VALOR').AsString := '%' + Valor + '%';

      ftInteger, ftSmallint, ftAutoInc:
        QryListagem.ParamByName('VALOR').AsInteger := I;

      ftFloat, ftCurrency, ftFMTBcd, ftBCD:
      begin
        FS := TFormatSettings.Create;
        FS.DecimalSeparator := ',';

        QryListagem.ParamByName('VALOR').AsFloat :=StrToFloat(Valor, FS);
      end;

      ftDate, ftDateTime:
        QryListagem.ParamByName('VALOR').AsDateTime := StrToDate(Valor);
    end;
  end;

  if TemInicio then
    QryListagem.ParamByName('dataInicio').AsDate := edtDataInicio.Date;
  if TemFim then
    QryListagem.ParamByName('dataFim').AsDate := edtDataFinal.Date;

  try
    QryListagem.Open;
  except
    on E: Exception do
    begin
      QryListagem.Close;
      QryListagem.SQL.Clear;
      QryListagem.SQL.Add(SelectOriginal);
      QryListagem.Open;
      MessageDlg('Erro na pesquisa: ' + E.Message, mtError, [mbOK], 0);
      Exit;
    end;
  end;

  mskPesquisar.Text := '';
  mskPesquisar.SetFocus;
  edtDataInicio.Clear;
  edtDataFinal.Clear;
end;

procedure TfrmProVenda.btnPesquisarClientesClick(Sender: TObject);
begin
  inherited;
  frmConClientes:=TfrmConClientes.Create(Self);

  if lkpCliente.KeyValue<>null then
    frmConClientes.aIniciarPesquisaId:=lkpCliente.KeyValue;

  frmConClientes.ShowModal;

  if frmConClientes.aRetornarIdSelecionado<>Unassigned then // Não Atribuido
    lkpCliente.KeyValue:=frmConClientes.aRetornarIdSelecionado;

  frmConClientes.Release;
end;

procedure TfrmProVenda.btnPesquisarProdutoClick(Sender: TObject);
begin
  inherited;
  frmConsultaProdutos:=TfrmConsultaProdutos.Create(Self);

  if lkpProduto.KeyValue<>null then
    frmConsultaProdutos.aIniciarPesquisaId:=lkpProduto.KeyValue;

  frmConsultaProdutos.ShowModal;

  if frmConsultaProdutos.aRetornarIdSelecionado<>Unassigned then // Não Atribuido
    lkpProduto.KeyValue:=frmConsultaProdutos.aRetornarIdSelecionado;

  frmConsultaProdutos.Release;
end;

procedure TfrmProVenda.btnAdicionarItemClick(Sender: TObject);
var EstoqueAtual: Double;
begin
  inherited;

  if lkpProduto.KeyValue = Null then begin
    MessageDlg('Produto é um campo obrigatório', mtInformation, [mbOk], 0);
    lkpProduto.SetFocus;
    Abort;
  end;

  if edtValorUnitario.Value <= 0 then begin
    MessageDlg('Valor Unitário não pode ser Zero', mtInformation, [mbOk], 0);
    edtValorUnitario.SetFocus;
    Abort;
  end;

  if edtQuantidade.Value <= 0 then begin
    MessageDlg('Quantidade não pode ser Zero', mtInformation, [mbOK], 0);
    edtQuantidade.SetFocus;
    Abort;
  end;

  EstoqueAtual := dtmVenda.QryProdutos.FieldByName('quantidade').AsFloat;

  if edtQuantidade.Value > EstoqueAtual then
  begin
    if MessageDlg('A quantidade informada é maior que o estoque atual (' +
      FloatToStr(EstoqueAtual) + '). Deseja continuar mesmo assim?',
      mtWarning, [mbYes, mbNo], 0) = mrNo then
    begin
      edtQuantidade.SetFocus;
      Abort;
    end;
  end;

  edtTotalProduto.Value := TotalizarProduto(edtValorUnitario.Value, edtQuantidade.Value);

  if dtmVenda.cdsItensVenda.Locate('produtoId', lkpProduto.KeyValue, []) then
  begin
    dtmVenda.cdsItensVenda.Edit;
  end
  else
  begin
    dtmVenda.cdsItensVenda.Append;
    dtmVenda.cdsItensVenda.FieldByName('produtoId').AsString  := lkpProduto.KeyValue;
    dtmVenda.cdsItensVenda.FieldByName('nomeProduto').AsString :=
      dtmVenda.QryProdutos.FieldByName('nome').AsString;
  end;

  dtmVenda.cdsItensVenda.FieldByName('quantidade').AsFloat        := edtQuantidade.Value;
  dtmVenda.cdsItensVenda.FieldByName('valorUnitario').AsFloat     := edtValorUnitario.Value;
  dtmVenda.cdsItensVenda.FieldByName('valorTotalProduto').AsFloat := edtTotalProduto.Value;
  dtmVenda.cdsItensVenda.Post;

  edtValorTotal.Value := TotalizarVenda;
  LimparComponentesItem;
  lkpProduto.SetFocus;
end;

procedure TfrmProVenda.LimparComponentesItem;
begin
  lkpProduto.KeyValue   :=Null;
  edtQuantidade.Value   := 0;
  edtValorUnitario.Value:= 0;
  edtTotalProduto.Value := 0;
end;

procedure TfrmProVenda.LimparCds;
begin
  dtmVenda.cdsItensVenda.First;
  while not dtmVenda.cdsItensVenda.Eof do
    dtmVenda.cdsItensVenda.Delete;
end;

procedure TfrmProVenda.edtQuantidadeExit(Sender: TObject);
begin
  inherited;
  edtTotalProduto.Value:=TotalizarProduto(edtValorUnitario.Value, edtQuantidade.Value);
end;

function  TfrmProVenda.TotalizarProduto(valorUnitario, Quantidade:Double):Double;
begin
  result :=valorUnitario * Quantidade;
end;

procedure TfrmProVenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if Assigned (dtmVenda) then
    FreeAndNil(dtmVenda);

  if Assigned (oVenda) then
    FreeAndNil(oVenda);
end;

procedure TfrmProVenda.FormCreate(Sender: TObject);
begin
  inherited;
  dtmVenda:=TdtmVenda.Create(Self);

  oVenda:=TVenda.Create(dtmPrincipal.ConexaoDB);

  dtmVenda.cdsItensVenda.Open;

  IndiceAtual:='clienteId';

   SelectOriginal := QryListagem.SQL.Text;

   dtmVenda.OnItemVendaChange := CarregarImagemProduto;

end;

procedure TfrmProVenda.FormShow(Sender: TObject);
begin
  inherited;
  dtmVenda.QryTipoEstoque.Open;
end;

procedure TfrmProVenda.CarregarImagemProduto(Sender: TObject);
var
  BlobField: TBlobField;
  Stream: TStream;
begin
  if dtmVenda.QryProdutos.Locate('produtoId',
     dtmVenda.cdsItensVenda.FieldByName('produtoId').AsInteger, []) then
  begin
    BlobField := dtmVenda.QryProdutos.FieldByName('foto') as TBlobField;

    if not BlobField.IsNull then
    begin
      Stream := dtmVenda.QryProdutos.CreateBlobStream(BlobField, bmRead);
      try
        ImagemProduto.Picture.LoadFromStream(Stream);
        ImagemProduto.Visible := True;
      finally
        Stream.Free;
      end;
    end
    else
      ImagemProduto.Visible := False;
  end
  else
    ImagemProduto.Visible := False;
end;

procedure TfrmProVenda.CarregarRegistrosSelecionados;
begin
  lkpProduto.KeyValue    :=dtmVenda.cdsItensVenda.FieldByName('produtoId').AsString;
  edtQuantidade.Value    :=dtmVenda.cdsItensVenda.FieldByName('quantidade').AsFloat;
  edtValorUnitario.Value :=dtmVenda.cdsItensVenda.FieldByName('valorUnitario').AsFloat;
  edtTotalProduto.Value  :=dtmVenda.cdsItensVenda.FieldByName('valorTotalProduto').AsFloat;
end;

procedure TfrmProVenda.dbGridItensVendaDblClick(Sender: TObject);
begin
  inherited;
  CarregarRegistrosSelecionados;
  ValidarstatusCliente;
end;

function  TfrmProVenda.TotalizarVenda:Double;
var Valor:Double;
begin
  Valor:=0;
  dtmVenda.cdsItensVenda.First;
  while not dtmVenda.cdsItensVenda.Eof do begin
    Valor := Valor + dtmVenda.cdsItensVenda.FieldByName('valorTotalProduto').Asfloat;
    dtmVenda.cdsItensVenda.Next;
  end;
  Result:=Valor;
end;

end.
