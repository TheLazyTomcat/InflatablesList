object frmItemPictureFrame: TfrmItemPictureFrame
  Left = 0
  Top = 0
  Width = 112
  Height = 522
  Constraints.MaxWidth = 112
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
    Width = 112
    Height = 522
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = True
    TabOrder = 0
    object shbPicsBackground: TShape
      Left = 0
      Top = 0
      Width = 112
      Height = 249
      Pen.Style = psClear
    end
    object shpThumbFull: TShape
      Left = 16
      Top = 24
      Width = 80
      Height = 80
      Brush.Style = bsClear
      Pen.Color = clSilver
      Pen.Style = psDot
    end
    object imgThumbFull: TImage
      Left = 8
      Top = 16
      Width = 96
      Height = 96
      Center = True
      OnClick = imgThumbFullClick
    end
    object shpThumbHalf: TShape
      Left = 40
      Top = 144
      Width = 32
      Height = 32
      Brush.Style = bsClear
      Pen.Color = clSilver
      Pen.Style = psDot
    end
    object shpThumbThirdth: TShape
      Left = 44
      Top = 212
      Width = 24
      Height = 24
      Brush.Style = bsClear
      Pen.Color = clSilver
      Pen.Style = psDot
    end
    object imgThumbHalf: TImage
      Left = 32
      Top = 136
      Width = 48
      Height = 48
      Center = True
      OnClick = imgThumbHalfClick
    end
    object imgThumbThirdth: TImage
      Left = 40
      Top = 208
      Width = 32
      Height = 32
      AutoSize = True
      OnClick = imgThumbThirdthClick
    end
    object lblThumbFull: TLabel
      Left = 0
      Top = 0
      Width = 112
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Full thumbnail'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object lblThumbHalf: TLabel
      Left = 0
      Top = 120
      Width = 112
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = '1/2 thumbnail'
      Transparent = True
    end
    object lblThumbThirdth: TLabel
      Left = 0
      Top = 192
      Width = 112
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = '1/3 thumbnail'
      Transparent = True
    end
    object btnViewPicture: TButton
      Left = 0
      Top = 496
      Width = 112
      Height = 25
      Caption = 'View picture'
      TabOrder = 0
      OnClick = btnViewPictureClick
    end
  end
end
