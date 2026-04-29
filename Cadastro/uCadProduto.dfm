inherited frmCadProduto: TfrmCadProduto
  Caption = 'Cadastro de Produtos'
  ClientHeight = 429
  ClientWidth = 752
  ExplicitWidth = 758
  ExplicitHeight = 458
  PixelsPerInch = 96
  TextHeight = 13
  inherited pgcPrincipal: TPageControl
    Width = 752
    Height = 388
    ExplicitWidth = 752
    ExplicitHeight = 388
    inherited TabListagem: TTabSheet
      ExplicitWidth = 744
      ExplicitHeight = 360
      object ImagemProduto: TImage [0]
        Left = 584
        Top = 49
        Width = 160
        Height = 311
        Align = alRight
        Center = True
        Proportional = True
        Stretch = True
        Visible = False
      end
      inherited Panel1: TPanel
        Width = 744
        ExplicitWidth = 744
        object btnLegendas: TBitBtn
          Left = 416
          Top = 18
          Width = 75
          Height = 25
          Caption = 'Legendas'
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FF2877E1176FBDFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FF2374E12374E1FF00FFFF00FFFF00FFFF00FF
            2B7CED3C9AFF3887DF1A74B8FF00FFFF00FFFF00FFFF00FF1870B8347FDF3895
            FF136DD9FF00FFFF00FFFF00FFFF00FF1A78CC38ACFF3CB9FF4AB0F91A74B8FF
            00FFFF00FF3082D34294F932A1FF2E94FF136DD9FF00FFFF00FFFF00FFFF00FF
            FF00FF2786BA42CBFF44CCFF49CAFF3082D33082D33FB6FF34AFFF2FA6FF136D
            D9FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF2786BA58D3FF58D3FF56D3FF50
            D1FF48CEFF40CAFF39BEFF31A7FF136DD9FF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FF1C7DB384E1FF6FDBFF6EDBFF66D8FF5BD5FF4CD0FF40CAFF249FFF136D
            D9FF00FFFF00FFFF00FFFF00FFFF00FF0464A093C7DFA8EBFF83E3FF82E2FF7A
            DFFF6DDAFF5BD4FF49CEFF2BB3FF0D7ADF0464A0FF00FFFF00FFFF00FF2A7DB0
            A9D4E7C2F4FFB5F3FFB0F2FF97ECFF87E5FF7BDFFF68D8FF52D1FF42CBFF2AA7
            FF0E71E70664B0FF00FF3F90BDB5DCEDB7F0FFB8F2FFC2F5FFC5F9FFBFF8FFB2
            F3FF9BEAFF7DDEFF59D3FF46CCFF3BBFFF2CA1FF0E69ED0764BD5AA0C769A9CC
            73AFD080B7D580B7D5C8E9F3CBF8FFB4F4FF9FF0FF94E9FF70CFF339B3E728A8
            E71C8CE7187FE7187FE7FF00FFFF00FFFF00FFFF00FFFF00FF50A4D0DEF9FFB5
            F2FF9BEFFF8DE8FF4EA5D0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FF50A4D0B0D4E7B2F0FF94EDFF71C7E74EA5D0FF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF50A4D0B3
            EFFF90EAFF4EA5D0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FF50A4D09ADCF385D9F650A4D0FF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF50
            A4D0429DCCFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
          TabOrder = 2
          OnMouseEnter = btnLegendasMouseEnter
          OnMouseLeave = btnLegendasMouseLeave
        end
      end
      inherited grdListagem: TDBGrid
        Width = 584
        Height = 311
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
          end
          item
            Expanded = False
            FieldName = 'descricao'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'valor'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'quantidade'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'categoriaId'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'descricaocategoria'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'tipoEstoqueProdutoId'
            Visible = True
          end>
      end
    end
    inherited tabManutencao: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 24
      ExplicitWidth = 744
      ExplicitHeight = 360
      object lblDescricao: TLabel
        Left = 16
        Top = 179
        Width = 46
        Height = 13
        Caption = 'Descri'#231#227'o'
      end
      object lblValor: TLabel
        Left = 16
        Top = 293
        Width = 24
        Height = 13
        Caption = 'Valor'
      end
      object lblQuantidade: TLabel
        Left = 178
        Top = 293
        Width = 56
        Height = 13
        Caption = 'Quantidade'
      end
      object lblCategoria: TLabel
        Left = 369
        Top = 133
        Width = 47
        Height = 13
        Caption = 'Categoria'
      end
      object btnCategorias: TSpeedButton
        Left = 520
        Top = 152
        Width = 23
        Height = 21
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
          FF00FF0A6B0A0A6B0A0A6B0A0A6B0AFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFB25D130A6B0A42D37331B85A0A6B0AA8
          4E0FA54A0EA4480DA1440DA0420C9F3F0C9D3E0BFF00FFFF00FFFF00FFFF00FF
          B561140A6B0A78F3A440D1710A6B0AFBF0DEFBEFDAFBEDD5FBEBD1FBE9CDFBE7
          C89E400BFF00FFFF00FF0A6B0A0A6B0A0A6B0A0A6B0A78F3A444D5740A6B0A0A
          6B0A0A6B0A0A6B0AFCEDD6FBEBD1FBEACEA1430CFF00FFFF00FF0A6B0A78F3A4
          53E4844FE1804CDD7C48D97845D67541D27231B85A0A6B0AFBEFDBFCEDD6FBEB
          D1A3470DFF00FFFF00FF0A6B0A78F3A478F3A478F3A478F3A44DDE7D78F3A478
          F3A442D3730A6B0AFCF1E0FBEFDBFBEDD7A64B0EFF00FFFF00FF0A6B0A0A6B0A
          0A6B0A0A6B0A78F3A450E2810A6B0A0A6B0A0A6B0A0A6B0AFCF4E4FBF1E1FCEF
          DCA94F0FFF00FFFF00FFFF00FFFF00FFC375190A6B0A78F3A454E5850A6B0AFC
          F9F5FCF7F1FCF7EEFCF5E9FBF3E4FCF2E2AC5110FF00FFFF00FFFF00FFFF00FF
          C579190A6B0A78F3A478F3A40A6B0AFCFAF7FCF9F5FCF7F2FCF7EEFBF6E9FBF3
          E5AD5611FF00FFFF00FFFF00FFFF00FFC77C1A0A6B0A0A6B0A0A6B0A0A6B0AFC
          FBFBFCFAF8FCF9F5FBF8F2FCF7EEFBF6EAB05A12FF00FFFF00FFFF00FFFF00FF
          C97F1CFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFAFCFBF8FCF9F6FCF8F2FCF7
          EFB35E13FF00FFFF00FFFF00FFFF00FFCC821CFCFCFCFCFCFCFCFCFCFCFCFCFC
          FCFCFCFCFCFCFCFAFCFBF9FCFAF6FCF8F3B66214FF00FFFF00FFFF00FFFF00FF
          CE851DFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFBFBFCFBF9FCFA
          F7B96615FF00FFFF00FFFF00FFFF00FFCF861DFCFCFCFCFCFCFCFCFCFCFCFCFC
          FCFCFCFCFCFCFCFCFCFCFCFCFCFBFCFBF8BC6A16FF00FFFF00FFFF00FFFF00FF
          CF871DCF871DCE861DCC831CCC821CCA801BC87D1BC67A1AC47719C37419C172
          17BF6F17FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        OnClick = btnCategoriasClick
      end
      object btnPesquisarCategoria: TSpeedButton
        Left = 549
        Top = 152
        Width = 23
        Height = 21
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FF9B3B0A9B3B0A9B3B0A993B0DFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF9B3B0AFA
          EAC2E9B171953B11FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FF9B3B0AFAE9C0EAB474953B11FF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF9B3B0AF9
          E7BFEBB677953B11FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFC3B6B09B3B0AA54D1E9B3B0A983B0EC3B8B4FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA86441C58355FA
          DEB1F7D6A5B3724AAC6C4CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFB89787A54E20F6D4A8FBE2B7F6D19DDBAB799A461FBDA79BFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC5BEBBA0491DDDA876F9E3C2F9
          DBADF4CB96E9B97FB17047A3542CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFAE7559B86F40F6D6ACFBE9CDF7D5A4F2C68FEBB879CA905A984D28B68E
          7AFF00FFFF00FFFF00FFFF00FFFF00FFBDA79B9F4516EBBC84FAE9D1FBE8CBF6
          D09CEFC187E9B272D49758A7653C9B4419C5BEBBFF00FFFF00FFFF00FFC7C4C3
          A4532BCD8E5BF5D5AAFBF5E9FAE2BEF3CB95EDBC80E7AD6ADF9C55B8743D924D
          2BAE7254FF00FFFF00FFFF00FFB3856FAC5E30EFC187FAEEDEFCF9F5F7D6A9F1
          C58DEBB778E4A862DF994EC179399B582E93411BC0ADA4FF00FFFF00FF9D3E0F
          9B3B0A9B3B0A9B3B0A9B3B0A9B3B0A9B3B0A9B3B0A9B3B0A9B3B0A9A3B0B983B
          0E973B0FA65B36FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        OnClick = btnPesquisarCategoriaClick
      end
      object lblUnidade: TLabel
        Left = 305
        Top = 293
        Width = 39
        Height = 13
        Caption = 'Unidade'
      end
      object edtProdutoId: TLabeledEdit
        Tag = 1
        Left = 13
        Top = 112
        Width = 121
        Height = 21
        EditLabel.Width = 33
        EditLabel.Height = 13
        EditLabel.Caption = 'C'#243'digo'
        MaxLength = 10
        NumbersOnly = True
        TabOrder = 0
      end
      object edtNome: TLabeledEdit
        Tag = 2
        Left = 13
        Top = 152
        Width = 350
        Height = 21
        EditLabel.Width = 27
        EditLabel.Height = 13
        EditLabel.Caption = 'Nome'
        MaxLength = 60
        TabOrder = 1
      end
      object edtDescricao: TMemo
        Left = 13
        Top = 198
        Width = 704
        Height = 89
        TabOrder = 3
      end
      object edtValor: TCurrencyEdit
        Tag = 2
        Left = 16
        Top = 312
        Width = 121
        Height = 21
        TabOrder = 4
      end
      object edtQuantidade: TCurrencyEdit
        Tag = 2
        Left = 178
        Top = 312
        Width = 121
        Height = 21
        DisplayFormat = ',0.00;- ,0.00'
        TabOrder = 5
      end
      object lkpCategoria: TDBLookupComboBox
        Tag = 2
        Left = 369
        Top = 152
        Width = 145
        Height = 21
        KeyField = 'categoriasId'
        ListField = 'descricao'
        ListSource = dtsCategoria
        TabOrder = 2
      end
      object pnlImage: TPanel
        Left = 578
        Top = 23
        Width = 150
        Height = 150
        BorderStyle = bsSingle
        TabOrder = 7
        object imgImagem: TImage
          Left = 1
          Top = 1
          Width = 144
          Height = 144
          Align = alClient
          PopupMenu = ppmImage
          ExplicitLeft = -3
          ExplicitTop = 41
          ExplicitWidth = 148
          ExplicitHeight = 148
        end
      end
      object lcbTipoEstoque: TDBLookupComboBox
        Tag = 2
        Left = 305
        Top = 312
        Width = 145
        Height = 21
        DataField = 'tipoEstoqueProdutoId'
        DataSource = dtsListagem
        KeyField = 'tipoEstoqueProdutoId'
        ListField = 'descricao'
        ListSource = dtsTipoEstoque
        TabOrder = 6
        OnClick = lcbTipoEstoqueClick
      end
    end
  end
  inherited pnlRodaPe: TPanel
    Top = 388
    Width = 752
    ExplicitTop = 388
    ExplicitWidth = 752
    inherited btnFechar: TBitBtn
      Left = 655
      ExplicitLeft = 655
    end
    inherited btnNavigator: TDBNavigator
      Hints.Strings = ()
    end
  end
  inherited dtsListagem: TDataSource
    Left = 244
  end
  inherited QryListagem: TFDQuery
    AfterScroll = QryListagemAfterScroll
    SQL.Strings = (
      'SELECT p.produtoId,'#10'       '
      'p.nome,'#10'       '
      'p.descricao,'#10'      '
      ' p.valor,'#10'       '
      'p.quantidade,'#10'       '
      'p.categoriaId,'#10'       '
      'p.foto,'#10'       '
      'p.tipoEstoqueProdutoId,'#10'       '
      'c.descricao AS descricaocategoria,'#10'       '
      't.sigla     AS sigla    '
      'FROM produtos AS p'
      #10'LEFT JOIN categorias AS c ON c.categoriasId = p.categoriaId'
      
        #10'LEFT JOIN tipoEstoqueProduto t ON t.tipoEstoqueProdutoId = p.ti' +
        'poEstoqueProdutoId')
    Left = 284
    object QryListagemprodutoId: TFDAutoIncField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'produtoId'
      Origin = 'produtoId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object QryListagemnome: TStringField
      DisplayLabel = 'Nome'
      FieldName = 'nome'
      Origin = 'nome'
      Size = 60
    end
    object QryListagemdescricao: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'descricao'
      Origin = 'descricao'
      Size = 255
    end
    object QryListagemvalor: TFMTBCDField
      DisplayLabel = 'Valor'
      FieldName = 'valor'
      Origin = 'valor'
      currency = True
      Precision = 18
      Size = 5
    end
    object QryListagemquantidade: TFMTBCDField
      DisplayLabel = 'Quantidade'
      FieldName = 'quantidade'
      Origin = 'quantidade'
      Precision = 18
      Size = 5
    end
    object QryListagemcategoriaId: TIntegerField
      DisplayLabel = 'C'#243'd. Categoria'
      FieldName = 'categoriaId'
      Origin = 'categoriaId'
    end
    object QryListagemfoto: TBlobField
      DisplayLabel = 'Foto'
      FieldName = 'foto'
      Origin = 'foto'
      Size = 2147483647
    end
    object QryListagemtipoEstoqueProdutoId: TIntegerField
      DisplayLabel = 'Tipo de EStoque'
      FieldName = 'tipoEstoqueProdutoId'
      Origin = 'tipoEstoqueProdutoId'
      Required = True
    end
    object QryListagemdescricaocategoria: TStringField
      DisplayLabel = 'Descri'#231#227'o Categoria'
      FieldName = 'descricaocategoria'
      Origin = 'descricaocategoria'
      Size = 30
    end
    object QryListagemsigla: TStringField
      DisplayLabel = 'Sigla'
      FieldName = 'sigla'
      Origin = 'sigla'
      Size = 10
    end
  end
  object QryCategoria: TFDQuery
    Connection = dtmPrincipal.ConexaoDB
    SQL.Strings = (
      'select categoriasId, descricao from categorias')
    Left = 156
    Top = 32
    object F1QryCategoriacategoriasId: TFDAutoIncField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'categoriasId'
      Origin = 'categoriasId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object F2QryCategoriadescricao: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'descricao'
      Origin = 'descricao'
      Size = 30
    end
  end
  object dtsCategoria: TDataSource
    DataSet = QryCategoria
    Left = 204
    Top = 32
  end
  object ppmImage: TPopupMenu
    Left = 630
    Top = 111
    object CarregarImagem1: TMenuItem
      Caption = 'Carregar Imagem'
      OnClick = CarregarImagem1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object LimparImagem1: TMenuItem
      Caption = 'Limpar Imagem'
      OnClick = LimparImagem1Click
    end
  end
  object QryTipoEstoque: TFDQuery
    Connection = dtmPrincipal.ConexaoDB
    SQL.Strings = (
      
        'select tipoEstoqueProdutoId, descricao, sigla, permiteDecimal, c' +
        'asasDecimais from tipoEstoqueProduto')
    Left = 620
    Top = 336
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
    Left = 684
    Top = 336
  end
  object BalloonHint1: TBalloonHint
    Left = 540
    Top = 32
  end
end
