unit InflatablesList_Item_Crypt;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Item_IO_00000008;

type
  TILItem_IO_Crypt = class(TILItem_IO_00000008)
  protected
    procedure SetEncrypted(Value: Boolean); override;
  public
    Function TryDecrypt(const Password: String): Boolean; virtual;
    procedure Decrypt; virtual;
  end;

implementation

uses
  Classes,
  MemoryBuffer,
  InflatablesList_Encryption,
  InflatablesList_Item_IO;

procedure TILItem_IO_Crypt.SetEncrypted(Value: Boolean);
var
  TempPswd: String;
begin
If fEncrypted <> Value then
  begin
    BeginUpdate;
    try
      If Value then
        begin
          // encrypt - do not perform the encryption atm., only mark the item as encrypted
          If RequestItemsPassword(TempPswd) then
            begin
              fEncrypted := True;
              fDataAccessible := True;
            end;
        end
      else
        begin
          // decrypt - only if necessary (data not accessible)
          If not fDataAccessible then
            begin
              If RequestItemsPassword(TempPswd) then
                begin
                  Decrypt;              // sets fDataAccessible
                  fEncrypted := False;
                end;
            end
          else fEncrypted := False;
        end;
      UpdateTitle;      // to show lock icon
      UpdateMainList;
      UpdateSmallList;
    finally
      EndUpdate;
    end;
  end;
end;

//==============================================================================

Function TILItem_IO_Crypt.TryDecrypt(const Password: String): Boolean;
var
  Stream: TMemoryStream;
begin
try
  Stream := TMemoryStream.Create;
  try
    Stream.WriteBuffer(fEncryptedData.Memory^,fEncryptedData.Size);
    DecryptStream_AES256(Stream,Password,IL_ITEM_DECRYPT_CHECK);
    Result := True;
  finally
    Stream.Free;
  end;
except
  on E: EILWrongPassword do
    Result := False
  else
    raise;
end;
end;

//------------------------------------------------------------------------------

procedure TILItem_IO_Crypt.Decrypt;
var
  Stream:   TMemoryStream;
  Password: String;
begin
If RequestItemsPassword(Password) then
  begin
    Stream := TMemoryStream.Create;
    try
      Stream.WriteBuffer(fEncryptedData.Memory^,fEncryptedData.Size);
      FreeBuffer(fEncryptedData);
      DecryptStream_AES256(Stream,Password,IL_ITEM_DECRYPT_CHECK);
      Stream.Seek(0,soBeginning);
      If Assigned(fFNDeferredLoadProc) then
        begin
          fFNDeferredLoadProc(Stream);
          fDataAccessible := True;
          RenderSmallPictures;
          UpdateOverview;          
          UpdateMainList;
          UpdateSmallList;
        end;
    finally
      Stream.Free;
    end;
  end;
end;

end.
