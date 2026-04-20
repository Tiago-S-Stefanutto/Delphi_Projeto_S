object dtmVenda: TdtmVenda
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 355
  Width = 571
  object QryCliente: TFDQuery
    Connection = dtmPrincipal.ConexaoDB
    SQL.Strings = (
      'select clienteId,'
      ' nome,'
      ' clienteStatusId'
      'from clientes')
    Left = 24
    Top = 16
    object F1QryClienteclienteId: TFDAutoIncField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'clienteId'
      Origin = 'clienteId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object F2QryClientenome: TStringField
      DisplayLabel = 'Nome'
      FieldName = 'nome'
      Origin = 'nome'
      Size = 60
    end
    object QryClienteclienteStatusId: TIntegerField
      FieldName = 'clienteStatusId'
      Origin = 'clienteStatusId'
      Required = True
    end
  end
  object QryProdutos: TFDQuery
    Connection = dtmPrincipal.ConexaoDB
    SQL.Strings = (
      'select produtoId,'
      ' nome,'
      ' valor,'
      ' quantidade,'
      ' foto,'
      ' tipoEstoqueProdutoId '
      'from produtos')
    Left = 88
    Top = 16
    object QryProdutosprodutoId: TFDAutoIncField
      FieldName = 'produtoId'
      Origin = 'produtoId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object QryProdutosnome: TStringField
      FieldName = 'nome'
      Origin = 'nome'
      Size = 60
    end
    object QryProdutosvalor: TFMTBCDField
      FieldName = 'valor'
      Origin = 'valor'
      Precision = 18
      Size = 5
    end
    object QryProdutosquantidade: TFMTBCDField
      FieldName = 'quantidade'
      Origin = 'quantidade'
      Precision = 18
      Size = 5
    end
    object QryProdutosfoto: TBlobField
      FieldName = 'foto'
      Origin = 'foto'
      Size = 2147483647
    end
    object QryProdutostipoEstoqueProdutoId: TIntegerField
      FieldName = 'tipoEstoqueProdutoId'
      Origin = 'tipoEstoqueProdutoId'
      Required = True
    end
  end
  object cdsItensVenda: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterScroll = cdsItensVendaAfterScroll
    Left = 232
    Top = 16
    object cdsItensVendaprodutoId: TIntegerField
      FieldName = 'produtoId'
    end
    object cdsItensVendanomeProduto: TStringField
      FieldName = 'nomeProduto'
      Size = 100
    end
    object cdsItensVendaquantidade: TFloatField
      FieldName = 'quantidade'
    end
    object cdsItensVendavalorUnitario: TFloatField
      FieldName = 'valorUnitario'
    end
    object cdsItensVendavalorTotalProduto: TFloatField
      FieldName = 'valorTotalProduto'
    end
  end
  object dtsCliente: TDataSource
    DataSet = QryCliente
    Left = 24
    Top = 72
  end
  object dtsProdutos: TDataSource
    DataSet = QryProdutos
    Left = 88
    Top = 64
  end
  object dtsItensVenda: TDataSource
    DataSet = cdsItensVenda
    Left = 232
    Top = 72
  end
  object QryTipoEstoque: TFDQuery
    Connection = dtmPrincipal.ConexaoDB
    SQL.Strings = (
      
        'select tipoEstoqueProdutoId, descricao, sigla, permiteDecimal, c' +
        'asasDecimais from tipoEstoqueProduto')
    Left = 146
    Top = 12
    object QryTipoEstoquetipoEstoqueProdutoId: TIntegerField
      FieldName = 'tipoEstoqueProdutoId'
      Origin = 'tipoEstoqueProdutoId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QryTipoEstoquedescricao: TStringField
      FieldName = 'descricao'
      Origin = 'descricao'
      Required = True
      Size = 30
    end
    object QryTipoEstoquesigla: TStringField
      FieldName = 'sigla'
      Origin = 'sigla'
      Required = True
      Size = 10
    end
    object QryTipoEstoquepermiteDecimal: TBooleanField
      FieldName = 'permiteDecimal'
      Origin = 'permiteDecimal'
      Required = True
    end
    object QryTipoEstoquecasasDecimais: TIntegerField
      FieldName = 'casasDecimais'
      Origin = 'casasDecimais'
      Required = True
    end
  end
  object dtsTipoEstoque: TDataSource
    DataSet = QryTipoEstoque
    Left = 146
    Top = 76
  end
end
