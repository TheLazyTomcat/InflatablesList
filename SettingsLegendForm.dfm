object fSettingsLegendForm: TfSettingsLegendForm
  Left = 1002
  Top = 120
  BorderStyle = bsDialog
  Caption = 'Settings legend'
  ClientHeight = 88
  ClientWidth = 248
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object grbStaticSettings: TGroupBox
    Left = 8
    Top = 8
    Width = 233
    Height = 33
    Caption = 'Static settings (command-line parameters)'
    TabOrder = 0
  end
  object grbDynamicSettings: TGroupBox
    Left = 8
    Top = 48
    Width = 233
    Height = 33
    Caption = 'Dynamic settings'
    TabOrder = 1
  end
end
