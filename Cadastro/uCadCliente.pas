unit uCadCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask, Vcl.ComCtrls, uEnum, cCadCliente,
  uDTMConexao, RxToolEdit, System.ImageList, Vcl.ImgList, IdHTTP, System.JSON,
  IdSSL, IdSSLOpenSSL, System.Net.HttpClient, System.Net.URLClient,
  System.Net.HttpClientComponent, uObservacaoClientes;

type
  //Campos visuais
  TTfrmCadCliente = class(TfrmTelaHeranca)
    edtClienteId: TLabeledEdit;
    edtNome: TLabeledEdit;
    lblCEP: TLabel;
    edtEndereco: TLabeledEdit;
    edtBairro: TLabeledEdit;
    edtCidade: TLabeledEdit;
    lblTelefone: TLabel;
    edtEmail: TLabeledEdit;
    edtDataNascimento: TDateEdit;
    lblData: TLabel;
  // colunas da consulta SQL usando o Grid
    QryListagemclienteId: TFDAutoIncField;
    QryListagemnome: TStringField;
    QryListagemendereco: TStringField;
    QryListagemcidade: TStringField;
    QryListagembairro: TStringField;
    QryListagemestado: TStringField;
    QryListagemcep: TStringField;
    QryListagemtelefone: TStringField;
    QryListagememail: TStringField;
    QryListagemdatanascimento: TSQLTimeStampField;
    edtEstado: TLabeledEdit;
    QryStatus: TFDQuery;
    dtsStatus: TDataSource;
    lcbStatus: TDBLookupComboBox;
    QryStatusclienteStatusId: TIntegerField;
    QryStatusdescricao: TStringField;
    QryListagemclienteStatusId: TIntegerField;
    QryTipoPessoa: TFDQuery;
    dtsTipoPessoa: TDataSource;
    lcbTipoPessoa: TDBLookupComboBox;
    QryListagempessoaTipoId: TIntegerField;
    lblCpfCnpj: TLabel;
    edtCpfCnpj: TEdit;
    edtCEP: TEdit;
    edtTelefone: TEdit;
    imgStatus: TImageList;
    sbtnCep: TSpeedButton;
    imagemStatus: TImage;
    lblNomeStatus: TLabel;
    lblStatusPesquisa: TLabel;
    lblStatusPesquisa2: TLabel;
    imgStatus2: TImage;
    lblStatusNome2: TLabel;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Label5: TLabel;
    Image3: TImage;
    Label6: TLabel;
    Label3: TLabel;
    Image2: TImage;
    Label4: TLabel;
    lblStatus: TLabel;
    lblPessoa: TLabel;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lcbTipoPessoaClick(Sender: TObject);
    procedure edtCpfCnpjChange(Sender: TObject);
    procedure edtCEPChange(Sender: TObject);
    procedure edtTelefoneChange(Sender: TObject);
    procedure grdListagemDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure sbtnCepClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure tabManutencaoEnter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtCEPExit(Sender: TObject);
  private
    { Private declarations }
  // TCliente essa classe é responsável por Inserir, Atualizar, Apagar e Buscar no banco de dados
    oCliente:TCliente;
    FStatusAntigo: Integer;
    function  Apagar:Boolean; override;
    function  Gravar(EstadoDoCadastro:TEstadoDoCadastro):Boolean; override;
    procedure AtualizarTipoDocumento;
    procedure ValidarDocumento;
    function AbrirObservacao(ClienteId, Tipo: Integer): Boolean;
    function NomeCampoId: string; override;
    function NomeCampoNome: string; override;
    function ValorLogId: string; override;
    function ValorLogNome: string; override;
  public
    { Public declarations }
  end;

var
  TfrmCadCliente: TTfrmCadCliente;

implementation

{$R *.dfm}

{ TfrmCadCliente }

{$region 'Override'}

function TTfrmCadCliente.Apagar: Boolean;
begin
  if oCliente.Selecionar(QryListagem.FieldByName('clienteId').AsInteger) then begin
     Result:=oCliente.Apagar;
  end;
end;


