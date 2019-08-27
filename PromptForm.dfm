object fPromptForm: TfPromptForm
  Left = 984
  Top = 116
  BorderStyle = bsDialog
  Caption = 'fPromptForm'
  ClientHeight = 88
  ClientWidth = 280
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblPrompt: TLabel
    Left = 8
    Top = 8
    Width = 44
    Height = 13
    Caption = 'lblPrompt'
  end
  object eTextValue: TEdit
    Left = 8
    Top = 24
    Width = 129
    Height = 21
    TabOrder = 0
    Text = 'eTextValue'
    OnKeyPress = ValueKeyPress
  end
  object btnOK: TButton
    Left = 56
    Top = 56
    Width = 81
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 144
    Top = 56
    Width = 81
    Height = 25
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object seIntValue: TSpinEdit
    Left = 144
    Top = 24
    Width = 129
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 0
    OnKeyPress = ValueKeyPress
  end
end
