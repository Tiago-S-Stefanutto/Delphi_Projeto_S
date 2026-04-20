unit uTelaHeranca;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask,
  Vcl.ComCtrls, Vcl.ExtCtrls, uDTMConexao, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, uEnum, cUsuarioLogado, IniFiles, cLog;

  function SomenteNumeros(const Texto: string): string;

type
  TfrmTelaHeranca = class(TForm)
    pgcPrincipal: TPageControl;
    pnlRodaPe: TPanel;
    TabListagem: TTabSheet;
    tabManutencao: TTabSheet;
    Panel1: TPanel;
    mskPesquisar: TMaskEdit;
    btnPesquisar: TBitBtn;
    grdListagem: TDBGrid;
    btnNovo: TBitBtn;
    btnAlterar: TBitBtn;
    btnCancelar: TBitBtn;
    btnGravar: TBitBtn;
    btnApagar: TBitBtn;
    btnFechar: TBitBtn;
    btnNavigator: TDBNavigator;
    dtsListagem: TDataSource;
    QryListagem: TFDQuery;
    lblIndice: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnApagarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grdListagemTitleClick(Column: TColumn);
    procedure mskPesquisarChange(Sender: TObject);
    procedure grdListagemDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnPesquisarClick(Sender: TObject);
    procedure grdListagemDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
  private
    { Private declarations }
    SelectOriginal:string;
    procedure ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar:TBitBtn; btnNavigator:TDBNavigator; pgcPrincipal:TPageControl; Flag:Boolean);
    procedure ControlarIndiceTab(pgcPrincipal: TpageControl; Indice: Integer);
    function RetomarCampoTraduzido(Campo: string): string;
    function ExisteCampoObrigatorio: boolean;
    procedure DesabilitarEditPK;
    procedure LimparEdits;
    procedure CarregarLayoutGrid;
    procedure SalvarLayoutGrid;
  public
    { Public declarations }
    IndiceAtual:string;
    EstadoDoCadastro:TEstadoDoCadastro;
    procedure ExibirIndiceLabel(Campo: string; aLabel: TLabel);
    function Apagar:Boolean; virtual;
    function Gravar(EstadoDoCadastro: TEstadoDoCadastro):Boolean; virtual;
    procedure BloqueiaCTRL_DEL_DBGrid(var Key: Word; Shift: TShiftState);
    function NomeCampoId: string; virtual;
    function NomeCampoNome: string; virtual;
    function ValorLogId: string; virtual;
    function ValorLogNome: string; virtual;
  end;

var
  frmTelaHeranca: TfrmTelaHeranca;
  Log: TLog;

implementation

uses uPrincipal;

{$R *.dfm}

//Procedimento de controle de tela
{$REGION 'Observações'}
//Tag: 1 - Chave Primária - pk
//Tag: 2 - Campo Obrigatórios
 {$ENDREGION}

{$REGION 'Funções e Procedures'}

procedure TfrmTelaHeranca.ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar:TBitBtn; btnNavigator:TDBNavigator; pgcPrincipal:TPageControl; Flag:Boolean);
begin
   btnNovo.Enabled   :=Flag;
   btnAlterar.Enabled   :=Flag;
   btnApagar.Enabled  := Flag;
   btnNavigator.Enabled :=Flag;
   pgcPrincipal.Pages [0].TabVisible  := Flag;
   btnCancelar.Enabled  := not(Flag);
   btnGravar.Enabled  := not(Flag);

end;

procedure TfrmTelaHeranca.ControlarIndiceTab (pgcPrincipal: TpageControl; Indice: Integer);
begin
    if (pgcPrincipal.Pages[Indice].TabVisible) then
    pgcPrincipal.TabIndex:=Indice;
end;

function  TfrmTelaHeranca.RetomarCampoTraduzido(Campo:string):string;
var i:Integer;
begin
  for i := 0 to QryListagem.Fields.Count -1 do begin
    if LowerCase(QryListagem.Fields[i].FieldName)=LowerCase(Campo) then begin
      Result:= QryListagem.Fields[i].DisplayLabel;
      Break;
    end;
  end;
end;




