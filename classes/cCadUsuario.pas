unit cCadUsuario;

interface
uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.ComCtrls, RxToolEdit, uEnum, uDTMConexao, uFuncaoCriptografia;

type
  TUsuario = class
  private
    ConexaoDB:TFDConnection;
    F_usuarioId:Integer;
    F_nome:String;
    F_senha: string;
    F_salt: string;
    F_AlterouSenha: Boolean;
    procedure SetSenha(const Value: string);

  public
    constructor Create(aConexao:TFDConnection);
    destructor Destroy; override;
    function Inserir:Boolean;
    function Atualizar:Boolean;
    function Apagar:Boolean;
    function Selecionar(id:Integer):Boolean;
    function Logar(aUsuario, aSenha: String): Boolean;
    function UsuarioExiste(aUsuario: String): Boolean;
    function AlterarSenha: Boolean;
  published
    property senha: string write SetSenha;
    property codigo        :Integer    read F_usuarioId      write F_usuarioId;
    property nome          :string     read F_nome           write F_nome;
  end;

implementation

{$region 'Constructor and Destructor'}
constructor TUsuario.Create(aConexao:TFDConnection);
begin
  ConexaoDB:=aConexao;
end;

destructor TUsuario.Destroy;
begin
  inherited;
end;
{$endRegion}

{$REGION 'CRUD'}

function TUsuario.Apagar: Boolean;
var Qry:TFDQuery;
begin
  if MessageDlg('Apagar o Registro: '+#13+#13+
                'Código: '+IntToStr(F_usuarioId)+#13+
                'Nome: '  +F_nome,mtConfirmation,[mbYes, mbNo],0)=mrNo then begin
     Result:=false;
     abort;
  end;


  Result:=true;
  Qry:=TFDQuery.Create(nil);
  try
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('DELET FROM usuariosAcaoAcesso WHERE usuarioId = :usuarioId');
    Qry.ParamByName('usuarioId').AsInteger :=F_usuarioId;
    Qry.SQL.Add('DELETE FROM usuarios '+
                ' WHERE usuarioId=:usuarioId ');
    Qry.ParamByName('usuarioId').AsInteger :=F_usuarioId;
     try
      Qry.ExecSQL;
    except
      raise;
    end;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TUsuario.Atualizar: Boolean;
var Qry:TFDQuery;
begin
    Result:=true;
    Qry:=TFDQuery.Create(nil);
  try
    Qry.Connection := ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('UPDATE usuarios SET nome = :nome');

    if F_AlterouSenha then
    begin
      Qry.SQL.Add(', senha = :senha');
      Qry.SQL.Add(', senhaSalt = :senhaSalt');
    end;

    Qry.SQL.Add(' WHERE usuarioId = :usuarioId');

    Qry.ParamByName('usuarioId').AsInteger := F_usuarioId;
    Qry.ParamByName('nome').AsString := F_nome;

    if F_AlterouSenha then
    begin
      Qry.ParamByName('senha').AsString := F_senha;
      Qry.ParamByName('senhaSalt').AsString := F_salt;
    end;

     try
      Qry.ExecSQL;
    except
      raise;
    end;

    F_senha := '';
    F_salt := '';
    F_AlterouSenha := False;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TUsuario.Inserir: Boolean;
var Qry:TFDQuery;
begin
  Result:=true;

  Qry:=TFDQuery.Create(nil);
  try
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('INSERT INTO usuarios (nome, '+
                '                      senha, '+
                '                      senhaSalt ) '+
                'OUTPUT INSERTED.usuarioId ' +
                ' VALUES              (:nome, '+
                '                      :senha, '+
                '                      :senhaSalt )' );
    if not F_AlterouSenha then
      raise Exception.Create('Senha não informada.');

    Qry.ParamByName('nome').AsString             :=Self.F_nome;
    Qry.ParamByName('senha').AsString            :=Self.F_senha;
    Qry.ParamByName('senhaSalt').AsString        := F_salt;


     try
      Qry.Open;
      Self.F_usuarioId := Qry.Fields[0].AsInteger
    except
      raise;
    end;

    F_senha := '';
    F_salt := '';
    F_AlterouSenha := False;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TUsuario.Selecionar(id: Integer): Boolean;
