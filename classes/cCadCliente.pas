unit cCadCliente;

interface

uses
Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.ComCtrls, RxToolEdit;

type
  TCliente = class
  private
    ConexaoDB:TFDConnection;

  //f_#### Essas variaveis guardam dados do cliente em memória
    F_cnpj: string;
    F_cpf: string;
    F_clienteId:Integer;  //Int
    F_nome:String; //VarChar
    F_endereco: string;
    F_cidade:String;
    F_bairro: String;
    F_estado: string;
    F_cep: String;
    F_telefone: string;
    F_email: string;
    F_dataNascimento: TDateTime;

  public
    constructor Create(aConexao:TFDConnection);
    destructor Destroy; override;
    function Inserir:Boolean;
    function Atualizar:Boolean;
    function Apagar:Boolean;
    function Selecionar(id:Integer):Boolean;
  published
    property codigo        :Integer    read F_clienteId      write F_clienteId;
    property nome          :string     read F_nome           write F_nome;
    property endereco      :string     read F_endereco       write F_endereco;
    property cidade        :string     read F_cidade         write F_cidade;
    property bairro        :string     read F_bairro         write F_bairro;
    property estado        :string     read F_estado         write F_Estado;
    property cep           :string     read F_cep            write F_Cep;
    property telefone      :string     read F_telefone       write F_telefone;
    property email         :string     read F_email          write F_email;
    property dataNascimento:TDateTime  read F_dataNascimento write F_dataNascimento;
    property cpf           :string     read F_cpf            write F_cpf;
    property cnpj          :string     read F_cnpj           write F_cnpj;
  end;

implementation


{ TCategoria }

{$region 'Constructor and Destructor'}
constructor TCliente.Create(aConexao:TFDConnection);
begin
  //recebe a conexão com o banco
  ConexaoDB:=aConexao;
end;

destructor TCliente.Destroy;
begin

  inherited;
end;
{$endRegion}

{$region 'CRUD'}
function TCliente.Apagar: Boolean;
var Qry:TFDQuery;
TemVenda: boolean;
begin
  Result := False;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := ConexaoDB;

    // Verifica se tem vendas
    Qry.SQL.Text := 'SELECT COUNT(*) FROM vendas WHERE clienteId = :clienteId';
    Qry.ParamByName('clienteId').AsInteger := F_clienteId;
    Qry.Open;

    TemVenda := Qry.Fields[0].AsInteger > 0;
    Qry.Close;

    if MessageDlg('Apagar o Registro: '+#13+#13+
                'Código: '+IntToStr(F_clienteId)+#13+
                'Descrição: '+F_nome,mtConfirmation,[mbYes, mbNo],0)=mrNo then begin
      Result:=false;
      abort;
    end;

    try

      if TemVenda then
      begin
        // SE TEM VENDA BLOQUEIA EM VEZ DE DELETAR
        Qry.SQL.Text :=
          'UPDATE clientes SET clienteStatusId = 2 '+
          'WHERE clienteId = :clienteId';

        Qry.ParamByName('clienteId').AsInteger := F_clienteId;
        Qry.ExecSQL;

        MessageDlg(
          'Cliente possui vendas vinculadas e NÃO pode ser excluído.' + sLineBreak +
          'Ele foi marcado como BLOQUEADO.',
          mtWarning, [mbOK], 0);
      end
      else
      begin
        // DELETE NORMAL
        Qry.SQL.Text :=
          'DELETE FROM clientes WHERE clienteId = :clienteId';

        Qry.ParamByName('clienteId').AsInteger := F_clienteId;
        Qry.ExecSQL;
      end;

      Qry.ExecSQL;
      Result := True;

    Except
      on E: Exception do
        raise;
     End;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TCliente.Atualizar: Boolean;
