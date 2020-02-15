object fUpdateForm: TfUpdateForm
  Left = 586
  Top = 158
  BorderStyle = bsDialog
  Caption = 'Updates'
  ClientHeight = 464
  ClientWidth = 680
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object bvlSplit: TBevel
    Left = 8
    Top = 88
    Width = 665
    Height = 9
    Shape = bsTopLine
  end
  object lblLog: TLabel
    Left = 8
    Top = 96
    Width = 72
    Height = 13
    Caption = 'Processing log:'
  end
  object lblNumberOfThreads: TLabel
    Left = 515
    Top = 60
    Width = 94
    Height = 13
    Alignment = taRightJustify
    Caption = 'Number of threads:'
  end
  object pnlInfo: TPanel
    Left = 8
    Top = 8
    Width = 665
    Height = 41
    BevelInner = bvLowered
    Caption = 'pnlInfo'
    TabOrder = 0
  end
  object btnAction: TButton
    Left = 8
    Top = 56
    Width = 105
    Height = 25
    Caption = 'btnAction'
    TabOrder = 1
    OnClick = btnActionClick
  end
  object pbProgress: TProgressBar
    Left = 120
    Top = 60
    Width = 385
    Height = 17
    Max = 1000
    Step = 1
    TabOrder = 2
  end
  object meLog: TMemo
    Left = 8
    Top = 112
    Width = 665
    Height = 345
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 4
    WordWrap = False
    OnKeyPress = meLogKeyPress
  end
  object seNumberOfThreads: TSpinEdit
    Left = 616
    Top = 56
    Width = 57
    Height = 22
    MaxValue = 1024
    MinValue = 1
    TabOrder = 3
    Value = 1
    OnChange = seNumberOfThreadsChange
  end
  object tmrUpdate: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrUpdateTimer
  end
end
