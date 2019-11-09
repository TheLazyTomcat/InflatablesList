object fSpecialsForm: TfSpecialsForm
  Left = 537
  Top = 136
  BorderStyle = bsDialog
  Caption = 'Special functions'
  ClientHeight = 396
  ClientWidth = 728
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
  DesignSize = (
    728
    396)
  PixelsPerInch = 96
  TextHeight = 13
  object lblFunctions: TLabel
    Left = 8
    Top = 88
    Width = 129
    Height = 13
    Caption = 'Available special functions:'
  end
  object lblDescription: TLabel
    Left = 368
    Top = 88
    Width = 155
    Height = 13
    Caption = 'Description of selected function:'
  end
  object pnlWarning: TPanel
    Left = 8
    Top = 8
    Width = 713
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
    TabOrder = 7
  end
  object leParam_1: TLabeledEdit
    Left = 8
    Top = 64
    Width = 233
    Height = 21
    EditLabel.Width = 63
    EditLabel.Height = 13
    EditLabel.Caption = 'Parameter 1:'
    TabOrder = 0
  end
  object leParam_2: TLabeledEdit
    Left = 248
    Top = 64
    Width = 233
    Height = 21
    EditLabel.Width = 63
    EditLabel.Height = 13
    EditLabel.Caption = 'Parameter 2:'
    TabOrder = 1
  end
  object cbCloseWhenDone: TCheckBox
    Left = 368
    Top = 364
    Width = 105
    Height = 17
    Caption = 'Close when done'
    Checked = True
    ParentShowHint = False
    ShowHint = False
    State = cbChecked
    TabOrder = 5
  end
  object leParam_3: TLabeledEdit
    Left = 488
    Top = 64
    Width = 233
    Height = 21
    EditLabel.Width = 63
    EditLabel.Height = 13
    EditLabel.Caption = 'Parameter 3:'
    TabOrder = 2
  end
  object lbFunctions: TListBox
    Left = 8
    Top = 104
    Width = 353
    Height = 284
    Style = lbOwnerDrawFixed
    IntegralHeight = True
    ItemHeight = 35
    TabOrder = 3
    OnClick = lbFunctionsClick
    OnDrawItem = lbFunctionsDrawItem
  end
  object btnRunSelected: TButton
    Left = 592
    Top = 360
    Width = 129
    Height = 25
    Caption = 'Run selected function'
    TabOrder = 6
    OnClick = btnRunSelectedClick
  end
  object meDescription: TMemo
    Left = 368
    Top = 104
    Width = 353
    Height = 249
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 4
  end
end
