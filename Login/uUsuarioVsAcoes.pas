unit uUsuarioVsAcoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, uDTMConexao, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons;

type
  TfrmUsuarioVsAcoes = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    grdUsuarios: TDBGrid;
    grdAcoes: TDBGrid;
    dtsUsuarios: TDataSource;
    dtsAcoes: TDataSource;
    QryUsuarios: TFDQuery;
    QryAcoes: TFDQuery;
    QryUsuariosusuarioId: TFDAutoIncField;
    QryUsuariosnome: TStringField;
    QryAcoesusuarioId: TIntegerField;
    QryAcoesacaoAcessoId: TIntegerField;
    QryAcoesdescricao: TStringField;
    QryAcoesativo: TBooleanField;
    btnFechar: TBitBtn;
    procedure btnFecharClick(Sender: TObject);
    procedure QryUsuariosAfterScroll(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure grdAcoesDblClick(Sender: TObject);
    procedure grdAcoesDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure grdUsuariosDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
  private
    { Private declarations }
    procedure SelecionarAcoesAcessoPorUsuario;
  public
    { Public declarations }
  end;

var
  frmUsuarioVsAcoes: TfrmUsuarioVsAcoes;

implementation

{$R *.dfm}

procedure TfrmUsuarioVsAcoes.btnFecharClick(Sender: TObject);
begin
  close;
end;

procedure TfrmUsuarioVsAcoes.grdAcoesDblClick(Sender: TObject);
var
  Qry: TFDQuery;
  nAcaoAcessoId: Integer;
begin
  nAcaoAcessoId := QryAcoes.FieldByName('acaoAcessoId').AsInteger; // salva o ID
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := dtmPrincipal.ConexaoDB;
    Qry.SQL.Add('UPDATE usuariosAcaoAcesso ' +
                '   SET ativo = :ativo ' +
                ' WHERE usuarioId = :usuarioId ' +
                '   AND acaoAcessoId = :acaoAcessoId');
    Qry.ParamByName('usuarioId').AsInteger    := QryAcoes.FieldByName('usuarioId').AsInteger;
    Qry.ParamByName('acaoAcessoId').AsInteger := QryAcoes.FieldByName('acaoAcessoId').AsInteger;
    Qry.ParamByName('ativo').AsBoolean        := not QryAcoes.FieldByName('ativo').AsBoolean;
    try
      dtmPrincipal.ConexaoDB.StartTransaction;
      Qry.ExecSQL;
      dtmPrincipal.ConexaoDB.Commit;
    except
      dtmPrincipal.ConexaoDB.Rollback;
      raise;
    end;
  finally
    SelecionarAcoesAcessoPorUsuario;
    // Reposiciona pelo ID em vez de bookmark
    QryAcoes.Locate('acaoAcessoId', nAcaoAcessoId, []);
    if Assigned(Qry) then
      FreeAndNil(Qry);
  end;
end;

procedure TfrmUsuarioVsAcoes.grdAcoesDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  Linha: Integer;
begin
  Linha := grdAcoes.DataSource.DataSet.RecNo;

  if not (gdSelected in State) then
  begin
    if (Linha mod 2) = 0 then
      grdAcoes.Canvas.Brush.Color := clWebLightgrey
    else
      grdAcoes.Canvas.Brush.Color := clWhite;
  end
  else
  begin
    grdAcoes.Canvas.Brush.Color := RGB(220, 200, 255); // roxo pastel
    grdAcoes.Canvas.Font.Color := clBlack;

  end;

  grdAcoes.Canvas.FillRect(Rect);
  grdAcoes.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, Column.Field.AsString);

  if not QryAcoes.FieldByName('ativo').AsBoolean  then
  begin
    TDBGrid(Sender).Canvas.Font.Color:= clWhite;
    TDBGrid(Sender).Canvas.Brush.Color:= clRed;
  end;
  TDBGrid(sender).DefaultDrawDataCell(rect, TDBGrid(Sender).Columns[DataCol].Field,state );

end;

procedure TfrmUsuarioVsAcoes.grdUsuariosDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
var
  Linha: Integer;
begin
  Linha := grdUsuarios.DataSource.DataSet.RecNo;

  if not (gdSelected in State) then
  begin
    if (Linha mod 2) = 0 then
      grdUsuarios.Canvas.Brush.Color := clWebLightgrey
    else
      grdUsuarios.Canvas.Brush.Color := clWhite;
  end
  else
  begin
    grdUsuarios.Canvas.Brush.Color := RGB(220, 200, 255); // roxo pastel
    grdUsuarios.Canvas.Font.Color := clBlack;
  end;

  grdUsuarios.Canvas.FillRect(Rect);
  grdUsuarios.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, Column.Field.AsString);

end;

procedure TfrmUsuarioVsAcoes.FormShow(Sender: TObject);
var i: Integer;
begin
  try
    QryUsuarios.DisableControls;
    QryUsuarios.Open;
    SelecionarAcoesAcessoPorUsuario;
  finally
    QryUsuarios.EnableControls;
  end;

  grdUsuarios.DefaultDrawing := False;

  for i := 0 to grdUsuarios.Columns.Count - 1 do
    grdUsuarios.Columns[i].Title.Alignment := taCenter;

  grdAcoes.DefaultDrawing := False;

  for i := 0 to grdAcoes.Columns.Count - 1 do
    grdAcoes.Columns[i].Title.Alignment := taCenter;

end;

procedure TfrmUsuarioVsAcoes.QryUsuariosAfterScroll(DataSet: TDataSet);
begin
  SelecionarAcoesAcessoPorUsuario;
end;

procedure TfrmUsuarioVsAcoes.SelecionarAcoesAcessoPorUsuario;
begin
  QryAcoes.Close;
  QryAcoes.ParamByName('usuarioId').AsInteger := QryUsuarios.FieldByName('usuarioId').AsInteger;
  QryAcoes.Open;
end;

end.
