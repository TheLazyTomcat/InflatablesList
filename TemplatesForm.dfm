object fTemplatesForm: TfTemplatesForm
  Left = 896
  Top = 91
  BorderStyle = bsDialog
  Caption = 'Shop templates'
  ClientHeight = 600
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblTemplates: TLabel
    Left = 8
    Top = 88
    Width = 53
    Height = 13
    Caption = 'Templates:'
  end
  object leName: TLabeledEdit
    Left = 8
    Top = 24
    Width = 257
    Height = 21
    EditLabel.Width = 77
    EditLabel.Height = 13
    EditLabel.Caption = 'Template name:'
    TabOrder = 0
  end
  object btnSave: TButton
    Left = 8
    Top = 56
    Width = 257
    Height = 25
    Caption = 'Save current shop as a template'
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object lbTemplates: TListBox
    Left = 8
    Top = 104
    Width = 257
    Height = 459
    IntegralHeight = True
    ItemHeight = 13
    PopupMenu = pmnTemplates
    TabOrder = 2
    OnClick = lbTemplatesClick
    OnDblClick = lbTemplatesDblClick
    OnMouseDown = lbTemplatesMouseDown
  end
  object btnLoad: TButton
    Left = 8
    Top = 568
    Width = 257
    Height = 25
    Caption = 'Load selected template'
    TabOrder = 3
    OnClick = btnLoadClick
  end
  object pmnTemplates: TPopupMenu
    OnPopup = pmnTemplatesPopup
    Left = 240
    Top = 88
    object mniTL_Rename: TMenuItem
      Caption = 'Rename template...'
      ShortCut = 113
      OnClick = mniTL_RenameClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mniTL_Remove: TMenuItem
      Caption = 'Remove template'
      ShortCut = 46
      OnClick = mniTL_RemoveClick
    end
    object mniTL_Clear: TMenuItem
      Caption = 'Remove all templates'
      ShortCut = 16430
      OnClick = mniTL_ClearClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mniTL_MoveUp: TMenuItem
      Caption = 'Move up'
      OnClick = mniTL_MoveUpClick
    end
    object mniTL_MoveDown: TMenuItem
      Caption = 'Move down'
      OnClick = mniTL_MoveDownClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object mniTL_Export: TMenuItem
      Caption = 'Export template...'
      OnClick = mniTL_ExportClick
    end
    object mniTL_Import: TMenuItem
      Caption = 'Import template...'
      OnClick = mniTL_ImportClick
    end
  end
  object diaImport: TOpenDialog
    Filter = 'Template files (*.tpl)|*.tpl|All files|*.*'
    Title = 'Import template'
    Left = 32
  end
  object diaExport: TSaveDialog
    DefaultExt = '.tpl'
    Filter = 'Template files (*.tpl)|*.tpl|All files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Export template'
  end
end
