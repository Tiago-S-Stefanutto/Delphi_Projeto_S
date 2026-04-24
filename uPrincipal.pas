unit uPrincipal;

{$REGION 'Interface'}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus,
  uDTMConexao, Enter, uFrmAtualizaDB, uProVenda, uRelCategoria, uRelClienteFicha,
  uRelProduto, uRelCliente, uRelProdutoComCategoria, uSelecionarData,
  uRelVendaPorData, uCadUsuario, uAlterarSenha, cUsuarioLogado, Vcl.ComCtrls,
  uLogin, uCadAcaoAcesso, cAcaoAcesso, RLReport, uUsuarioVsAcoes, uTelaHeranca,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ExtCtrls,
  uDtmGrafico, VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart, VCLTee.DBChart, cArquivoIni, cFuncao,
  cAtualizacaoCampoMSSQL, Vcl.Buttons, System.ImageList, Vcl.ImgList,Vcl.Imaging.pngimage
  , cLog, uLogSistema, uCadGrupoCliente, uCadSegmentoCliente,
  uCadPrimeiroContatoCliente, uCadRegiaoCliente;

type
  TfrmPrincipal = class(TForm)

    {$REGION 'Componentes visuais'}
    stbPrincipal: TStatusBar;
    GridPanel1: TGridPanel;
    tmrAtualizaDashboard: TTimer;
    TreeView1: TTreeView;
    pnlTop: TPanel;
    {$ENDREGION}

    {$REGION 'Gráficos do Dashboard'}
    DBChart1: TDBChart;
    DBChart2: TDBChart;
    Series2: TPieSeries;
    DBChart3: TDBChart;
    DBChart4: TDBChart;
    Series3: TPieSeries;
    Series4: TFastLineSeries;
    Series1: THorizBarSeries;
    imgTree: TImageList;
    Panel1: TPanel;
    imgBackground: TImage;
    imgHeader: TImage;
    btnAterarSenha: TSpeedButton;
    btnCategoria: TSpeedButton;
    btnCliente: TSpeedButton;
    btnDashboard: TSpeedButton;
    btnDesligar: TSpeedButton;
    btnLog: TSpeedButton;
    btnProduto: TSpeedButton;
    btnVenda: TSpeedButton;
    imgLogo: TImage;
    {$ENDREGION}

    {$REGION 'Eventos do formulário'}
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    {$ENDREGION}

    {$REGION 'Eventos da TreeView'}
    procedure TreeView1DblClick(Sender: TObject);
    procedure TreeView1CustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    {$ENDREGION}

    {$REGION 'Eventos dos botões de atalho'}
    procedure btnDashboardClick(Sender: TObject);
    procedure btnVendaClick(Sender: TObject);
    procedure btnDesligarClick(Sender: TObject);
    procedure btnCategoriaClick(Sender: TObject);
    procedure btnProdutoClick(Sender: TObject);
    procedure btnClienteClick(Sender: TObject);
    procedure btnAterarSenhaClick(Sender: TObject);
    procedure btnLogClick(Sender: TObject);
    {$ENDREGION}

    {$REGION 'Eventos de menu / sistema'}
    procedure tmrAtualizaDashboardTimer(Sender: TObject);
    {$ENDREGION}

    {$REGION 'Procedures públicas de status/clientes'}
    procedure AtualizarStatusCliente;
    {$ENDREGION}

  private
    {$REGION 'Membros privados'}
    TeclaEnter: TMREnter;
    procedure AtualizacaoBancoDados(aForm: TfrmAtualizaDB);
    procedure VendaporDataClick(Sender: TObject);
    {$ENDREGION}

  public
    {$REGION 'Membros públicos'}
    procedure AtualizarDashBoard;
    {$ENDREGION}

  end;

var
  frmPrincipal: TfrmPrincipal;
  oUsuarioLogado: TUsuarioLogado;
  Log: TLog;

{$ENDREGION}

implementation

{$R *.dfm}

uses
  uCadCategorias, uCadCliente, uCadProduto, cAtualizacaoBandoDeDados;

// =============================================================================

