object FormEdit: TFormEdit
  Left = 371
  Top = 169
  BorderStyle = bsToolWindow
  Caption = 'Enter a name'
  ClientHeight = 61
  ClientWidth = 252
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 39
    Top = 39
    Width = 61
    Height = 20
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 150
    Top = 39
    Width = 60
    Height = 20
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object Edit1: TEdit
    Left = 7
    Top = 7
    Width = 241
    Height = 24
    TabOrder = 0
  end
end
