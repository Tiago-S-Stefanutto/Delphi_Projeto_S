unit uDtmVenda;

interface

uses
  System.SysUtils, System.Classes, uDTMConexao, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Datasnap.DBClient;

type
  TdtmVenda = class(TDataModule)
    QryCliente: TFDQuery;
    F1QryClienteclienteId: TFDAutoIncField;
    F2QryClientenome: TStringField;
    QryProdutos: TFDQuery;
    cdsItensVenda: TClientDataSet;
    dtsCliente: TDataSource;
    dtsProdutos: TDataSource;
    dtsItensVenda: TDataSource;
    cdsItensVendaprodutoId: TIntegerField;
    cdsItensVendanomeProduto: TStringField;
    cdsItensVendaquantidade: TFloatField;
    cdsItensVendavalorUnitario: TFloatField;
    cdsItensVendavalorTotalProduto: TFloatField;
    QryClienteclienteStatusId: TIntegerField;
    QryProdutosprodutoId: TFDAutoIncField;
    QryProdutosnome: TStringField;
    QryProdutosvalor: TFMTBCDField;
    QryProdutosquantidade: TFMTBCDField;
    QryProdutosfoto: TBlobField;
    QryProdutostipoEstoqueProdutoId: TIntegerField;
    QryTipoEstoque: TFDQuery;
    QryTipoEstoquetipoEstoqueProdutoId: TIntegerField;
    QryTipoEstoquedescricao: TStringField;
    QryTipoEstoquesigla: TStringField;
    QryTipoEstoquepermiteDecimal: TBooleanField;
    QryTipoEstoquecasasDecimais: TIntegerField;
    dtsTipoEstoque: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure cdsItensVendaAfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
    FOnItemVendaChange: TNotifyEvent;
  public
    { Public declarations }
    property OnItemVendaChange: TNotifyEvent read FOnItemVendaChange write FOnItemVendaChange;
  end;

var
  dtmVenda: TdtmVenda;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdtmVenda.cdsItensVendaAfterScroll(DataSet: TDataSet);
begin
  // dispara evento para o form
  if Assigned(OnItemVendaChange) then
    OnItemVendaChange(DataSet);
end;

procedure TdtmVenda.DataModuleCreate(Sender: TObject);
begin
  cdsItensVenda.CreateDataSet;
  QryCliente.Open;
  QryProdutos.Open;
end;

procedure TdtmVenda.DataModuleDestroy(Sender: TObject);
begin
  cdsItensVenda.Close;
  QryCliente.Close;
  QryProdutos.Close;
end;

end.
