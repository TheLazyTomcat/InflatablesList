object fSpecialsForm: TfSpecialsForm
  Left = 651
  Top = 139
  BorderStyle = bsDialog
  Caption = 'Special functions'
  ClientHeight = 242
  ClientWidth = 616
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    616
    242)
  PixelsPerInch = 96
  TextHeight = 13
  object pnlWarning: TPanel
    Left = 8
    Top = 8
    Width = 601
    Height = 33
    Anchors = [akLeft, akTop, akRight]
    BevelInner = bvLowered
    Caption = 
      'WARNING - All functions here are affecting entire list immediate' +
      'ly, no warnings or prompts are issued!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object btnClearTextTags: TButton
    Left = 8
    Top = 48
    Width = 137
    Height = 25
    Caption = 'Clear text tags'
    TabOrder = 1
    OnClick = btnClearTextTagsClick
  end
  object btnClearParsing: TButton
    Left = 152
    Top = 48
    Width = 137
    Height = 25
    Caption = 'Clear parsing settings'
    TabOrder = 2
    OnClick = btnClearParsingClick
  end
  object btnSetAltDownMethod: TButton
    Left = 296
    Top = 48
    Width = 137
    Height = 25
    Caption = '... => AltDownMethod+'
    TabOrder = 3
    OnClick = btnSetAltDownMethodClick
  end
end
