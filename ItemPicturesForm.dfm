object fItemPicturesForm: TfItemPicturesForm
  Left = 710
  Top = 119
  BorderStyle = bsDialog
  Caption = 'fItemPicturesForm'
  ClientHeight = 368
  ClientWidth = 552
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbPictures: TListBox
    Left = 8
    Top = 8
    Width = 377
    Height = 354
    Style = lbOwnerDrawFixed
    IntegralHeight = True
    ItemHeight = 35
    PopupMenu = pmnPictures
    TabOrder = 0
  end
  object grbPicture: TGroupBox
    Left = 392
    Top = 8
    Width = 153
    Height = 353
    Caption = 'Selected picture'
    TabOrder = 1
    object cbItemPicture: TCheckBox
      Left = 8
      Top = 24
      Width = 113
      Height = 17
      Caption = 'Use as item picture'
      TabOrder = 0
    end
    object cbPackagePicture: TCheckBox
      Left = 8
      Top = 48
      Width = 137
      Height = 17
      Caption = 'Use as package picture'
      TabOrder = 1
    end
    object btnLoadThumbnail: TButton
      Left = 8
      Top = 248
      Width = 137
      Height = 25
      Caption = 'Load thumbnail....'
      TabOrder = 2
    end
    object btnExportPicture: TButton
      Left = 8
      Top = 288
      Width = 137
      Height = 25
      Caption = 'Export picture...'
      TabOrder = 3
    end
    object btnExportThumbnail: TButton
      Left = 8
      Top = 320
      Width = 137
      Height = 25
      Caption = 'Export thumbnail...'
      TabOrder = 4
    end
  end
  object pmnPictures: TPopupMenu
    Left = 8
  end
end
