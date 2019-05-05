object fParsingForm: TfParsingForm
  Left = 614
  Top = 129
  BorderStyle = bsDialog
  Caption = 'fParsingForm'
  ClientHeight = 448
  ClientWidth = 648
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object gbFinderSettings: TGroupBox
    Left = 8
    Top = 8
    Width = 633
    Height = 361
    Caption = 'Finder settings'
    TabOrder = 0
    object lblAttrComps: TLabel
      Left = 216
      Top = 16
      Width = 140
      Height = 13
      Caption = 'Searched attributes settings:'
    end
    object lblStages: TLabel
      Left = 8
      Top = 16
      Width = 74
      Height = 13
      Caption = 'Parsing stages:'
    end
    object lblStageElements: TLabel
      Left = 8
      Top = 152
      Width = 125
      Height = 13
      Caption = 'Searched stage elements:'
    end
    object lblTextComps: TLabel
      Left = 424
      Top = 16
      Width = 113
      Height = 13
      Caption = 'Searched text settings:'
    end
    object lbStages: TListBox
      Left = 8
      Top = 32
      Width = 201
      Height = 113
      ItemHeight = 13
      TabOrder = 0
      OnClick = lbStagesClick
    end
    object tvStageElements: TTreeView
      Left = 8
      Top = 168
      Width = 201
      Height = 113
      HideSelection = False
      Indent = 19
      ReadOnly = True
      TabOrder = 1
      OnChange = tvStageElementsChange
      OnClick = tvStageElementsClick
      OnEnter = tvStageElementsEnter
    end
    object gbSelectedDetails: TGroupBox
      Left = 8
      Top = 288
      Width = 617
      Height = 65
      Caption = 'Selected object details'
      TabOrder = 4
      inline frmComparatorFrame: TfrmComparatorFrame
        Left = 8
        Top = 16
        Width = 600
        Height = 41
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
    end
    object tvAttrComps: TTreeView
      Left = 216
      Top = 32
      Width = 201
      Height = 249
      HideSelection = False
      Indent = 19
      ReadOnly = True
      TabOrder = 2
      OnChange = tvAttrCompsChange
      OnClick = tvAttrCompsClick
      OnEnter = tvAttrCompsEnter
    end
    object tvTextComps: TTreeView
      Left = 424
      Top = 32
      Width = 201
      Height = 249
      HideSelection = False
      Indent = 19
      ReadOnly = True
      TabOrder = 3
      OnChange = tvTextCompsChange
      OnClick = tvTextCompsClick
      OnEnter = tvTextCompsEnter
    end
  end
  object gbExtracSettings: TGroupBox
    Left = 8
    Top = 376
    Width = 633
    Height = 65
    Caption = 'Extraction settings'
    TabOrder = 1
    object lblExtractFrom: TLabel
      Left = 8
      Top = 16
      Width = 64
      Height = 13
      Caption = 'Extract from:'
    end
    object lblExtractMethod: TLabel
      Left = 176
      Top = 16
      Width = 92
      Height = 13
      Caption = 'Extraction method:'
    end
    object cmbExtractFrom: TComboBox
      Left = 8
      Top = 32
      Width = 161
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object cmbExtractMethod: TComboBox
      Left = 176
      Top = 32
      Width = 161
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
    end
    object leExtractionData: TLabeledEdit
      Left = 344
      Top = 32
      Width = 137
      Height = 21
      EditLabel.Width = 78
      EditLabel.Height = 13
      EditLabel.Caption = 'Extraction data:'
      TabOrder = 2
    end
    object leNegativeTag: TLabeledEdit
      Left = 488
      Top = 32
      Width = 137
      Height = 21
      EditLabel.Width = 66
      EditLabel.Height = 13
      EditLabel.Caption = 'Negative tag:'
      TabOrder = 3
    end
  end
end
