object fAdvancedSearchForm: TfAdvancedSearchForm
  Left = 756
  Top = 135
  BorderStyle = bsDialog
  Caption = 'Advanced search'
  ClientHeight = 528
  ClientWidth = 504
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
  object bvlHorSplit: TBevel
    Left = 8
    Top = 140
    Width = 489
    Height = 9
    Shape = bsTopLine
  end
  object lblSearchResults: TLabel
    Left = 8
    Top = 144
    Width = 72
    Height = 13
    Caption = 'Search results:'
  end
  object grbSearchSettings: TGroupBox
    Left = 8
    Top = 48
    Width = 489
    Height = 81
    Caption = 'Search settings'
    TabOrder = 2
    object cbPartialMatch: TCheckBox
      Left = 8
      Top = 16
      Width = 113
      Height = 17
      Caption = 'Allow partial match'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object cbSearchCalculated: TCheckBox
      Left = 168
      Top = 36
      Width = 145
      Height = 17
      Caption = 'Search calculated values'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object cbCaseSensitive: TCheckBox
      Left = 168
      Top = 16
      Width = 153
      Height = 17
      Caption = 'Case sensitive comparisons'
      TabOrder = 1
    end
    object cbSearchShops: TCheckBox
      Left = 8
      Top = 56
      Width = 113
      Height = 17
      Caption = 'Search item shops'
      TabOrder = 6
    end
    object cbTextsOnly: TCheckBox
      Left = 328
      Top = 16
      Width = 153
      Height = 17
      Caption = 'Search only textual values'
      TabOrder = 2
    end
    object cbIncludeUnits: TCheckBox
      Left = 328
      Top = 36
      Width = 121
      Height = 17
      Caption = 'Include unit symbols'
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
    object cbDeepScan: TCheckBox
      Left = 168
      Top = 56
      Width = 73
      Height = 17
      Caption = 'Deep scan'
      TabOrder = 7
    end
    object cbEditablesOnly: TCheckBox
      Left = 8
      Top = 36
      Width = 153
      Height = 17
      Caption = 'Search only editable values'
      TabOrder = 3
    end
  end
  object leTextToFind: TLabeledEdit
    Left = 8
    Top = 24
    Width = 401
    Height = 21
    EditLabel.Width = 60
    EditLabel.Height = 13
    EditLabel.Caption = 'Text to find:'
    TabOrder = 0
    OnKeyPress = leTextToFindKeyPress
  end
  object btnSearch: TButton
    Left = 416
    Top = 24
    Width = 81
    Height = 21
    Caption = 'Search'
    TabOrder = 1
    OnClick = btnSearchClick
  end
  object meSearchResults: TMemo
    Left = 8
    Top = 160
    Width = 489
    Height = 361
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 3
    WordWrap = False
    OnKeyPress = meSearchResultsKeyPress
  end
end
