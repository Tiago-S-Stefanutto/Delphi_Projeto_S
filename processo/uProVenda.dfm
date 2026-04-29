inherited frmProVenda: TfrmProVenda
  Caption = 'Pedido de Vendas'
  ClientHeight = 492
  ClientWidth = 915
  ExplicitLeft = -130
  ExplicitWidth = 921
  ExplicitHeight = 521
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 20
    Top = 72
    Width = 33
    Height = 13
    Caption = 'Cliente'
  end
  inherited pgcPrincipal: TPageControl
    Width = 915
    Height = 451
    ExplicitWidth = 915
    ExplicitHeight = 451
    inherited TabListagem: TTabSheet
      ExplicitWidth = 907
      ExplicitHeight = 423
      inherited Panel1: TPanel
        Width = 907
        ExplicitTop = -6
        ExplicitWidth = 907
        object Label2: TLabel [1]
          Left = 416
          Top = 8
          Width = 49
          Height = 13
          Caption = 'Data '#237'nicio'
        end
        object Label3: TLabel [2]
          Left = 543
          Top = 8
          Width = 48
          Height = 13
          Caption = 'Data Final'
          Color = clNone
          ParentColor = False
        end
        object btnXlsx: TPngSpeedButton [3]
          Left = 670
          Top = 11
          Width = 32
          Height = 32
          Flat = True
          OnClick = btnXlsxClick
          PngImage.Data = {
            89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
            F4000000097048597300000B1300000B1301009A9C180000036F4944415478DA
            C5976D48535118C7FF77BB6ECB392BB7E95A98A9235FC830D4C298A4915A6858
            D42A83A2770AA2A2FA529A82F6328220522288D40A0A2B51AC88244833EA4B81
            7E53A3082BB3C46873236FAEDD9EDD487CB973774EF3BF0FE7E53ECF39BFF3DC
            E79EB3C36086C54CF490E77995CBE1A8E4010B19864E6602E74FDC98AD0FD9CD
            308CDB6F805F767B31399607B2C21F03BC9D8A3ADD3CCD5E31085F004FC82927
            10009B831F028F208A62B518842F8067E490190880DDC1D3ABFC5B1783900CE0
            74BA30303034CE46A309825ACD4A021083987680416E0400CFFFA67AAF8C95DD
            D46835A7FC02A02F022E170F29625906E4E7F5398DD5AC080DCDF20BA0AF6F10
            FDFD9C2400AD5609BD5E35B500331E016F3920265F79210AB0DA9A94C4F04C2D
            F524FCEB2B5F77A93F65419AF6BF00645B93EE5373E34843EBFA4A2C99BF54D2
            A4FE481420FF4A6237676723670C606BBDA9D5F94D61760FC93CDF2D471BE897
            FD998754D13A932190C9147215A2D4714239214061A389120E9953BE5C925635
            0F45C955541A6606C0A3BCC89DD81C7BC437C01C850E9698C3A8E93A03953C18
            85A613A8EE2C47AA7E9560F7EAEB63A19CABD463D7A2D360650AA1FDB0BB0A3D
            CEF7A2BE436E0E66C33AEC8B2FF30D304BAE867579039A7BEAA0A3D0456B1251
            FC7A2BF6C4950A76D73A4A84327E4E2A4E265FC3A38F3534A01B2D5F1A30F0EB
            BBA8AF9BFF2D1DC0534F8F582B18CBE877B66D0FDEDADA869DC7025C683FE039
            E1F0CED60ECE3D28EAEB915F004114D64A7333065D4E1C7D994313F0E3008CEA
            1894A5DC116C3DBAF7FE32BD866A515FBF01362C3C8855460B94EC2CDCEA3A8F
            D6DEC6710023E58944C78F37A8FF7055D4D72F803065042E2C6FC4F5CE526895
            46AC8DDC81A3AF72B17351111687A5E3B3F3DD70C2ED8E2B119270A126014D9F
            6EE339E58198AFB4247C606AA0468152A6425A780E5E10B99C61B122220F2FBE
            3E4054483C9685670F279C8DEBC39AC8EDB4D2E0517D237D330C0568E9AD179E
            4B8840EC313AF92E4ED73E9065DC2444D12B80E56EA28255714F0922633A008E
            27556089D6EC1DC0A395CF56B246C7A76D742CA7525399169E9DAF66438D814C
            2C97B1480E330F4F3E21C0584DC5DF7231F90310F0C5C40B401301E44A0108F8
            6AE605A08800CEF9042043255D4E2B682FDB32D9CBE9A8F1E8A646E3D4B22121
            8769619C4F80FFA13FD1C0063F7B0E22C60000000049454E44AE426082}
        end
        object edtDataInicio: TDateEdit
          Left = 416
          Top = 22
          Width = 121
          Height = 21
          NumGlyphs = 2
          TabOrder = 2
        end
        object edtDataFinal: TDateEdit
          Left = 543
          Top = 22
          Width = 121
          Height = 21
          NumGlyphs = 2
          TabOrder = 3
        end
      end
      inherited grdListagem: TDBGrid
        Width = 907
        Height = 374
        Columns = <
          item
            Expanded = False
            FieldName = 'vendaId'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'clienteId'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'nome'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'dataVenda'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'totalVenda'
            Visible = True
          end>
      end
    end
    inherited tabManutencao: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 24
      ExplicitWidth = 907
      ExplicitHeight = 423
      object lblCliente: TLabel
        Left = 130
        Top = 5
        Width = 33
        Height = 13
        Caption = 'Cliente'
      end
      object lblDataVenda: TLabel
        Left = 537
        Top = 5
        Width = 56
        Height = 13
        Caption = 'Data Venda'
      end
      object btnClientes: TSpeedButton
        Left = 471
        Top = 24
        Width = 23
        Height = 22
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
        OnClick = btnClientesClick
      end
      object btnPesquisarClientes: TSpeedButton
        Left = 500
        Top = 24
        Width = 23
        Height = 22
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
        OnClick = btnPesquisarClientesClick
      end
      object edtVendaId: TLabeledEdit
        Tag = 1
        Left = 3
        Top = 24
        Width = 121
        Height = 21
        EditLabel.Width = 70
        EditLabel.Height = 13
        EditLabel.Caption = 'N'#250'mero Venda'
        MaxLength = 10
        NumbersOnly = True
        TabOrder = 0
      end
      object lkpCliente: TDBLookupComboBox
        Left = 130
        Top = 24
        Width = 335
        Height = 21
        KeyField = 'clienteId'
        ListField = 'nome'
        ListSource = dtmVenda.dtsCliente
        TabOrder = 1
        OnCloseUp = lkpClienteCloseUp
      end
      object edtDataVenda: TDateEdit
        Left = 537
        Top = 24
        Width = 121
        Height = 21
        ClickKey = 114
        DialogTitle = 'Selecione a Data'
        NumGlyphs = 2
        CalendarStyle = csDialog
        TabOrder = 2
      end
      object pnl1: TPanel
        Left = 0
        Top = 52
        Width = 907
        Height = 371
        Align = alBottom
        TabOrder = 3
        object pnl2: TPanel
          Left = 1
          Top = 1
          Width = 905
          Height = 100
          Align = alTop
          TabOrder = 0
          object lblProduto: TLabel
            Left = 111
            Top = 2
            Width = 38
            Height = 13
            Caption = 'Produto'
          end
          object lblValorUnitario: TLabel
            Left = 363
            Top = 5
            Width = 64
            Height = 13
            Caption = 'Valor Unit'#225'rio'
          end
          object lblQuantidade: TLabel
            Left = 490
            Top = 5
            Width = 56
            Height = 13
            Caption = 'Quantidade'
          end
          object lblTotaldoProduto: TLabel
            Left = 617
            Top = 5
            Width = 80
            Height = 13
            Caption = 'Total do Produto'
          end
          object btnPesquisarProduto: TSpeedButton
            Left = 317
            Top = 21
            Width = 23
            Height = 22
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
            OnClick = btnPesquisarProdutoClick
          end
          object lkpProduto: TDBLookupComboBox
            Left = 111
            Top = 21
            Width = 200
            Height = 21
            KeyField = 'produtoId'
            ListField = 'nome'
            ListSource = dtmVenda.dtsProdutos
            TabOrder = 0
            OnClick = lkpProdutoClick
            OnExit = lkpProdutoExit
          end
          object edtValorUnitario: TCurrencyEdit
            Tag = 2
            Left = 363
            Top = 24
            Width = 121
            Height = 21
            DisplayFormat = ',0.00;- ,0.00'
            ReadOnly = True
            TabOrder = 1
          end
          object edtQuantidade: TCurrencyEdit
            Left = 490
            Top = 24
            Width = 121
            Height = 21
            DisplayFormat = ',0.00;- ,0.00'
            TabOrder = 2
            OnExit = edtQuantidadeExit
          end
          object btnAdicionarItem: TBitBtn
            Left = 744
            Top = 24
            Width = 79
            Height = 19
            Caption = 'A&dicionar'
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              18000000000000030000120B0000120B00000000000000000000FF00FF686868
              6868686868686767676767676767676767676767676666666666666666666666
              66666666FF00FFFF00FFFF00FF767676FCFCFC98A9CBF7F7F7F7F7F7F7F7F7F7
              F7F7F7F7F7F6F6F6F6F6F6F6F6F6FCFCFC747474FF00FFFF00FFFF00FF818181
              7D7D7E98A9CBD9B08CD9B08CD9B08CD9B08CD9B08CD9B08CD9B08CD9B08CD9B0
              8C7F7F7FFF00FFFF00FFFF00FF8B8B8BF8F8F898A9CBE5E5E5E5E5E5E5E5E5E5
              E5E5E3E3E3E2E2E2E1E1E1E0E0E0F7F7F78A8A8AFF00FFFF00FFFF00FF959595
              D9B08C98A9CBD9B08CD9B08CD9B08CD9B08CD9B08CD9B08CD9B08CD9B08CD9B0
              8C929292FF00FFFF00FFFF00FF9A9A9AFAFAFA98A9CBEBEBEBEBEBEBEBEBEBEB
              EBEBEAEAEAEAEAEAE9E9E9E6E6E6F8F8F8999999FF00FFFF00FFFF00FFA1A1A1
              D9B08C98A9CBD9B08CD9B08CD9B08CD9B08CD9B08CD9B08CD9B08CD9B08CD9B0
              8CA0A0A0FF00FFFF00FFFF00FFA5A5A57D7D7E98A9CBF0F0F0F2F2F2F2F2F2F0
              F0F0F0F0F0EFEFEFEEEEEEEDEDEDFAFAFAA5A5A5FF00FFFF00FFFF00FFA9A9A9
              D9B08C98A9CBD9B08CD9B08CD9B08CD9B08CD9B08CD9B08CD9B08CD9B08CD9B0
              8CA7A7A7FF00FFFF00FFFF00FFABABABFCFCFC98A9CBF6F6F6F6F6F6F6F6F6F6
              F6F6F4F4F4F3F3F3F2F2F2F0F0F0FBFBFBABABABFF00FFFF00FFFF00FFACACAC
              D9B08C98A9CBD9B08CD9B08CD9B08CD9B08CD9B08CD9B08CD9B08CD9B08CD9B0
              8CACACACFF00FFFF00FFFF00FFADADADFCFCFC98A9CBF8F8F8F8F8F8FAFAFAF8
              F8F8F8F8F8F7F7F7F6F6F6F3F3F3FCFCFCADADADFF00FFFF00FFFF00FFAFAFAF
              D9B08C98A9CBD9B08CD9B08CD9B08CD9B08CD9B08CD9B08CAFAFAFBCBCBCD0D0
              D0ADADADFF00FFFF00FFFF00FFAFAFAF7D7D7E98A9CBFAFAFAFBFBFBFBFBFBFB
              FBFBFAFAFAF8F8F8BCBCBCD9D9D9ADADADFF00FFFF00FFFF00FFFF00FFAFAFAF
              FFFFFF98A9CBFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEF8F8F8D0D0D0ADADADFF00
              FFFF00FFFF00FFFF00FFFF00FFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF
              AFAFAFAFAFAFAFAFADADADFF00FFFF00FFFF00FFFF00FFFF00FF}
            TabOrder = 3
            OnClick = btnAdicionarItemClick
          end
          object btnApagarItem: TBitBtn
            Left = 829
            Top = 24
            Width = 75
            Height = 19
            Caption = 'Re&mover'
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
              2D2BAA252595FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0101
              60000073FF00FFFF00FFFF00FF3836B61111B81C1CB82F2FA4FF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FF06066D01018A00008B020074FF00FF3F3FBB1616C5
              0A0AC20A0AC02222C43737ADFF00FFFF00FFFF00FFFF00FF11117B0505910000
              9000009000008B0200743B3BB22C2CD30D0DD00D0DCE0C0CC92828CC3D3DB4FF
              00FFFF00FF1F1F8E0C0C9F00009200009000009000008800005DFF00FF4747C1
              3333DE1111DA0F0FD50D0DCF2A2AD13C3CB42F2FA41717B40303A30101990000
              91010189010160FF00FFFF00FFFF00FF5454CC3C3CE71313E11111DA0E0ED328
              28CF2222C60707B50505AA0303A0060693050566FF00FFFF00FFFF00FFFF00FF
              FF00FF5C5CD33F3FEA1414E31111DC0E0ED10C0CC70909BC0606B10D0DA40E0E
              77FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF5B5BD03D3DE61414E311
              11DA0D0DCF0A0AC21616B5181886FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FF6E6ECE5B5BE92020E71313E10F0FD40C0CC91616B7181887FF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF7878CE7474E75353EE4848ED35
              35E92020DD1111CE0A0ABF0F0FAB0E0E79FF00FFFF00FFFF00FFFF00FFFF00FF
              7F7FCB8787E56D6DF26363F05757EF5C5CDE5252D83B3BDA2D2DCE1F1FC01818
              A5111176FF00FFFF00FFFF00FF8484C79797E38484F47B7BF37070F27272E05B
              5BBB4D4DB15151CF4141D43838C92F2FBD2929A51B1B78FF00FF8686C2A0A0E0
              9999F69191F68888F48383DE6767BCFF00FFFF00FF4747A55050C54242CB3737
              C02E2EB52929A01D1D7A9393B7A5A5EAA1A1F79A9AF69292DD6E6EBDFF00FFFF
              00FFFF00FFFF00FF3F3F9C4A4ABC3B3BC03232B52D2DA92B2B8EFF00FF9594B6
              A7A7E99D9DDC7676BBFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF3C3C984141
              B53535B0343495FF00FFFF00FFFF00FF9796B68080C0FF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FF3636933E3E9AFF00FFFF00FF}
            TabOrder = 4
            OnClick = btnApagarItemClick
          end
          object edtTotalProduto: TCurrencyEdit
            Left = 617
            Top = 24
            Width = 121
            Height = 21
            TabStop = False
            DisplayFormat = ',0.00;- ,0.00'
            ParentColor = True
            ReadOnly = True
            TabOrder = 5
          end
          object pnlImagem: TPanel
            Left = 15
            Top = 5
            Width = 90
            Height = 90
            TabOrder = 6
            object ImagemProduto: TImage
              Left = 1
              Top = 1
              Width = 88
              Height = 88
              Align = alClient
              Center = True
              Visible = False
              ExplicitLeft = 15
              ExplicitTop = -49
              ExplicitWidth = 90
              ExplicitHeight = 90
            end
          end
        end
        object pnl3: TPanel
          Left = 1
          Top = 101
          Width = 905
          Height = 219
          Align = alClient
          TabOrder = 1
          object dbGridItensVenda: TDBGrid
            Left = 1
            Top = 1
            Width = 903
            Height = 217
            Align = alClient
            DataSource = dtmVenda.dtsItensVenda
            DefaultDrawing = False
            DrawingStyle = gdsClassic
            FixedColor = clGray
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit]
            ParentFont = False
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWhite
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnDrawColumnCell = dbGridItensVendaDrawColumnCell
            OnDblClick = dbGridItensVendaDblClick
            Columns = <
              item
                Expanded = False
                FieldName = 'produtoId'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'nomeProduto'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'quantidade'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorUnitario'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorTotalProduto'
                Visible = True
              end>
          end
        end
        object pnl4: TPanel
          Left = 1
          Top = 320
          Width = 905
          Height = 50
          Align = alBottom
          TabOrder = 2
          DesignSize = (
            905
            50)
          object lblValor: TLabel
            Left = 808
            Top = 5
            Width = 84
            Height = 13
            Anchors = [akLeft, akRight]
            Caption = 'Valor da venda'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object edtValorTotal: TCurrencyEdit
            Left = 710
            Top = 27
            Width = 182
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            Anchors = [akLeft, akRight]
            ParentColor = True
            ParentFont = False
            ReadOnly = True
            TabOrder = 0
          end
        end
      end
    end
  end
  inherited pnlRodaPe: TPanel
    Top = 451
    Width = 915
    ExplicitTop = 451
    ExplicitWidth = 915
    inherited btnFechar: TBitBtn
      Left = 820
      ExplicitLeft = 820
    end
    inherited btnNavigator: TDBNavigator
      Hints.Strings = ()
    end
  end
  inherited dtsListagem: TDataSource
    Left = 372
    Top = 0
  end
  inherited QryListagem: TFDQuery
    SQL.Strings = (
      'select '
      '  vendas.vendaId,'
      '  vendas.clienteId,'
      '  clientes.nome,'
      '  vendas.dataVenda,'
      '  CAST(vendas.totalVenda as numeric(18,2)) as totalVenda'
      'from vendas'
      'inner join clientes on clientes.clienteId = vendas.clienteId')
    Left = 292
    Top = 0
    object QryListagemvendaId: TFDAutoIncField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'vendaId'
      Origin = 'vendaId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object QryListagemclienteId: TIntegerField
      DisplayLabel = 'C'#243'd. Cliente'
      FieldName = 'clienteId'
      Origin = 'clienteId'
      Required = True
    end
    object QryListagemnome: TStringField
      DisplayLabel = 'Nome'
      FieldName = 'nome'
      Origin = 'nome'
      Size = 60
    end
    object QryListagemdataVenda: TSQLTimeStampField
      DisplayLabel = 'Data da Venda'
      FieldName = 'dataVenda'
      Origin = 'dataVenda'
    end
    object QryListagemtotalVenda: TBCDField
      FieldName = 'totalVenda'
      Origin = 'totalVenda'
      ReadOnly = True
      currency = True
      Precision = 18
      Size = 2
    end
  end
  object QryXlsx: TFDQuery
    Connection = dtmPrincipal.ConexaoDB
    SQL.Strings = (
      'SELECT '
      '  v.vendaId AS codVenda,'
      '  c.nome AS nomeCliente,'
      '  p.nome AS nomeProduto,'
      '  p.produtoId as codProduto,'
      '  iv.Quantidade,'
      '  iv.valorUnitario,'
      '  v.totalVenda'
      'FROM vendas v'
      'JOIN clientes c ON c.clienteId = v.clienteId'
      'JOIN vendasItens iv ON iv.vendaId = v.vendaId'
      'JOIN produtos p ON p.produtoId = iv.produtoId'
      'ORDER BY v.vendaId')
    Left = 732
    Top = 32
  end
end
