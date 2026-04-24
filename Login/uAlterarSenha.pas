unit uAlterarSenha;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;
type
  TfrmAlterarSenha = class(TForm)
    lblSenhaAtual: TLabel;
    lblNovaSenha: TLabel;
    lblDigiteNovamente: TLabel;
    edtSenhaAtual: TEdit;
    edtNovaSenha: TEdit;
    edtDigiteNovamente: TEdit;
    btnFechar: TBitBtn;
    btnAlterar: TBitBtn;
    lblUsuarioLogado: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
  private
    procedure LimparEdits;
    function SenhaAtualCorreta: Boolean;
  public
  end;
var
  frmAlterarSenha: TfrmAlterarSenha;
implementation
uses cCadUsuario, uPrincipal, uDTMConexao, uFuncaoCriptografia,
     FireDAC.Comp.Client, FireDAC.Stan.Param, Data.DB;
{$R *.dfm}

function TfrmAlterarSenha.SenhaAtualCorreta: Boolean;
var
  Qry: TFDQuery;
  HashDigitado: string;
begin
  Result := False;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := dtmPrincipal.ConexaoDB;
    Qry.SQL.Text :=
      'SELECT senha, senhaSalt ' +
      'FROM usuarios ' +
      'WHERE usuarioId = :usuarioId';
    Qry.ParamByName('usuarioId').AsInteger := oUsuarioLogado.codigo;
    Qry.Open;

    if not Qry.IsEmpty then
    begin
      HashDigitado := GerarHash(edtSenhaAtual.Text, Qry.FieldByName('senhaSalt').AsString);
      Result := HashDigitado = Qry.FieldByName('senha').AsString;
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

procedure TfrmAlterarSenha.btnAlterarClick(Sender: TObject);
var
  oUsuario: TUsuario;
begin
  if Trim(edtSenhaAtual.Text) = '' then
  begin
    MessageDlg('Informe a senha atual.', mtWarning, [mbOK], 0);
    edtSenhaAtual.SetFocus;
    Exit;
  end;

  if Trim(edtNovaSenha.Text) = '' then
  begin
    MessageDlg('Informe a nova senha.', mtWarning, [mbOK], 0);
    edtNovaSenha.SetFocus;
    Exit;
  end;

  if not SenhaAtualCorreta then
  begin
    MessageDlg('Senha atual inválida.', mtWarning, [mbOK], 0);
    edtSenhaAtual.SetFocus;
    LimparEdits;
    Exit;
  end;

  if edtNovaSenha.Text <> edtDigiteNovamente.Text then
  begin
    MessageDlg('As novas senhas não coincidem.', mtWarning, [mbOK], 0);
    edtNovaSenha.SetFocus;
    Exit;
  end;

  oUsuario := TUsuario.Create(dtmPrincipal.ConexaoDB);
  try
    oUsuario.codigo := oUsuarioLogado.codigo;
    oUsuario.senha  := edtNovaSenha.Text;
    if oUsuario.AlterarSenha then
    begin
      MessageDlg('Senha alterada com sucesso.', mtInformation, [mbOK], 0);
      LimparEdits;
    end
    else
      MessageDlg('Erro ao alterar a senha. Tente novamente.', mtError, [mbOK], 0);
  finally
    FreeAndNil(oUsuario);
  end;
end;

procedure TfrmAlterarSenha.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAlterarSenha.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LimparEdits;
end;

procedure TfrmAlterarSenha.FormShow(Sender: TObject);
begin
  LimparEdits;
  lblUsuarioLogado.Caption := oUsuarioLogado.nome;
  edtSenhaAtual.SetFocus;
end;

procedure TfrmAlterarSenha.LimparEdits;
begin
  edtSenhaAtual.Clear;
  edtNovaSenha.Clear;
  edtDigiteNovamente.Clear;
end;

end.
