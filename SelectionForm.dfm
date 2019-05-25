object fSelectionForm: TfSelectionForm
  Left = 411
  Top = 117
  Width = 864
  Height = 498
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Shop selection table'
  Color = clBtnFace
  Constraints.MinHeight = 100
  Constraints.MinWidth = 100
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    856
    464)
  PixelsPerInch = 96
  TextHeight = 13
  object sgTable: TStringGrid
    Left = 8
    Top = 8
    Width = 841
    Height = 449
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = 16316664
    ColCount = 2
    DefaultRowHeight = 37
    DefaultDrawing = False
    RowCount = 2
    Options = [goThumbTracking]
    TabOrder = 0
    OnDblClick = sgTableDblClick
    OnDrawCell = sgTableDrawCell
    OnExit = sgTableExit
    OnKeyDown = sgTableKeyDown
    OnKeyPress = sgTableKeyPress
    OnKeyUp = sgTableKeyUp
    OnMouseMove = sgTableMouseMove
    RowHeights = (
      37
      37)
  end
end
