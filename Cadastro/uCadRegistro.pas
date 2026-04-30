unit uCadRegistro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.ComCtrls, cCadUsuario, uEnum, uDTMConexao, cAcaoAcesso,
  Vcl.Imaging.pngimage, cLog;

type
  TfrmCadRegistro = class(TForm)
    Background: TPanel;
    Image1: TImage;
    Panel1: TPanel;
    btnGravar: TBitBtn;
    btnFechar: TBitBtn;
    Label3: TLabel;
    edtSenha: TEdit;
    Label2: TLabel;
    edtUsuario: TEdit;
    Label1: TLabel;
    procedure btnFecharClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    oUsuario:Tusuario;
    Log:TLog;
    function NomeCampoId: string;
    function NomeCampoNome: string;
    function ValorLogId: string;
    function ValorLogNome: string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadRegistro: TfrmCadRegistro;

implementation

{$R *.dfm}

procedure TfrmCadRegistro.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadRegistro.btnGravarClick(Sender: TObject);
begin
  if not assigned(oUsuario) then
    oUsuario := TUsuario.Create(dtmPrincipal.ConexaoDB);

  if oUsuario.UsuarioExiste(edtUsuario.Text) then
  begin
    MessageDlg('Usuário já cadastrado', mtInformation, [mbOK], 0);
    edtUsuario.SetFocus;
    Exit;
  end;

  if Trim(edtUsuario.Text) = '' then
  begin
    MessageDlg('Informe o Nome', mtWarning, [mbOK], 0);
    Exit;
  end;

  if Trim(edtSenha.Text) = '' then
  begin
    MessageDlg('Informe a senha', mtWarning, [mbOK], 0);
    Exit;
  end;

  oUsuario.codigo := 0;
  oUsuario.nome := edtUsuario.Text;
  oUsuario.senha := edtSenha.Text;
  oUsuario.nivelUsuarioId := 3;
  oUsuario.statusUsuarioId := 2;

  oUsuario.Inserir;

  Log := TLog.Create(dtmPrincipal.ConexaoDB);
  try
    Log.usuarioId   := oUsuario.codigo;
    Log.usuarioNome := oUsuario.nome;
    Log.tela        := Self.Name;
    Log.acao        := 'Registro';

    Log.descricao := 'Na ' + Log.tela + ' Houve um(a) ' + Log.acao + ' do Usuário de Id: ' +
                      IntToStr(oUsuario.codigo) +
                     ' Nome: ' + oUsuario.nome;

    if not Log.Inserir(False) then
      raise Exception.Create('Falha ao gravar log');


  finally
    if Assigned (Log) then
      FreeAndNil(Log);
  end;

  ShowMessage('Usuário cadastrado com sucesso!');
  edtUsuario.Clear;
  edtSenha.Clear;
  Close;
end;

procedure TfrmCadRegistro.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(oUsuario) then
    FreeAndNil(oUsuario);
end;

function TfrmCadRegistro.NomeCampoId: string;
begin
  Result := 'usuarioId';
end;

function TfrmCadRegistro.NomeCampoNome: string;
begin
  Result := 'nome';
end;

function TfrmCadRegistro.ValorLogId: string;
begin
  Result := null ;
end;

function TfrmCadRegistro.ValorLogNome: string;
begin
  Result := edtUsuario.Text;
end;

end.