{$REGION 'Inicialização e encerramento do formulário'}

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  NoCadastro, NoMov, NoRel, NoUsuario, NoSistema, NoCRM: TTreeNode;
begin
  {$REGION 'Verificação e criação do arquivo INI'}
  if not FileExists(TArquivoIni.ArquivoIni) then
  begin
    TArquivoIni.AtualizarIni('SERVER', 'TipoDataBase', 'MSSQL');
    TArquivoIni.AtualizarIni('SERVER', 'HostName', '.\');
    TArquivoIni.AtualizarIni('SERVER', 'Port', '1433');
    TArquivoIni.AtualizarIni('SERVER', 'OSAuthent', 'Yes');
    TArquivoIni.AtualizarIni('SERVER', 'User', 'admin');
    TArquivoIni.AtualizarIni('SERVER', 'Password', 'admin');
    TArquivoIni.AtualizarIni('SERVER', 'Database', 'vendas');

    MessageDlg('Arquivo ' + TArquivoIni.ArquivoIni + ' criado com sucesso!' + #13 + 'Configure o arquivo antes de inicializar a aplicação!!!', mtInformation, [mbOK], 0);

    Application.Terminate;
    Exit;
  end;
  {$ENDREGION}

  {$REGION 'Tela de atualização do banco'}
  frmAtualizaDB := TfrmAtualizaDB.Create(Self);
  frmAtualizaDB.Show;
  frmAtualizaDB.Refresh;
  {$ENDREGION}

  {$REGION 'Conexão com o banco de dados'}
  dtmPrincipal := TdtmPrincipal.Create(Self);

  with dtmPrincipal.ConexaoDB do
  begin
    Connected := False;
    Params.Clear;
    Params.DriverID := 'MSSQL';
    Params.Add('Server=' + TArquivoIni.LerIni('SERVER', 'HostName'));
    Params.Add('Database=' + TArquivoIni.LerIni('SERVER', 'Database'));

    if TArquivoIni.LerIni('SERVER', 'OSAuthent') = 'Yes' then
      Params.Add('OSAuthent=Yes')
    else
    begin
      Params.Add('User_Name=' + TArquivoIni.LerIni('SERVER', 'User'));
      Params.Add('Password=' + TArquivoIni.LerIni('SERVER', 'Password'));
    end;

    if TArquivoIni.LerIni('SERVER', 'Port') <> '' then
      Params.Add('Port=' + TArquivoIni.LerIni('SERVER', 'Port'));

    LoginPrompt := False;
    try
      Connected := True;
    except
      on E: Exception do
      begin
        ShowMessage('Erro ao conectar: ' + E.Message);
        Exit;
      end;
    end;
  end;

  dtmPrincipal.ConexaoDB.Connected := True;
  {$ENDREGION}

  {$REGION 'TeclaEnter'}
  TeclaEnter := TMREnter.Create(Self);
  TeclaEnter.FocusEnabled := True;
  TeclaEnter.FocusColor := clInfoBk;
  {$ENDREGION}

  {$REGION 'Atualização do banco de dados'}
  AtualizacaoBancoDados(frmAtualizaDB);
  {$ENDREGION}

  {$REGION 'Registro das ações de acesso'}
  TAcaoAcesso.CriarAcoes(TfrmCadCategorias, DtmPrincipal.ConexaoDB);
  TAcaoAcesso.CriarAcoes(TTfrmCadCliente, DtmPrincipal.ConexaoDB);
  TAcaoAcesso.CriarAcoes(TfrmCadProduto, DtmPrincipal.ConexaoDB);
  TAcaoAcesso.CriarAcoes(TfrmCadUsuario, DtmPrincipal.ConexaoDB);
  TAcaoAcesso.CriarAcoes(TfrmCadAcaoAcesso, DtmPrincipal.ConexaoDB);
  TAcaoAcesso.CriarAcoes(TfrmAlterarSenha, DtmPrincipal.ConexaoDB);
  TAcaoAcesso.CriarAcoes(TfrmProVenda, DtmPrincipal.ConexaoDB);
  TAcaoAcesso.CriarAcoes(TfrmRelVendaPorData, DtmPrincipal.ConexaoDB);
  TAcaoAcesso.CriarAcoes(TfrmRelClienteFicha, DtmPrincipal.ConexaoDB);
  TAcaoAcesso.CriarAcoes(TfrmRelCliente, DtmPrincipal.ConexaoDB);
  TAcaoAcesso.CriarAcoes(TfrmRelProdutoComCategoria, DtmPrincipal.ConexaoDB);
  TAcaoAcesso.CriarAcoes(TfrmRelProduto, DtmPrincipal.ConexaoDB);
  TAcaoAcesso.CriarAcoes(TfrmRelCategoria, DtmPrincipal.ConexaoDB);
  TAcaoAcesso.CriarAcoes(TfrmUsuarioVsAcoes, DtmPrincipal.ConexaoDB);
  TAcaoAcesso.CriarAcoes(TfrmSelecionarData, DtmPrincipal.ConexaoDB);
  TAcaoAcesso.CriarAcoes(TfrmLogSistema, DtmPrincipal.ConexaoDB);
  TAcaoAcesso.CriarAcoes(TfrmCadGrupoCliente, DtmPrincipal.ConexaoDB);
  TAcaoAcesso.CriarAcoes(TfrmCadSegmentoCliente, dtmPrincipal.ConexaoDB);
  TAcaoAcesso.CriarAcoes(TfrmCadPrimeiroContato, dtmPrincipal.ConexaoDB);
  TAcaoAcesso.CriarAcoes(TfrmCadRegiaoCliente, dtmPrincipal.ConexaoDB);

  TAcaoAcesso.PreencherUsuariosVsAcoes(dtmPrincipal.ConexaoDB);
  {$ENDREGION}

  {$REGION 'Dashboard inicial'}
  dtmGrafico := TdtmGrafico.Create(Self);
  AtualizarDashBoard;
  frmAtualizaDB.Free;
  {$ENDREGION}

  {$REGION 'Atualização de status dos clientes'}
  try
    AtualizarStatusCliente;
  except
    on E: Exception do
      ShowMessage('Erro ao atualizar status dos clientes: ' + E.Message);
  end;
  {$ENDREGION}

  {$REGION 'Montagem da TreeView'}
  TreeView1.Items.Clear;

  {$REGION 'Cadastro'}
    // Cadastro
    NoCadastro := TreeView1.Items.Add(nil, 'Cadastro');
    NoCadastro.ImageIndex := 0;
    NoCadastro.SelectedIndex := 0;

    with TreeView1.Items.AddChild(NoCadastro, 'Cliente') do
    begin
      ImageIndex := 4;
      SelectedIndex := 5;
    end;

    with TreeView1.Items.AddChild(NoCadastro, 'Categoria') do
    begin
      ImageIndex := 4;
      SelectedIndex := 5;
    end;

    with TreeView1.Items.AddChild(NoCadastro, 'Produto') do
    begin
      ImageIndex := 4;
      SelectedIndex := 5;
    end;
  {$ENDREGION}

  {$REGION 'Movimentação'}
    // Movimentação
    NoMov := TreeView1.Items.Add(nil, 'Movimentação');
    NoMov.ImageIndex := 1;
    NoMov.SelectedIndex := 1;

    with TreeView1.Items.AddChild(NoMov, 'Venda') do
    begin
      ImageIndex := 4;
      SelectedIndex := 5;
    end;
  {$ENDREGION}

  {$REGION 'CRM'}
    // CRM
    NoCRM := TreeView1.Items.Add(nil, 'CRM');
    NoCRM.ImageIndex := 7;
    NoCRM.SelectedIndex := 7;

    with TreeView1.Items.AddChild(NoCRM, 'Cad. Grupo de Cliente') do
    begin
      ImageIndex := 4;
      SelectedIndex := 5;
    end;
    with TreeView1.Items.AddChild(NoCRM, 'Cad. Segmento de Cliente') do
    begin
      ImageIndex := 4;
      SelectedIndex := 5;
    end;
    with TreeView1.Items.AddChild(NoCRM, 'Cad. Primeiro Contato Cliente') do
    begin
      ImageIndex := 4;
      SelectedIndex := 5;
    end;
    with TreeView1.Items.AddChild(NoCRM, 'Cad. Regiao do Cliente') do
    begin
      ImageIndex := 4;
      SelectedIndex := 5;
    end;
  {$ENDREGION}

  {$REGION 'Relatórios'}
    // Relatórios
    NoRel := TreeView1.Items.Add(nil, 'Relatórios');
    NoRel.ImageIndex := 2;
    NoRel.SelectedIndex := 2;

    with TreeView1.Items.AddChild(NoRel, 'Categoria') do
    begin
      ImageIndex := 4;
      SelectedIndex := 5;
    end;
    with TreeView1.Items.AddChild(NoRel, 'Cliente') do
    begin
      ImageIndex := 4;
      SelectedIndex := 5;
    end;
    with TreeView1.Items.AddChild(NoRel, 'Ficha de Cliente') do
    begin
      ImageIndex := 4;
      SelectedIndex := 5;
    end;
    with TreeView1.Items.AddChild(NoRel, 'Produto') do
    begin
      ImageIndex := 4;
      SelectedIndex := 5;
    end;
    with TreeView1.Items.AddChild(NoRel, 'Produto por Categoria') do
    begin
      ImageIndex := 4;
      SelectedIndex := 5;
    end;
    with TreeView1.Items.AddChild(NoRel, 'Venda por Data') do
    begin
      ImageIndex := 4;
      SelectedIndex := 5;
    end;
  {$ENDREGION}

  {$REGION 'Usuátios'}
    // Usuários
    NoUsuario := TreeView1.Items.Add(nil, 'Usuários');
    NoUsuario.ImageIndex := 3;
    NoUsuario.SelectedIndex := 3;

    with TreeView1.Items.AddChild(NoUsuario, 'Usuário') do
    begin
      ImageIndex := 4;
      SelectedIndex := 5;
    end;
    with TreeView1.Items.AddChild(NoUsuario, 'Usuários vs Ações') do
    begin
      ImageIndex := 4;
      SelectedIndex := 5;
    end;
    with TreeView1.Items.AddChild(NoUsuario, 'Ação de Acesso') do
    begin
       ImageIndex := 4;
       SelectedIndex := 5;
    end;
  {$ENDREGION}

  {$REGION 'Sistema'}

   NoSistema := TreeView1.Items.Add(nil, 'Sistema');
   NoSistema.ImageIndex := 6;
   NoSIstema.SelectedIndex := 6;

   with TreeView1.Items.AddChild(NoSistema, 'Log (Registros)') do
    begin
      ImageIndex := 4;
      SelectedIndex := 5;
    end;

  {$ENDREGION}

    TreeView1.FullExpand;
    TreeView1.HideSelection := False;
    TreeView1.RowSelect := True;
    TreeView1.ReadOnly := True;
  {$ENDREGION}

  {$REGION 'Montagem do Design'}
    frmPrincipal.Color := $00FFD5E4;
    pnlTop.Color := RGB(172, 122, 251);
    GridPanel1.Color := RGB(248, 244, 255);
    DBChart1.Color := clWhite;
    DBChart2.Color := clWhite;
    DBChart3.Color := clWhite;
    DBChart4.Color := clWhite;
    DBChart1.BevelOuter := bvNone;
    DBChart2.BevelOuter := bvNone;
    DBChart3.BevelOuter := bvNone;
    DBChart4.BevelOuter := bvNone;
  {$ENDREGION}
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  try
    oUsuarioLogado := TUsuarioLogado.Create;
    frmLogin := TfrmLogin.Create(Self);
    frmLogin.ShowModal;
  finally
    frmLogin.Release;
    stbPrincipal.Panels[0].Text := 'Usuário: ' + oUsuarioLogado.nome;
  end;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(TeclaEnter);
  FreeAndNil(dtmPrincipal);
  FreeAndNil(dtmGrafico);

  if Assigned(DtmPrincipal) then
    FreeAndNil(DtmPrincipal);

  if Assigned(oUsuarioLogado) then
    FreeAndNil(oUsuarioLogado);
end;

{$ENDREGION}

// =============================================================================

{$REGION 'Banco de dados — atualização estrutural'}

procedure TfrmPrincipal.AtualizacaoBancoDados(aForm: TfrmAtualizaDB);
var
  oAtualizarMSSQL: TAtualizaBancoDeDadosMSSQL;
begin
  aForm.Refresh;
  try
    oAtualizarMSSQL := TAtualizaBancoDeDadosMSSQL.Create(dtmPrincipal.ConexaoDB);
    oAtualizarMSSQL.AtualizaBancoDeDadosMSSQL;
  finally
    if Assigned(oAtualizarMSSQL) then
      FreeAndNil(oAtualizarMSSQL);
  end;
end;

{$ENDREGION}

// =============================================================================

{$REGION 'Dashboard'}

procedure TfrmPrincipal.AtualizarDashBoard;
begin
  try
    Screen.Cursor := crSQLWait;

    if dtmGrafico.QryProdutoEstoque.Active then
      dtmGrafico.QryProdutoEstoque.Close;
    if dtmGrafico.QryValorVendaPorCliente.Active then
      dtmGrafico.QryValorVendaPorCliente.Close;
    if dtmGrafico.QryVendasUltimaSeana.Active then
      dtmGrafico.QryVendasUltimaSeana.Close;
    if dtmGrafico.QryProdutosMaisVendidos.Active then
      dtmGrafico.QryProdutosMaisVendidos.Close;

    dtmGrafico.QryProdutoEstoque.Open;
    dtmGrafico.QryValorVendaPorCliente.Open;
    dtmGrafico.QryVendasUltimaSeana.Open;
    dtmGrafico.QryProdutosMaisVendidos.Open;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmPrincipal.tmrAtualizaDashboardTimer(Sender: TObject);
begin
  AtualizarDashBoard;
end;

{$ENDREGION}

// =============================================================================

{$REGION 'Botões de atalho (pnlTop)'}

procedure TfrmPrincipal.btnClienteClick(Sender: TObject);
begin
  TFuncao.CriarForm(TTfrmCadCliente, oUsuarioLogado, dtmPrincipal.ConexaoDB);
end;

procedure TfrmPrincipal.btnCategoriaClick(Sender: TObject);
begin
  TFuncao.CriarForm(TfrmCadCategorias, oUsuarioLogado, dtmPrincipal.ConexaoDB);
end;

procedure TfrmPrincipal.btnProdutoClick(Sender: TObject);
begin
  TFuncao.CriarForm(TfrmCadProduto, oUsuarioLogado, dtmPrincipal.ConexaoDB);
end;

procedure TfrmPrincipal.btnVendaClick(Sender: TObject);
begin
  TFuncao.CriarForm(TfrmProVenda, oUsuarioLogado, dtmPrincipal.ConexaoDB);
end;

procedure TfrmPrincipal.btnDesligarClick(Sender: TObject);
begin
  try
        Log := TLog.Create(dtmPrincipal.ConexaoDB);

        Log.  usuarioId      := oUsuarioLogado.codigo;
        Log.usuarioNome    := oUsuarioLogado.nome;

        Log.tela           := 'uPrincipal';
        Log.acao           := 'LogOut';
        Log.descricao      := ('Na tela ' + Log.tela + ' houve um(a) ' + Log.acao);

        if not Log.Inserir(False) then
            raise Exception.Create('Falha ao gravar log');

      finally
        if Assigned (Log) then
          FreeAndNil(Log);
      end;
  Application.Terminate;
end;

procedure TfrmPrincipal.btnAterarSenhaClick(Sender: TObject);
begin
  TFuncao.CriarForm(TfrmAlterarSenha, oUsuarioLogado, dtmPrincipal.ConexaoDB);
end;

procedure TfrmPrincipal.btnDashboardClick(Sender: TObject);
begin
  AtualizarDashBoard;

  GridPanel1.Visible := not GridPanel1.Visible;
  imgBackground.Visible := not GridPanel1.Visible;
end;

procedure TfrmPrincipal.btnLogClick(Sender: TObject);
begin
  TFuncao.CriarForm(TfrmLogSistema, oUsuarioLogado, dtmPrincipal.ConexaoDB);
end;

{$ENDREGION}

// =============================================================================

{$REGION 'TreeView — navegação e desenho'}

procedure TfrmPrincipal.TreeView1DblClick(Sender: TObject);
var
  Texto, Grupo: string;
begin
  if not Assigned(TreeView1.Selected) then
    Exit;

  Texto := TreeView1.Selected.Text;

  if Assigned(TreeView1.Selected.Parent) then
    Grupo := TreeView1.Selected.Parent.Text
  else
    Exit; // clicou em um nó raiz

  {$REGION 'Cadastro'}
  if (Grupo = 'Cadastro') and (Texto = 'Cliente') then
    TFuncao.CriarForm(TTfrmCadCliente, oUsuarioLogado, dtmPrincipal.ConexaoDB)
  else if (Grupo = 'Cadastro') and (Texto = 'Categoria') then
    TFuncao.CriarForm(TfrmCadCategorias, oUsuarioLogado, dtmPrincipal.ConexaoDB)
  else if (Grupo = 'Cadastro') and (Texto = 'Produto') then
    TFuncao.CriarForm(TfrmCadProduto, oUsuarioLogado, dtmPrincipal.ConexaoDB)
  {$ENDREGION}

  {$REGION 'CRM'}
  else if (Grupo  = 'CRM') and (Texto = 'Cad. Grupo de Cliente') then
    TFuncao.CriarForm(TfrmCadGrupoCliente, oUsuarioLogado, dtmPrincipal.ConexaoDB)
  else if (Grupo  = 'CRM') and (Texto = 'Cad. Segmento de Cliente') then
    TFuncao.CriarForm(TfrmCadSegmentoCliente, oUsuarioLogado, dtmPrincipal.ConexaoDB)
  else if (Grupo  = 'CRM') and (Texto = 'Cad. Primeiro Contato Cliente') then
    TFuncao.CriarForm(TfrmCadPrimeiroContato, oUsuarioLogado, dtmPrincipal.ConexaoDB)
  else if (Grupo  = 'CRM') and (Texto = 'Cad. Regiao do Cliente') then
    TFuncao.CriarForm(TfrmCadRegiaoCliente, oUsuarioLogado, dtmPrincipal.ConexaoDB)
  {$ENDREGION}

  {$REGION 'Movimentação'}
  else if (Grupo = 'Movimentação') and (Texto = 'Venda') then
    TFuncao.CriarForm(TfrmProVenda, oUsuarioLogado, dtmPrincipal.ConexaoDB)
  {$ENDREGION}

  {$REGION 'Relatórios'}
  else if (Grupo = 'Relatórios') and (Texto = 'Categoria') then
    TFuncao.CriarRelatorio(TfrmRelCategoria, oUsuarioLogado, dtmPrincipal.ConexaoDB)
  else if (Grupo = 'Relatórios') and (Texto = 'Cliente') then
    TFuncao.CriarRelatorio(TfrmRelCliente, oUsuarioLogado, dtmPrincipal.ConexaoDB)
  else if (Grupo = 'Relatórios') and (Texto = 'Ficha de Cliente') then
    TFuncao.CriarRelatorio(TfrmRelClienteFicha, oUsuarioLogado, dtmPrincipal.ConexaoDB)
  else if (Grupo = 'Relatórios') and (Texto = 'Produto') then
    TFuncao.CriarRelatorio(TfrmRelProduto, oUsuarioLogado, dtmPrincipal.ConexaoDB)
  else if (Grupo = 'Relatórios') and (Texto = 'Produto por Categoria') then
    TFuncao.CriarRelatorio(TfrmRelProdutoComCategoria, oUsuarioLogado, dtmPrincipal.ConexaoDB)
  else if (Grupo = 'Relatórios') and (Texto = 'Venda por Data') then
    VendaporDataClick(nil)
  {$ENDREGION}

  {$REGION 'Usuários'}
  else if (Grupo = 'Usuários') and (Texto = 'Usuário') then
    TFuncao.CriarForm(TfrmCadUsuario, oUsuarioLogado, dtmPrincipal.ConexaoDB)
  else if (Grupo = 'Usuários') and (Texto = 'Usuários vs Ações') then
    TFuncao.CriarForm(TfrmUsuarioVsAcoes, oUsuarioLogado, dtmPrincipal.ConexaoDB)
  else if (Grupo = 'Usuários') and (Texto = 'Ação de Acesso') then
    TFuncao.CriarForm(TfrmCadAcaoAcesso, oUsuarioLogado, dtmPrincipal.ConexaoDB)
  {$ENDREGION}

  {$REGION 'Sistema'}
  else if (Grupo = 'Sistema') and (Texto = 'Log (Registros)') then
    TFuncao.CriarForm(TfrmLogSistema, oUsuarioLogado, dtmPrincipal.ConexaoDB);
  {$ENDREGION}
end;

procedure TfrmPrincipal.TreeView1CustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  R: TRect;
  TextX: Integer;
begin
  DefaultDraw := True;


  // reset padrão
  Sender.Canvas.Font.Style := [];

  if cdsSelected in State then
  begin
    Sender.Canvas.Brush.Color := TColor($00FFC8DC); // roxo pastel
    Sender.Canvas.Font.Color := TColor($00501830); // texto escuro

    if not Assigned(Node.Parent) then
      Sender.Canvas.Font.Style := [fsBold]; // mantém negrito no grupo
  end
  else if cdsHot in State then
  begin
    Sender.Canvas.Brush.Color := TColor($00FFE8F4); // hover
    Sender.Canvas.Font.Color := TColor($00501830);

    if not Assigned(Node.Parent) then
      Sender.Canvas.Font.Style := [fsBold];
  end
  else if not Assigned(Node.Parent) then
  begin
    Sender.Canvas.Brush.Color := TColor($00F8F0FF); // grupo pai
    Sender.Canvas.Font.Color := TColor($00601840);
    Sender.Canvas.Font.Style := [fsBold];
  end
  else
  begin
    Sender.Canvas.Brush.Color := clWhite;
    Sender.Canvas.Font.Color := TColor($00501830);
  end;
end;

{$ENDREGION}

// =============================================================================

{$REGION 'Relatório — Venda por Data'}

procedure TfrmPrincipal.VendaporDataClick(Sender: TObject);
begin
  try
    frmSelecionarData := TfrmSelecionarData.Create(Self);

    if TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, 'frmRelVendaPorData', DtmPrincipal.ConexaoDB) then
    begin
      frmSelecionarData.ShowModal;

      frmRelVendaPorData := TfrmRelVendaPorData.Create(Self);
      frmRelVendaPorData.QryVendaPorData.Close;
      frmRelVendaPorData.QryVendaPorData.ParamByName('DataInicio').AsDate := frmSelecionarData.EdtDataInicio.Date;
      frmRelVendaPorData.QryVendaPorData.ParamByName('DataFim').AsDate := frmSelecionarData.EdtDataFinal.Date;
      frmRelVendaPorData.QryVendaPorData.Open;
      frmRelVendaPorData.Relatorio.PreviewModal;
    end
    else
      MessageDlg('Usuário: ' + oUsuarioLogado.nome + ', não tem permissão de acesso', mtWarning, [mbOK], 0);

  finally
    if Assigned(frmSelecionarData) then
      frmSelecionarData.Release;
    if Assigned(frmRelVendaPorData) then
      frmRelVendaPorData.Release;
  end;
end;

{$ENDREGION}

// =============================================================================

{$REGION 'Clientes — atualização de status'}

procedure TfrmPrincipal.AtualizarStatusCliente;
var
  Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := dtmPrincipal.ConexaoDB;
    dtmPrincipal.ConexaoDB.StartTransaction;

    Qry.SQL.Add('UPDATE clientes SET clienteStatusId = 5 ' + 'WHERE clienteId NOT IN (SELECT clienteId FROM vendas) ' + 'AND clienteStatusId NOT IN (2,3); ' + 'UPDATE clientes SET clienteStatusId = 1 ' + 'WHERE clienteId IN ( ' + '  SELECT clienteId FROM vendas GROUP BY clienteId ' + '  HAVING DATEDIFF(DAY, MAX(dataVenda), GETDATE()) <= 7 ' + ') AND clienteStatusId <> 5 ' + 'AND clienteStatusId NOT IN (2,3); ' + 'UPDATE clientes SET clienteStatusId = 4 ' + 'WHERE clienteId IN ( ' + '  SELECT clienteId FROM vendas GROUP BY clienteId ' + '  HAVING DATEDIFF(DAY, MAX(dataVenda), GETDATE()) > 7 ' + ') AND clienteStatusId NOT IN (4,5) ' + 'AND clienteStatusId NOT IN (2,3);');

    try
      Qry.ExecSQL;
      dtmPrincipal.ConexaoDB.Commit;
    except
      dtmPrincipal.ConexaoDB.Rollback;
      Abort;
    end;

  finally
    if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;

{$ENDREGION}

end.

