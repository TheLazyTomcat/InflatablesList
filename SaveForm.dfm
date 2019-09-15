object fSaveForm: TfSaveForm
  Left = 998
  Top = 122
  BorderStyle = bsNone
  Caption = 'fSaveForm'
  ClientHeight = 57
  ClientWidth = 257
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object bvlOuterFrame: TBevel
    Left = 0
    Top = 0
    Width = 257
    Height = 57
    Style = bsRaised
  end
  object bvlInnerFrame: TBevel
    Left = 8
    Top = 8
    Width = 241
    Height = 41
  end
  object lblText: TLabel
    Left = 16
    Top = 16
    Width = 225
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = 'Saving the list, please wait...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
    Layout = tlCenter
  end
end
