unit uTelaHerancaPesquisa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TfrmTelaHerancaPesquisa = class(TfrmTelaHeranca)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTelaHerancaPesquisa: TfrmTelaHerancaPesquisa;

implementation

{$R *.dfm}

procedure TfrmTelaHerancaPesquisa.FormCreate(Sender: TObject);
begin
  inherited;
  btnNovo.Visible := False;
  btnAlterar.Visible := False;
  btnApagar.Visible := False;
  btnGravar.Visible := False;
  btnCancelar.Visible := False;
  btnNavigator.Visible := False;

  tabManutencao.TabVisible := False;
end;

end.