procedure TfrmTelaHeranca.ExibirIndiceLabel(Campo:string; aLabel:TLabel);
begin
  aLabel.Caption:=RetomarCampoTraduzido(Campo);
end;

function  TfrmTelaHeranca.ExisteCampoObrigatorio:boolean;
var i:Integer;
begin
  Result :=False;
  for i := 0 to ComponentCount -1 do begin
    if (Components[i] is TLabeledEdit) then begin
        if ((TLabeledEdit(Components[i]).Tag = 2) and (TLabeledEdit(Components[i]).Text = EmptyStr)) then begin
         MessageDlg(TLabeledEdit(Components[i]).EditLabel.Caption + ' é um campo obrigatório',mtInformation,[mbOK],0);
         TLabeledEdit(Components[i]).SetFocus;

         Result := True;
         Break ;
      end
     end;
   end;
end;

procedure TfrmTelaHeranca.DesabilitarEditPK;
var i:Integer;
begin
  for i := 0 to ComponentCount -1 do begin
    if (Components[i] is TLabeledEdit) then begin
        if (TLabeledEdit(Components[i]).Tag = 1) then begin
          TLabeledEdit(Components[i]).Enabled:=False;
        end;
    end;
  end;
end;

procedure TfrmTelaHeranca.LimparEdits;
var i:Integer;
begin
  for i := 0 to ComponentCount -1 do begin
    if (Components[i] is TLabeledEdit) then
          (TLabeledEdit(Components[i])).Text:=EmptyStr
    else if(Components[i] is TEdit) then
      TEdit(Components[i]).Text:='';
  end;
end;

function SomenteNumeros(const Texto: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(Texto) do
  begin
    if Texto[i] in ['0'..'9'] then
      Result := Result + Texto[i];
  end;
end;



{$ENDREGION}

{$REGION 'Métodos Virtuais'}
function TfrmTelaHeranca.Apagar: Boolean;
begin
  ShowMessage('Deletado');
  Result := True;
end;

function  TfrmTelaHeranca.Gravar(EstadoDoCadastro:TEstadoDoCadastro) : Boolean;
begin
  if (EstadoDoCadastro=ecInserir) then
      ShowMessage('Inserir')
  else if (EstadoDoCadastro=ecAlterar) then
      ShowMessage('Alterado');
      Result := True;
end;

{$ENDREGION}

  procedure TfrmTelaHeranca.btnNovoClick(Sender: TObject);
begin

  if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, self.Name+'_'+TBitBtn(Sender).Name, DtmPrincipal.ConexaoDB) then
  begin
     MessageDlg('Usuário: '+oUsuarioLogado.nome +', não tem permissão de acesso',mtWarning,[mbOK],0);
     Abort;
  end;

  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, False);
  EstadoDoCadastro:=ecInserir;
  LimparEdits;
end;

procedure TfrmTelaHeranca.btnAlterarClick(Sender: TObject);
begin

  if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, self.Name+'_'+TBitBtn(Sender).Name, DtmPrincipal.ConexaoDB) then
  begin
     MessageDlg('Usuário: '+oUsuarioLogado.nome +', não tem permissão de acesso',mtWarning,[mbOK],0);
     Abort;
  end;

  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, False);
  EstadoDoCadastro:=ecAlterar;
end;

