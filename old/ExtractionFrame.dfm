object frmExtractionFrame: TfrmExtractionFrame
  Left = 0
  Top = 0
  Width = 505
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
    Width = 505
    Height = 41
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblExtractFrom: TLabel
      Left = 16
      Top = 0
      Width = 64
      Height = 13
      Caption = 'Extract from:'
    end
    object lblExtractMethod: TLabel
      Left = 152
      Top = 0
      Width = 92
      Height = 13
      Caption = 'Extraction method:'
    end
    object bvlExtrSeparator: TBevel
      Left = 0
      Top = 0
      Width = 9
      Height = 41
      Shape = bsLeftLine
    end
    object cmbExtractFrom: TComboBox
      Left = 16
      Top = 16
      Width = 129
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object cmbExtractMethod: TComboBox
      Left = 152
      Top = 16
      Width = 129
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
    end
    object leExtractionData: TLabeledEdit
      Left = 288
      Top = 16
      Width = 105
      Height = 21
      EditLabel.Width = 78
      EditLabel.Height = 13
      EditLabel.Caption = 'Extraction data:'
      TabOrder = 2
    end
    object leNegativeTag: TLabeledEdit
      Left = 400
      Top = 16
      Width = 104
      Height = 21
      EditLabel.Width = 66
      EditLabel.Height = 13
      EditLabel.Caption = 'Negative tag:'
      TabOrder = 3
    end
  end
end
