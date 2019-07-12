object fMainForm: TfMainForm
  Left = 14
  Top = 104
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Inflatables List'
  ClientHeight = 675
  ClientWidth = 1232
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object gbDetails: TGroupBox
    Left = 640
    Top = 8
    Width = 585
    Height = 641
    Caption = 'Item details'
    TabOrder = 1
    inline frmItemFrame: TfrmItemFrame
      Left = 8
      Top = 16
      Width = 569
      Height = 613
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
    Top = 656
    Width = 1232
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Width = 100
      end
      item
        Width = 540
      end
      item
        Alignment = taRightJustify
        Width = 50
      end>
  end
  object lbList: TListBox
    Left = 8
    Top = 8
    Width = 625
    Height = 610
    Style = lbOwnerDrawFixed
    IntegralHeight = True
    ItemHeight = 101
    PopupMenu = pmnListMenu
    TabOrder = 0
    OnClick = lbListClick
    OnDblClick = lbListDblClick
    OnDrawItem = lbListDrawItem
    OnMouseDown = lbListMouseDown
  end
  object eSearchFor: TEdit
    Left = 8
    Top = 627
    Width = 593
    Height = 21
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
    Top = 627
    Width = 16
    Height = 21
    Caption = '3'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Webdings'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnFindPrevClick
  end
  object btnFindNext: TButton
    Left = 617
    Top = 627
    Width = 16
    Height = 21
    Caption = '4'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Webdings'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnFindNextClick
  end
  object pmnListMenu: TPopupMenu
    OnPopup = pmnListMenuPopup
    Left = 32
    object mniLM_Add: TMenuItem
      Caption = 'Add new item'
      ShortCut = 45
      OnClick = mniLM_AddClick
    end
    object mniLM_AddCopy: TMenuItem
      Caption = 'Add copy of selected item'
      ShortCut = 16429
      OnClick = mniLM_AddCopyClick
    end
    object mniLM_Remove: TMenuItem
      Caption = 'Remove selected item'
      ShortCut = 46
      OnClick = mniLM_RemoveClick
    end
    object mniLM_Clear: TMenuItem
      Caption = 'Clear the entire list'
      ShortCut = 16430
      OnClick = mniLM_ClearClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mniLM_MoveBeginning: TMenuItem
      Caption = 'Move item to the beginning'
      OnClick = mniLM_MoveBeginningClick
    end
    object mniLM_MoveUpBy: TMenuItem
      Caption = 'Move item up by 10 places'
      OnClick = mniLM_MoveUpByClick
    end
    object mniLM_MoveUp: TMenuItem
      Caption = 'Move item up'
      OnClick = mniLM_MoveUpClick
    end
    object mniLM_MoveDown: TMenuItem
      Caption = 'Move item down'
      OnClick = mniLM_MoveDownClick
    end
    object mniLM_MoveDownBy: TMenuItem
      Caption = 'Move item down by 10 places'
      OnClick = mniLM_MoveDownByClick
    end
    object mniLM_MoveEnd: TMenuItem
      Caption = 'Move item to the end'
      OnClick = mniLM_MoveEndClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mniLM_ItemShops: TMenuItem
      Caption = 'Item shops...'
      ShortCut = 16464
      OnClick = mniLM_ItemShopsClick
    end
    object mniLM_ItemExport: TMenuItem
      Caption = 'Export item...'
      ShortCut = 16453
      OnClick = mniLM_ItemExportClick
    end
    object mniLM_ItemExportMulti: TMenuItem
      Caption = 'Export multiple items...'
      ShortCut = 49221
      OnClick = mniLM_ItemExportMultiClick
    end
    object mniLM_ItemImport: TMenuItem
      Caption = 'Import items...'
      ShortCut = 16457
      OnClick = mniLM_ItemImportClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object mniLM_Find: TMenuItem
      Caption = 'Find...'
      ShortCut = 16454
      OnClick = mniLM_FindClick
    end
    object mniLM_FindPrev: TMenuItem
      Caption = 'Find previous'
      ShortCut = 8306
      OnClick = mniLM_FindPrevClick
    end
    object mniLM_FindNext: TMenuItem
      Caption = 'Find next'
      ShortCut = 114
      OnClick = mniLM_FindNextClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object mniLM_SortSett: TMenuItem
      Caption = 'Sorting settings...'
      OnClick = mniLM_SortSettClick
    end
    object mniLM_SortRev: TMenuItem
      Caption = 'Reversed sort'
      ShortCut = 16466
      OnClick = mniLM_SortRevClick
    end
    object mniLM_Sort: TMenuItem
      Caption = 'Sort'
      ShortCut = 16463
      OnClick = mniLM_SortClick
    end
    object mniLM_SortBy: TMenuItem
      Caption = 'Sort by profile'
      object mniLM_SB_Default: TMenuItem
        Tag = -2
        Caption = 'default'
        OnClick = mniLM_SortByClick
      end
      object mniLM_SB_Actual: TMenuItem
        Tag = -1
        Caption = 'actual'
        OnClick = mniLM_SortByClick
      end
      object N1_1: TMenuItem
        Tag = -100
        Caption = '-'
      end
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object mniLM_UpdateItem: TMenuItem
      Caption = 'Update item shops...'
      ShortCut = 16469
      OnClick = mniLM_UpdateItemClick
    end
    object mniLM_UpdateAll: TMenuItem
      Caption = 'Update all shops...'
      ShortCut = 49237
      OnClick = mniLM_UpdateAllClick
    end
    object mniLM_UpdateWanted: TMenuItem
      Caption = 'Update shops of wanted items...'
      OnClick = mniLM_UpdateWantedClick
    end
    object mniLM_UpdateSelected: TMenuItem
      Caption = 'Update selected shops...'
      OnClick = mniLM_UpdateSelectedClick
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object mniLM_UpdateItemShopHistory: TMenuItem
      Caption = 'Update item shops history'
      ShortCut = 16456
      OnClick = mniLM_UpdateItemShopHistoryClick
    end
    object mniLM_UpdateShopsHistory: TMenuItem
      Caption = 'Update all shops history'
      ShortCut = 49224
      OnClick = mniLM_UpdateShopsHistoryClick
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object mniLM_Sums: TMenuItem
      Caption = 'Sums...'
      ShortCut = 16461
      OnClick = mniLM_SumsClick
    end
    object mniLM_Overview: TMenuItem
      Caption = 'Selected shops overview...'
      ShortCut = 16471
      OnClick = mniLM_OverviewClick
    end
    object mniLM_Selection: TMenuItem
      Caption = 'Shop selection table...'
      Enabled = False
      ShortCut = 16468
      OnClick = mniLM_SelectionClick
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object mniLM_Notes: TMenuItem
      Caption = 'Notes...'
      ShortCut = 16462
      OnClick = mniLM_NotesClick
    end
    object mniLM_Save: TMenuItem
      Caption = 'Save now'
      ShortCut = 16467
      OnClick = mniLM_SaveClick
    end
    object mniLM_Specials: TMenuItem
      Caption = 'Special functions...'
      ShortCut = 16460
      OnClick = mniLM_SpecialsClick
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object mniLM_Exit: TMenuItem
      Caption = 'Close without saving'
      ShortCut = 16472
      OnClick = mniLM_ExitClick
    end
  end
  object oXPManifest: TXPManifest
  end
  object alShortcuts: TActionList
    Left = 64
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
      Category = 'global'
      Caption = 'acSums'
      ShortCut = 16461
      OnExecute = acSumsExecute
    end
    object acOverview: TAction
      Category = 'global'
      Caption = 'acOverview'
      ShortCut = 16471
      OnExecute = acOverviewExecute
    end
    object acSelection: TAction
      Category = 'global'
      Caption = 'acSelection'
      ShortCut = 16468
      OnExecute = acSelectionExecute
    end
    object acNotes: TAction
      Category = 'global'
      Caption = 'acNotes'
      ShortCut = 16462
      OnExecute = acNotesExecute
    end
    object acSave: TAction
      Category = 'global'
      Caption = 'acSave'
      ShortCut = 16467
      OnExecute = acSaveExecute
    end
    object acSpecials: TAction
      Category = 'global'
      Caption = 'acSpecials'
      ShortCut = 16460
      OnExecute = acSpecialsExecute
    end
    object acExit: TAction
      Category = 'global'
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
  end
  object diaItemsImport: TOpenDialog
    Filter = 'Exported items (*.lei)|*.lei|All files (*.*)|*.*'
    Title = 'Items import'
    Left = 128
  end
  object diaItemsExport: TSaveDialog
    DefaultExt = 'LEI'
    Filter = 'Exported items (*.lei)|*.lei|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Items export'
    Left = 96
  end
end
