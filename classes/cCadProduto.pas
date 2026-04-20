unit cCadProduto;

interface

uses
Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.ComCtrls, RxToolEdit;

type
  TProduto = class
  private
    ConexaoDB:TFDConnection;
    F_produtoId:Integer;  //Int
    F_nome:String; //VarChar
    F_descricao: string;
    F_valor:Double;
    F_quantidade: Double;
    F_categoriaId: Integer;
    F_foto:TBitmap;
    F_tipoEstoqueProdutoId: Integer;

  public
    constructor Create(aConexao:TFDConnection);
    destructor Destroy; override;
    function Inserir:Boolean;
    function Atualizar:Boolean;
    function Apagar:Boolean;
    function Selecionar(id:Integer):Boolean;
  published
    property codigo        :Integer         read F_produtoId            write F_produtoId;
    property nome          :string          read F_nome                 write F_nome;
    property descricao     :string          read F_descricao            write F_descricao;
    property valor         :Double          read F_valor                write F_valor;
    property quantidade    :Double          read F_quantidade           write F_quantidade;
    property categoriaId   :Integer         read F_categoriaId          write F_categoriaId;
    property foto          :TBitmap         read F_foto                 write F_foto;
    property tipoEstoqueProdutoId : Integer read F_tipoEstoqueProdutoId write F_tipoEstoqueProdutoId;
  end;

implementation


{ TCategoria }

{$region 'Constructor and Destructor'}
constructor TProduto.Create(aConexao:TFDConnection);
begin
  ConexaoDB:=aConexao;
  F_foto  := TBitmap.Create;
  F_foto.Assign(nil);
end;

destructor TProduto.Destroy;
begin
  if Assigned(F_foto) then begin
    F_foto.Assign(nil);
    F_foto.Free;
  end;
  inherited;
end;
{$endRegion}

{$region 'CRUD'}
function TProduto.Apagar: Boolean;
var Qry:TFDQuery;
TemVenda: Boolean;
begin

    if MessageDlg('Apagar o Registro: '+#13+#13+
                   'C digo: '+IntToStr(F_produtoId)+#13+
                   'Descri  o: '+F_nome,mtConfirmation,[mbYes, mbNo],0)=mrNo
    then begin
       Result:=false;
       abort;
    end;


    Result:=true;
    Qry:=TFDQuery.Create(nil);
  try
    Qry.Connection:=ConexaoDB;

    // Verifica se o produto esta em uma venda
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT COUNT(*) FROM vendasItens WHERE produtoId = :produtoId');
    Qry.ParamByName('produtoId').AsInteger := F_produtoId;
    Qry.Open;

    TemVenda := Qry.Fields[0].AsInteger > 0;
    Qry.Close;

    if TemVenda then
    begin
      MessageDlg(
        'Produto possui vendas vinculadas e não pode ser excluído.',
        mtWarning, [mbOK], 0);

      Result := False;
      Exit;
    end;

    // Delete se não houver vinculo com venda
    Qry.SQL.Clear;
    Qry.SQL.Add('DELETE FROM produtos '+
                ' WHERE produtoId=:produtoId ');
    Qry.ParamByName('produtoId').AsInteger :=F_produtoId;
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

function TProduto.Atualizar: Boolean;
var Qry:TFDQuery;
    MS: TMemoryStream;
begin
    Result:=true;
    Qry:=TFDQuery.Create(nil);
  try
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('UPDATE produtos '+
                '   SET nome           =:nome '+
                '       ,descricao     =:descricao '+
                '       ,valor         =:valor '+
                '       ,quantidade    =:quantidade '+
                '       ,foto          =:foto '+
                '       ,categoriaId   =:categoriaId '+
                '       ,tipoEstoqueProdutoId =:tipoEstoqueProdutoId '+
                ' WHERE produtoId=:produtoId ');
    Qry.ParamByName('produtoId').AsInteger            :=Self.F_produtoId;
    Qry.ParamByName('nome').AsString                  :=Self.F_nome;
    Qry.ParamByName('descricao').AsString             :=Self.F_descricao;
    Qry.ParamByName('valor').AsFloat                  :=Self.F_valor;
    Qry.ParamByName('quantidade').AsFloat             :=Self.F_quantidade;
    Qry.ParamByName('categoriaId').AsInteger          :=Self.F_categoriaId;
    Qry.ParamByName('tipoEstoqueProdutoId').AsInteger := Self.F_tipoEstoqueProdutoId;

    if (Self.F_Foto = nil) or Self.F_Foto.Empty then
    begin
      Qry.ParamByName('foto').DataType := ftBlob;
      Qry.ParamByName('foto').Clear;
    end
    else
    begin
      MS := TMemoryStream.Create;
      try
        Self.F_Foto.SaveToStream(MS);
        MS.Position := 0;
        Qry.ParamByName('foto').DataType := ftBlob;
        Qry.ParamByName('foto').LoadFromStream(MS, ftBlob);
      finally
        MS.Free;
      end;
    end;

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

