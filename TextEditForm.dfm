object fTextEditForm: TfTextEditForm
  Left = 435
  Top = 155
  Width = 800
  Height = 498
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
    792
    464)
  PixelsPerInch = 96
  TextHeight = 13
  object meText: TMemo
    Left = 8
    Top = 8
    Width = 777
    Height = 449
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'meText')
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
    OnKeyPress = meTextKeyPress
  end
end
