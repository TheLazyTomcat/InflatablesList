object frmShopFrame: TfrmShopFrame
  Left = 0
  Top = 0
  Width = 889
  Height = 378
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 889
    Height = 378
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = True
    TabOrder = 0
    object lblAvailable: TLabel
      Left = 0
      Top = 120
      Width = 77
      Height = 13
      Caption = 'Available count:'
    end
    object lblPrice: TLabel
      Left = 184
      Top = 120
      Width = 54
      Height = 13
      Caption = 'Price [%s]:'
    end
    object lblAvailHistory: TLabel
      Left = 0
      Top = 160
      Width = 83
      Height = 13
      Caption = 'Available history:'
    end
    object lblPriceHistory: TLabel
      Left = 184
      Top = 160
      Width = 63
      Height = 13
      Caption = 'Price history:'
    end
    object bvlSplit: TBevel
      Left = 0
      Top = 344
      Width = 889
      Height = 9
      Shape = bsTopLine
    end
    object lblNotes: TLabel
      Left = 368
      Top = 0
      Width = 32
      Height = 13
      Caption = 'Notes:'
    end
    object lblNotesEdit: TLabel
      Left = 853
      Top = -4
      Width = 16
      Height = 19
      Hint = 'Open editor...'
      Alignment = taRightJustify
      Caption = '2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -16
      Font.Name = 'Webdings'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = lblNotesEditClick
      OnMouseEnter = lblNotesEditMouseEnter
      OnMouseLeave = lblNotesEditMouseLeave
    end
    object lblLastUpdateTime: TLabel
      Left = 802
      Top = 299
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Caption = 'lblLastUpdateTime'
    end
    object leShopName: TLabeledEdit
      Left = 0
      Top = 16
      Width = 185
      Height = 21
      EditLabel.Width = 57
      EditLabel.Height = 13
      EditLabel.Caption = 'Shop name:'
      TabOrder = 0
      OnChange = leShopNameChange
    end
    object cbShopSelected: TCheckBox
      Left = 200
      Top = 8
      Width = 65
      Height = 17
      Caption = 'Selected'
      TabOrder = 1
      OnClick = cbShopSelectedClick
    end
    object leShopURL: TLabeledEdit
      Left = 0
      Top = 56
      Width = 336
      Height = 21
      EditLabel.Width = 50
      EditLabel.Height = 13
      EditLabel.Caption = 'Shop URL:'
      TabOrder = 4
    end
    object btnShopURLOpen: TButton
      Left = 336
      Top = 56
      Width = 25
      Height = 21
      Hint = 'Open shop URL in web browser'
      Caption = '>'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = btnShopURLOpenClick
    end
    object leShopItemURL: TLabeledEdit
      Left = 0
      Top = 96
      Width = 336
      Height = 21
      EditLabel.Width = 48
      EditLabel.Height = 13
      EditLabel.Caption = 'Item URL:'
      TabOrder = 6
      OnChange = leShopItemURLChange
    end
    object btnShopItemURLOpen: TButton
      Left = 336
      Top = 96
      Width = 25
      Height = 21
      Hint = 'Open item URL in web browser'
      Caption = '>'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = btnShopItemURLOpenClick
    end
    object seAvailable: TSpinEdit
      Left = 0
      Top = 136
      Width = 152
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 8
      Value = 0
      OnChange = seAvailableChange
    end
    object sePrice: TSpinEdit
      Left = 184
      Top = 136
      Width = 152
      Height = 22
      MaxValue = 2147483647
      MinValue = 0
      TabOrder = 11
      Value = 0
      OnChange = sePriceChange
    end
    object btnUpdate: TButton
      Left = 656
      Top = 352
      Width = 113
      Height = 25
      Caption = 'Update this shop'
      TabOrder = 18
      OnClick = btnUpdateClick
    end
    object lvAvailHistory: TListView
      Left = 0
      Top = 176
      Width = 177
      Height = 161
      Columns = <
        item
          Caption = 'Time'
          Width = 100
        end
        item
          Alignment = taRightJustify
          Caption = 'Count'
        end>
      ColumnClick = False
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      PopupMenu = pmnHistory
      TabOrder = 10
      ViewStyle = vsReport
    end
    object lvPriceHistory: TListView
      Left = 184
      Top = 176
      Width = 177
      Height = 161
      Columns = <
        item
          Caption = 'Time'
          Width = 100
        end
        item
          Alignment = taRightJustify
          Caption = 'Price'
        end>
      ColumnClick = False
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      PopupMenu = pmnHistory
      TabOrder = 13
      ViewStyle = vsReport
    end
    object leLastUpdateMsg: TLabeledEdit
      Left = 368
      Top = 315
      Width = 521
      Height = 21
      EditLabel.Width = 106
      EditLabel.Height = 13
      EditLabel.Caption = 'Last update message:'
      ReadOnly = True
      TabOrder = 17
    end
    object btnTemplates: TButton
      Left = 776
      Top = 352
      Width = 113
      Height = 25
      Caption = 'Shop templates...'
      TabOrder = 19
      OnClick = btnTemplatesClick
    end
    object btnAvailToHistory: TButton
      Left = 152
      Top = 136
      Width = 25
      Height = 21
      Hint = 'Add available count to history'
      Caption = '6'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Webdings'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      OnClick = btnAvailToHistoryClick
    end
    object btnPriceToHistory: TButton
      Left = 336
      Top = 136
      Width = 25
      Height = 21
      Hint = 'Add price to history'
      Caption = '6'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Webdings'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 12
      OnClick = btnPriceToHistoryClick
    end
    object meNotes: TMemo
      Left = 368
      Top = 16
      Width = 521
      Height = 97
      ScrollBars = ssBoth
      TabOrder = 14
      WordWrap = False
      OnKeyPress = meNotesKeyPress
    end
    object gbParsing: TGroupBox
      Left = 368
      Top = 120
      Width = 521
      Height = 177
      Caption = 'Parsing'
      TabOrder = 16
      object bvlVarsSep: TBevel
        Left = 8
        Top = 100
        Width = 505
        Height = 9
        Shape = bsTopLine
      end
      object lblParsTemplRef: TLabel
        Left = 8
        Top = 104
        Width = 134
        Height = 13
        Caption = 'Parsing template reference:'
      end
      object leParsVar_0: TLabeledEdit
        Left = 8
        Top = 32
        Width = 121
        Height = 21
        EditLabel.Width = 97
        EditLabel.Height = 13
        EditLabel.Caption = 'Parsing variable #0:'
        TabOrder = 0
      end
      object leParsVar_1: TLabeledEdit
        Left = 136
        Top = 32
        Width = 121
        Height = 21
        EditLabel.Width = 97
        EditLabel.Height = 13
        EditLabel.Caption = 'Parsing variable #1:'
        TabOrder = 1
      end
      object leParsVar_2: TLabeledEdit
        Left = 264
        Top = 32
        Width = 121
        Height = 21
        EditLabel.Width = 97
        EditLabel.Height = 13
        EditLabel.Caption = 'Parsing variable #2:'
        TabOrder = 2
      end
      object leParsVar_3: TLabeledEdit
        Left = 392
        Top = 32
        Width = 121
        Height = 21
        EditLabel.Width = 97
        EditLabel.Height = 13
        EditLabel.Caption = 'Parsing variable #3:'
        TabOrder = 3
      end
      object leParsVar_4: TLabeledEdit
        Left = 8
        Top = 72
        Width = 121
        Height = 21
        EditLabel.Width = 97
        EditLabel.Height = 13
        EditLabel.Caption = 'Parsing variable #4:'
        TabOrder = 4
      end
      object leParsVar_5: TLabeledEdit
        Left = 136
        Top = 72
        Width = 121
        Height = 21
        EditLabel.Width = 97
        EditLabel.Height = 13
        EditLabel.Caption = 'Parsing variable #5:'
        TabOrder = 5
      end
      object leParsVar_6: TLabeledEdit
        Left = 264
        Top = 72
        Width = 121
        Height = 21
        EditLabel.Width = 97
        EditLabel.Height = 13
        EditLabel.Caption = 'Parsing variable #6:'
        TabOrder = 6
      end
      object leParsVar_7: TLabeledEdit
        Left = 392
        Top = 72
        Width = 121
        Height = 21
        EditLabel.Width = 97
        EditLabel.Height = 13
        EditLabel.Caption = 'Parsing variable #7:'
        TabOrder = 7
      end
      object btnParsAvail: TButton
        Left = 232
        Top = 118
        Width = 137
        Height = 25
        Caption = 'Available count parsing'
        TabOrder = 10
        OnClick = btnParsAvailClick
      end
      object btnParsPrice: TButton
        Left = 376
        Top = 118
        Width = 137
        Height = 25
        Caption = 'Price parsing'
        TabOrder = 11
        OnClick = btnParsPriceClick
      end
      object cbParsDisableErrs: TCheckBox
        Left = 8
        Top = 152
        Width = 177
        Height = 17
        Caption = 'Disable raising of parsing errors'
        TabOrder = 12
      end
      object cmbParsTemplRef: TComboBox
        Left = 8
        Top = 120
        Width = 193
        Height = 21
        AutoComplete = False
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 8
        OnChange = cmbParsTemplRefChange
      end
      object btnParsCopyToLocal: TButton
        Left = 204
        Top = 118
        Width = 25
        Height = 25
        Hint = 'Copy available and price parsing settings from template to local'
        Caption = '>>'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        OnClick = btnParsCopyToLocalClick
      end
    end
    object cbShopUntracked: TCheckBox
      Left = 272
      Top = 8
      Width = 73
      Height = 17
      Caption = 'Untracked'
      TabOrder = 2
      OnClick = cbShopUntrackedClick
    end
    object cbShopAltDownMethod: TCheckBox
      Left = 200
      Top = 30
      Width = 161
      Height = 17
      Caption = 'Alternative download method'
      TabOrder = 3
    end
    object btnPredefNotes: TButton
      Left = 873
      Top = 0
      Width = 16
      Height = 16
      Hint = 'Predefined messages'
      Caption = '6'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Webdings'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 15
      OnClick = btnPredefNotesClick
    end
  end
  object pmnHistory: TPopupMenu
    OnPopup = pmnHistoryPopup
    Left = 168
    Top = 312
    object mniHI_Remove: TMenuItem
      Caption = 'Remove selected entry'
      OnClick = mniHI_RemoveClick
    end
    object mniHI_Clear: TMenuItem
      Caption = 'Clear the history'
      OnClick = mniHI_ClearClick
    end
  end
  object pmnPredefNotes: TPopupMenu
    Alignment = paRight
    Left = 816
  end
end
