object fItemSelectForm: TfItemSelectForm
  Left = 745
  Top = 120
  BorderStyle = bsDialog
  Caption = 'fItemSelectForm'
  ClientHeight = 596
  ClientWidth = 520
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
  object lbItems: TListBox
    Left = 8
    Top = 24
    Width = 505
    Height = 534
    Style = lbOwnerDrawFixed
    IntegralHeight = True
    ItemHeight = 53
    TabOrder = 0
    OnClick = lbItemsClick
    OnDblClick = lbItemsDblClick
    OnDrawItem = lbItemsDrawItem
  end
  object btnAccept: TButton
    Left = 344
    Top = 564
    Width = 81
    Height = 25
    Caption = 'Accept'
    TabOrder = 1
    OnClick = btnAcceptClick
  end
  object btnCancel: TButton
    Left = 432
    Top = 564
    Width = 81
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
