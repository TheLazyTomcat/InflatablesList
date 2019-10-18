unit InflatablesList_ItemShop_Update;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_ItemShop_Base;

const
  // how many times to repeat update when it fails in certain ways
  IL_LISTFILE_UPDATE_TRYCOUNT = 5;

type
  TILItemShop_Update = class(TILItemShop_Base)
  public
    Function Update: Boolean; virtual;
  end;

implementation

uses
  InflatablesList_Types,
  InflatablesList_Utils,
  InflatablesList_ShopUpdater;

const
  IL_RESULT_STRS: array[0..11] of String = (
    'Success (%d bytes downloaded) - Avail: %d  Price: %d',
    'No item link',
    'Insufficient search data',
    'Download failed (code: %d)',
    'Parsing failed (%s)',
    'Search of available count failed',
    'Search failed',
    'Unable to obtain available count',
    'Unable to obtain values',
    'Failed - general error (%s)',
    'Failed - unknown state (%d)',
    'Success (untracked) - Avail: %d  Price: %d');

//------------------------------------------------------------------------------    

Function TILItemShop_Update.Update: Boolean;
var
  Updater:        TILShopUpdater;
  UpdaterResult:  TILShopUpdaterResult;
  TryCounter:     Integer;
begin
If not fUntracked then
  begin
    TryCounter := IL_LISTFILE_UPDATE_TRYCOUNT;
    Result := False;
    Updater := TILShopUpdater.Create(Self);
    try
      repeat
        UpdaterResult := Updater.Run(fAltDownMethod);
        case UpdaterResult of
          ilurSuccess:          begin
                                  SetValues(IL_Format(IL_RESULT_STRS[0],
                                    [Updater.DownloadSize,Updater.Available,Updater.Price]),
                                    ilisurSuccess,Updater.Available,Updater.Price);
                                  Result := True;
                                end;
          ilurDownSuccess:      Result := True; // do not change last result
          ilurNoLink:           SetValues(IL_RESULT_STRS[1],ilisurDataFail,0,0);
          ilurNoData:           SetValues(IL_RESULT_STRS[2],ilisurDataFail,0,0);
          // when download fails, keep old price (assumes the item vent unavailable)
          ilurFailDown:         SetValues(IL_Format(IL_RESULT_STRS[3],[Updater.DownloadResultCode]),ilisurDownload,0,fPrice);
          // when parsing fails, keep old values (assumes bad download or internal exception)
          ilurFailParse:        SetValues(IL_Format(IL_RESULT_STRS[4],[Updater.ErrorString]),ilisurParsing,fAvailable,fPrice);
          // following assumes the item is unavailable
          ilurFailAvailSearch:  SetValues(IL_RESULT_STRS[5],ilisurSoftFail,0,Updater.Price);
          // following assumes the item is unavailable, keep old price
          ilurFailSearch:       SetValues(IL_RESULT_STRS[6],ilisurHardFail,0,fPrice);
          // following assumes the item is unavailable
          ilurFailAvailValGet:  SetValues(IL_RESULT_STRS[7],ilisurSoftFail,0,Updater.Price);
          // following assumes the item is unavailable, keep old price
          ilurFailValGet:       SetValues(IL_RESULT_STRS[8],ilisurHardFail,0,fPrice);
          // general fail, invalidate
          ilurFail:             SetValues(IL_Format(IL_RESULT_STRS[9],[Updater.ErrorString]),ilisurFatal,0,0);
        else
          SetValues(IL_Format(IL_RESULT_STRS[10],[Ord(UpdaterResult)]),ilisurFatal,0,0);
        end;
        Dec(TryCounter);
      until (TryCounter <= 0) or not(UpdaterResult in [ilurFailDown,ilurFailParse]);
    finally
      Updater.Free;
    end;
  end
else
  begin
    SetValues(IL_Format(IL_RESULT_STRS[11],[fAvailable,fPrice]),ilisurMildSucc,fAvailable,fPrice);
    Result := True;
  end;
end;

end.
