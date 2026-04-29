inherited frmConsultaProdutos: TfrmConsultaProdutos
  Caption = 'Consulta Produtos'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSuperior: TPanel
    inherited mskPesquisa: TMaskEdit
      ExplicitWidth = 432
    end
  end
  inherited pnlGrid: TPanel
    ExplicitLeft = 0
    ExplicitTop = 41
    ExplicitWidth = 454
    ExplicitHeight = 147
    inherited grdPesquisa: TDBGrid
      Columns = <
        item
          Expanded = False
          FieldName = 'produtoId'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'nome'
          Visible = True
        end>
    end
  end
  inherited pnlInferior: TPanel
    inherited btnFechar: TBitBtn
      ExplicitLeft = 369
    end
  end
  inherited QryPesquisa: TFDQuery
    SQL.Strings = (
      'select produtoId,'
      'nome'
      'from produtos')
    object QryPesquisaprodutoId: TFDAutoIncField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'produtoId'
      Origin = 'produtoId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object QryPesquisanome: TStringField
      DisplayLabel = 'Nome'
      FieldName = 'nome'
      Origin = 'nome'
      Size = 60
    end
  end
end
