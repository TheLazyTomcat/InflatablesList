object fItemSelectForm: TfItemSelectForm
  Left = 830
  Top = 135
  BorderStyle = bsDialog
  Caption = 'fItemSelectForm'
  ClientHeight = 484
  ClientWidth = 416
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblItems: TLabel
    Left = 8
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Items:'
  end
  object clbItems: TCheckListBox
    Left = 8
    Top = 24
    Width = 401
    Height = 420
    IntegralHeight = True
    ItemHeight = 13
    TabOrder = 0
    OnClick = clbItemsClick
  end
  object btnAccept: TButton
    Left = 240
    Top = 452
    Width = 81
    Height = 25
    Caption = 'Accept'
    TabOrder = 1
    OnClick = btnAcceptClick
  end
  object btnClose: TButton
    Left = 328
    Top = 452
    Width = 81
    Height = 25
    Caption = 'Close'
    TabOrder = 2
    OnClick = btnCloseClick
  end
end