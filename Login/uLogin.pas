 unit uLogin;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, cCadUsuario, uDTMConexao,
  Vcl.Imaging.pngimage, cLog;

type
  TfrmLogin = class(TForm)
    Panel2: TPanel;
    btnAcessar: TBitBtn;
    btnFechar: TBitBtn;
    edtSenha: TEdit;
    edtUsuario: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnAcessarClick(Sender: TObject);
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

procedure TfrmLogin.btnAcessarClick(Sender: TObject);
var oUsuario:TUsuario;
begin
  try
    oUsuario:=TUsuario.Create(dtmPrincipal.ConexaoDB);
      if oUsuario.Logar(edtUsuario.Text,edtSenha.Text) then begin
      oUsuarioLogado.codigo := oUsuario.codigo;
      oUsuarioLogado.nome   := oUsuario.nome;;
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
end;

end.
