object fShopsForm: TfShopsForm
  Left = 342
  Top = 47
  BorderStyle = bsDialog
  Caption = 'Shops'
  ClientHeight = 660
  ClientWidth = 920
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblShops: TLabel
    Left = 8
    Top = 8
    Width = 33
    Height = 13
    Caption = 'Shops:'
  end
  object lblLegend: TLabel
    Left = 796
    Top = 8
    Width = 117
    Height = 13
    Alignment = taRightJustify
    Caption = '* selected   ^ untracked'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGrayText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lvShops: TListView
    Left = 8
    Top = 24
    Width = 905
    Height = 177
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
    PopupMenu = pmnShops
    TabOrder = 0
    ViewStyle = vsReport
    OnSelectItem = lvShopsSelectItem
  end
  object gbShopDetails: TGroupBox
    Left = 8
    Top = 208
    Width = 905
    Height = 401
    Caption = 'Shop details'
    TabOrder = 1
    inline frmShopFrame: TfrmShopFrame
      Left = 8
      Top = 16
      Width = 889
      Height = 378
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object btnClose: TButton
    Left = 776
    Top = 624
    Width = 137
    Height = 25
    Caption = 'Close'
    TabOrder = 6
    OnClick = btnCloseClick
  end
  object btnUpdateAll: TButton
    Left = 488
    Top = 624
    Width = 137
    Height = 25
    Caption = 'Update all shops...'
    TabOrder = 4
    OnClick = btnUpdateAllClick
  end
  object lePriceLowest: TLabeledEdit
    Left = 8
    Top = 632
    Width = 105
    Height = 21
    EditLabel.Width = 64
    EditLabel.Height = 13
    EditLabel.Caption = 'Lowest price:'
    ReadOnly = True
    TabOrder = 2
  end
  object lePriceSelected: TLabeledEdit
    Left = 120
    Top = 632
    Width = 105
    Height = 21
    EditLabel.Width = 71
    EditLabel.Height = 13
    EditLabel.Caption = 'Selected price:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
  end
  object btnUpdateHistory: TButton
    Left = 632
    Top = 624
    Width = 137
    Height = 25
    Caption = 'Update all shops history'
    TabOrder = 5
    OnClick = btnUpdateHistoryClick
  end
  object pmnShops: TPopupMenu
    OnPopup = pmnShopsPopup
    Left = 56
    object mniSH_Add: TMenuItem
      Caption = 'Add new shop'
      ShortCut = 45
      OnClick = mniSH_AddClick
    end
    object mniSH_AddFromTemplate: TMenuItem
      Caption = 'Add new shop from template...'
      ShortCut = 16429
      OnClick = mniSH_AddFromTemplateClick
    end
    object mniSH_Remove: TMenuItem
      Caption = 'Remove selected shop'
      ShortCut = 46
      OnClick = mniSH_RemoveClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mniSH_MoveUp: TMenuItem
      Caption = 'Move up'
      OnClick = mniSH_MoveUpClick
    end
    object mniSH_MoveDown: TMenuItem
      Caption = 'Move down'
      OnClick = mniSH_MoveDownClick
    end
  end
end
