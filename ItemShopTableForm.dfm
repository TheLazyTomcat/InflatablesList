object fItemShopTableForm: TfItemShopTableForm
  Left = 193
  Top = 56
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Item-shop table'
  ClientHeight = 656
  ClientWidth = 1048
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    1048
    656)
  PixelsPerInch = 96
  TextHeight = 13
  object dgTable: TDrawGrid
    Left = 8
    Top = 8
    Width = 1033
    Height = 641
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = 16316664
    ColCount = 2
    DefaultColWidth = 300
    DefaultRowHeight = 35
    DefaultDrawing = False
    RowCount = 2
    Options = [goThumbTracking]
    TabOrder = 0
    OnDrawCell = dgTableDrawCell
  end
end