procedure TfrmTelaHeranca.btnApagarClick(Sender: TObject);
var vId, vNome: string;
begin

  if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, self.Name+'_'+TBitBtn(Sender).Name, DtmPrincipal.ConexaoDB) then
  begin
     MessageDlg('Usuário: '+oUsuarioLogado.nome +', não tem permissão de acesso',mtWarning,[mbOK],0);
     Abort;
  end;

  vId   := QryListagem.FieldByName(NomeCampoId).AsString;
  vNome := QryListagem.FieldByName(NomeCampoNome).AsString;

  try
    if not (Apagar)  then begin
      dtmPrincipal.ConexaoDB.Rollback;
      MessageDlg('Erro na Exclusão', mtWarning, [mbOK], 0);
      Exit;
    end;

    Log:= TLog.Create(dtmPrincipal.ConexaoDB);
    try
      Log.usuarioId      := oUsuarioLogado.codigo;
      Log.usuarioNome    := oUsuarioLogado.nome;
      Log.tela           := Self.Name;
      Log.acao           := 'Exclusão';

      Log.descricao := ('Na tela ' + Self.Name + ' houve um(a) ' + Log.acao + ' no item de Id: ' + vId +  ' e nome: ' + vNome);

      if not Log.Inserir(False) then
        raise Exception.Create('Falha ao gravar log');
    finally
      FreeAndNil(Log);
    end;


    dtmPrincipal.ConexaoDB.Commit;
    ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, True);
    ControlarIndiceTab(pgcPrincipal, 0);
    EstadoDoCadastro:=ecNenhum;
    LimparEdits;
    QryListagem.Refresh;

  Except
    on E: Exception do
    begin
      if dtmPrincipal.ConexaoDB.InTransaction then
        dtmPrincipal.ConexaoDB.Rollback;
      MessageDlg('Erro: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmTelaHeranca.btnCancelarClick(Sender: TObject);
begin
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, True);
  ControlarIndiceTab(pgcPrincipal, 0);
  EstadoDoCadastro:=ecNenhum;
  LimparEdits;
end;

procedure TfrmTelaHeranca.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTelaHeranca.btnGravarClick(Sender: TObject);
var AcaoLog : string;
vId, vNome: string;
begin

  if EstadoDoCadastro = ecInserir then
    AcaoLog := 'Inserir'
  else
    AcaoLog := 'Atualização';

  if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, self.Name+'_'+TBitBtn(Sender).Name, DtmPrincipal.ConexaoDB) then
  begin
     MessageDlg('Usuário: '+oUsuarioLogado.nome +', não tem permissão de acesso',mtWarning,[mbOK],0);
     Abort;
  end;

  if (ExisteCampoObrigatorio) then
  Abort ;

  if not dtmPrincipal.ConexaoDB.InTransaction then
    dtmPrincipal.ConexaoDB.StartTransaction;

  try
    if not Gravar(EstadoDoCadastro) then
    begin
      dtmPrincipal.ConexaoDB.Rollback;
      MessageDlg('Erro na gravação', mtWarning, [mbOK], 0);
      Exit;
    end;

    vId   := ValorLogId;
    vNome := ValorLogNome;

    Log:= TLog.Create(dtmPrincipal.ConexaoDB);
    try
      Log.usuarioId      := oUsuarioLogado.codigo;
      Log.usuarioNome    := oUsuarioLogado.nome;
      Log.tela           := Self.Name;
      Log.acao           := AcaoLog;

      Log.descricao := ('Na tela ' + Self.Name + ' houve um(a) ' + Log.acao + ' no item de Id: ' + vId +  ' e nome: ' + vNome);

      if not Log.Inserir(False) then
        raise Exception.Create('Falha ao gravar log');
    finally
      FreeAndNil(Log);
    end;


    dtmPrincipal.ConexaoDB.Commit;
    ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, True);
    ControlarIndiceTab(pgcPrincipal, 0);
    EstadoDoCadastro:=ecNenhum;
    LimparEdits;
    QryListagem.Refresh;

  Except
    on E: Exception do
    begin
      if dtmPrincipal.ConexaoDB.InTransaction then
        dtmPrincipal.ConexaoDB.Rollback;
      MessageDlg('Erro: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmTelaHeranca.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SalvarLayoutGrid;
  QryListagem.Close;
end;

procedure TfrmTelaHeranca.FormCreate(Sender: TObject);
var i: Integer;
begin
  QryListagem.Connection := dtmPrincipal.ConexaoDB;
  dtsListagem.DataSet    := QryListagem;
  grdListagem.DataSource := dtsListagem;
  grdListagem.Options    := [dgTitles, dgIndicator, dgColumnResize, dgColLines,
                             dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection,
                             dgCancelOnExit, dgTitleClick, dgTitleHotTrack];
  grdListagem.DefaultDrawing := False;

  for i := 0 to grdListagem.Columns.Count - 1 do
    grdListagem.Columns[i].Title.Alignment := taCenter;

end;

procedure TfrmTelaHeranca.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  BloqueiaCTRL_DEL_DBGrid(Key,Shift);
end;

procedure TfrmTelaHeranca.FormShow(Sender: TObject);
begin
  if (QryListagem.SQL.Text<>EmptyStr) then begin
      dtsListagem.DataSet:=QryListagem;
      ExibirIndiceLabel(IndiceAtual, lblIndice);
      SelectOriginal:=QryListagem.SQL.Text;
      QryListagem.Open;
  end;
  ControlarIndiceTab(pgcPrincipal, 0);
  DesabilitarEditPK;
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, True);
  CarregarLayoutGrid;
