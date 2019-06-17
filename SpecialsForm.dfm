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
    TabOrder = 6
  end
  object btnClearTextTags: TButton
    Left = 8
    Top = 96
    Width = 145
    Height = 25
    Caption = 'Clear text tags'
    TabOrder = 2
    OnClick = btnClearTextTagsClick
  end
  object btnClearParsing: TButton
    Left = 160
    Top = 96
    Width = 145
    Height = 25
    Caption = 'Clear parsing settings'
    TabOrder = 3
    OnClick = btnClearParsingClick
  end
  object btnSetAltDownMethod: TButton
    Left = 312
    Top = 96
    Width = 145
    Height = 25
    Caption = 'I.name = P1 => AltDM+'
    TabOrder = 4
    OnClick = btnSetAltDownMethodClick
  end
  object leParam_1: TLabeledEdit
    Left = 8
    Top = 64
    Width = 297
    Height = 21
    EditLabel.Width = 63
    EditLabel.Height = 13
    EditLabel.Caption = 'Parameter 1:'
    TabOrder = 0
  end
  object btnUpdateAllAPF: TButton
    Left = 464
    Top = 96
    Width = 145
    Height = 25
    Caption = 'Upd avail + prc and flag'
    TabOrder = 5
    OnClick = btnUpdateAllAPFClick
  end
  object leParam_2: TLabeledEdit
    Left = 312
    Top = 64
    Width = 297
    Height = 21
    EditLabel.Width = 63
    EditLabel.Height = 13
    EditLabel.Caption = 'Parameter 2:'
    TabOrder = 1
  end
end
