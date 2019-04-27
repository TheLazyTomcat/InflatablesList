object frmParsingFrame: TfrmParsingFrame
  Left = 0
  Top = 0
  Width = 329
  Height = 233
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 329
    Height = 233
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblStages: TLabel
      Left = 0
      Top = 4
      Width = 37
      Height = 13
      Caption = 'Stages:'
    end
    object lbStages: TListBox
      Left = 0
      Top = 20
      Width = 329
      Height = 60
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      IntegralHeight = True
      ItemHeight = 14
      ParentFont = False
      PopupMenu = pmnStages
      TabOrder = 0
      OnClick = lbStagesClick
      OnMouseDown = lbStagesMouseDown
    end
    object gbStage: TGroupBox
      Left = 0
      Top = 88
      Width = 329
      Height = 145
      Caption = 'Parsing stage'
      TabOrder = 1
      object leStageAttributeName: TLabeledEdit
        Left = 168
        Top = 32
        Width = 153
        Height = 21
        EditLabel.Width = 76
        EditLabel.Height = 13
        EditLabel.Caption = 'Attribute name:'
        TabOrder = 1
        OnChange = leStageAttributeNameChange
      end
      object leStageElementName: TLabeledEdit
        Left = 8
        Top = 32
        Width = 153
        Height = 21
        EditLabel.Width = 67
        EditLabel.Height = 13
        EditLabel.Caption = 'Element name'
        TabOrder = 0
        OnChange = leStageElementNameChange
      end
      object leStageAttributeValue: TLabeledEdit
        Left = 8
        Top = 72
        Width = 153
        Height = 21
        EditLabel.Width = 76
        EditLabel.Height = 13
        EditLabel.Caption = 'Attribute value:'
        TabOrder = 2
        OnChange = leStageAttributeValueChange
      end
      object cbStageTextFullMatch: TCheckBox
        Left = 168
        Top = 66
        Width = 113
        Height = 17
        Caption = 'Full match for text'
        TabOrder = 3
        OnClick = cbStageTextFullMatchClick
      end
      object leStageText: TLabeledEdit
        Left = 8
        Top = 112
        Width = 313
        Height = 21
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = 'Text:'
        TabOrder = 5
        OnChange = leStageTextChange
      end
      object cbStageRecursiveSearch: TCheckBox
        Left = 168
        Top = 88
        Width = 145
        Height = 17
        Caption = 'Recursive search for text'
        TabOrder = 4
        OnClick = cbStageRecursiveSearchClick
      end
    end
  end
  object pmnStages: TPopupMenu
    OnPopup = pmnStagesPopup
    Left = 296
    object mniSG_Add: TMenuItem
      Caption = 'Add new'
      ShortCut = 45
      OnClick = mniSG_AddClick
    end
    object mniSG_Remove: TMenuItem
      Caption = 'Remove selected'
      ShortCut = 46
      OnClick = mniSG_RemoveClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mniSG_MoveUp: TMenuItem
      Caption = 'Move  up'
      OnClick = mniSG_MoveUpClick
    end
    object mniSG_MoveDown: TMenuItem
      Caption = 'Move down'
      OnClick = mniSG_MoveDownClick
    end
  end
end
