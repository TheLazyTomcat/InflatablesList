object fMainForm: TfMainForm
  Left = 2
  Top = 9
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
  Position = poScreenCenter
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
    Left = 640
    Top = 8
    Width = 617
    Height = 673
    Anchors = [akTop, akRight, akBottom]
    Caption = 'Item details'
    TabOrder = 1
    DesignSize = (
      617
      673)
    inline frmItemFrame: TfrmItemFrame
      Left = 8
      Top = 16
      Width = 601
      Height = 652
      Anchors = [akLeft, akTop, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
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
        Width = 100
      end
      item
        Alignment = taRightJustify
        Style = psOwnerDraw
        Width = 320
      end
      item
        Alignment = taCenter
        Style = psOwnerDraw
        Width = 160
      end
      item
        Width = 390
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
    Width = 625
    Height = 646
    Style = lbOwnerDrawFixed
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
    Width = 593
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
    Left = 601
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
    Left = 617
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
    Left = 128
  end
  object alShortcuts: TActionList
    Left = 32
    object acItemShops: TAction
      Category = 'item'
      Caption = 'acItemShops'
      ShortCut = 16464
      OnExecute = acItemShopsExecute
    end
    object acItemExport: TAction
      Category = 'item'
      Caption = 'acItemExport'
      ShortCut = 16453
      OnExecute = acItemExportExecute
    end
    object acItemExportMulti: TAction
      Category = 'item'
      Caption = 'acItemExportMulti'
      ShortCut = 49221
      OnExecute = acItemExportMultiExecute
    end
    object acItemImport: TAction
      Category = 'item'
      Caption = 'acItemImport'
      ShortCut = 16457
      OnExecute = acItemImportExecute
    end
    object acFind: TAction
      Category = 'search'
      Caption = 'acFind'
      ShortCut = 16454
      OnExecute = acFindExecute
    end
    object acFindPrev: TAction
      Category = 'search'
      Caption = 'acFindPrev'
      ShortCut = 8306
      OnExecute = acFindPrevExecute
    end
    object acFindNext: TAction
      Category = 'search'
      Caption = 'acFindNext'
      ShortCut = 114
      OnExecute = acFindNextExecute
    end
    object acSortSett: TAction
      Category = 'sorting'
      Caption = 'acSortSett'
      OnExecute = acSortSettExecute
    end
    object acSortRev: TAction
      Category = 'sorting'
      Caption = 'acSortRev'
      ShortCut = 16466
      OnExecute = acSortRevExecute
    end
    object acSortCase: TAction
      Category = 'sorting'
      Caption = 'acSortCase'
      OnExecute = acSortCaseExecute
    end
    object acSort: TAction
      Category = 'sorting'
      Caption = 'acSort'
      ShortCut = 16463
      OnExecute = acSortExecute
    end
    object acUpdateItem: TAction
      Category = 'update'
      Caption = 'acUpdateItem'
      ShortCut = 16469
      OnExecute = acUpdateItemExecute
    end
    object acUpdateAll: TAction
      Category = 'update'
      Caption = 'acUpdateAll'
      ShortCut = 49237
      OnExecute = acUpdateAllExecute
    end
    object acUpdateWanted: TAction
      Category = 'update'
      Caption = 'acUpdateWanted'
      OnExecute = acUpdateWantedExecute
    end
    object acUpdateSelected: TAction
      Category = 'update'
      Caption = 'acUpdateSelected'
      OnExecute = acUpdateSelectedExecute
    end
    object acUpdateItemShopHistory: TAction
      Category = 'update'
      Caption = 'acUpdateItemShopHistory'
      ShortCut = 16456
      OnExecute = acUpdateItemShopHistoryExecute
    end
    object acUpdateShopsHistory: TAction
      Category = 'update'
      Caption = 'acUpdateShopsHistory'
      ShortCut = 49224
      OnExecute = acUpdateShopsHistoryExecute
    end
    object acSums: TAction
      Category = 'list'
      Caption = 'acSums'
      ShortCut = 16461
      OnExecute = acSumsExecute
    end
    object acOverview: TAction
      Category = 'list'
      Caption = 'acOverview'
      ShortCut = 16471
      OnExecute = acOverviewExecute
    end
    object acSelection: TAction
      Category = 'tools'
      Caption = 'acSelection'
      ShortCut = 16468
      OnExecute = acSelectionExecute
    end
    object acNotes: TAction
      Category = 'list'
      Caption = 'acNotes'
      ShortCut = 16462
      OnExecute = acNotesExecute
    end
    object acSave: TAction
      Category = 'file'
      Caption = 'acSave'
      ShortCut = 16467
      OnExecute = acSaveExecute
    end
    object acSpecials: TAction
      Category = 'tools'
      Caption = 'acSpecials'
      ShortCut = 16460
      OnExecute = acSpecialsExecute
    end
    object acExit: TAction
      Category = 'file'
      Caption = 'acExit'
      ShortCut = 16472
      OnExecute = acExitExecute
    end
    object acSortBy_0: TAction
      Category = 'sorting_by'
      Caption = 'acSortBy_0'
      OnExecute = acSortByCommonExecute
    end
    object acSortBy_1: TAction
      Tag = 1
      Category = 'sorting_by'
      Caption = 'acSortBy_1'
      OnExecute = acSortByCommonExecute
    end
    object acSortBy_2: TAction
      Tag = 2
      Category = 'sorting_by'
      Caption = 'acSortBy_2'
      OnExecute = acSortByCommonExecute
    end
    object acSortBy_3: TAction
      Tag = 3
      Category = 'sorting_by'
      Caption = 'acSortBy_3'
      OnExecute = acSortByCommonExecute
    end
    object acSortBy_4: TAction
      Tag = 4
      Category = 'sorting_by'
      Caption = 'acSortBy_4'
      OnExecute = acSortByCommonExecute
    end
    object acSortBy_5: TAction
      Tag = 5
      Category = 'sorting_by'
      Caption = 'acSortBy_5'
      OnExecute = acSortByCommonExecute
    end
    object acSortBy_6: TAction
      Tag = 6
      Category = 'sorting_by'
      Caption = 'acSortBy_6'
      OnExecute = acSortByCommonExecute
    end
    object acSortBy_7: TAction
      Tag = 7
      Category = 'sorting_by'
      Caption = 'acSortBy_7'
      OnExecute = acSortByCommonExecute
    end
    object acSortBy_8: TAction
      Tag = 8
      Category = 'sorting_by'
      Caption = 'acSortBy_8'
      OnExecute = acSortByCommonExecute
    end
    object acSortBy_9: TAction
      Tag = 9
      Category = 'sorting_by'
      Caption = 'acSortBy_9'
      OnExecute = acSortByCommonExecute
    end
    object acAdvSearch: TAction
      Category = 'search'
      Caption = 'acAdvSearch'
      ShortCut = 49222
      OnExecute = acAdvSearchExecute
    end
  end
  object diaItemsImport: TOpenDialog
    Filter = 'Exported items (*.lei)|*.lei|All files (*.*)|*.*'
    Title = 'Items import'
    Left = 64
  end
  object diaItemsExport: TSaveDialog
    DefaultExt = 'LEI'
    Filter = 'Exported items (*.lei)|*.lei|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Items export'
    Left = 96
  end
  object mmMainMenu: TMainMenu
    object mniMM_File: TMenuItem
      Caption = 'File'
      OnClick = mniMM_FileClick
      object mniMMF_ListCompress: TMenuItem
        Caption = 'Compress list file'
        OnClick = mniMMF_ListCompressClick
      end
      object mniMMF_ListEncrypt: TMenuItem
        Caption = 'Encrypt list file'
        OnClick = mniMMF_ListEncryptClick
      end
      object mniMMF_ListPassword: TMenuItem
        Caption = 'Change list password...'
        OnClick = mniMMF_ListPasswordClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mniMMF_SaveOnClose: TMenuItem
        Caption = 'Save on close'
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
        ShortCut = 45
        OnClick = mniMML_AddClick
      end
      object mniMML_AddCopy: TMenuItem
        Caption = 'Add copy of selected item'
        ShortCut = 16429
        OnClick = mniMML_AddCopyClick
      end
      object mniMML_Remove: TMenuItem
        Caption = 'Remove selected item'
        ShortCut = 46
        OnClick = mniMML_RemoveClick
      end
      object mniMML_Clear: TMenuItem
        Caption = 'Clear the entire list'
        ShortCut = 16430
        OnClick = mniMML_ClearClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mniMML_Sums: TMenuItem
        Caption = 'Sums...'
        ShortCut = 16461
        OnClick = mniMML_SumsClick
      end
      object mniMML_Overview: TMenuItem
        Caption = 'Selected shops overview...'
        ShortCut = 16471
        OnClick = mniMML_OverviewClick
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
      object mniMMI_ItemShops: TMenuItem
        Caption = 'Item shops...'
        ShortCut = 16464
        OnClick = mniMMI_ItemShopsClick
      end
      object mniMMI_ItemExport: TMenuItem
        Caption = 'Export item...'
        ShortCut = 16453
        OnClick = mniMMI_ItemExportClick
      end
      object mniMMI_ItemExportMulti: TMenuItem
        Caption = 'Export multiple items...'
        ShortCut = 49221
        OnClick = mniMMI_ItemExportMultiClick
      end
      object mniMMI_ItemImport: TMenuItem
        Caption = 'Import items...'
        ShortCut = 16457
        OnClick = mniMMI_ItemImportClick
      end
      object N4: TMenuItem
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
        Enabled = False
        ShortCut = 49222
        OnClick = mniMMS_AdvSearchClick
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
        Caption = 'Reversed sort'
        ShortCut = 16466
        OnClick = mniMMO_SortRevClick
      end
      object mniMMO_SortCase: TMenuItem
        Caption = 'Case sensitive sort'
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
      object N5: TMenuItem
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
      object mniMMT_Selection: TMenuItem
        Caption = 'Shop selection...'
        ShortCut = 16468
        OnClick = mniMMT_SelectionClick
      end
      object mniMMT_Specials: TMenuItem
        Caption = 'Special functions...'
        ShortCut = 16460
        OnClick = mniMMT_SpecialsClick
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
      object N6: TMenuItem
        Caption = '-'
      end
      object mniMMH_About: TMenuItem
        Caption = 'About the program...'
        OnClick = mniMMH_AboutClick
      end
    end
  end
end
