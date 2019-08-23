object fSelectionForm: TfSelectionForm
  Left = 333
  Top = 39
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsDialog
  Caption = 'Shop selection'
  ClientHeight = 664
  ClientWidth = 936
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
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblShops: TLabel
    Left = 8
    Top = 8
    Width = 33
    Height = 13
    Caption = 'Shops:'
  end
  object lblItems: TLabel
    Left = 424
    Top = 8
    Width = 175
    Height = 13
    Caption = 'Items available in the selected shop:'
  end
  object lblItemsHint: TLabel
    Left = 714
    Top = 8
    Width = 215
    Height = 13
    Alignment = taRightJustify
    Caption = 'Doubleclick to (de)select the item in this shop'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGrayText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbItems: TListBox
    Left = 424
    Top = 24
    Width = 505
    Height = 428
    Style = lbOwnerDrawFixed
    IntegralHeight = True
    ItemHeight = 53
    PopupMenu = pmnItems
    TabOrder = 1
    OnClick = lbItemsClick
    OnDblClick = lbItemsDblClick
    OnDrawItem = lbItemsDrawItem
    OnMouseDown = lbItemsMouseDown
  end
  object lvShops: TListView
    Left = 8
    Top = 24
    Width = 409
    Height = 430
    Columns = <
      item
        Caption = 'Shop'
        Width = 205
      end
      item
        Alignment = taRightJustify
        Caption = 'Items'
        Width = 60
      end
      item
        Alignment = taRightJustify
        Caption = 'Available'
        Width = 60
      end
      item
        Alignment = taRightJustify
        Caption = 'Selected'
        Width = 60
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnSelectItem = lvShopsSelectItem
  end
  object grbItemShops: TGroupBox
    Left = 8
    Top = 456
    Width = 921
    Height = 201
    Caption = 'Item shops'
    TabOrder = 2
    object lvItemShops: TListView
      Left = 8
      Top = 16
      Width = 905
      Height = 178
      Columns = <
        item
          Width = 30
        end
        item
          Caption = 'Shop name'
          Width = 200
        end
        item
          Caption = 'Item URL'
          Width = 480
        end
        item
          Alignment = taRightJustify
          Caption = 'Available'
          Width = 85
        end
        item
          Alignment = taRightJustify
          Caption = 'Price'
          Width = 85
        end>
      ColumnClick = False
      GridLines = True
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnDblClick = lvItemShopsDblClick
      OnSelectItem = lvShopsSelectItem
    end
  end
  object pmnItems: TPopupMenu
    OnPopup = pmnItemsPopup
    Left = 904
    object mniIT_EditTextTag: TMenuItem
      Caption = 'Edit textual tag...'
      ShortCut = 16468
      OnClick = mniIT_EditTextTagClick
    end
    object mniIT_EditNumTag: TMenuItem
      Caption = 'Edit numerical tag...'
      ShortCut = 16462
      OnClick = mniIT_EditNumTagClick
    end
  end
end
