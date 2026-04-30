 unit uLogin;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, cCadUsuario, uDTMConexao,
  Vcl.Imaging.pngimage, cLog, uCadRegistro;

type
  TfrmLogin = class(TForm)
    Panel2: TPanel;
    Image1: TImage;
    Panel1: TPanel;
    btnRegistro: TBitBtn;
    btnFechar: TBitBtn;
    edtSenha: TEdit;
    edtUsuario: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnAcessar: TBitBtn;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnAcessarClick(Sender: TObject);
    procedure btnRegistroClick(Sender: TObject);
  private
    { Private declarations }
    bFechar:Boolean;
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;
  Log: TLog;

implementation

uses uPrincipal;

{$R *.dfm}

procedure TfrmLogin.btnRegistroClick(Sender: TObject);
begin
  frmCadRegistro := TfrmCadRegistro.Create(nil);
  try
    frmCadRegistro.ShowModal;
  finally
    FreeAndNil(frmCadRegistro);
  end;

  edtUsuario.Clear;
  edtSenha.Clear;

  edtUsuario.SetFocus;
end;

procedure TfrmLogin.btnAcessarClick(Sender: TObject);
var oUsuario:TUsuario;
begin
  try
    oUsuario:=TUsuario.Create(dtmPrincipal.ConexaoDB);
      if oUsuario.Logar(edtUsuario.Text,edtSenha.Text) then begin
      case oUsuario.statusUsuarioId of
        1: begin
             // ATIVO
           end;

        2: begin
             MessageDlg('Usuário está PENDENTE. Contate o administrador.',
               mtWarning,[mbOK],0);
             Exit;
           end;

        3: begin
             MessageDlg('Usuário BLOQUEADO. Acesso negado.',
               mtError,[mbOK],0);
             Exit;
           end;

      else
        begin
          MessageDlg('Status de usuário desconhecido.',
            mtError,[mbOK],0);
          Exit;
        end;
      end;
      oUsuarioLogado.codigo := oUsuario.codigo;
      oUsuarioLogado.nome   := oUsuario.nome;
      oUsuarioLogado.nivelUsuarioId := oUsuario.nivelUsuarioId;
      oUsuarioLogado.statusUsuarioId := oUsuario.statusUsuarioId;
      bFechar:=true;
       try
        Log := TLog.Create(dtmPrincipal.ConexaoDB);

        Log.usuarioId      := oUsuarioLogado.codigo;
        Log.usuarioNome    := oUsuarioLogado.nome;

        Log.tela           := 'uLogin';
        Log.acao           := 'Login';
        Log.descricao      := ('Na tela ' + Log.tela + ' houve um(a) ' + Log.acao);

        if not Log.Inserir(False) then
            raise Exception.Create('Falha ao gravar log');

      finally
        if Assigned (Log) then
          FreeAndNil(Log);
      end;
      Close;
    end
    else begin
      MessageDlg('Usuário Inválido',mtInformation,[mbok],0);
      edtUsuario.SetFocus;
    end;
  finally
    if Assigned(oUsuario) then
      FreeAndNil(oUsuario);
  end;
end;

procedure TfrmLogin.btnFecharClick(Sender: TObject);
begin
  bFechar:=true;
  Application.Terminate;
end;

procedure TfrmLogin.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:= bFechar;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  bFechar:=False;
  edtUsuario.SetFocus;
end;

end.
