object fTextEditForm: TfTextEditForm
  Left = 263
  Top = 47
  Width = 1008
  Height = 674
  BorderStyle = bsSizeToolWin
  Caption = 'fTextEditForm'
  Color = clBtnFace
  Constraints.MinHeight = 128
  Constraints.MinWidth = 256
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  DesignSize = (
    1000
    640)
  PixelsPerInch = 96
  TextHeight = 13
  object meText: TMemo
    Left = 8
    Top = 8
    Width = 985
    Height = 625
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'meText')
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
    OnKeyPress = meTextKeyPress
  end
end
