object fParsingForm: TfParsingForm
  Left = 621
  Top = 115
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
  OnCreate = FormCreate
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
      Top = 120
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
      Height = 82
      IntegralHeight = True
      ItemHeight = 13
      PopupMenu = pmnStages
      TabOrder = 0
      OnClick = lbStagesClick
      OnMouseDown = lbStagesMouseDown
    end
    object tvStageElements: TTreeView
      Left = 8
      Top = 136
      Width = 201
      Height = 145
      HideSelection = False
      Indent = 19
      PopupMenu = pmnElements
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
      PopupMenu = pmnAttributes
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
      PopupMenu = pmnTexts
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
    object lblExtrIdx: TLabel
      Left = 59
      Top = 30
      Width = 28
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = '-'
    end
    object btnExtrNext: TButton
      Left = 88
      Top = 24
      Width = 17
      Height = 25
      Caption = '>'
      TabOrder = 3
      OnClick = btnExtrNextClick
    end
    object btnExtrPrev: TButton
      Left = 42
      Top = 24
      Width = 17
      Height = 25
      Caption = '<'
      TabOrder = 2
      OnClick = btnExtrPrevClick
    end
    object btnExtrAdd: TButton
      Left = 8
      Top = 24
      Width = 17
      Height = 25
      Caption = '+'
      TabOrder = 0
      OnClick = btnExtrAddClick
    end
    object btnExtrRemove: TButton
      Left = 25
      Top = 24
      Width = 17
      Height = 25
      Caption = '-'
      TabOrder = 1
      OnClick = btnExtrRemoveClick
    end
    inline frmExtractionFrame: TfrmExtractionFrame
      Left = 120
      Top = 16
      Width = 505
      Height = 41
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
  end
  object pmnStages: TPopupMenu
    OnPopup = pmnStagesPopup
    Left = 192
    Top = 96
    object mniSG_Add: TMenuItem
      Caption = 'Add new stage'
      OnClick = mniSG_AddClick
    end
    object mniSG_Remove: TMenuItem
      Caption = 'Remove selected stage'
      OnClick = mniSG_RemoveClick
    end
  end
  object pmnElements: TPopupMenu
    OnPopup = pmnElementsPopup
    Left = 192
    Top = 264
    object mniEL_Add: TMenuItem
      Caption = 'Add new element option'
      OnClick = mniEL_AddClick
    end
    object mniEL_Remove: TMenuItem
      Caption = 'Remove selected element option'
      OnClick = mniEL_RemoveClick
    end
  end
  object pmnAttributes: TPopupMenu
    OnPopup = pmnAttributesPopup
    Left = 400
    Top = 264
    object mniAT_AddComp: TMenuItem
      Caption = 'Add new comparator'
      OnClick = mniAT_AddCompClick
    end
    object mniAT_AddGroup: TMenuItem
      Caption = 'Add new group'
      OnClick = mniAT_AddGroupClick
    end
    object mniAT_Remove: TMenuItem
      Caption = 'Remove selected object'
      OnClick = mniAT_RemoveClick
    end
  end
  object pmnTexts: TPopupMenu
    OnPopup = pmnTextsPopup
    Left = 608
    Top = 264
    object mniTX_AddComp: TMenuItem
      Caption = 'Add new comparator'
      OnClick = mniTX_AddCompClick
    end
    object mniTX_AddGroup: TMenuItem
      Caption = 'Add new group'
      OnClick = mniTX_AddGroupClick
    end
    object mniTX_Remove: TMenuItem
      Caption = 'Remove selected object'
      OnClick = mniTX_RemoveClick
    end
  end
end
