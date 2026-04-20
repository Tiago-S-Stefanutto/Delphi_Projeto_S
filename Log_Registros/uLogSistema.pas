unit uLogSistema;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.ComCtrls, uDTMConexao, uDtmVenda, RxCurrEdit, RxToolEdit, uEnum, cUsuarioLogado, uTelaHerancaPesquisa;

type
  TfrmLogSistema = class(TfrmTelaHerancaPesquisa)
    edtDataFinal: TDateEdit;
    Label3: TLabel;
    edtDataInicio: TDateEdit;
    Label2: TLabel;
    QryListagemlogId: TFDAutoIncField;
    QryListagemdataHora: TSQLTimeStampField;
    QryListagemusuarioId: TIntegerField;
    QryListagemusuarioNome: TStringField;
    QryListagemtela: TStringField;
    QryListagemacao: TStringField;
    QryListagemdescricao: TStringField;
    procedure btnPesquisarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    SelectOriginal:string;
  public
    { Public declarations }
  end;

var
  frmLogSistema: TfrmLogSistema;

implementation

uses uPrincipal;

{$R *.dfm}

procedure TfrmLogSistema.btnPesquisarClick(Sender: TObject);
var
  CondicaoData: string;
  TemInicio, TemFim: Boolean;
  I: Integer;
  TipoCampo: TFieldType;
  NomeCampo: String;
  CondicaoSQL: String;
  Valor: String;
  FS: TFormatSettings;
begin
  if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo,
     Self.Name + '_' + TBitBtn(Sender).Name, DtmPrincipal.ConexaoDB) then
  begin
    MessageDlg('Usuário: ' + oUsuarioLogado.nome +
      ', não tem permissão de acesso', mtWarning, [mbOK], 0);
    Abort;
  end;

  Valor        := Trim(mskPesquisar.Text);
  TemInicio    := edtDataInicio.Date > 0;
  TemFim       := edtDataFinal.Date > 0;
  CondicaoSQL  := '';
  CondicaoData := '';
  NomeCampo    := '';
  TipoCampo    := ftUnknown;

  if (Valor = '') and (not TemInicio) and (not TemFim) then
  begin
    QryListagem.Close;
    QryListagem.SQL.Text := SelectOriginal;
    QryListagem.Open;
    Exit;
  end;

  if Valor <> '' then
  begin
    for I := 0 to QryListagem.FieldCount - 1 do
    begin
      if QryListagem.Fields[I].FieldName = IndiceAtual then
      begin
        TipoCampo := QryListagem.Fields[I].DataType;

        NomeCampo := 'logSistema.' + QryListagem.Fields[I].FieldName;

        Break;
      end;
    end;

    if NomeCampo <> '' then
    begin
      case TipoCampo of
        ftString, ftWideString:
          CondicaoSQL := ' WHERE ' + NomeCampo + ' LIKE :VALOR';

        ftInteger, ftSmallint, ftAutoInc:
        begin
          if not TryStrToInt(Valor, I) then
          begin
            MessageDlg('Digite um número válido', mtWarning, [mbOK], 0);
            Exit;
          end;
          CondicaoSQL := ' WHERE ' + NomeCampo + ' = :VALOR';
        end;

        ftFloat, ftCurrency, ftFMTBcd, ftBCD:
          CondicaoSQL := ' WHERE ' + NomeCampo + ' = :VALOR';

        ftDate, ftDateTime:
          CondicaoSQL := ' WHERE ' + NomeCampo + ' = :VALOR';
      end;
    end;
  end;

  if TemInicio and TemFim then
    CondicaoData := 'logSistema.dataHora BETWEEN :dataInicio AND :dataFim'
  else if TemInicio then
    CondicaoData := 'logSistema.dataHora >= :dataInicio'
  else if TemFim then
    CondicaoData := 'logSistema.dataHora <= :dataFim';

  if CondicaoData <> '' then
  begin
    if CondicaoSQL <> '' then
      CondicaoData := ' AND ' + CondicaoData
    else
      CondicaoData := ' WHERE ' + CondicaoData;
  end;

  QryListagem.Close;
  QryListagem.SQL.Text := SelectOriginal + ' ' + CondicaoSQL + ' ' + CondicaoData;

  if (Valor <> '') and (QryListagem.Params.FindParam('VALOR') <> nil) then
  begin
    case TipoCampo of
      ftString, ftWideString:
        QryListagem.ParamByName('VALOR').AsString := '%' + Valor + '%';

      ftInteger, ftSmallint, ftAutoInc:
        QryListagem.ParamByName('VALOR').AsInteger := I;

      ftFloat, ftCurrency, ftFMTBcd, ftBCD:
      begin
        FS := TFormatSettings.Create;
        FS.DecimalSeparator := ',';
        QryListagem.ParamByName('VALOR').AsFloat := StrToFloat(Valor, FS);
      end;

      ftDate, ftDateTime:
        QryListagem.ParamByName('VALOR').AsDateTime := StrToDate(Valor);
    end;
  end;

  if TemInicio then
    QryListagem.ParamByName('dataInicio').AsDate := edtDataInicio.Date;

  if TemFim then
    QryListagem.ParamByName('dataFim').AsDateTime := edtDataFinal.Date + 0.99999;

  try
    QryListagem.Open;
  except
    on E: Exception do
    begin
      QryListagem.Close;
      QryListagem.SQL.Text := SelectOriginal;
      QryListagem.Open;
      MessageDlg('Erro na pesquisa: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;

  mskPesquisar.Clear;
  edtDataInicio.Clear;
  edtDataFinal.Clear;
end;

procedure TfrmLogSistema.FormCreate(Sender: TObject);
begin
  inherited;
  SelectOriginal := QryListagem.SQL.Text;
end;

procedure TfrmLogSistema.FormShow(Sender: TObject);
var i : Integer;
begin
  inherited;
  for i := 0 to grdListagem.Columns.Count - 1 do
    grdListagem.Columns[i].Title.Alignment := taCenter;

  IndiceAtual := 'logId';

  ExibirIndiceLabel(IndiceAtual, lblIndice);
end;

end.
