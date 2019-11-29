object fItemShopTableForm: TfItemShopTableForm
  Left = 279
  Top = 57
  BorderStyle = bsDialog
  Caption = 'Item-shop table'
  ClientHeight = 656
  ClientWidth = 976
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
    976
    656)
  PixelsPerInch = 96
  TextHeight = 13
  object dgTable: TDrawGrid
    Left = 8
    Top = 8
    Width = 961
    Height = 641
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = 16316664
    ColCount = 2
    DefaultDrawing = False
    RowCount = 2
    Options = [goRowSelect, goThumbTracking]
    TabOrder = 0
  end
end
