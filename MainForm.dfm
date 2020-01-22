object fMainForm: TfMainForm
  Left = 9
  Top = 21
  BorderStyle = bsSingle
  Caption = 'Inflatables List'
  ClientHeight = 707
  ClientWidth = 1264
  Color = clBtnFace
  Constraints.MinHeight = 761
  Constraints.MinWidth = 1272
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = mmMainMenu
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    1264
    707)
  PixelsPerInch = 96
  TextHeight = 13
  object shpListFiller: TShape
    Left = 8
    Top = 616
    Width = 65
    Height = 65
    Brush.Color = clSilver
    Brush.Style = bsFDiagonal
    Pen.Style = psClear
  end
  object gbDetails: TGroupBox
    Left = 616
    Top = 8
    Width = 641
    Height = 673
    Anchors = [akTop, akRight, akBottom]
    Caption = 'Item details'
    TabOrder = 1
    DesignSize = (
      641
      673)
    inline frmItemFrame: TfrmItemFrame
      Left = 8
      Top = 16
      Width = 625
      Height = 652
      Anchors = [akLeft, akTop, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      inherited pnlMain: TPanel
        Height = 652
      end
    end
  end
  object sbStatusBar: TStatusBar
    Left = 0
    Top = 688
    Width = 1264
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Width = 80
      end
      item
        Alignment = taRightJustify
        Style = psOwnerDraw
        Width = 235
      end
      item
        Alignment = taCenter
        Style = psOwnerDraw
        Width = 160
      end
      item
        Width = 450
      end
      item
        Alignment = taRightJustify
        Width = 50
      end>
    OnMouseDown = sbStatusBarMouseDown
    OnDrawPanel = sbStatusBarDrawPanel
  end
  object lbList: TListBox
    Left = 8
    Top = 8
    Width = 601
    Height = 646
    Style = lbOwnerDrawFixed
    AutoComplete = False
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    IntegralHeight = True
    ItemHeight = 107
    ParentFont = False
    TabOrder = 0
    OnClick = lbListClick
    OnDblClick = lbListDblClick
    OnDrawItem = lbListDrawItem
    OnMouseDown = lbListMouseDown
  end
  object eSearchFor: TEdit
    Left = 8
    Top = 659
    Width = 569
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnEnter = eSearchForEnter
    OnExit = eSearchForExit
    OnKeyPress = eSearchForKeyPress
  end
  object btnFindPrev: TButton
    Left = 577
    Top = 659
    Width = 16
    Height = 21
    Hint = 'Find previous'
    Anchors = [akTop, akRight]
    Caption = '3'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Webdings'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = btnFindPrevClick
  end
  object btnFindNext: TButton
    Left = 594
    Top = 659
    Width = 16
    Height = 21
    Hint = 'Find next'
    Anchors = [akTop, akRight]
    Caption = '4'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Webdings'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = btnFindNextClick
  end
  object oXPManifest: TXPManifest
    Left = 96
  end
  object diaItemsImport: TOpenDialog
    Filter = 'Exported items (*.lei)|*.lei|All files (*.*)|*.*'
    Title = 'Items import'
    Left = 32
  end
  object diaItemsExport: TSaveDialog
    DefaultExt = 'LEI'
    Filter = 'Exported items (*.lei)|*.lei|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Items export'
    Left = 64
  end
  object mmMainMenu: TMainMenu
    object mniMM_File: TMenuItem
      Caption = 'File'
      OnClick = mniMM_FileClick
      object mniMMF_ListCompress: TMenuItem
        Caption = 'Compress list file (switch)'
        OnClick = mniMMF_ListCompressClick
      end
      object mniMMF_ListEncrypt: TMenuItem
        Caption = 'Encrypt list file (switch)'
        OnClick = mniMMF_ListEncryptClick
      end
      object mniMMF_ListPassword: TMenuItem
        Caption = 'Change list password...'
        OnClick = mniMMF_ListPasswordClick
      end
      object mniMMF_Backups: TMenuItem
        Caption = 'Backups...'
        ShortCut = 16450
        OnClick = mniMMF_BackupsClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mniMMF_SaveOnClose: TMenuItem
        Caption = 'Save on close (switch)'
        OnClick = mniMMF_SaveOnCloseClick
      end
      object mniMMF_Save: TMenuItem
        Caption = 'Save now'
        ShortCut = 16467
        OnClick = mniMMF_SaveClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mniMMF_Exit: TMenuItem
        Caption = 'Close without saving'
        ShortCut = 16472
        OnClick = mniMMF_ExitClick
      end
    end
    object mniMM_List: TMenuItem
      Caption = 'List'
      OnClick = mniMM_ListClick
      object mniMML_Add: TMenuItem
        Caption = 'Add new item'
        ShortCut = 16429
        OnClick = mniMML_AddClick
      end
      object mniMML_AddCopy: TMenuItem
        Caption = 'Add copy of selected item'
        OnClick = mniMML_AddCopyClick
      end
      object mniMML_Remove: TMenuItem
        Caption = 'Remove selected item'
        ShortCut = 16430
        OnClick = mniMML_RemoveClick
      end
      object mniMML_Clear: TMenuItem
        Caption = 'Clear the entire list'
        OnClick = mniMML_ClearClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mniMML_GoToItemNum: TMenuItem
        Caption = 'Go to item #...'
        ShortCut = 16455
        OnClick = mniMML_GoToItemNumClick
      end
      object mniMML_PrevItem: TMenuItem
        Caption = 'Previous item (keep focus)'
        OnClick = mniMML_PrevItemClick
      end
      object mniMML_NextItem: TMenuItem
        Caption = 'Next item (keep focus)'
        OnClick = mniMML_NextItemClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mniMML_Rename: TMenuItem
        Caption = 'Change list name...'
        ShortCut = 49230
        OnClick = mniMML_RenameClick
      end
      object mniMML_Notes: TMenuItem
        Caption = 'Notes...'
        ShortCut = 16462
        OnClick = mniMML_NotesClick
      end
    end
    object mniMM_Item: TMenuItem
      Caption = 'Item'
      OnClick = mniMM_ItemClick
      object mniMMI_ItemPictures: TMenuItem
        Caption = 'Item pictures...'
        ShortCut = 16464
        OnClick = mniMMI_ItemPicturesClick
      end
      object mniMMI_ItemShops: TMenuItem
        Caption = 'Item shops...'
        ShortCut = 16452
        OnClick = mniMMI_ItemShopsClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object mniMMI_ItemExport: TMenuItem
        Caption = 'Export item...'
        Enabled = False
        ShortCut = 16453
        OnClick = mniMMI_ItemExportClick
      end
      object mniMMI_ItemExportMulti: TMenuItem
        Caption = 'Export multiple items...'
        Enabled = False
        ShortCut = 49221
        OnClick = mniMMI_ItemExportMultiClick
      end
      object mniMMI_ItemImport: TMenuItem
        Caption = 'Import items...'
        Enabled = False
        ShortCut = 16457
        OnClick = mniMMI_ItemImportClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object mniMMI_Encrypted: TMenuItem
        Caption = 'Encrypted item (switch)'
        ShortCut = 16459
        OnClick = mniMMI_EncryptedClick
      end
      object mniMMI_Decrypt: TMenuItem
        Caption = 'Decrypt item'
        ShortCut = 16473
        OnClick = mniMMI_DecryptClick
      end
      object mniMMI_DecryptAll: TMenuItem
        Caption = 'Decrypt all items'
        ShortCut = 49241
        OnClick = mniMMI_DecryptAllClick
      end
      object mniMMI_ChangeItemsPswd: TMenuItem
        Caption = 'Change items encryption password...'
        OnClick = mniMMI_ChangeItemsPswdClick
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object mniMMI_MoveBeginning: TMenuItem
        Caption = 'Move item to the beginning'
        OnClick = mniMMI_MoveBeginningClick
      end
      object mniMMI_MoveUpBy: TMenuItem
        Caption = 'Move item up by 10 places'
        OnClick = mniMMI_MoveUpByClick
      end
      object mniMMI_MoveUp: TMenuItem
        Caption = 'Move item up'
        OnClick = mniMMI_MoveUpClick
      end
      object mniMMI_MoveDown: TMenuItem
        Caption = 'Move item down'
        OnClick = mniMMI_MoveDownClick
      end
      object mniMMI_MoveDownBy: TMenuItem
        Caption = 'Move item down by 10 places'
        OnClick = mniMMI_MoveDownByClick
      end
      object mniMMI_MoveEnd: TMenuItem
        Caption = 'Move item to the end'
        OnClick = mniMMI_MoveEndClick
      end
    end
    object mniMM_Search: TMenuItem
      Caption = 'Search'
      OnClick = mniMM_SearchClick
      object mniMMS_Find: TMenuItem
        Caption = 'Find...'
        ShortCut = 16454
        OnClick = mniMMS_FindClick
      end
      object mniMMS_FindPrev: TMenuItem
        Caption = 'Find previous'
        ShortCut = 8306
        OnClick = mniMMS_FindPrevClick
      end
      object mniMMS_FindNext: TMenuItem
        Caption = 'Find next'
        ShortCut = 114
        OnClick = mniMMS_FindNextClick
      end
      object mniMMS_AdvSearch: TMenuItem
        Caption = 'Advanced search...'
        ShortCut = 49222
        OnClick = mniMMS_AdvSearchClick
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object mniMMS_FindPrevValue: TMenuItem
        Caption = 'Find previous value'
        ShortCut = 24690
        OnClick = mniMMS_FindPrevValueClick
      end
      object mniMMS_FindNextValue: TMenuItem
        Caption = 'Find next value'
        ShortCut = 16498
        OnClick = mniMMS_FindNextValueClick
      end
    end
    object mniMM_Sorting: TMenuItem
      Caption = 'Sorting'
      OnClick = mniMM_SortingClick
      object mniMMO_SortSett: TMenuItem
        Caption = 'Sorting settings...'
        OnClick = mniMMO_SortSettClick
      end
      object mniMMO_SortRev: TMenuItem
        Caption = 'Reversed sort (switch)'
        ShortCut = 16466
        OnClick = mniMMO_SortRevClick
      end
      object mniMMO_SortCase: TMenuItem
        Caption = 'Case sensitive sort (switch)'
        OnClick = mniMMO_SortCaseClick
      end
      object mniMMO_Sort: TMenuItem
        Caption = 'Sort'
        ShortCut = 16463
        OnClick = mniMMO_SortClick
      end
      object mniMMO_SortBy: TMenuItem
        Caption = 'Sort by profile'
        object mniMMO_SB_Default: TMenuItem
          Tag = -2
          Caption = 'default'
          OnClick = mniMMO_SortByClick
        end
        object mniMMO_SB_Actual: TMenuItem
          Tag = -1
          Caption = 'actual'
          OnClick = mniMMO_SortByClick
        end
        object N1_1: TMenuItem
          Tag = -100
          Caption = '-'
        end
      end
    end
    object mniMM_Update: TMenuItem
      Caption = 'Update'
      OnClick = mniMM_UpdateClick
      object mniMMU_UpdateItem: TMenuItem
        Caption = 'Update item shops...'
        ShortCut = 16469
        OnClick = mniMMU_UpdateItemClick
      end
      object mniMMU_UpdateAll: TMenuItem
        Caption = 'Update all shops...'
        ShortCut = 49237
        OnClick = mniMMU_UpdateAllClick
      end
      object mniMMU_UpdateWanted: TMenuItem
        Caption = 'Update shops of wanted items...'
        OnClick = mniMMU_UpdateWantedClick
      end
      object mniMMU_UpdateSelected: TMenuItem
        Caption = 'Update selected shops...'
        OnClick = mniMMU_UpdateSelectedClick
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object mniMMU_UpdateItemShopHistory: TMenuItem
        Caption = 'Update item shops history'
        ShortCut = 16456
        OnClick = mniMMU_UpdateItemShopHistoryClick
      end
      object mniMMU_UpdateShopsHistory: TMenuItem
        Caption = 'Update all shops history'
        ShortCut = 49224
        OnClick = mniMMU_UpdateShopsHistoryClick
      end
    end
    object mniMM_Tools: TMenuItem
      Caption = 'Tools'
      OnClick = mniMM_ToolsClick
      object mniMMT_Sums: TMenuItem
        Caption = 'Sums...'
        ShortCut = 16461
        OnClick = mniMMT_SumsClick
      end
      object mniMMT_Overview: TMenuItem
        Caption = 'Selected shops overview...'
        ShortCut = 16471
        OnClick = mniMMT_OverviewClick
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object mniMMT_Selection: TMenuItem
        Caption = 'Shop selection...'
        ShortCut = 16468
        OnClick = mniMMT_SelectionClick
      end
      object mniMMT_ItemShopTable: TMenuItem
        Caption = 'Item-shop table...'
        ShortCut = 49236
        OnClick = mniMMT_ItemShopTableClick
      end
      object mniMMT_ShopByItems: TMenuItem
        Caption = 'Find shop by items...'
        ShortCut = 16465
        OnClick = mniMMT_ShopByItemsClick
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object mniMMT_Specials: TMenuItem
        Caption = 'Special functions...'
        ShortCut = 16460
        OnClick = mniMMT_SpecialsClick
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object mniMMT_ExportAllPics: TMenuItem
        Caption = 'Export all pictures...'
        OnClick = mniMMT_ExportAllPicsClick
      end
      object mniMMT_ExportAllThumbs: TMenuItem
        Caption = 'Export all thumbnails...'
        OnClick = mniMMT_ExportAllThumbsClick
      end
      object mniMMT_CleanUpPicAutoFolder: TMenuItem
        Caption = 'Clean-up picture automation folder'
        OnClick = mniMMT_CleanUpPicAutoFolderClick
      end
      object mniMMT_CleanUpBackupFolder: TMenuItem
        Caption = 'Clean-up backup folder'
        OnClick = mniMMT_CleanUpBackupFolderClick
      end
    end
    object mniMM_Help: TMenuItem
      Caption = 'Help'
      OnClick = mniMM_HelpClick
      object mniMMH_ResMarkLegend: TMenuItem
        Caption = 'Worst update result mark colors...'
        OnClick = mniMMH_ResMarkLegendClick
      end
      object mniMMH_SettingsLegend: TMenuItem
        Caption = 'Settings tag legend...'
        OnClick = mniMMH_SettingsLegendClick
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object mniMMH_About: TMenuItem
        Caption = 'About the program...'
        OnClick = mniMMH_AboutClick
      end
    end
  end
end