// Botão alterar carrega dados do cliente selecionado no grid
procedure TTfrmCadCliente.btnAlterarClick(Sender: TObject);
begin

  if oCliente.Selecionar(QryListagem.FieldByName('clienteId').AsInteger) then begin
     edtClienteId.Text:=IntToStr(oCliente.codigo);
     edtNome.Text          :=oCliente.nome;
     edtCEP.Text           :=oCliente.cep;
     edtEndereco.Text      :=oCliente.endereco;
     edtBairro.Text        :=oCliente.bairro;
     edtCidade.Text        :=oCliente.cidade;
     edtTelefone.Text      :=oCliente.telefone;
     edtEmail.Text         :=oCliente.email;
     edtDataNascimento.Date:=oCliente.dataNascimento;
     edtEstado.Text        :=oCliente.estado;
     AtualizarTipoDocumento;
     if lcbTipoPessoa.KeyValue = 1 then
     begin
        edtCpfCnpj.Text := oCliente.cpf; //cpf
     end
     else if lcbTipoPessoa.KeyValue = 2 then
     begin
       edtCpfCnpj.Text := oCliente.cnpj; //cnpj
     end;
  end
  else begin
    btnCancelar.Click;
    Abort;
  end;

  inherited;

end;

function TTfrmCadCliente.NomeCampoId: string;
begin
  Result := 'clienteId';
end;

function TTfrmCadCliente.NomeCampoNome: string;
begin
  Result := 'nome';
end;

function TTfrmCadCliente.ValorLogId: string;
begin
  Result := edtClienteId.Text;
end;

function TTfrmCadCliente.ValorLogNome: string;
begin
  Result := edtNome.Text;
end;

procedure TTfrmCadCliente.btnFecharClick(Sender: TObject);
begin
  inherited;

end;

