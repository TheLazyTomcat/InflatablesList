object fShopByItems: TfShopByItems
  Left = 421
  Top = 158
  BorderStyle = bsDialog
  Caption = 'Selection of shops by items'
  ClientHeight = 462
  ClientWidth = 832
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
  PixelsPerInch = 96
  TextHeight = 13
  object lblItems: TLabel
    Left = 8
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Items:'
  end
  object lblShops: TLabel
    Left = 520
    Top = 8
    Width = 158
    Height = 13
    Caption = 'Shops offering all selected items:'
  end
  object clbItems: TCheckListBox
    Left = 8
    Top = 24
    Width = 505
    Height = 428
    OnClickCheck = clbItemsClickCheck
    IntegralHeight = True
    ItemHeight = 53
    PopupMenu = pmnItems
    Style = lbOwnerDrawFixed
    TabOrder = 0
    OnDrawItem = clbItemsDrawItem
  end
  object lvShops: TListView
    Left = 520
    Top = 24
    Width = 305
    Height = 430
    Columns = <
      item
        Caption = 'Shop'
        Width = 180
      end
      item
        Alignment = taRightJustify
        Caption = 'Price of selected'
        Width = 100
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
  end
  object pmnItems: TPopupMenu
    Left = 488
    object mniSL_UnselectAll: TMenuItem
      Caption = 'Unselect all items'
      OnClick = mniSL_UnselectAllClick
    end
  end
end