end;

procedure TfrmTelaHeranca.grdListagemDblClick(Sender: TObject);
begin
  btnAlterar.Click;
end;

procedure TfrmTelaHeranca.grdListagemDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Linha: Integer;
begin
  Linha := grdListagem.DataSource.DataSet.RecNo;

  if not (gdSelected in State) then
  begin
    if (Linha mod 2) = 0 then
      grdListagem.Canvas.Brush.Color := clWebLightgrey
    else
      grdListagem.Canvas.Brush.Color := clWhite;
  end
  else
  begin
    grdListagem.Canvas.Brush.Color := RGB(220, 200, 255); // roxo pastel
    grdListagem.Canvas.Font.Color := clBlack;
  end;

  grdListagem.Canvas.FillRect(Rect);
  grdListagem.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, Column.Field.AsString);
end;

procedure TfrmTelaHeranca.grdListagemTitleClick(Column: TColumn);
begin
  IndiceAtual := Column.FieldName;
  QryListagem.IndexFieldNames:=IndiceAtual;
  ExibirIndiceLabel(IndiceAtual, lblIndice);
end;

procedure TfrmTelaHeranca.mskPesquisarChange(Sender: TObject);
begin
  if Trim(TMaskEdit(Sender).Text) = '' then
    Exit;

  QryListagem.Locate(IndiceAtual, TMaskEdit(Sender).Text, [loPartialKey]);
end;

procedure TfrmTelaHeranca.btnPesquisarClick(Sender: TObject);
var
  I: Integer;
  TipoCampo: TFieldType;
  NomeCampo: String;
  WhereOrAnd: String;
  CondicaoSQL: String;
  Valor: String;
begin
  if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo,
     Self.Name + '_' + TBitBtn(Sender).Name, DtmPrincipal.ConexaoDB) then
  begin
    MessageDlg('Usuário: ' + oUsuarioLogado.nome +
      ', não tem permissão de acesso', mtWarning, [mbOK], 0);
    Abort;
  end;

  Valor := Trim(mskPesquisar.Text);

  if Valor = '' then
  begin
    QryListagem.Close;
    QryListagem.SQL.Text := SelectOriginal;
    QryListagem.Open;
    Exit;
  end;

  NomeCampo := '';
  TipoCampo := ftUnknown;

  for I := 0 to QryListagem.FieldCount - 1 do
  begin
    if SameText(QryListagem.Fields[I].FieldName, IndiceAtual) then
    begin
      TipoCampo := QryListagem.Fields[I].DataType;
      NomeCampo := QryListagem.Fields[I].FieldName;
      Break;
    end;
  end;

  if NomeCampo = '' then Exit;

  if Pos('where', LowerCase(SelectOriginal)) > 0 then
    WhereOrAnd := ' AND '
  else
    WhereOrAnd := ' WHERE ';

  QryListagem.Close;
  QryListagem.SQL.Clear;
  QryListagem.SQL.Add(SelectOriginal);

  case TipoCampo of
    ftString, ftWideString:
      begin
        QryListagem.SQL.Add(WhereOrAnd + NomeCampo + ' LIKE :VALOR');
        QryListagem.ParamByName('VALOR').AsString := '%' + Valor + '%';
      end;

    ftInteger, ftSmallint, ftAutoInc:
      begin
        Valor := Trim(Valor);

        if not TryStrToInt(Valor, I) then
        begin
          MessageDlg('Digite um número válido', mtWarning, [mbOK], 0);
          Exit;
        end;

        QryListagem.SQL.Add(WhereOrAnd + NomeCampo + ' = :VALOR');
        QryListagem.ParamByName('VALOR').AsInteger := I;
      end;

    ftFloat, ftCurrency:
      begin
        Valor := StringReplace(Valor, ',', '.', [rfReplaceAll]);
        QryListagem.SQL.Add(WhereOrAnd + NomeCampo + ' = :VALOR');
        QryListagem.ParamByName('VALOR').AsFloat := StrToFloat(Valor);
      end;

    ftDate, ftDateTime:
      begin
        QryListagem.SQL.Add(WhereOrAnd + NomeCampo + ' = :VALOR');
        QryListagem.ParamByName('VALOR').AsDateTime := StrToDate(Valor);
      end;
  end;

  QryListagem.Open;

  mskPesquisar.Clear;
  mskPesquisar.SetFocus;
