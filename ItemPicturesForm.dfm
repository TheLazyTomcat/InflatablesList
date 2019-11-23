object fItemPicturesForm: TfItemPicturesForm
  Left = 706
  Top = 116
  BorderStyle = bsDialog
  Caption = 'fItemPicturesForm'
  ClientHeight = 560
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
  object lblPictures: TLabel
    Left = 8
    Top = 8
    Width = 48
    Height = 13
    Caption = 'lblPictures'
  end
  object lbPictures: TListBox
    Left = 8
    Top = 24
    Width = 537
    Height = 529
    Style = lbOwnerDrawFixed
    IntegralHeight = True
    ItemHeight = 35
    PopupMenu = pmnPictures
    TabOrder = 0
    OnClick = lbPicturesClick
    OnDblClick = lbPicturesDblClick
    OnDrawItem = lbPicturesDrawItem
    OnMouseDown = lbPicturesMouseDown
  end
  object pmnPictures: TPopupMenu
    OnPopup = pmnPicturesPopup
    Left = 520
    object mniIP_Add: TMenuItem
      Caption = 'Add pictures...'
      ShortCut = 45
      OnClick = mniIP_AddClick
    end
    object mniIP_LoadThumb: TMenuItem
      Caption = 'Load thumbnail for selected picture...'
      ShortCut = 8237
      OnClick = mniIP_LoadThumbClick
    end
    object mniIP_AddWithThumb: TMenuItem
      Caption = 'Add picture with thumbnail...'
      ShortCut = 16429
      OnClick = mniIP_AddWithThumbClick
    end
    object mniIP_Remove: TMenuItem
      Caption = 'Remove selected picture'
      ShortCut = 46
      OnClick = mniIP_RemoveClick
    end
    object mniIP_RemoveAll: TMenuItem
      Caption = 'Remove all pictures'
      ShortCut = 8238
      OnClick = mniIP_RemoveAllClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mniIP_ExportPic: TMenuItem
      Caption = 'Export picture...'
      ShortCut = 16453
      OnClick = mniIP_ExportPicClick
    end
    object mniIP_ExportThumb: TMenuItem
      Caption = 'Export thumbnail...'
      OnClick = mniIP_ExportThumbClick
    end
    object mniIP_ExportPicAll: TMenuItem
      Caption = 'Export all pictures...'
      OnClick = mniIP_ExportPicAllClick
    end
    object mniIP_ExportThumbAll: TMenuItem
      Caption = 'Export all thumbnails...'
      OnClick = mniIP_ExportThumbAllClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mniIP_ItemPicture: TMenuItem
      Caption = 'Item picture'
      ShortCut = 16457
      OnClick = mniIP_ItemPictureClick
    end
    object mniIP_PackagePicture: TMenuItem
      Caption = 'Package picture'
      ShortCut = 16464
      OnClick = mniIP_PackagePictureClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object mniIP_MoveUp: TMenuItem
      Caption = 'Move up'
      OnClick = mniIP_MoveUpClick
    end
    object mniIP_MoveDown: TMenuItem
      Caption = 'Move down'
      OnClick = mniIP_MoveDownClick
    end
  end
  object diaOpenDialog: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 456
  end
  object diaSaveDialog: TSaveDialog
    Left = 488
  end
end
