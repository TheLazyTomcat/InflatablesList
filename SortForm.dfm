object fSortForm: TfSortForm
  Left = 307
  Top = 136
  BorderStyle = bsDialog
  Caption = 'Sorting settings'
  ClientHeight = 440
  ClientWidth = 960
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
  object lblSortBy: TLabel
    Left = 288
    Top = 8
    Width = 104
    Height = 13
    Caption = 'Sort by values (-/30):'
  end
  object lblAvailable: TLabel
    Left = 664
    Top = 8
    Width = 81
    Height = 13
    Caption = 'Available values:'
  end
  object bvlSplitter: TBevel
    Left = 8
    Top = 400
    Width = 945
    Height = 9
    Shape = bsTopLine
  end
  object lblProfiles: TLabel
    Left = 8
    Top = 8
    Width = 39
    Height = 13
    Caption = 'Profiles:'
  end
  object lbSortBy: TListBox
    Left = 288
    Top = 24
    Width = 289
    Height = 368
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    IntegralHeight = True
    ItemHeight = 14
    ParentFont = False
    TabOrder = 5
    OnDblClick = lbSortByDblClick
  end
  object lbAvailable: TListBox
    Left = 664
    Top = 24
    Width = 289
    Height = 368
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    IntegralHeight = True
    ItemHeight = 14
    ParentFont = False
    TabOrder = 11
    OnDblClick = lbAvailableDblClick
  end
  object btnMoveUp: TButton
    Left = 584
    Top = 128
    Width = 73
    Height = 25
    Caption = 'Move up'
    TabOrder = 6
    OnClick = btnMoveUpClick
  end
  object btnAdd: TButton
    Left = 592
    Top = 160
    Width = 57
    Height = 25
    Hint = 'Add value to sorting'
    Caption = '<<'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    OnClick = btnAddClick
  end
  object btnToggleOrder: TButton
    Left = 600
    Top = 192
    Width = 41
    Height = 25
    Hint = 'Toggle reverse'
    Caption = '+/-'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    OnClick = btnToggleOrderClick
  end
  object btnRemove: TButton
    Left = 592
    Top = 224
    Width = 57
    Height = 25
    Hint = 'Remove value from sorting'
    Caption = '>>'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    OnClick = btnRemoveClick
  end
  object btnMoveDown: TButton
    Left = 584
    Top = 256
    Width = 73
    Height = 25
    Caption = 'Move down'
    TabOrder = 10
    OnClick = btnMoveDownClick
  end
  object btnClose: TButton
    Left = 864
    Top = 408
    Width = 89
    Height = 25
    Caption = 'Close'
    TabOrder = 14
    OnClick = btnCloseClick
  end
  object btnSort: TButton
    Left = 768
    Top = 408
    Width = 89
    Height = 25
    Caption = 'Sort and close'
    TabOrder = 13
    OnClick = btnSortClick
  end
  object lbProfiles: TListBox
    Left = 8
    Top = 24
    Width = 185
    Height = 368
    IntegralHeight = True
    ItemHeight = 13
    PopupMenu = pmnProfiles
    TabOrder = 0
    OnClick = lbProfilesClick
    OnDblClick = lbProfilesDblClick
    OnMouseDown = lbProfilesMouseDown
  end
  object btnProfileLoad: TButton
    Left = 200
    Top = 144
    Width = 81
    Height = 25
    Caption = 'Load >>'
    TabOrder = 1
    OnClick = btnProfileLoadClick
  end
  object btnProfileSave: TButton
    Left = 200
    Top = 240
    Width = 81
    Height = 25
    Caption = '<< Save'
    TabOrder = 4
    OnClick = btnProfileSaveClick
  end
  object btnLoadDefault: TButton
    Left = 200
    Top = 176
    Width = 81
    Height = 25
    Caption = 'Load default'
    TabOrder = 2
    OnClick = btnLoadDefaultClick
  end
  object cbSortRev: TCheckBox
    Left = 672
    Top = 412
    Width = 89
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Reversed sort'
    TabOrder = 12
  end
  object btnClear: TButton
    Left = 200
    Top = 208
    Width = 81
    Height = 25
    Caption = 'Clear'
    TabOrder = 3
    OnClick = btnClearClick
  end
  object pmnProfiles: TPopupMenu
    OnPopup = pmnProfilesPopup
    Left = 160
    Top = 8
    object pmi_PR_Add: TMenuItem
      Caption = 'Add new profile...'
      ShortCut = 45
      OnClick = pmi_PR_AddClick
    end
    object pmi_PR_Rename: TMenuItem
      Caption = 'Rename selected profile...'
      ShortCut = 113
      OnClick = pmi_PR_RenameClick
    end
    object pmi_PR_Remove: TMenuItem
      Caption = 'Remove selected profile'
      ShortCut = 46
      OnClick = pmi_PR_RemoveClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object pmi_PR_MoveUp: TMenuItem
      Caption = 'Move up'
      OnClick = pmi_PR_MoveUpClick
    end
    object pmi_PR_MoveDown: TMenuItem
      Caption = 'Move down'
      OnClick = pmi_PR_MoveDownClick
    end
  end
end
