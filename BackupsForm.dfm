object fBackupsForm: TfBackupsForm
  Left = 361
  Top = 125
  BorderStyle = bsDialog
  Caption = 'Backups'
  ClientHeight = 446
  ClientWidth = 888
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
  object lvBackups: TListView
    Left = 8
    Top = 8
    Width = 873
    Height = 385
    Columns = <
      item
        Caption = 'File name'
        Width = 300
      end
      item
        Alignment = taRightJustify
        Caption = 'File size'
        Width = 100
      end
      item
        Alignment = taRightJustify
        Caption = 'Program version'
        Width = 150
      end
      item
        Alignment = taRightJustify
        Caption = 'Time of saving'
        Width = 150
      end
      item
        Alignment = taRightJustify
        Caption = 'Time of backup'
        Width = 150
      end>
    ColumnClick = False
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    PopupMenu = pmnBackups
    TabOrder = 0
    ViewStyle = vsReport
  end
  object leBackupFolder: TLabeledEdit
    Left = 8
    Top = 416
    Width = 848
    Height = 21
    Color = clBtnFace
    EditLabel.Width = 69
    EditLabel.Height = 13
    EditLabel.Caption = 'Backup folder:'
    ReadOnly = True
    TabOrder = 1
  end
  object btnOpenBckFolder: TButton
    Left = 856
    Top = 416
    Width = 25
    Height = 21
    Hint = 'Open backup folder'
    Caption = '>'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = btnOpenBckFolderClick
  end
  object pmnBackups: TPopupMenu
    OnPopup = pmnBackupsPopup
    Left = 8
    object mniBU_Delete: TMenuItem
      Caption = 'Delete this backup'
      ShortCut = 46
      OnClick = mniBU_DeleteClick
    end
    object mniBU_Restore: TMenuItem
      Caption = 'Restore selected backup'
      ShortCut = 16466
      OnClick = mniBU_RestoreClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mniBU_Backup: TMenuItem
      Caption = 'Perform backup now'
      ShortCut = 16450
      OnClick = mniBU_BackupClick
    end
  end
end
