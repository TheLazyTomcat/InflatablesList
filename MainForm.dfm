object fMainform: TfMainform
  Left = 348
  Top = 123
  BorderStyle = bsSingle
  Caption = 'fMainform'
  ClientHeight = 446
  ClientWidth = 862
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 427
    Width = 862
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Style = psOwnerDraw
        Width = 50
      end
      item
        Style = psOwnerDraw
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
    OnDrawPanel = StatusBar1DrawPanel
  end
  object XPManifest1: TXPManifest
    Left = 776
    Top = 32
  end
  object MainMenu1: TMainMenu
    Left = 152
    Top = 72
    object file1: TMenuItem
      Caption = 'file'
    end
  end
end
