object fOverviewForm: TfOverviewForm
  Left = 769
  Top = 116
  BorderStyle = bsDialog
  Caption = 'Selected shops overview'
  ClientHeight = 544
  ClientWidth = 496
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
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
    Top = 520
    Width = 81
    Height = 17
    Caption = 'Stay on top'
    Checked = True
    State = cbChecked
    TabOrder = 1
    OnClick = cbStayOnTopClick
  end
end
