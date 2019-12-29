object frmItemFrame: TfrmItemFrame
  Left = 0
  Top = 0
  Width = 625
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
    Width = 625
    Height = 652
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      625
      652)
    object shpTotalPriceSelectedBcgr: TShape
      Left = 541
      Top = 634
      Width = 80
      Height = 18
      Anchors = [akLeft, akBottom]
      Brush.Color = clYellow
      Pen.Style = psClear
    end
    object shpUnitPriceSelectedBcgr: TShape
      Left = 325
      Top = 634
      Width = 80
      Height = 18
      Anchors = [akLeft, akBottom]
      Brush.Color = clYellow
      Pen.Style = psClear
    end
    object shpItemTitleBcgr: TShape
      Left = 0
      Top = 0
      Width = 625
      Height = 145
      Pen.Style = psClear
    end
    object lblWantedLevel: TLabel
      Left = 0
      Top = 312
      Width = 98
      Height = 13
      Caption = 'Wanted level (0..7):'
    end
    object lblSizeZ: TLabel
      Left = 520
      Top = 352
      Width = 59
      Height = 13
      Caption = 'Size Z [mm]:'
    end
    object lblSizeY: TLabel
      Left = 408
      Top = 352
      Width = 59
      Height = 13
      Caption = 'Size Y [mm]:'
    end
    object lblSizeX: TLabel
      Left = 296
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
      Left = 520
      Top = 192
      Width = 64
      Height = 13
      Caption = 'Numerical ID:'
    end
    object lblUnitDefaultPrice: TLabel
      Left = 272
      Top = 512
      Width = 87
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Default price [K'#269']:'
    end
    object imgManufacturerLogo: TImage
      Left = 4
      Top = 28
      Width = 256
      Height = 96
      Center = True
    end
    object bvlInfoSep: TBevel
      Left = 0
      Top = 598
      Width = 625
      Height = 9
      Anchors = [akLeft, akBottom]
      Shape = bsTopLine
    end
    object lblPieces: TLabel
      Left = 448
      Top = 152
      Width = 34
      Height = 13
      Caption = 'Pieces:'
    end
    object lblTimeOfAddition: TLabel
      Left = 538
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
      Left = 528
      Top = 312
      Width = 55
      Height = 13
      Caption = 'Weight [g]:'
    end
    object lblTotalWeightTitle: TLabel
      Left = 474
      Top = 604
      Width = 63
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = 'Total weight:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblTotalWeight: TLabel
      Left = 544
      Top = 604
      Width = 73
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
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
      Left = 449
      Top = 620
      Width = 88
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = 'Total price lowest:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblTotalPriceLowest: TLabel
      Left = 544
      Top = 620
      Width = 73
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
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
      Left = 423
      Top = 636
      Width = 114
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = 'Total price selected:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTotalPriceSelected: TLabel
      Left = 544
      Top = 636
      Width = 73
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
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
      Left = 239
      Top = 620
      Width = 83
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = 'Unit price lowest:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblUnitPriceLowest: TLabel
      Left = 328
      Top = 620
      Width = 73
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
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
      Left = 213
      Top = 636
      Width = 108
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = 'Unit price selected:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblAvailPiecesTitle: TLabel
      Left = 241
      Top = 604
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = 'Available pieces:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblAvailPieces: TLabel
      Left = 328
      Top = 604
      Width = 73
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
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
      Left = 34
      Top = 620
      Width = 71
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = 'Selected shop:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblSelectedShop: TLabel
      Left = 112
      Top = 620
      Width = 75
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'lblSelectedShop'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblUnitPriceSelected: TLabel
      Left = 328
      Top = 636
      Width = 73
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
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
      Left = 20
      Top = 636
      Width = 85
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = 'Number of shops:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblShopCount: TLabel
      Left = 112
      Top = 636
      Width = 57
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
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
      Left = 609
      Top = 388
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
    object lblMaterial: TLabel
      Left = 0
      Top = 352
      Width = 42
      Height = 13
      Caption = 'Material:'
    end
    object lblThickness: TLabel
      Left = 192
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
    object lblRating: TLabel
      Left = 392
      Top = 512
      Width = 97
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Rating (0..100)[%]:'
    end
    object lblItemTitleShadow: TLabel
      Left = 25
      Top = 1
      Width = 577
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
      Left = 24
      Top = 0
      Width = 577
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
    object shpHighlight: TShape
      Left = 600
      Top = 0
      Width = 25
      Height = 25
      Brush.Color = clBlue
      Pen.Style = psClear
    end
    object imgItemLock: TImage
      Left = 0
      Top = 2
      Width = 24
      Height = 24
      Picture.Data = {
        07544269746D6170F6060000424DF60600000000000036000000280000001800
        0000180000000100180000000000C0060000C4000000C4000000000000000000
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAEDEDED
        E3E3E3E0E0E0E0E0E0E3E3E3EDEDEDFAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEC
        ECECDBDBDBCBCBCBBFBFBFBABABABABABABFBFBFCBCBCBDBDBDBEDEDEDFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFEFEFEE6E6E6D2D2D2B6B6B6B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B7
        B7B7D2D2D2E6E6E6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFEAEAEAD1D1D1B2B2B2B1B1B1B5B5B5CACACAD7D7D7D7D7
        D7CACACAB4B4B4B1B1B1B2B2B2D1D1D1EAEAEAFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F9F9D8D8D8B5B5B5B1B1B1BFBFBFE8E8E8
        EDEDEDEDEDEDEDEDEDEDEDEDE8E8E8BEBEBEB1B1B1B5B5B5D9D9D9F9F9F9FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8E8E8C6C6C6B1B1B1B8
        B8B8E9E9E9EDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE8E8E8B7B7B7B1B1B1
        C6C6C6E8E8E8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDDDD
        DDB8B8B8B1B1B1D3D3D3EDEDEDEDEDEDEDEDEDF5F5F5F5F5F5EDEDEDEDEDEDED
        EDEDD2D2D2B1B1B1B8B8B8DDDDDDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFCFCFCDBDBDBB2B2B2B1B1B1E4E4E4EDEDEDEDEDEDEDEDEDF5F5F5F5F5
        F5EDEDEDEDEDEDEDEDEDE3E3E3B1B1B1B1B1B1DADADAFCFCFCFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFAFAFAD9D9D9B1B1B1B1B1B1E6E6E6EDEDEDEDEDED
        EEEEEEFDFDFDFDFDFDEEEEEEEDEDEDEDEDEDE6E6E6B1B1B1B1B1B1D9D9D9FAFA
        FAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFDDBDBDBB3B3B3B1B1B1DE
        DEDEEDEDEDEDEDEDF0F0F0FFFFFFFFFFFFF0F0F0EDEDEDEDEDEDDDDDDDB1B1B1
        B4B4B4DBDBDBFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE1E1
        E1BDBDBDB1B1B1C7C7C7EDEDEDEDEDEDEDEDEDF3F3F3F3F3F3EDEDEDEDEDEDED
        EDEDC6C6C6B1B1B1BEBEBEE1E1E1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFEEEEEED0D0D0B1B1B1B2B2B2D7D7D7EDEDEDEDEDEDEDEDEDEDED
        EDEDEDEDEDEDEDD8D8D8B1B1B1B1B1B1D0D0D0EEEEEEFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFDDFDFDFC0C0C0B1B1B1B1B1B1CBCBCB
        E8E8E8EDEDEDEDEDEDE7E7E7CACACAB1B1B1B1B1B1C1C1C1DFDFDFFEFEFEFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5F5F5DBDBDBC0
        C0C0B1B1B1B1B1B1B2B2B2B9B9B9B9B9B9B2B2B2B1B1B1B1B1B1C0C0C0DBDBDB
        F6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFE8E8E8D8D8D8CCCCCCB8B8B8B1B1B1B1B1B1B1B1B1B1B1B1B8B8B8CD
        CDCDD8D8D8E8E8E8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFEDEDEDB7B7B7DFDFDFDDDDDDD6D6D6D1D1D1D1D1
        D1D6D6D6DDDDDDDFDFDFB7B7B7EDEDEDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEDEDEDB3B3B3E4E4E4FEFEFE
        F6F6F6F2F2F2F2F2F2F6F6F6FEFEFEE4E4E4B3B3B3EDEDEDFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFECECECB3
        B3B3E4E4E4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4E4E4B3B3B3ECECEC
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFEBEBEBC0C0C0E3E3E3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE1
        E1E1BABABAE9E9E9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFF2F2F2B1B1B1D6D6D6FFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFD9D9D9B1B1B1F3F3F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEBABABABBBBBBFBFBFB
        FFFFFFFFFFFFFFFFFFFFFFFFFBFBFBBABABABBBBBBFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE0
        E0E0B1B1B1C6C6C6F7F7F7FFFFFFFFFFFFF7F7F7C5C5C5B1B1B1E1E1E1FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFD5D5D5B1B1B1B3B3B3C1C1C1C1C1C1B3B3B3B1B1B1D6
        D6D6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBEBEBC9C9C9BBBBBBBBBB
        BBCACACAEBEBEBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFF}
    end
    object shpPictureABcgr: TShape
      Left = 324
      Top = 36
      Width = 81
      Height = 81
      Brush.Style = bsClear
      Pen.Color = clSilver
      Pen.Style = psDot
    end
    object shpPictureBBcgr: TShape
      Left = 428
      Top = 36
      Width = 81
      Height = 81
      Brush.Style = bsClear
      Pen.Color = clSilver
      Pen.Style = psDot
    end
    object shpPictureCBcgr: TShape
      Left = 532
      Top = 36
      Width = 81
      Height = 81
      Brush.Style = bsClear
      Pen.Color = clSilver
      Pen.Style = psDot
    end
    object imgPictureA: TImage
      Tag = 196608
      Left = 316
      Top = 28
      Width = 96
      Height = 96
      Center = True
      OnClick = imgPictureClick
    end
    object imgPictureB: TImage
      Tag = 131072
      Left = 420
      Top = 28
      Width = 96
      Height = 96
      Center = True
      OnClick = imgPictureClick
    end
    object imgPictureC: TImage
      Tag = 65536
      Left = 524
      Top = 28
      Width = 96
      Height = 96
      Center = True
      OnClick = imgPictureClick
    end
    object imgNextPicture: TImage
      Left = 296
      Top = 48
      Width = 10
      Height = 56
      Hint = 'Next secondary picture'
      AutoSize = True
      ParentShowHint = False
      Picture.Data = {
        07544269746D617036070000424D360700000000000036000000280000000A00
        0000380000000100180000000000000700002702000027020000000000000000
        0000F6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000E3E3E3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000D2D2D2FDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFEBEBEBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFD6D6D6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCF9F9F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCE5E5E5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCD4D4D4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCCCCCCCF5F5F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCCCCCCCE2E2E2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCCCCCCCD1D1D1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCCCCCCCCCCCCCF0F0F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCCFCFCFCCCCCCDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCD7D7D7CCCCCCCECECEFDFDFDFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCDFDFDFCECECECCCCCCEEEEEEFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCE0E0E0D6D6D6CCCCCCDBDBDBFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCE0E0E0DFDFDFCCCCCCCDCDCDFBFBFBFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCE0E0E0E6E6E6CFCFCFCCCCCCEBEBEBFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCE0E0E0E6E6E6D9D9D9CCCCCCDBDBDBFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCE0E0E0E6E6E6E2E2E2CCCCCCCDCDCDFBFBFBFFFFFFFFFFFF
        0000CFCFCFCCCCCCE0E0E0E6E6E6E6E6E6D2D2D2CCCCCCEAEAEAFFFFFFFFFFFF
        0000CFCFCFCCCCCCE0E0E0E6E6E6E6E6E6DADADACCCCCCD9D9D9FFFFFFFFFFFF
        0000CFCFCFCCCCCCE0E0E0E6E6E6E6E6E6E4E4E4CCCCCCCCCCCCFAFAFAFFFFFF
        0000CFCFCFCCCCCCE0E0E0E6E6E6E6E6E6E6E6E6D3D3D3CCCCCCE7E7E7FFFFFF
        0000CFCFCFCCCCCCE0E0E0E6E6E6E6E6E6E6E6E6DBDBDBCCCCCCD6D6D6FFFFFF
        0000CFCFCFCCCCCCE0E0E0E6E6E6E6E6E6E6E6E6E4E4E4CDCDCDCCCCCCF8F8F8
        0000CFCFCFCCCCCCE0E0E0E6E6E6E6E6E6E6E6E6E6E6E6D4D4D4CCCCCCE5E5E5
        0000CFCFCFCCCCCCE0E0E0E6E6E6E6E6E6E6E6E6E6E6E6DDDDDDCCCCCCD4D4D4
        0000CFCFCFCCCCCCE0E0E0E6E6E6E6E6E6E6E6E6E6E6E6DCDCDCCCCCCCD4D4D4
        0000CFCFCFCCCCCCE0E0E0E6E6E6E6E6E6E6E6E6E6E6E6D4D4D4CCCCCCE5E5E5
        0000CFCFCFCCCCCCE0E0E0E6E6E6E6E6E6E6E6E6E5E5E5CCCCCCCCCCCCF8F8F8
        0000CFCFCFCCCCCCE0E0E0E6E6E6E6E6E6E6E6E6DCDCDCCCCCCCD7D7D7FFFFFF
        0000CFCFCFCCCCCCE0E0E0E6E6E6E6E6E6E6E6E6D2D2D2CCCCCCE8E8E8FFFFFF
        0000CFCFCFCCCCCCE0E0E0E6E6E6E6E6E6E3E3E3CDCDCDCCCCCCF9F9F9FFFFFF
        0000CFCFCFCCCCCCE0E0E0E6E6E6E6E6E6DBDBDBCCCCCCD8D8D8FFFFFFFFFFFF
        0000CFCFCFCCCCCCE0E0E0E6E6E6E6E6E6D2D2D2CCCCCCEAEAEAFFFFFFFFFFFF
        0000CFCFCFCCCCCCE0E0E0E6E6E6E2E2E2CCCCCCCCCCCCFAFAFAFFFFFFFFFFFF
        0000CFCFCFCCCCCCE0E0E0E6E6E6D9D9D9CCCCCCD9D9D9FFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCE0E0E0E6E6E6D0D0D0CCCCCCEAEAEAFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCE0E0E0E0E0E0CCCCCCCDCDCDFAFAFAFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCE0E0E0D7D7D7CCCCCCDADADAFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCDFDFDFCECECECCCCCCEDEDEDFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCD8D8D8CCCCCCCECECEFDFDFDFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCCFCFCFCCCCCCDDDDDDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCCCCCCCCCCCCCF0F0F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCCCCCCCD0D0D0FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCCCCCCCE2E2E2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCCCCCCCF4F4F4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCD3D3D3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCE4E4E4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFCCCCCCF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFD6D6D6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000CFCFCFE9E9E9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000D1D1D1FCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000E1E1E1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000F6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000}
      ShowHint = True
      Visible = False
      OnMouseDown = imgNextPictureMouseDown
      OnMouseUp = imgNextPictureMouseUp
    end
    object imgPrevPicture: TImage
      Left = 272
      Top = 48
      Width = 10
      Height = 56
      Hint = 'Previous secondary picture'
      AutoSize = True
      ParentShowHint = False
      Picture.Data = {
        07544269746D617036070000424D360700000000000036000000280000000A00
        0000380000000100180000000000000700002702000027020000000000000000
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5F5F5
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE3E3E3
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBD1D1D1
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE9E9E9CFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD7D7D7CFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8F8CCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5E5E5CCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD3D3D3CCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3F3F3CCCCCCCCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE2E2E2CCCCCCCCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFED0D0D0CCCCCCCCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1F1F1CCCCCCCCCCCCCCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFDFCCCCCCCFCFCFCCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFDFDFDCECECECCCCCCD7D7D7CCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFEDEDEDCCCCCCCECECEDFDFDFCCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFDCDCDCCCCCCCD6D6D6E0E0E0CCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFBFBFBCDCDCDCCCCCCE0E0E0E0E0E0CCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFECECECCCCCCCCFCFCFE6E6E6E0E0E0CCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFDADADACCCCCCD9D9D9E6E6E6E0E0E0CCCCCCCFCFCF
        0000FFFFFFFFFFFFFBFBFBCCCCCCCCCCCCE2E2E2E6E6E6E0E0E0CCCCCCCFCFCF
        0000FFFFFFFFFFFFEAEAEACCCCCCD2D2D2E6E6E6E6E6E6E0E0E0CCCCCCCFCFCF
        0000FFFFFFFFFFFFD7D7D7CCCCCCDBDBDBE6E6E6E6E6E6E0E0E0CCCCCCCFCFCF
        0000FFFFFFFAFAFACCCCCCCCCCCCE4E4E4E6E6E6E6E6E6E0E0E0CCCCCCCFCFCF
        0000FFFFFFE8E8E8CCCCCCD3D3D3E6E6E6E6E6E6E6E6E6E0E0E0CCCCCCCFCFCF
        0000FFFFFFD7D7D7CCCCCCDCDCDCE6E6E6E6E6E6E6E6E6E0E0E0CCCCCCCFCFCF
        0000F8F8F8CCCCCCCDCDCDE4E4E4E6E6E6E6E6E6E6E6E6E0E0E0CCCCCCCFCFCF
        0000E6E6E6CCCCCCD4D4D4E6E6E6E6E6E6E6E6E6E6E6E6E0E0E0CCCCCCCFCFCF
        0000D4D4D4CCCCCCDDDDDDE6E6E6E6E6E6E6E6E6E6E6E6E0E0E0CCCCCCCFCFCF
        0000D4D4D4CCCCCCDDDDDDE6E6E6E6E6E6E6E6E6E6E6E6E0E0E0CCCCCCCFCFCF
        0000E6E6E6CCCCCCD4D4D4E6E6E6E6E6E6E6E6E6E6E6E6E0E0E0CCCCCCCFCFCF
        0000F6F6F6CCCCCCCCCCCCE5E5E5E6E6E6E6E6E6E6E6E6E0E0E0CCCCCCCFCFCF
        0000FFFFFFD6D6D6CCCCCCDCDCDCE6E6E6E6E6E6E6E6E6E0E0E0CCCCCCCFCFCF
        0000FFFFFFE8E8E8CCCCCCD3D3D3E6E6E6E6E6E6E6E6E6E0E0E0CCCCCCCFCFCF
        0000FFFFFFF8F8F8CCCCCCCDCDCDE4E4E4E6E6E6E6E6E6E0E0E0CCCCCCCFCFCF
        0000FFFFFFFFFFFFD7D7D7CCCCCCDBDBDBE6E6E6E6E6E6E0E0E0CCCCCCCFCFCF
        0000FFFFFFFFFFFFE9E9E9CCCCCCD2D2D2E6E6E6E6E6E6E0E0E0CCCCCCCFCFCF
        0000FFFFFFFFFFFFFAFAFACCCCCCCCCCCCE2E2E2E6E6E6E0E0E0CCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFD8D8D8CCCCCCD9D9D9E6E6E6E0E0E0CCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFEBEBEBCCCCCCD0D0D0E6E6E6E0E0E0CCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFAFAFACDCDCDCCCCCCE0E0E0E0E0E0CCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFDBDBDBCCCCCCD7D7D7E0E0E0CCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFECECECCCCCCCCECECEDFDFDFCCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFDFDFDCECECECCCCCCD8D8D8CCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDCDCDCCCCCCCCFCFCFCCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFCCCCCCCCCCCCCCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFECFCFCFCCCCCCCCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE1E1E1CCCCCCCCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2F2F2CCCCCCCCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD2D2D2CCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5E5E5CCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6CCCCCCCFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD7D7D7CFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE9E9E9CFCFCF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBD1D1D1
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE0E0E0
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5F5F5
        0000}
      ShowHint = True
      Visible = False
      OnMouseDown = imgPrevPictureMouseDown
      OnMouseUp = imgPrevPictureMouseUp
    end
    object lblPictureCountTitle: TLabel
      Left = 38
      Top = 604
      Width = 67
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = 'Picture count:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblPictureCount: TLabel
      Left = 112
      Top = 604
      Width = 57
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      AutoSize = False
      Caption = 'lblPictureCount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblRatingDetails: TLabel
      Left = 612
      Top = 509
      Width = 13
      Height = 18
      Hint = 'Rating details not empty'
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #357
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Webdings'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object seWantedLevel: TSpinEdit
      Left = 0
      Top = 328
      Width = 121
      Height = 22
      MaxLength = 1
      MaxValue = 7
      MinValue = 0
      TabOrder = 10
      Value = 0
      OnChange = seWantedLevelChange
    end
    object seSizeZ: TSpinEdit
      Left = 520
      Top = 368
      Width = 105
      Height = 22
      MaxValue = 100000
      MinValue = 0
      TabOrder = 18
      Value = 0
      OnChange = seSizeZChange
    end
    object seSizeY: TSpinEdit
      Left = 408
      Top = 368
      Width = 105
      Height = 22
      MaxValue = 100000
      MinValue = 0
      TabOrder = 17
      Value = 0
      OnChange = seSizeYChange
    end
    object seSizeX: TSpinEdit
      Left = 296
      Top = 368
      Width = 105
      Height = 22
      MaxValue = 100000
      MinValue = 0
      TabOrder = 16
      Value = 0
      OnChange = seSizeXChange
    end
    object seNumID: TSpinEdit
      Left = 520
      Top = 208
      Width = 105
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 8
      Value = 0
      OnChange = seNumIDChange
    end
    object seUnitPriceDefault: TSpinEdit
      Left = 272
      Top = 528
      Width = 113
      Height = 22
      Anchors = [akLeft, akBottom]
      MaxValue = 268435455
      MinValue = 0
      TabOrder = 22
      Value = 0
      OnChange = seUnitPriceDefaultChange
    end
    object meNotes: TMemo
      Left = 0
      Top = 408
      Width = 625
      Height = 101
      Anchors = [akLeft, akTop, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 19
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
      TabOrder = 6
      OnChange = leManufacturerStringChange
    end
    object leVariant: TLabeledEdit
      Left = 128
      Top = 328
      Width = 305
      Height = 21
      EditLabel.Width = 163
      EditLabel.Height = 13
      EditLabel.Caption = 'Variant (color, pattern, type, ...):'
      TabOrder = 11
      OnChange = leVariantChange
    end
    object leItemTypeSpecification: TLabeledEdit
      Left = 168
      Top = 168
      Width = 273
      Height = 21
      EditLabel.Width = 173
      EditLabel.Height = 13
      EditLabel.Caption = 'Item type specification (eg. animal):'
      TabOrder = 1
      OnChange = leItemTypeSpecificationChange
    end
    object gbFlagsTags: TGroupBox
      Left = 0
      Top = 232
      Width = 625
      Height = 73
      Caption = 'Flags and tags'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 9
      object bvlTagSep: TBevel
        Left = 455
        Top = 34
        Width = 9
        Height = 31
        Shape = bsLeftLine
      end
      object lblTextTag: TLabel
        Left = 478
        Top = 18
        Width = 59
        Height = 13
        Alignment = taRightJustify
        BiDiMode = bdLeftToRight
        Caption = 'Textual tag:'
        ParentBiDiMode = False
      end
      object lblNumTag: TLabel
        Left = 468
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
        Width = 57
        Height = 17
        Caption = 'Owned'
        TabOrder = 0
        OnClick = CommonFlagClick
      end
      object cbFlagWanted: TCheckBox
        Tag = 2
        Left = 100
        Top = 16
        Width = 57
        Height = 17
        Caption = 'Wanted'
        TabOrder = 1
        OnClick = CommonFlagClick
      end
      object cbFlagOrdered: TCheckBox
        Tag = 3
        Left = 192
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
        Top = 33
        Width = 65
        Height = 17
        Caption = 'Untested'
        TabOrder = 5
        OnClick = CommonFlagClick
      end
      object cbFlagTesting: TCheckBox
        Tag = 7
        Left = 100
        Top = 33
        Width = 57
        Height = 17
        Caption = 'Testing'
        TabOrder = 6
        OnClick = CommonFlagClick
      end
      object cbFlagTested: TCheckBox
        Tag = 8
        Left = 192
        Top = 33
        Width = 57
        Height = 17
        Caption = 'Tested'
        TabOrder = 7
        OnClick = CommonFlagClick
      end
      object cbFlagBoxed: TCheckBox
        Tag = 4
        Left = 284
        Top = 16
        Width = 49
        Height = 17
        Caption = 'Boxed'
        TabOrder = 3
        OnClick = CommonFlagClick
      end
      object cbFlagDamaged: TCheckBox
        Tag = 9
        Left = 284
        Top = 33
        Width = 65
        Height = 17
        Caption = 'Damaged'
        TabOrder = 8
        OnClick = CommonFlagClick
      end
      object cbFlagRepaired: TCheckBox
        Tag = 10
        Left = 376
        Top = 33
        Width = 65
        Height = 17
        Caption = 'Repaired'
        TabOrder = 9
        OnClick = CommonFlagClick
      end
      object cbFlagElsewhere: TCheckBox
        Tag = 5
        Left = 376
        Top = 16
        Width = 69
        Height = 17
        Caption = 'Elsewhere'
        TabOrder = 4
        OnClick = CommonFlagClick
      end
      object cbFlagPriceChange: TCheckBox
        Tag = 11
        Left = 8
        Top = 50
        Width = 81
        Height = 17
        Caption = 'Price change'
        TabOrder = 10
        OnClick = CommonFlagClick
      end
      object cbFlagAvailChange: TCheckBox
        Tag = 12
        Left = 100
        Top = 50
        Width = 84
        Height = 17
        Caption = 'Avail. change'
        TabOrder = 11
        OnClick = CommonFlagClick
      end
      object cbFlagNotAvailable: TCheckBox
        Tag = 13
        Left = 192
        Top = 50
        Width = 81
        Height = 17
        Caption = 'Not available'
        TabOrder = 12
        OnClick = CommonFlagClick
      end
      object cbFlagLost: TCheckBox
        Tag = 14
        Left = 284
        Top = 50
        Width = 41
        Height = 17
        Caption = 'Lost'
        TabOrder = 13
        OnClick = CommonFlagClick
      end
      object cbFlagDiscarded: TCheckBox
        Tag = 15
        Left = 376
        Top = 50
        Width = 69
        Height = 17
        Caption = 'Discarded'
        TabOrder = 14
        OnClick = CommonFlagClick
      end
      object seNumTag: TSpinEdit
        Left = 544
        Top = 43
        Width = 73
        Height = 22
        MaxLength = 6
        MaxValue = 99999
        MinValue = -99999
        TabOrder = 17
        Value = 0
        OnChange = seNumTagChange
      end
      object eTextTag: TEdit
        Left = 544
        Top = 15
        Width = 73
        Height = 21
        MaxLength = 10
        TabOrder = 16
        OnChange = eTextTagChange
      end
      object btnFlagMacros: TButton
        Left = 448
        Top = 16
        Width = 16
        Height = 16
        Hint = 'Flag macros'
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
        OnClick = btnFlagMacrosClick
      end
    end
    object cmbManufacturer: TComboBox
      Left = 0
      Top = 208
      Width = 161
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 5
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
      Left = 512
      Top = 560
      Width = 113
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Update shops...'
      TabOrder = 27
      OnClick = btnUpdateShopsClick
    end
    object btnShops: TButton
      Left = 392
      Top = 560
      Width = 113
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Shops...'
      TabOrder = 26
      OnClick = btnShopsClick
    end
    object sePieces: TSpinEdit
      Left = 448
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
      Left = 0
      Top = 528
      Width = 240
      Height = 21
      Anchors = [akLeft, akBottom]
      EditLabel.Width = 61
      EditLabel.Height = 13
      EditLabel.Caption = 'Review URL:'
      TabOrder = 20
      OnChange = leReviewURLChange
    end
    object btnReviewOpen: TButton
      Left = 240
      Top = 528
      Width = 25
      Height = 21
      Hint = 'Open review URL in web browser'
      Anchors = [akLeft, akBottom]
      Caption = '>'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 21
      OnClick = btnReviewOpenClick
    end
    object seUnitWeight: TSpinEdit
      Left = 528
      Top = 328
      Width = 97
      Height = 22
      MaxValue = 2147483647
      MinValue = 0
      TabOrder = 13
      Value = 0
      OnChange = seUnitWeightChange
    end
    object cmbMaterial: TComboBox
      Left = 0
      Top = 368
      Width = 185
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 14
    end
    object seThickness: TSpinEdit
      Left = 192
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
      Width = 113
      Height = 21
      EditLabel.Width = 54
      EditLabel.Height = 13
      EditLabel.Caption = 'Textual ID:'
      TabOrder = 7
      OnChange = leTextIDChange
    end
    object seRating: TSpinEdit
      Left = 392
      Top = 528
      Width = 113
      Height = 22
      Anchors = [akLeft, akBottom]
      MaxLength = 3
      MaxValue = 100
      MinValue = 0
      TabOrder = 23
      Value = 0
      OnChange = seRatingChange
    end
    object leUserID: TLabeledEdit
      Left = 520
      Top = 168
      Width = 80
      Height = 21
      EditLabel.Width = 40
      EditLabel.Height = 13
      EditLabel.Caption = 'User ID:'
      TabOrder = 3
      OnChange = leUserIDChange
    end
    object btnUserIDGen: TButton
      Left = 600
      Top = 168
      Width = 25
      Height = 21
      Hint = 'Generate user ID'
      Caption = 'G'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = btnUserIDGenClick
    end
    object leVariantTag: TLabeledEdit
      Left = 440
      Top = 328
      Width = 81
      Height = 21
      EditLabel.Width = 57
      EditLabel.Height = 13
      EditLabel.Caption = 'Variant tag:'
      MaxLength = 16
      TabOrder = 12
    end
    object btnPictures: TButton
      Left = 272
      Top = 560
      Width = 113
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Pictures...'
      TabOrder = 25
      OnClick = btnPicturesClick
    end
    object btnRatingDetails: TButton
      Left = 512
      Top = 526
      Width = 113
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Rating details...'
      TabOrder = 24
      OnClick = btnRatingDetailsClick
    end
  end
  object tmrHighlightTimer: TTimer
    Interval = 250
    OnTimer = tmrHighlightTimerTimer
    Left = 568
  end
  object pmnFlagMacros: TPopupMenu
    Alignment = paRight
    Left = 464
    Top = 248
  end
  object tmrSecondaryPics: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrSecondaryPicsTimer
    Left = 536
  end
end
