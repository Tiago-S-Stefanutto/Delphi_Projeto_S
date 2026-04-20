object frmObservacaoCliente: TfrmObservacaoCliente
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmObservacaoCliente'
  ClientHeight = 240
  ClientWidth = 463
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblTitulo: TLabel
    Left = 8
    Top = 13
    Width = 234
    Height = 14
    Caption = 'Escreva o Motivo do Status escolhido:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object mmObservacao: TMemo
    Left = 8
    Top = 32
    Width = 447
    Height = 169
    TabOrder = 0
  end
  object btnSalvar: TBitBtn
    Left = 8
    Top = 207
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 1
    OnClick = btnSalvarClick
  end
  object btnFechar: TBitBtn
    Left = 380
    Top = 207
    Width = 75
    Height = 25
    Caption = 'Fechar'
    TabOrder = 2
    OnClick = btnFecharClick
  end
end
