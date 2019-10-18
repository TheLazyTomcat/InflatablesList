object frmItemFrame: TfrmItemFrame
  Left = 0
  Top = 0
  Width = 601
  Height = 652
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  OnResize = FrameResize
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 601
    Height = 652
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object shpTotalPriceSelectedBcgr: TShape
      Left = 517
      Top = 634
      Width = 80
      Height = 18
      Brush.Color = clYellow
      Pen.Style = psClear
    end
    object shpUnitPriceSelectedBcgr: TShape
      Left = 309
      Top = 634
      Width = 80
      Height = 18
      Brush.Color = clYellow
      Pen.Style = psClear
    end
    object shpItemTitleBcgr: TShape
      Left = 0
      Top = 0
      Width = 601
      Height = 145
      Pen.Style = psClear
    end
    object shpPictureBBcgr: TShape
      Left = 404
      Top = 36
      Width = 81
      Height = 81
      Brush.Style = bsClear
      Pen.Color = clSilver
      Pen.Style = psDot
    end
    object shpPictureABcgr: TShape
      Left = 300
      Top = 36
      Width = 81
      Height = 81
      Brush.Style = bsClear
      Pen.Color = clSilver
      Pen.Style = psDot
    end
    object lblWantedLevel: TLabel
      Left = 0
      Top = 312
      Width = 98
      Height = 13
      Caption = 'Wanted level (0..7):'
    end
    object lblSizeZ: TLabel
      Left = 272
      Top = 352
      Width = 59
      Height = 13
      Caption = 'Size Z [mm]:'
    end
    object lblSizeY: TLabel
      Left = 136
      Top = 352
      Width = 59
      Height = 13
      Caption = 'Size Y [mm]:'
    end
    object lblSizeX: TLabel
      Left = 0
      Top = 352
      Width = 59
      Height = 13
      Caption = 'Size X [mm]:'
    end
    object lblNotes: TLabel
      Left = 0
      Top = 392
      Width = 32
      Height = 13
      Caption = 'Notes:'
    end
    object lblManufacturer: TLabel
      Left = 0
      Top = 192
      Width = 69
      Height = 13
      Caption = 'Manufacturer:'
    end
    object lblItemType: TLabel
      Left = 0
      Top = 152
      Width = 51
      Height = 13
      Caption = 'Item type:'
    end
    object lblID: TLabel
      Left = 504
      Top = 192
      Width = 64
      Height = 13
      Caption = 'Numerical ID:'
    end
    object lblUnitDefaultPrice: TLabel
      Left = 0
      Top = 552
      Width = 87
      Height = 13
      Caption = 'Default price [K'#269']:'
    end
    object imgManufacturerLogo: TImage
      Left = 4
      Top = 28
      Width = 256
      Height = 96
      Center = True
    end
    object imgPictureB: TImage
      Tag = 131072
      Left = 396
      Top = 28
      Width = 96
      Height = 96
      Center = True
      PopupMenu = pmnPicturesMenu
      OnClick = imgPictureClick
    end
    object imgPictureA: TImage
      Tag = 196608
      Left = 292
      Top = 28
      Width = 96
      Height = 96
      Center = True
      PopupMenu = pmnPicturesMenu
      OnClick = imgPictureClick
    end
    object bvlInfoSep: TBevel
      Left = 0
      Top = 598
      Width = 601
      Height = 9
      Shape = bsTopLine
    end
    object lblPieces: TLabel
      Left = 536
      Top = 152
      Width = 34
      Height = 13
      Caption = 'Pieces:'
    end
    object lblTimeOfAddition: TLabel
      Left = 514
      Top = 128
      Width = 83
      Height = 13
      Alignment = taRightJustify
      Caption = 'lblTimeOfAddition'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object lblUnitWeight: TLabel
      Left = 408
      Top = 352
      Width = 55
      Height = 13
      Caption = 'Weight [g]:'
    end
    object lblTotalWeightTitle: TLabel
      Left = 450
      Top = 604
      Width = 63
      Height = 13
      Alignment = taRightJustify
      Caption = 'Total weight:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblTotalWeight: TLabel
      Left = 520
      Top = 604
      Width = 73
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lblTotalWeight'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblTotalPriceLowestTitle: TLabel
      Left = 425
      Top = 620
      Width = 88
      Height = 13
      Alignment = taRightJustify
      Caption = 'Total price lowest:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblTotalPriceLowest: TLabel
      Left = 520
      Top = 620
      Width = 73
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lblTotalPriceLowest'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblTotalPriceSelectedTitle: TLabel
      Left = 399
      Top = 636
      Width = 114
      Height = 13
      Alignment = taRightJustify
      Caption = 'Total price selected:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTotalPriceSelected: TLabel
      Left = 520
      Top = 636
      Width = 73
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lblTotalPriceSelected'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lblUnitPriceLowestTitle: TLabel
      Left = 222
      Top = 620
      Width = 83
      Height = 13
      Alignment = taRightJustify
      Caption = 'Unit price lowest:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblUnitPriceLowest: TLabel
      Left = 312
      Top = 620
      Width = 73
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lblUnitPriceLowest'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblUnitPriceSelectedTitle: TLabel
      Left = 197
      Top = 636
      Width = 108
      Height = 13
      Alignment = taRightJustify
      Caption = 'Unit price selected:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblAvailPiecesTitle: TLabel
      Left = 225
      Top = 604
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Caption = 'Available pieces:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblAvailPieces: TLabel
      Left = 312
      Top = 604
      Width = 73
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lblAvailPieces'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblSelectedShopTitle: TLabel
      Left = 26
      Top = 604
      Width = 71
      Height = 13
      Alignment = taRightJustify
      Caption = 'Selected shop:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblSelectedShop: TLabel
      Left = 104
      Top = 604
      Width = 75
      Height = 13
      Caption = 'lblSelectedShop'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblUnitPriceSelected: TLabel
      Left = 312
      Top = 636
      Width = 73
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lblUnitPriceSelected'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lblShopCountTitle: TLabel
      Left = 12
      Top = 620
      Width = 85
      Height = 13
      Alignment = taRightJustify
      Caption = 'Number of shops:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblShopCount: TLabel
      Left = 104
      Top = 620
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lblShopCount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblNotesEdit: TLabel
      Left = 297
      Top = 388
      Width = 16
      Height = 19
      Alignment = taRightJustify
      Caption = '2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -16
      Font.Name = 'Webdings'
      Font.Style = []
      ParentFont = False
      OnClick = lblNotesEditClick
      OnMouseEnter = lblNotesEditMouseEnter
      OnMouseLeave = lblNotesEditMouseLeave
    end
    object lblMaterial: TLabel
      Left = 408
      Top = 312
      Width = 42
      Height = 13
      Caption = 'Material:'
    end
    object lblThickness: TLabel
      Left = 504
      Top = 352
      Width = 75
      Height = 13
      Caption = 'Thickness ['#283'm]:'
      Font.Charset = GREEK_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblUniqueID: TLabel
      Left = 0
      Top = 128
      Width = 77
      Height = 14
      Caption = 'lblUniqueID'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object shpPictureCBcgr: TShape
      Left = 508
      Top = 36
      Width = 81
      Height = 81
      Brush.Style = bsClear
      Pen.Color = clSilver
      Pen.Style = psDot
    end
    object imgPictureC: TImage
      Tag = 65536
      Left = 500
      Top = 28
      Width = 96
      Height = 96
      Center = True
      PopupMenu = pmnPicturesMenu
      OnClick = imgPictureClick
    end
    object lblRating: TLabel
      Left = 112
      Top = 552
      Width = 97
      Height = 13
      Caption = 'Rating (0..100)[%]:'
    end
    object shpFiller: TShape
      Left = 0
      Top = 634
      Width = 193
      Height = 17
      Brush.Color = clSilver
      Brush.Style = bsFDiagonal
      Pen.Style = psClear
      Visible = False
    end
    object lblItemTitleShadow: TLabel
      Left = 1
      Top = 1
      Width = 601
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = 'lblItemTitleShadow'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 14211288
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      Layout = tlCenter
    end
    object lblItemTitle: TLabel
      Left = 0
      Top = 0
      Width = 601
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = 'lblItemTitle'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      Layout = tlCenter
      OnClick = lblItemTitleClick
    end
    object seWantedLevel: TSpinEdit
      Left = 0
      Top = 328
      Width = 129
      Height = 22
      MaxLength = 1
      MaxValue = 7
      MinValue = 0
      TabOrder = 8
      Value = 0
      OnChange = seWantedLevelChange
    end
    object seSizeZ: TSpinEdit
      Left = 272
      Top = 368
      Width = 129
      Height = 22
      MaxValue = 100000
      MinValue = 0
      TabOrder = 13
      Value = 0
      OnChange = seSizeZChange
    end
    object seSizeY: TSpinEdit
      Left = 136
      Top = 368
      Width = 129
      Height = 22
      MaxValue = 100000
      MinValue = 0
      TabOrder = 12
      Value = 0
      OnChange = seSizeYChange
    end
    object seSizeX: TSpinEdit
      Left = 0
      Top = 368
      Width = 129
      Height = 22
      MaxValue = 100000
      MinValue = 0
      TabOrder = 11
      Value = 0
      OnChange = seSizeXChange
    end
    object seID: TSpinEdit
      Left = 504
      Top = 208
      Width = 97
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 6
      Value = 0
      OnChange = seIDChange
    end
    object seUnitPriceDefault: TSpinEdit
      Left = 0
      Top = 568
      Width = 105
      Height = 22
      MaxValue = 268435455
      MinValue = 0
      TabOrder = 25
      Value = 0
      OnChange = seUnitPriceDefaultChange
    end
    object meNotes: TMemo
      Left = 0
      Top = 408
      Width = 313
      Height = 141
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 16
      WordWrap = False
      OnKeyPress = meNotesKeyPress
    end
    object leManufacturerString: TLabeledEdit
      Left = 168
      Top = 208
      Width = 225
      Height = 21
      EditLabel.Width = 99
      EditLabel.Height = 13
      EditLabel.Caption = 'Manufacturer string:'
      TabOrder = 4
      OnChange = leManufacturerStringChange
    end
    object leItemPictureFile: TLabeledEdit
      Left = 320
      Top = 448
      Width = 256
      Height = 21
      EditLabel.Width = 79
      EditLabel.Height = 13
      EditLabel.Caption = 'Item picture file:'
      TabOrder = 19
      OnChange = leItemPictureFileChange
    end
    object leVariant: TLabeledEdit
      Left = 136
      Top = 328
      Width = 265
      Height = 21
      EditLabel.Width = 163
      EditLabel.Height = 13
      EditLabel.Caption = 'Variant (color, pattern, type, ...):'
      TabOrder = 9
      OnChange = leVariantChange
    end
    object leItemTypeSpecification: TLabeledEdit
      Left = 168
      Top = 168
      Width = 361
      Height = 21
      EditLabel.Width = 173
      EditLabel.Height = 13
      EditLabel.Caption = 'Item type specification (eg. animal):'
      TabOrder = 1
      OnChange = leItemTypeSpecificationChange
    end
    object lePackagePictureFile: TLabeledEdit
      Left = 320
      Top = 528
      Width = 256
      Height = 21
      EditLabel.Width = 97
      EditLabel.Height = 13
      EditLabel.Caption = 'Package picture file:'
      TabOrder = 23
      OnChange = lePackagePictureFileChange
    end
    object gbFlagsTags: TGroupBox
      Left = 0
      Top = 232
      Width = 601
      Height = 73
      Caption = 'Flags and tags'
      TabOrder = 7
      object bvlTagSep: TBevel
        Left = 432
        Top = 16
        Width = 9
        Height = 49
        Shape = bsLeftLine
      end
      object lblTextTag: TLabel
        Left = 454
        Top = 18
        Width = 59
        Height = 13
        Alignment = taRightJustify
        BiDiMode = bdLeftToRight
        Caption = 'Textual tag:'
        ParentBiDiMode = False
      end
      object lblNumTag: TLabel
        Left = 444
        Top = 46
        Width = 69
        Height = 13
        Alignment = taRightJustify
        Caption = 'Numerical tag:'
      end
      object cbFlagOwned: TCheckBox
        Tag = 1
        Left = 8
        Top = 16
        Width = 65
        Height = 17
        Caption = 'Owned'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
        OnClick = CommonFlagClick
      end
      object cbFlagWanted: TCheckBox
        Tag = 2
        Left = 96
        Top = 16
        Width = 65
        Height = 17
        Caption = 'Wanted'
        TabOrder = 1
        OnClick = CommonFlagClick
      end
      object cbFlagOrdered: TCheckBox
        Tag = 3
        Left = 184
        Top = 16
        Width = 65
        Height = 17
        Caption = 'Ordered'
        TabOrder = 2
        OnClick = CommonFlagClick
      end
      object cbFlagUntested: TCheckBox
        Tag = 6
        Left = 8
        Top = 32
        Width = 65
        Height = 17
        Caption = 'Untested'
        TabOrder = 5
        OnClick = CommonFlagClick
      end
      object cbFlagTesting: TCheckBox
        Tag = 7
        Left = 96
        Top = 32
        Width = 57
        Height = 17
        Caption = 'Testing'
        TabOrder = 6
        OnClick = CommonFlagClick
      end
      object cbFlagTested: TCheckBox
        Tag = 8
        Left = 184
        Top = 32
        Width = 65
        Height = 17
        Caption = 'Tested'
        TabOrder = 7
        OnClick = CommonFlagClick
      end
      object cbFlagBoxed: TCheckBox
        Tag = 4
        Left = 272
        Top = 16
        Width = 57
        Height = 17
        Caption = 'Boxed'
        TabOrder = 3
        OnClick = CommonFlagClick
      end
      object cbFlagDamaged: TCheckBox
        Tag = 9
        Left = 272
        Top = 32
        Width = 73
        Height = 17
        Caption = 'Damaged'
        TabOrder = 8
        OnClick = CommonFlagClick
      end
      object cbFlagRepaired: TCheckBox
        Tag = 10
        Left = 352
        Top = 32
        Width = 65
        Height = 17
        Caption = 'Repaired'
        TabOrder = 9
        OnClick = CommonFlagClick
      end
      object cbFlagElsewhere: TCheckBox
        Tag = 5
        Left = 352
        Top = 16
        Width = 73
        Height = 17
        Caption = 'Elsewhere'
        TabOrder = 4
        OnClick = CommonFlagClick
      end
      object cbFlagPriceChange: TCheckBox
        Tag = 11
        Left = 8
        Top = 48
        Width = 89
        Height = 17
        Caption = 'Price change'
        TabOrder = 10
        OnClick = CommonFlagClick
      end
      object cbFlagAvailChange: TCheckBox
        Tag = 12
        Left = 96
        Top = 48
        Width = 89
        Height = 17
        Caption = 'Avail. change'
        TabOrder = 11
        OnClick = CommonFlagClick
      end
      object cbFlagNotAvailable: TCheckBox
        Tag = 13
        Left = 184
        Top = 48
        Width = 89
        Height = 17
        Caption = 'Not available'
        TabOrder = 12
        OnClick = CommonFlagClick
      end
      object cbFlagLost: TCheckBox
        Tag = 14
        Left = 272
        Top = 48
        Width = 49
        Height = 17
        Caption = 'Lost'
        TabOrder = 13
        OnClick = CommonFlagClick
      end
      object cbFlagDiscarded: TCheckBox
        Tag = 15
        Left = 352
        Top = 48
        Width = 73
        Height = 17
        Caption = 'Discarded'
        TabOrder = 14
        OnClick = CommonFlagClick
      end
      object seNumTag: TSpinEdit
        Left = 520
        Top = 43
        Width = 73
        Height = 22
        MaxLength = 6
        MaxValue = 99999
        MinValue = -99999
        TabOrder = 16
        Value = 0
        OnChange = seNumTagChange
      end
      object eTextTag: TEdit
        Left = 520
        Top = 15
        Width = 73
        Height = 21
        MaxLength = 10
        TabOrder = 15
        OnChange = eTextTagChange
      end
    end
    object cmbManufacturer: TComboBox
      Left = 0
      Top = 208
      Width = 161
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      OnChange = cmbManufacturerChange
    end
    object cmbItemType: TComboBox
      Left = 0
      Top = 168
      Width = 161
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = cmbItemTypeChange
    end
    object btnUpdateShops: TButton
      Left = 384
      Top = 566
      Width = 105
      Height = 25
      Caption = 'Update shops...'
      TabOrder = 27
      OnClick = btnUpdateShopsClick
    end
    object btnShops: TButton
      Left = 496
      Top = 566
      Width = 105
      Height = 25
      Caption = 'Shops...'
      TabOrder = 28
      OnClick = btnShopsClick
    end
    object btnBrowseItemPictureFile: TButton
      Left = 576
      Top = 448
      Width = 25
      Height = 21
      Hint = 'Select item picture file...'
      Caption = '...'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 20
      OnClick = btnBrowseItemPictureFileClick
    end
    object btnBrowsePackagePictureFile: TButton
      Left = 576
      Top = 528
      Width = 25
      Height = 21
      Hint = 'Select package picture file...'
      Caption = '...'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 24
      OnClick = btnBrowsePackagePictureFileClick
    end
    object sePieces: TSpinEdit
      Left = 536
      Top = 168
      Width = 65
      Height = 22
      MaxValue = 268435455
      MinValue = 1
      TabOrder = 2
      Value = 1
      OnChange = sePiecesChange
    end
    object leReviewURL: TLabeledEdit
      Left = 320
      Top = 408
      Width = 256
      Height = 21
      EditLabel.Width = 61
      EditLabel.Height = 13
      EditLabel.Caption = 'Review URL:'
      TabOrder = 17
      OnChange = leReviewURLChange
    end
    object btnReviewOpen: TButton
      Left = 576
      Top = 408
      Width = 25
      Height = 21
      Hint = 'Open review URL in web browser'
      Caption = '>'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 18
      OnClick = btnReviewOpenClick
    end
    object seUnitWeight: TSpinEdit
      Left = 408
      Top = 368
      Width = 89
      Height = 22
      MaxValue = 2147483647
      MinValue = 0
      TabOrder = 14
      Value = 0
      OnChange = seUnitWeightChange
    end
    object cmbMaterial: TComboBox
      Left = 408
      Top = 328
      Width = 193
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 10
    end
    object seThickness: TSpinEdit
      Left = 504
      Top = 368
      Width = 97
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 15
      Value = 0
    end
    object leTextID: TLabeledEdit
      Left = 400
      Top = 208
      Width = 97
      Height = 21
      EditLabel.Width = 54
      EditLabel.Height = 13
      EditLabel.Caption = 'Textual ID:'
      TabOrder = 5
      OnChange = leTextIDChange
    end
    object leSecondaryPictureFile: TLabeledEdit
      Left = 320
      Top = 488
      Width = 256
      Height = 21
      EditLabel.Width = 108
      EditLabel.Height = 13
      EditLabel.Caption = 'Secondary picture file:'
      TabOrder = 21
      OnChange = leSecondaryPictureFileChange
    end
    object btnBrowseSecondaryPictureFile: TButton
      Left = 576
      Top = 488
      Width = 25
      Height = 21
      Hint = 'Select secondary picture file...'
      Caption = '...'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 22
      OnClick = btnBrowseSecondaryPictureFileClick
    end
    object seRating: TSpinEdit
      Left = 112
      Top = 568
      Width = 105
      Height = 22
      MaxLength = 3
      MaxValue = 100
      MinValue = 0
      TabOrder = 26
      Value = 0
      OnChange = seRatingChange
    end
    object Button1: TButton
      Left = 0
      Top = 0
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 29
      Visible = False
      OnClick = Button1Click
    end
  end
  object diaPicOpenDialog: TOpenDialog
    Filter = 'BMP image files|*.bmp|All files|*.*'
    Top = 96
  end
  object pmnPicturesMenu: TPopupMenu
    OnPopup = pmnPicturesMenuPopup
    Left = 64
    Top = 96
    object mniPM_ReplacePic: TMenuItem
      Caption = 'Replace picture...'
      OnClick = mniPM_ReplacePicClick
    end
    object mniPM_LoadItemPic: TMenuItem
      Caption = 'Load item picture...'
      OnClick = mniPM_LoadItemPicClick
    end
    object mniPM_LoadSecondaryPic: TMenuItem
      Caption = 'Load secondary picture...'
      OnClick = mniPM_LoadSecondaryPicClick
    end
    object mniPM_LoadPackagePic: TMenuItem
      Caption = 'Load package picture...'
      OnClick = mniPM_LoadPackagePicClick
    end
    object mniPM_ExportPic: TMenuItem
      Caption = 'Export picture...'
      OnClick = mniPM_ExportPicClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mniPM_RemovePic: TMenuItem
      Caption = 'Remove picture'
      OnClick = mniPM_RemovePicClick
    end
    object mniPM_RemoveItemPic: TMenuItem
      Caption = 'Remove item picture'
      OnClick = mniPM_RemoveItemPicClick
    end
    object mniPM_RemoveSecondaryPic: TMenuItem
      Caption = 'Remove secondary picture'
      OnClick = mniPM_RemoveSecondaryPicClick
    end
    object mniPM_RemovePackagePic: TMenuItem
      Caption = 'Remove package picture'
      OnClick = mniPM_RemovePackagePicClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mniPM_SwapItemPic: TMenuItem
      Caption = 'Swap with item picture'
      OnClick = mniPM_SwapItemPicClick
    end
    object mniPM_SwapSecondaryPic: TMenuItem
      Caption = 'Swap with secondary picture'
      OnClick = mniPM_SwapSecondaryPicClick
    end
    object mniPM_SwapPackagePic: TMenuItem
      Caption = 'Swap with package picture'
      OnClick = mniPM_SwapPackagePicClick
    end
  end
  object diaPicExport: TSaveDialog
    DefaultExt = 'BMP'
    Filter = 'BMP image files|*.bmp|All files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 32
    Top = 96
  end
end
