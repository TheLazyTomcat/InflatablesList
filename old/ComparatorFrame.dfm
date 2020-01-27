object frmComparatorFrame: TfrmComparatorFrame
  Left = 0
  Top = 0
  Width = 600
  Height = 41
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
    Width = 600
    Height = 41
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object bvlStrSeparator: TBevel
      Left = 432
      Top = -1
      Width = 9
      Height = 41
      Shape = bsLeftLine
    end
    object lblVarIndex: TLabel
      Left = 216
      Top = 0
      Width = 71
      Height = 13
      Caption = 'Variable index:'
    end
    object lblOperator: TLabel
      Left = 448
      Top = 0
      Width = 48
      Height = 13
      Caption = 'Operator:'
    end
    object leString: TLabeledEdit
      Left = 0
      Top = 16
      Width = 209
      Height = 21
      EditLabel.Width = 106
      EditLabel.Height = 13
      EditLabel.Caption = 'String for comparison:'
      TabOrder = 0
      OnChange = leStringChange
    end
    object seVarIndex: TSpinEdit
      Left = 216
      Top = 16
      Width = 89
      Height = 22
      MaxValue = 8
      MinValue = 0
      TabOrder = 1
      Value = 0
      OnChange = seVarIndexChange
    end
    object cbCaseSensitive: TCheckBox
      Left = 312
      Top = 0
      Width = 97
      Height = 17
      Caption = 'Case sensitive'
      TabOrder = 2
      OnClick = cbCaseSensitiveClick
    end
    object cbAllowPartial: TCheckBox
      Left = 312
      Top = 23
      Width = 113
      Height = 17
      Caption = 'Allow partial match'
      TabOrder = 3
      OnClick = cbAllowPartialClick
    end
    object cmbOperator: TComboBox
      Left = 448
      Top = 16
      Width = 81
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 4
      OnChange = cmbOperatorChange
    end
    object cbNegate: TCheckBox
      Left = 543
      Top = 17
      Width = 58
      Height = 17
      Caption = 'Negate'
      TabOrder = 5
      OnClick = cbNegateClick
    end
    object cbNestedText: TCheckBox
      Left = 0
      Top = 16
      Width = 129
      Height = 17
      Caption = 'Search full nested text'
      TabOrder = 6
      OnClick = cbNestedTextClick
    end
  end
end
