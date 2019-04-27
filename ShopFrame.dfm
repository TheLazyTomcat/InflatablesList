object frmShopFrame: TfrmShopFrame
  Left = 0
  Top = 0
  Width = 729
  Height = 410
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
    Width = 729
    Height = 410
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
      Width = 49
      Height = 13
      Caption = 'Price [K'#269']:'
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
      Top = 376
      Width = 729
      Height = 9
      Shape = bsTopLine
    end
    object leShopName: TLabeledEdit
      Left = 0
      Top = 16
      Width = 289
      Height = 21
      EditLabel.Width = 57
      EditLabel.Height = 13
      EditLabel.Caption = 'Shop name:'
      TabOrder = 0
      OnChange = leShopNameChange
    end
    object cbShopSelected: TCheckBox
      Left = 296
      Top = 18
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
      TabOrder = 2
    end
    object btnShopURLOpen: TButton
      Left = 336
      Top = 56
      Width = 25
      Height = 21
      Caption = '>'
      TabOrder = 3
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
      TabOrder = 4
      OnChange = leShopItemURLChange
    end
    object btnShopItemURLOpen: TButton
      Left = 336
      Top = 96
      Width = 25
      Height = 21
      Caption = '>'
      TabOrder = 5
      OnClick = btnShopItemURLOpenClick
    end
    object seAvailable: TSpinEdit
      Left = 0
      Top = 136
      Width = 152
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 6
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
      TabOrder = 9
      Value = 0
      OnChange = sePriceChange
    end
    object bgParsing: TGroupBox
      Left = 368
      Top = 0
      Width = 361
      Height = 329
      Caption = 'Parsing'
      TabOrder = 12
      object lblParsingAvailExtractMethod: TLabel
        Left = 104
        Top = 16
        Width = 108
        Height = 13
        Caption = 'Avail. extract method:'
      end
      object lblParsingPriceExtractMethod: TLabel
        Left = 232
        Top = 16
        Width = 104
        Height = 13
        Caption = 'Price extract method:'
      end
      object leParsingMoreThanTag: TLabeledEdit
        Left = 8
        Top = 32
        Width = 89
        Height = 21
        EditLabel.Width = 80
        EditLabel.Height = 13
        EditLabel.Caption = '"More than" tag:'
        TabOrder = 0
      end
      object cmbParsingAvailExtractMethod: TComboBox
        Left = 104
        Top = 32
        Width = 121
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
      end
      object cmbParsingPriceExtractMethod: TComboBox
        Left = 232
        Top = 32
        Width = 121
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
      end
      object tcParsingStages: TTabControl
        Left = 8
        Top = 56
        Width = 345
        Height = 265
        TabOrder = 3
        Tabs.Strings = (
          'Available'
          'Price')
        TabIndex = 0
        OnChange = tcParsingStagesChange
        inline frmParsingFrame: TfrmParsingFrame
          Left = 8
          Top = 24
          Width = 329
          Height = 233
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object btnUpdate: TButton
      Left = 496
      Top = 384
      Width = 113
      Height = 25
      Caption = 'Update this shop'
      TabOrder = 14
      OnClick = btnUpdateClick
    end
    object lvAvailHistory: TListView
      Left = 0
      Top = 176
      Width = 177
      Height = 193
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
      TabOrder = 8
      ViewStyle = vsReport
    end
    object lvPriceHistory: TListView
      Left = 184
      Top = 176
      Width = 177
      Height = 193
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
      TabOrder = 11
      ViewStyle = vsReport
    end
    object leLastUpdateMsg: TLabeledEdit
      Left = 368
      Top = 347
      Width = 361
      Height = 21
      EditLabel.Width = 106
      EditLabel.Height = 13
      EditLabel.Caption = 'Last update message:'
      ReadOnly = True
      TabOrder = 13
    end
    object btnTemplates: TButton
      Left = 616
      Top = 384
      Width = 113
      Height = 25
      Caption = 'Shop templates...'
      TabOrder = 15
      OnClick = btnTemplatesClick
    end
    object btnAvailToHistory: TButton
      Left = 152
      Top = 136
      Width = 25
      Height = 21
      Caption = '6'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Webdings'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = btnAvailToHistoryClick
    end
    object btnPriceToHistory: TButton
      Left = 336
      Top = 136
      Width = 25
      Height = 21
      Caption = '6'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Webdings'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      OnClick = btnPriceToHistoryClick
    end
  end
  object pmnHistory: TPopupMenu
    OnPopup = pmnHistoryPopup
    Left = 168
    Top = 344
    object mniHI_Remove: TMenuItem
      Caption = 'Remove selected entry'
      ShortCut = 46
      OnClick = mniHI_RemoveClick
    end
    object mniHI_Clear: TMenuItem
      Caption = 'Clear the history'
      ShortCut = 16430
      OnClick = mniHI_ClearClick
    end
  end
end
