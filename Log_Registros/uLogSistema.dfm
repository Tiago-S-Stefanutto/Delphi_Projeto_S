inherited frmLogSistema: TfrmLogSistema
  Caption = 'Log do Sistema'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pgcPrincipal: TPageControl
    inherited TabListagem: TTabSheet
      inherited Panel1: TPanel
        object Label3: TLabel [1]
          Left = 543
          Top = 8
          Width = 48
          Height = 13
          Caption = 'Data Final'
          Color = clNone
          ParentColor = False
        end
        object Label2: TLabel [2]
          Left = 416
          Top = 8
          Width = 49
          Height = 13
          Caption = 'Data '#237'nicio'
        end
        object edtDataFinal: TDateEdit
          Left = 543
          Top = 22
          Width = 121
          Height = 21
          NumGlyphs = 2
          TabOrder = 2
        end
        object edtDataInicio: TDateEdit
          Left = 416
          Top = 22
          Width = 121
          Height = 21
          NumGlyphs = 2
          TabOrder = 3
        end
      end
    end
  end
  inherited pnlRodaPe: TPanel
    inherited btnNavigator: TDBNavigator
      Hints.Strings = ()
    end
  end
  inherited dtsListagem: TDataSource
    Left = 564
    Top = 184
  end
  inherited QryListagem: TFDQuery
    SQL.Strings = (
      
        'select logId, dataHora, usuarioId, usuarioNome, tela, acao, desc' +
        'ricao from logSistema')
    Left = 628
    Top = 184
    object QryListagemlogId: TFDAutoIncField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'logId'
      Origin = 'logId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object QryListagemdataHora: TSQLTimeStampField
      DisplayLabel = 'Hora e Data'
      FieldName = 'dataHora'
      Origin = 'dataHora'
      Required = True
    end
    object QryListagemusuarioId: TIntegerField
      DisplayLabel = 'C'#243'd. Usu'#225'rio'
      FieldName = 'usuarioId'
      Origin = 'usuarioId'
    end
    object QryListagemusuarioNome: TStringField
      DisplayLabel = 'Nome do Usu'#225'rio'
      FieldName = 'usuarioNome'
      Origin = 'usuarioNome'
      Size = 100
    end
    object QryListagemtela: TStringField
      DisplayLabel = 'Tela'
      FieldName = 'tela'
      Origin = 'tela'
      Size = 100
    end
    object QryListagemacao: TStringField
      DisplayLabel = 'A'#231#227'o'
      FieldName = 'acao'
      Origin = 'acao'
      Size = 50
    end
    object QryListagemdescricao: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'descricao'
      Origin = 'descricao'
      Size = 255
    end
  end
end
