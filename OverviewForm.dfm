object fOverviewForm: TfOverviewForm
  Left = 712
  Top = 165
  BorderStyle = bsDialog
  Caption = 'Selected shops overview'
  ClientHeight = 552
  ClientWidth = 496
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblUpdateInterval: TLabel
    Left = 196
    Top = 525
    Width = 125
    Height = 13
    Alignment = taRightJustify
    Caption = 'AutoUpdate interval [ms]:'
  end
  object sgOverview: TStringGrid
    Left = 8
    Top = 8
    Width = 481
    Height = 505
    Color = 16316664
    DefaultColWidth = 80
    DefaultRowHeight = 20
    DefaultDrawing = False
    RowCount = 2
    GridLineWidth = 0
    Options = [goRowSelect, goThumbTracking]
    TabOrder = 0
    OnDrawCell = sgOverviewDrawCell
  end
  object cbStayOnTop: TCheckBox
    Left = 8
    Top = 523
    Width = 81
    Height = 17
    Caption = 'Stay on top'
    TabOrder = 1
    OnClick = cbStayOnTopClick
  end
  object btnUpdate: TButton
    Left = 392
    Top = 520
    Width = 97
    Height = 25
    Caption = 'Update overview'
    TabOrder = 4
    OnClick = btnUpdateClick
  end
  object cbAutoUpdate: TCheckBox
    Left = 96
    Top = 523
    Width = 81
    Height = 17
    Caption = 'AutoUpdate'
    TabOrder = 2
    OnClick = cbAutoUpdateClick
  end
  object seUpdateInterval: TSpinEdit
    Left = 328
    Top = 521
    Width = 57
    Height = 22
    MaxValue = 10000
    MinValue = 250
    TabOrder = 3
    Value = 1000
    OnChange = seUpdateIntervalChange
  end
  object tmrUpdate: TTimer
    Enabled = False
    OnTimer = tmrUpdateTimer
    Left = 464
    Top = 488
  end
end