function TProduto.Inserir: Boolean;
var Qry:TFDQuery;
    MS: TMemoryStream;
begin
    Result:=true;
    Qry:=TFDQuery.Create(nil);
  try
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('INSERT INTO produtos (nome, '+
                '                      descricao, '+
                '                      valor,  '+
                '                      quantidade,  '+
                '                      categoriaId, '+
                '                      foto, '+
                '                      tipoEstoqueProdutoId) '+
                'OUTPUT INSERTED.produtoId '+
                ' VALUES              (:nome, '+
                '                      :descricao, '+
                '                      :valor,  '+
                '                      :quantidade,  '+
                '                      :categoriaId, '+
                '                      :foto, '+
                '                      :tipoEstoqueProdutoId)');

    Qry.ParamByName('nome').AsString                  :=Self.F_nome;
    Qry.ParamByName('descricao').AsString             :=Self.F_descricao;
    Qry.ParamByName('valor').AsFloat                  :=Self.F_valor;
    Qry.ParamByName('quantidade').AsFloat             :=Self.F_quantidade;
    Qry.ParamByName('categoriaId').AsInteger          :=Self.F_categoriaId;
    Qry.ParamByName('tipoEstoqueProdutoId').AsInteger := Self.F_tipoEstoqueProdutoId;

    if (Self.F_foto = nil) or Self.F_foto.Empty then
    begin
      Qry.ParamByName('foto').DataType := ftBlob;
      Qry.ParamByName('foto').Clear;
    end
    else
    begin
      MS := TMemoryStream.Create;
      try
        Self.F_Foto.SaveToStream(MS);
        MS.Position := 0;
        Qry.ParamByName('foto').DataType := ftBlob;
        Qry.ParamByName('foto').LoadFromStream(MS, ftBlob);
      finally
        MS.Free;
      end;
    end;

     try
      Qry.Open;
      Self.F_produtoId := Qry.Fields[0].AsInteger;
    except
      raise;
    end;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TProduto.Selecionar(id: Integer): Boolean;
var Qry:TFDQuery;
begin
  try
    Result:=true;
    Qry:=TFDQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT produtoId,'+
                '       nome, '+
                '       descricao, '+
                '       valor, '+
                '       quantidade, '+
                '       foto, '+
                '       categoriaId, '+
                '       tipoEstoqueProdutoId '+
                '  FROM produtos '+
                ' WHERE produtoId=:produtoId');
    Qry.ParamByName('produtoId').AsInteger:=id;
    Try
      Qry.Open;

      Self.F_produtoId            := Qry.FieldByName('produtoId').AsInteger;
      Self.F_nome                 := Qry.FieldByName('nome').AsString;
      Self.F_descricao            := Qry.FieldByName('descricao').AsString;
      Self.F_valor                := Qry.FieldByName('valor').AsFloat;
      Self.F_quantidade           := Qry.FieldByName('quantidade').AsFloat;
      Self.F_categoriaId          := Qry.FieldByName('categoriaId').AsInteger;
      Self.F_tipoEstoqueProdutoId := Qry.FieldByName('tipoEstoqueProdutoId').AsInteger;
      if not Qry.FieldByName('foto').IsNull then
        Self.F_foto.Assign(Qry.FieldByName('foto'))
      else
        Self.F_foto.Assign(nil);
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