{$REGION 'Verificação dos documentos}

{$REGION 'cpf'}

function ValidarCPF(const CPF: string): Boolean;
var
  i, Soma, Resto: Integer;
  Num: string;
begin
  Result := False;

  // Remove máscara
  Num := '';
  for i := 1 to Length(CPF) do
    if CharInSet(CPF[i], ['0'..'9']) then
      Num := Num + CPF[i];

  // Tem que ter 11 dígitos
  if Length(Num) <> 11 then Exit;

  // Bloqueia CPFs inválidos conhecidos (11111111111 etc)
  if Num = StringOfChar(Num[1], 11) then Exit;

  // 1º dígito
  Soma := 0;
  for i := 1 to 9 do
    Soma := Soma + StrToInt(Num[i]) * (11 - i);

  Resto := (Soma * 10) mod 11;
  if Resto = 10 then Resto := 0;
  if Resto <> StrToInt(Num[10]) then Exit;

  // 2º dígito
  Soma := 0;
  for i := 1 to 10 do
    Soma := Soma + StrToInt(Num[i]) * (12 - i);

  Resto := (Soma * 10) mod 11;
  if Resto = 10 then Resto := 0;

  Result := (Resto = StrToInt(Num[11]));
end;

  {$ENDREGION}


{$REGION 'Cnpj'}

function ValidarCNPJ(const CNPJ: string): Boolean;
const
  Peso1: array[1..12] of Integer = (5,4,3,2,9,8,7,6,5,4,3,2);
  Peso2: array[1..13] of Integer = (6,5,4,3,2,9,8,7,6,5,4,3,2);
var
  i, Soma, Resto: Integer;
  Num: string;
begin
  Result := False;

  // Remove máscara
  Num := '';
  for i := 1 to Length(CNPJ) do
    if CharInSet(CNPJ[i], ['0'..'9']) then
      Num := Num + CNPJ[i];

  if Length(Num) <> 14 then Exit;

  // Bloqueia sequências inválidas
  if Num = StringOfChar(Num[1], 14) then Exit;

  // 1º dígito
  Soma := 0;
  for i := 1 to 12 do
    Soma := Soma + StrToInt(Num[i]) * Peso1[i];

  Resto := Soma mod 11;
  if Resto < 2 then Resto := 0 else Resto := 11 - Resto;

  if Resto <> StrToInt(Num[13]) then Exit;

  // 2º dígito
  Soma := 0;
  for i := 1 to 13 do
    Soma := Soma + StrToInt(Num[i]) * Peso2[i];

  Resto := Soma mod 11;
  if Resto < 2 then Resto := 0 else Resto := 11 - Resto;

  Result := (Resto = StrToInt(Num[14]));
end;

{$ENDREGION}

procedure TTfrmCadCliente.ValidarDocumento;
begin
  if lcbTipoPessoa.KeyValue = 1 then
  begin
    if not ValidarCPF(edtCpfCnpj.Text) then
    begin
      ShowMessage('CPF inválido!');
      edtCpfCnpj.SetFocus;
      Abort;
    end;
  end
  else if lcbTipoPessoa.KeyValue = 2 then
  begin
    if not ValidarCNPJ(edtCpfCnpj.Text) then
    begin
      ShowMessage('CNPJ inválido!');
      edtCpfCnpj.SetFocus;
      Abort;
    end;
  end;
end;

{$ENDREGION}

function TTfrmCadCliente.AbrirObservacao(ClienteId, Tipo: Integer): Boolean;
begin
  frmObservacaoCliente := TfrmObservacaoCliente.Create(nil);
  try
    frmObservacaoCliente.ClienteId := ClienteId;
    frmObservacaoCliente.TipoObs := Tipo;

    Result := frmObservacaoCliente.ShowModal = mrOk;
  finally
    frmObservacaoCliente.Free;
  end;
end;

procedure TTfrmCadCliente.btnGravarClick(Sender: TObject);
begin

  ValidarDocumento;

  inherited;

end;

function TTfrmCadCliente.Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean;
var Status: Integer;
begin
  if edtClienteId.Text<>EmptyStr then
     oCliente.codigo:=StrToInt(edtClienteId.Text)
  else
     oCliente.codigo:=0;

  //pega os dados da tela
  oCliente.nome           :=edtNome.Text;
  oCliente.cep            :=edtCEP.Text;
  oCliente.endereco       :=edtEndereco.Text;
  oCliente.bairro         :=edtBairro.Text;
  oCliente.cidade         :=edtCidade.Text;
  oCliente.telefone       :=edtTelefone.Text;
  oCliente.email          :=edtEmail.Text;
  oCliente.dataNascimento :=edtDataNascimento.Date;
  oCliente.estado         :=edtEstado.Text;

  if lcbTipoPessoa.KeyValue = 1 then
  begin
    oCliente.cpf  := SomenteNumeros(edtCpfCnpj.Text); //cpf
    oCliente.cnpj := '';
  end
  else if lcbTipoPessoa.KeyValue = 2 then
  begin
    oCliente.cpf := '';
    oCliente.cnpj := SomenteNumeros(edtCpfCnpj.Text); //cnpj
  end;

  Status := lcbStatus.KeyValue;


  //verifica estado se é update ou insert
  if (EstadoDoCadastro=ecInserir) then
     Result:=oCliente.Inserir
  else if (EstadoDoCadastro=ecAlterar) then
     Result:=oCliente.Atualizar;

   if Result and (EstadoDoCadastro = ecInserir) then
    edtClienteId.Text := IntToStr(oCliente.codigo);

  if status in [2,3] then
  begin
    AbrirObservacao(oCliente.codigo, Status);
  end;

end;

{$endregion}

procedure TTfrmCadCliente.grdListagemDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var StatusId: Integer;
    ImgIndex: Integer;
    TipoPessoa: string;
begin
 inherited;
  if Column.FieldName = 'pessoaTipoId' then
  begin
    if Column.Field.AsInteger = 1 then
      TipoPessoa := 'Física'
    else
      TipoPessoa := 'Jurídica';

    grdListagem.Canvas.FillRect(Rect);
    grdListagem.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, TipoPessoa);
  end


  else if Column.FieldName = 'clienteStatusId' then
  begin
    StatusId := Column.Field.AsInteger;

    case StatusId of
      1: ImgIndex := 0; // verde
      2: ImgIndex := 1; // vermelho
      3: ImgIndex := 2; // amarelo
      4: ImgIndex := 3; // preto
      5: ImgIndex := 4; // roxo
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

procedure TTfrmCadCliente.lcbTipoPessoaClick(Sender: TObject);
begin
  inherited;
  AtualizarTipoDocumento;
end;

procedure TTfrmCadCliente.sbtnCepClick(Sender: TObject);
var
  HTTP: TNetHTTPClient;
  Response: IHTTPResponse;
  JSONObject: TJSONObject;
  JSONStr: string;
