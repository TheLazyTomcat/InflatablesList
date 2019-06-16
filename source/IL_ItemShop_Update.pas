unit IL_ItemShop_Update;

{$INCLUDE '.\IL_defs.inc'}

interface

uses
  IL_ItemShop_Base;

const
  // how many times to repeat update when it fails in certain way
  IL_LISTFILE_UPDATE_TRYCOUNT = 5;

type
  TILITemShop_Update = class(TILITemShop_Base)
  public
    Function Update: Boolean; virtual;
  end;

implementation

uses
  SysUtils,
  AuxTypes,
  IL_Types, InflatablesList_ShopUpdate;

Function TILITemShop_Update.Update: Boolean;
var
  Updater:        TILShopUpdater;
  UpdaterResult:  TILShopUpdaterResult;
  TryCounter:     Integer;

  procedure SetValues(const Msg: String; Res: TILItemShopUpdateResult; Avail: Int32; Price: UInt32);
  begin
    fAvailable := Avail;
    fPrice := Price;
    fLastUpdateRes := Res;
    fLastUpdateMsg := Msg;
    UpdateList;
    UpdateValues;
  end;

begin
If not fUntracked then
  begin
    TryCounter := IL_LISTFILE_UPDATE_TRYCOUNT;
    Result := False;
    Updater := TILShopUpdater.Create(Self,IL_ThreadSafeCopy(fStaticOptions));
    try
      repeat
        UpdaterResult := Updater.Run(fAltDownMethod);
        case UpdaterResult of
          ilurSuccess:          begin
                                  SetValues(Format(
                                    'Success (%d bytes downloaded) - Avail: %d  Price: %d',
                                    [Updater.DownloadSize,Updater.Available,Updater.Price]),
                                    ilisurSuccess,Updater.Available,Updater.Price);
                                  Result := True;
                                end;
          ilurNoLink:           SetValues('No item link',ilisurDataFail,0,0);
          ilurNoData:           SetValues('Insufficient search data',ilisurDataFail,0,0);
          // when download fails, keep old price (assumes the item vent unavailable)
          ilurFailDown:         SetValues(Format('Download failed (code: %d)',[Updater.DownloadResultCode]),ilisurCritical,0,fPrice);
          // when parsing fails, keep old values (assumes bad download or internal exception)
          ilurFailParse:        SetValues(Format('Parsing failed (%s)',[Updater.ErrorString]),ilisurCritical,fAvailable,fPrice);
          // following assumes the item is unavailable
          ilurFailAvailSearch:  SetValues('Search of available count failed',ilisurSoftFail,0,Updater.Price);
          // following assumes the item is unavailable, keep old price
          ilurFailSearch:       SetValues('Search failed',ilisurHardFail,0,fPrice);
          // following assumes the item is unavailable
          ilurFailAvailValGet:  SetValues('Unable to obtain available count',ilisurSoftFail,0,Updater.Price);
          // following assumes the item is unavailable, keep old price
          ilurFailValGet:       SetValues('Unable to obtain values',ilisurHardFail,0,fPrice);
          // general fail, invalidate
          ilurFail:             SetValues('Failed (general error)',ilisurFatal,0,0);
        else
          SetValues('Failed (unknown state)',ilisurFatal,0,0);
        end;
        Dec(TryCounter);
      until (TryCounter <= 0) or not(UpdaterResult in [ilurFailDown,ilurFailParse]);
    finally
      Updater.Free;
    end;
  end
else
  begin
    SetValues(Format('Success (untracked) - Avail: %d  Price: %d',[fAvailable,fPrice]),ilisurMildSucc,fAvailable,fPrice);
    Result := True;
  end;
end;

end.
