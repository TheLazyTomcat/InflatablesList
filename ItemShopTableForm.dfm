object fItemShopTableForm: TfItemShopTableForm
  Left = 217
  Top = 63
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
  object lblSelectedInfo: TLabel
    Left = 970
    Top = 634
    Width = 71
    Height = 13
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = 'lblSelectedInfo'
  end
  object dgTable: TDrawGrid
    Left = 8
    Top = 8
    Width = 1033
    Height = 617
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = 16316664
    ColCount = 2
    DefaultDrawing = False
    RowCount = 2
    Options = [goThumbTracking]
    TabOrder = 0
    OnDblClick = dgTableDblClick
    OnDrawCell = dgTableDrawCell
    OnSelectCell = dgTableSelectCell
  end
  object cbCompactView: TCheckBox
    Left = 8
    Top = 632
    Width = 89
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Compact view'
    TabOrder = 1
    OnClick = cbCompactViewClick
  end
end