var Qry:TFDQuery;
begin
    Result:=true;
    Qry:=TFDQuery.Create(nil);
  Try
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('UPDATE clientes '+
                '   SET nome            =:nome '+
                '       ,endereco       =:endereco '+
                '       ,cidade         =:cidade '+
                '       ,bairro         =:bairro '+
                '       ,estado         =:estado '+
                '       ,cep            =:cep '+
                '       ,telefone       =:telefone '+
                '       ,email          =:email '+
                '       ,dataNascimento =:dataNascimento '+
                '       ,cpf            =:cpf ' +
                '       ,cnpj           =:cnpj '+
                ' WHERE clienteId=:clienteId ');
    Qry.ParamByName('clienteId').AsInteger       :=Self.F_clienteId;
    Qry.ParamByName('nome').AsString             :=Self.F_nome;
    Qry.ParamByName('endereco').AsString         :=Self.F_endereco;
    Qry.ParamByName('cidade').AsString           :=Self.F_cidade;
    Qry.ParamByName('bairro').AsString           :=Self.F_bairro;
    Qry.ParamByName('estado').AsString           :=Self.F_estado;
    Qry.ParamByName('cep').AsString              :=Self.F_cep;
    Qry.ParamByName('telefone').AsString         :=Self.F_telefone;
    Qry.ParamByName('email').AsString            :=Self.F_email;
    Qry.ParamByName('dataNascimento').AsDateTime :=Self.F_dataNascimento;
    Qry.ParamByName('cpf').AsString              :=Self.F_cpf;
    Qry.ParamByName('cnpj').AsString             :=Self.F_cnpj;


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

function TCliente.Inserir: Boolean;
var Qry:TFDQuery;
begin

  Result:=true;
  Qry:=TFDQuery.Create(nil);
  try
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('INSERT INTO clientes (nome, '+
                '                      endereco, '+
                '                      cidade,  '+
                '                      bairro,  '+
                '                      estado, '+
                '                      cep, '+
                '                      telefone, '+
                '                      email, '+
                '                      cpf, '+
                '                      cnpj, '+
                '                      datanascimento) '+
                'OUTPUT INSERTED.clienteId ' +
                ' VALUES              (:nome, '+
                '                      :endereco, '+
                '                      :cidade,  '+
                '                      :bairro,  '+
                '                      :estado, '+
                '                      :cep, '+
                '                      :telefone, '+
                '                      :email, '+
                '                      :cpf, '+
                '                      :cnpj, '+
                '                      :datanascimento)' );

    //preenche os parâmetros
    Qry.ParamByName('nome').AsString             :=Self.F_nome;
    Qry.ParamByName('endereco').AsString         :=Self.F_endereco;
    Qry.ParamByName('cidade').AsString           :=Self.F_cidade;
    Qry.ParamByName('bairro').AsString           :=Self.F_bairro;
    Qry.ParamByName('estado').AsString           :=Self.F_estado;
    Qry.ParamByName('cep').AsString              :=Self.F_cep;
    Qry.ParamByName('telefone').AsString         :=Self.F_telefone;
    Qry.ParamByName('email').AsString            :=Self.F_email;
    Qry.ParamByName('dataNascimento').AsDateTime :=Self.F_dataNascimento;
    Qry.ParamByName('cpf').AsString              :=Self.F_cpf;
    Qry.ParamByName('cnpj').AsString             :=Self.F_cnpj;

    try
      Qry.Open;
      Self.F_clienteId := Qry.Fields[0].AsInteger;
    except
      raise;
    end;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TCliente.Selecionar(id: Integer): Boolean;
var Qry:TFDQuery;
begin
    Result:=true;
    Qry:=TFDQuery.Create(nil);
  try
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT clienteId,'+
                '       nome, '+
                '       endereco, '+
                '       cidade, '+
                '       bairro, '+
                '       estado, '+
                '       cep, '+
                '       telefone, '+
                '       email, '+
                '       datanascimento, '+
                '       cpf, '+
                '       cnpj '+
                '  FROM clientes '+
                ' WHERE clienteId=:clienteId');
    Qry.ParamByName('clienteId').AsInteger:=id;
    Try
      Qry.Open;

      Self.F_clienteId     := Qry.FieldByName('clienteId').AsInteger;
      Self.F_nome          := Qry.FieldByName('nome').AsString;
      Self.F_endereco      := Qry.FieldByName('endereco').AsString;
      Self.F_cidade        := Qry.FieldByName('cidade').AsString;
      Self.F_bairro        := Qry.FieldByName('bairro').AsString;
      Self.F_estado        := Qry.FieldByName('estado').AsString;
      Self.F_cep           := Qry.FieldByName('cep').AsString;
      Self.F_telefone      := Qry.FieldByName('telefone').AsString;
      Self.F_email         := Qry.FieldByName('email').AsString;
      Self.F_dataNascimento:= Qry.FieldByName('datanascimento').AsDateTime;
      Self.F_cpf           := Qry.FieldByName('cpf').AsString;
      Self.F_cnpj          := Qry.FieldByName('cnpj').AsString;

    Except
      Result:=false;
    End;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;
{$endregion}

end.