begin
  inherited;

  HTTP := TNetHTTPClient.Create(nil);
  try
    try
      Response := HTTP.Get('https://viacep.com.br/ws/' + edtCEP.Text + '/json/');
      JSONStr := Response.ContentAsString;
    except
      on E: Exception do
      begin
        ShowMessage('Erro: ' + E.Message);
        Exit;
      end;
    end;

    JSONObject := TJSONObject.ParseJSONValue(JSONStr) as TJSONObject;
    try
      if Assigned(JSONObject) then
      begin
        if JSONObject.GetValue('erro') <> nil then
        begin
          ShowMessage('CEP não encontrado!');
          Exit;
        end;

        edtEndereco.Text := JSONObject.GetValue<string>('logradouro');
        edtBairro.Text   := JSONObject.GetValue<string>('bairro');
        edtCidade.Text   := JSONObject.GetValue<string>('localidade');
        edtEstado.Text   := JSONObject.GetValue<string>('uf'); // correto
      end;
    finally
      JSONObject.Free;
    end;

  finally
    HTTP.Free;
  end;
end;

procedure TTfrmCadCliente.tabManutencaoEnter(Sender: TObject);
begin
  inherited;
  FStatusAntigo := QryListagem.FieldByName('clienteStatusId').AsInteger;
end;

procedure TTfrmCadCliente.btnNovoClick(Sender: TObject);
begin
  inherited;
  lcbTipoPessoa.KeyValue := Null;
  lblCpfCnpj.Caption := 'CPF/CNPJ';
  edtDataNascimento.Date:=Date;
  lcbStatus.KeyValue := null;
  edtNome.SetFocus;

end;

procedure TTfrmCadCliente.edtCEPChange(Sender: TObject);
var RawText, MaskedText: string;
  NumCount, i: Integer;
begin
  inherited;

  edtCEP.OnChange := nil;
  try
    // Remove tudo que não é número
    RawText := SomenteNumeros(edtCEP.Text);
    NumCount := Length(RawText);
    MaskedText := '';

    begin
      if NumCount > 0 then MaskedText := Copy(RawText,1,5);
      if NumCount > 5 then MaskedText := Copy(RawText,1,5) + '-' + Copy(RawText,6,3);
    end;

    edtCEP.Text := MaskedText;

    // Cursor no final
    edtCEP.SelStart := Length(MaskedText);

  finally
    edtCEP.OnChange := edtCEPChange;
  end;
end;

procedure TTfrmCadCliente.edtCEPExit(Sender: TObject);
var
  HTTP: TNetHTTPClient;
  Response: IHTTPResponse;
  JSONObject: TJSONObject;
  JSONStr: string;
begin
  inherited;

  HTTP := TNetHTTPClient.Create(nil);
  try
    try
      Response := HTTP.Get('https://viacep.com.br/ws/' + edtCEP.Text + '/json/');
      JSONStr := Response.ContentAsString;
    except
      on E: Exception do
      begin
        ShowMessage('Erro: ' + E.Message);
        Exit;
      end;
    end;

    JSONObject := TJSONObject.ParseJSONValue(JSONStr) as TJSONObject;
    try
      if Assigned(JSONObject) then
      begin
        if JSONObject.GetValue('erro') <> nil then
        begin
          ShowMessage('CEP não encontrado!');
          Exit;
        end;

        edtEndereco.Text := JSONObject.GetValue<string>('logradouro');
        edtBairro.Text   := JSONObject.GetValue<string>('bairro');
        edtCidade.Text   := JSONObject.GetValue<string>('localidade');
        edtEstado.Text   := JSONObject.GetValue<string>('uf'); // correto
      end;
    finally
      JSONObject.Free;
    end;

  finally
    HTTP.Free;
  end;
end;

procedure TTfrmCadCliente.edtCpfCnpjChange(Sender: TObject);
var
  RawText, MaskedText: string;
  NumCount, i: Integer;