var Qry:TFDQuery;
begin
  try
    Result:=true;
    Qry:=TFDQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT usuarioId,'+
                '       nome, '+
                '       senha, '+
                '       senhaSalt '+
                '  FROM usuarios '+
                ' WHERE usuarioId=:usuarioId');
    Qry.ParamByName('usuarioId').AsInteger:=id;
    Try
      Qry.Open;

      Self.F_usuarioId     := Qry.FieldByName('usuarioId').AsInteger;
      Self.F_nome          := Qry.FieldByName('nome').AsString;
      F_senha := '';
      F_salt := '';
      F_AlterouSenha := False;
    Except
      Result:=false;
    End;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TUsuario.UsuarioExiste(aUsuario:String):Boolean;
var Qry:TFDQuery;
begin
  try
    Qry:=TFDQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT COUNT(usuarioId) AS Qtde '+
                '  FROM usuarios '+
                ' WHERE nome =:nome ');
    Qry.ParamByName('nome').AsString :=aUsuario;
    Try
      Qry.Open;

      if Qry.FieldByName('Qtde').AsInteger>0 then
         result := true
      else
         result := false;

    Except
      Result:=false;
    End;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

{$ENDREGION}

{$REGION 'Alterar a senha'}

function TUsuario.AlterarSenha: Boolean;
var Qry:TFDQuery;
begin
   try
     Result:=True;
     Qry:=TFDQuery.Create(nil);
     Qry.Connection:=ConexaoDB;
     Qry.SQL.Clear;
     Qry.SQL.Add('UPDATE usuarios '+
                 '   SET senha =:senha, '+
                 '       senhaSalt =:senhaSalt '+
                 ' WHERE usuarioId=:usuarioId ');
     Qry.ParamByName('usuarioId').AsInteger     :=Self.F_usuarioId;
     Qry.ParamByName('senha').AsString          := F_senha;
     Qry.ParamByName('senhaSalt').AsString           := F_salt;

     if not F_AlterouSenha then
      raise Exception.Create('Senha inválida.');

      Try
      ConexaoDB.StartTransaction;
      Qry.ExecSQL;
      ConexaoDB.Commit;
    Except
      ConexaoDB.Rollback;
      Result:=false;
    End;
   finally
    if Assigned(Qry) then
      FreeAndNil(Qry);
   end;
end;

{$ENDREGION}


{$REGION 'Login'}

function TUsuario.Logar(aUsuario, aSenha: String): Boolean;
var Qry:TFDQuery;
HashDigitado: string;
begin
  Result  := False;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := ConexaoDB;

    //busca usuário
    Qry.SQL.Clear;
    Qry.SQL.Add('Select usuarioId, nome, senha, senhaSalt '+
                'FROM usuarios where nome = :nome');

    Qry.ParamByName('nome').AsString  := aUsuario;
    Qry.Open;

    if not Qry.IsEmpty then
    begin
      //gera hash com salt
      HashDigitado := GerarHash(aSenha, Qry.FieldByName('senhaSalt').AsString);

      // compara
      if HashDigitado = Qry.FieldByName('senha').AsString then
      begin
        F_usuarioId := Qry.FieldByName('usuarioId').AsInteger;
        F_nome := Qry.FieldByName('nome').AsString;
        Result := True;
      end;
    end;

    F_AlterouSenha := False;

  finally
    if Assigned (Qry) then
      FreeAndNil(Qry);
  end;
end;

{$ENDREGION}

procedure TUsuario.SetSenha(const Value: string);
begin
  F_salt := GerarSalt;
  F_senha := GerarHash(Value, F_salt);
  F_AlterouSenha := True;
end;

end.