end;

procedure TfrmTelaHeranca.BloqueiaCTRL_DEL_DBGrid(var Key:Word; Shift: TShiftState);
begin
  //Bloqueia o ctrl del
  if (Shift = [ssCtrl]) and (Key = 46) then
    key:=0;
end;

procedure TfrmTelaHeranca.SalvarLayoutGrid;
var
  Ini: TIniFile;
  Secao: string;
  i: Integer;
begin
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    Secao := Self.Name + '_' + IntToStr(oUsuarioLogado.codigo) + '_Grid';
    Ini.EraseSection(Secao);
    for i := 0 to grdListagem.Columns.Count - 1 do
    begin
      // Salva pelo índice VISUAL atual (posição que o usuário deixou)
      Ini.WriteInteger(Secao, 'Col_' + IntToStr(i) + '_Width', grdListagem.Columns[i].Width);
      Ini.WriteInteger(Secao, 'Col_' + IntToStr(i) + '_Order', grdListagem.Columns[i].Index);
      Ini.WriteString(Secao,  'Col_' + IntToStr(i) + '_Field', grdListagem.Columns[i].FieldName);
    end;
  finally
    Ini.Free;
  end;
end;

procedure TfrmTelaHeranca.CarregarLayoutGrid;
var
  Ini: TIniFile;
  Secao: string;
  i, j, W, Order: Integer;
  FieldName: string;
  Col: TColumn;
begin
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    Secao := Self.Name + '_' + IntToStr(oUsuarioLogado.codigo) + '_Grid';
    if not Ini.SectionExists(Secao) then Exit;

    for i := 0 to grdListagem.Columns.Count - 1 do
    begin
      FieldName := Ini.ReadString(Secao, 'Col_' + IntToStr(i) + '_Field', '');
      if FieldName = '' then Continue;

      Col := nil;
      for j := 0 to grdListagem.Columns.Count - 1 do
        if SameText(grdListagem.Columns[j].FieldName, FieldName) then
        begin
          Col := grdListagem.Columns[j];
          Break;
        end;

      if Col = nil then Continue;

      W     := Ini.ReadInteger(Secao, 'Col_' + IntToStr(i) + '_Width', Col.Width);
      Order := Ini.ReadInteger(Secao, 'Col_' + IntToStr(i) + '_Order', Col.Index);

      Col.Width := W;
      Col.Index := Order;
    end;
  finally
    Ini.Free;
  end;
end;

function TfrmTelaHeranca.NomeCampoId: string;
begin
    Result := QryListagem.Fields[0].AsString;
end;

function TfrmTelaHeranca.NomeCampoNome: string;
var
  i: Integer;
begin
  if EstadoDoCadastro in [ecInserir, ecAlterar] then
    Result := ''
  else
  begin
    Result := '';
    for i := 0 to QryListagem.Fields.Count - 1 do
    begin
      if LowerCase(QryListagem.Fields[i].FieldName).Contains('nome') then
      begin
        Result := QryListagem.Fields[i].AsString;
        Break;
      end;
    end;
  end;
end;

function TfrmTelaHeranca.ValorLogId: string;
begin
  Result := '';
end;

function TfrmTelaHeranca.ValorLogNome: string;
begin
  Result := '';
end;

end.