begin
  inherited;

  if VarIsNull(lcbTipoPessoa.KeyValue) then Exit;

  edtCpfCnpj.OnChange := nil;
  try
    // Remove tudo que não é número
    RawText := SomenteNumeros(edtCpfCnpj.Text);
    NumCount := Length(RawText);
    MaskedText := '';

    // Máscara CPF
    if lcbTipoPessoa.KeyValue = 1 then
    begin
      if NumCount > 0 then MaskedText := Copy(RawText,1,3);
      if NumCount > 3 then MaskedText := Copy(RawText,1,3) + '.' + Copy(RawText,4,3);
      if NumCount > 6 then MaskedText := Copy(RawText,1,3) + '.' + Copy(RawText,4,3) + '.' + Copy(RawText,7,3);
      if NumCount > 9 then MaskedText := Copy(RawText,1,3) + '.' + Copy(RawText,4,3) + '.' + Copy(RawText,7,3) + '-' + Copy(RawText,10,2);
    end
    // Máscara CNPJ
    else if lcbTipoPessoa.KeyValue = 2 then
    begin
      if NumCount > 0 then MaskedText := Copy(RawText,1,2);
      if NumCount > 2 then MaskedText := Copy(RawText,1,2) + '.' + Copy(RawText,3,3);
      if NumCount > 5 then MaskedText := Copy(RawText,1,2) + '.' + Copy(RawText,3,3) + '.' + Copy(RawText,6,3);
      if NumCount > 8 then MaskedText := Copy(RawText,1,2) + '.' + Copy(RawText,3,3) + '.' + Copy(RawText,6,3) + '/' + Copy(RawText,9,4);
      if NumCount > 12 then MaskedText := Copy(RawText,1,2) + '.' + Copy(RawText,3,3) + '.' + Copy(RawText,6,3) + '/' + Copy(RawText,9,4) + '-' + Copy(RawText,13,2);
    end;

    edtCpfCnpj.Text := MaskedText;

    // Cursor no final
    edtCpfCnpj.SelStart := Length(MaskedText);

  finally
    edtCpfCnpj.OnChange := edtCpfCnpjChange;
  end;
end;

procedure TTfrmCadCliente.edtTelefoneChange(Sender: TObject);
var
  RawText, MaskedText: string;
  NumCount: Integer;
begin
  inherited;

  edtTelefone.OnChange := nil;
  try
    RawText := SomenteNumeros(edtTelefone.Text);
    NumCount := Length(RawText);
    MaskedText := '';

    // serviço: padrão 0X00
    if (NumCount >= 4) and (RawText[1] = '0') and (RawText[3] = '0') and (RawText[4] = '0') then
    begin
      MaskedText := Copy(RawText,1,4);
      if NumCount > 4 then MaskedText := MaskedText + ' ' + Copy(RawText,5,3);
      if NumCount > 7 then MaskedText := MaskedText + ' ' + Copy(RawText,8,4);
    end
    // telefone fixo com até 10 dígitos
    else if NumCount <= 10 then
    begin
      if NumCount >= 1 then MaskedText := '(' + Copy(RawText,1,2);
      if NumCount > 2 then MaskedText := '(' + Copy(RawText,1,2) + ')' + Copy(RawText,3,4);
      if NumCount > 6 then MaskedText := '(' + Copy(RawText,1,2) + ')' + Copy(RawText,3,4) + '-' + Copy(RawText,7,4);
    end
    // celular com 11 dígitos
    else if NumCount = 11 then
    begin
      MaskedText := '(' + Copy(RawText,1,2) + ')' + Copy(RawText,3,5) + '-' + Copy(RawText,8,4);
    end;

    edtTelefone.Text := MaskedText;
    edtTelefone.SelStart := Length(MaskedText);

  finally
    edtTelefone.OnChange := edtTelefoneChange;
  end;
end;

procedure TTfrmCadCliente.AtualizarTipoDocumento;
begin
  edtCpfCnpj.Clear;
  if lcbTipoPessoa.KeyValue = 1 then
    lblCpfCnpj.Caption := 'CPF'
  else if lcbTipoPessoa.KeyValue = 2 then
    lblCpfCnpj.Caption := 'CNPJ'
  else
    lblCpfCnpj.Caption := 'CPF/CNPJ';
end;


procedure TTfrmCadCliente.FormCreate(Sender: TObject);
begin
  inherited;
    oCliente:=TCliente.Create(dtmPrincipal.ConexaoDB);

  IndiceAtual:='nome';

end;


procedure TTfrmCadCliente.FormShow(Sender: TObject);
begin
  inherited;
  QryStatus.Open;
  QryTipoPessoa.Open;

end;

procedure TTfrmCadCliente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
    if Assigned(oCliente) then
     FreeAndNil(oCliente);

    QryStatus.Close;
    QryTipoPessoa.Close;

end;
end.

