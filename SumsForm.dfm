object fSumsForm: TfSumsForm
  Left = 314
  Top = 20
  BorderStyle = bsDialog
  Caption = 'Sums'
  ClientHeight = 688
  ClientWidth = 896
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
  object sbMain: TScrollBox
    Left = 0
    Top = 80
    Width = 896
    Height = 569
    VertScrollBar.Margin = 8
    VertScrollBar.Position = 500
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Color = clWhite
    ParentColor = False
    TabOrder = 0
    object lblSumsByTextTag: TLabel
      Left = 8
      Top = 318
      Width = 86
      Height = 13
      Caption = 'Sums by text tag:'
    end
    object lblSumsBySelShop: TLabel
      Left = 8
      Top = 70
      Width = 113
      Height = 13
      Caption = 'Sums by selected shop:'
    end
    object lblSumsByManufacturer: TLabel
      Left = 8
      Top = -178
      Width = 135
      Height = 13
      Caption = 'Sums by item manufacturer:'
    end
    object lblSumsByType: TLabel
      Left = 8
      Top = -426
      Width = 87
      Height = 13
      Caption = 'Sum by item type:'
    end
    object lblSumsGrandTotal: TLabel
      Left = 8
      Top = -492
      Width = 58
      Height = 13
      Caption = 'Grand total:'
    end
    object sgSumsByManufacturer: TStringGrid
      Left = 8
      Top = -162
      Width = 857
      Height = 225
      Color = 16316664
      ColCount = 2
      DefaultColWidth = 80
      DefaultRowHeight = 20
      DefaultDrawing = False
      RowCount = 10
      GridLineWidth = 0
      Options = [goThumbTracking]
      TabOrder = 2
      OnDrawCell = CommonDrawCell
    end
    object sgSumsByType: TStringGrid
      Left = 8
      Top = -410
      Width = 857
      Height = 225
      Color = 16316664
      ColCount = 2
      DefaultColWidth = 80
      DefaultRowHeight = 20
      DefaultDrawing = False
      RowCount = 10
      GridLineWidth = 0
      Options = [goThumbTracking]
      TabOrder = 1
      OnDrawCell = CommonDrawCell
    end
    object sgSumsBySelShop: TStringGrid
      Left = 8
      Top = 86
      Width = 857
      Height = 225
      Color = 16316664
      ColCount = 2
      DefaultColWidth = 80
      DefaultRowHeight = 20
      DefaultDrawing = False
      RowCount = 10
      GridLineWidth = 0
      Options = [goThumbTracking]
      TabOrder = 3
      OnDrawCell = CommonDrawCell
    end
    object sgSumsByTextTag: TStringGrid
      Left = 8
      Top = 334
      Width = 857
      Height = 225
      Color = 16316664
      ColCount = 2
      DefaultColWidth = 80
      DefaultRowHeight = 20
      DefaultDrawing = False
      RowCount = 10
      GridLineWidth = 0
      Options = [goThumbTracking]
      TabOrder = 4
      OnDrawCell = CommonDrawCell
    end
    object sgSumsGrandTotal: TStringGrid
      Left = 8
      Top = -476
      Width = 857
      Height = 44
      Color = 16316664
      ColCount = 9
      DefaultColWidth = 80
      DefaultRowHeight = 20
      DefaultDrawing = False
      FixedCols = 0
      RowCount = 2
      GridLineWidth = 0
      Options = [goThumbTracking]
      TabOrder = 0
      OnDrawCell = CommonDrawCell
      RowHeights = (
        20
        20)
    end
  end
  object btnClose: TButton
    Left = 808
    Top = 656
    Width = 81
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object bgFlagFilter: TGroupBox
    Left = 8
    Top = 0
    Width = 881
    Height = 73
    Caption = 'Flag filter'
    TabOrder = 2
    object bvlFlagsSep: TBevel
      Left = 112
      Top = 16
      Width = 9
      Height = 49
      Shape = bsLeftLine
    end
    object bvlLegengSep: TBevel
      Left = 728
      Top = 16
      Width = 9
      Height = 49
      Shape = bsLeftLine
    end
    object cbFlagOwned: TCheckBox
      Left = 136
      Top = 16
      Width = 65
      Height = 17
      AllowGrayed = True
      Caption = 'Owned'
      State = cbGrayed
      TabOrder = 3
      OnClick = CommonFilterCheckBoxClick
    end
    object cbFlagWanted: TCheckBox
      Left = 256
      Top = 16
      Width = 65
      Height = 17
      AllowGrayed = True
      Caption = 'Wanted'
      State = cbGrayed
      TabOrder = 4
      OnClick = CommonFilterCheckBoxClick
    end
    object cbFlagOrdered: TCheckBox
      Left = 376
      Top = 16
      Width = 73
      Height = 17
      AllowGrayed = True
      Caption = 'Ordered'
      State = cbGrayed
      TabOrder = 5
      OnClick = CommonFilterCheckBoxClick
    end
    object cbFlagBoxed: TCheckBox
      Left = 496
      Top = 16
      Width = 57
      Height = 17
      AllowGrayed = True
      Caption = 'Boxed'
      State = cbGrayed
      TabOrder = 6
      OnClick = CommonFilterCheckBoxClick
    end
    object cbFlagElsewhere: TCheckBox
      Left = 616
      Top = 16
      Width = 81
      Height = 17
      AllowGrayed = True
      Caption = 'Elsewhere'
      State = cbGrayed
      TabOrder = 7
      OnClick = CommonFilterCheckBoxClick
    end
    object cbFlagUntested: TCheckBox
      Left = 136
      Top = 32
      Width = 73
      Height = 17
      AllowGrayed = True
      Caption = 'Untested'
      State = cbGrayed
      TabOrder = 8
      OnClick = CommonFilterCheckBoxClick
    end
    object cbFlagTesting: TCheckBox
      Left = 256
      Top = 32
      Width = 65
      Height = 17
      AllowGrayed = True
      Caption = 'Testing'
      State = cbGrayed
      TabOrder = 9
      OnClick = CommonFilterCheckBoxClick
    end
    object cbFlagTested: TCheckBox
      Left = 376
      Top = 32
      Width = 65
      Height = 17
      AllowGrayed = True
      Caption = 'Tested'
      State = cbGrayed
      TabOrder = 10
      OnClick = CommonFilterCheckBoxClick
    end
    object cbFlagDamaged: TCheckBox
      Left = 496
      Top = 32
      Width = 73
      Height = 17
      AllowGrayed = True
      Caption = 'Damaged'
      State = cbGrayed
      TabOrder = 11
      OnClick = CommonFilterCheckBoxClick
    end
    object cbFlagRepaired: TCheckBox
      Left = 616
      Top = 32
      Width = 73
      Height = 17
      AllowGrayed = True
      Caption = 'Repaired'
      State = cbGrayed
      TabOrder = 12
      OnClick = CommonFilterCheckBoxClick
    end
    object cbFlagPriceChange: TCheckBox
      Left = 136
      Top = 48
      Width = 89
      Height = 17
      AllowGrayed = True
      Caption = 'Price change'
      State = cbGrayed
      TabOrder = 13
      OnClick = CommonFilterCheckBoxClick
    end
    object cbFlagAvailChange: TCheckBox
      Left = 256
      Top = 48
      Width = 113
      Height = 17
      AllowGrayed = True
      Caption = 'Availability change'
      State = cbGrayed
      TabOrder = 14
      OnClick = CommonFilterCheckBoxClick
    end
    object cbFlagNotAvailable: TCheckBox
      Left = 376
      Top = 48
      Width = 89
      Height = 17
      AllowGrayed = True
      Caption = 'Not available'
      State = cbGrayed
      TabOrder = 15
      OnClick = CommonFilterCheckBoxClick
    end
    object rbOpAND: TRadioButton
      Left = 8
      Top = 16
      Width = 89
      Height = 17
      Caption = 'AND operator'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = CommonFilterCheckBoxClick
    end
    object rbOpOR: TRadioButton
      Left = 8
      Top = 32
      Width = 89
      Height = 17
      Caption = 'OR operator'
      TabOrder = 1
      OnClick = CommonFilterCheckBoxClick
    end
    object rbOpXOR: TRadioButton
      Left = 8
      Top = 48
      Width = 89
      Height = 17
      Caption = 'XOR operator'
      TabOrder = 2
      OnClick = CommonFilterCheckBoxClick
    end
    object cbStateUnchecked: TCheckBox
      Left = 752
      Top = 16
      Width = 113
      Height = 17
      TabStop = False
      Caption = 'Flag must be clear'
      TabOrder = 16
      OnClick = CommonStateCheckBoxClick
    end
    object cbStateChecked: TCheckBox
      Left = 752
      Top = 32
      Width = 113
      Height = 17
      TabStop = False
      Caption = 'Flag must be set'
      Checked = True
      State = cbChecked
      TabOrder = 17
      OnClick = CommonStateCheckBoxClick
    end
    object cbStateGrayed: TCheckBox
      Left = 752
      Top = 48
      Width = 113
      Height = 17
      TabStop = False
      Caption = 'Flag will be ignored'
      State = cbGrayed
      TabOrder = 18
      OnClick = CommonStateCheckBoxClick
    end
  end
end
