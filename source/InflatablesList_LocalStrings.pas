unit InflatablesList_LocalStrings;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Types;

const

//- common ---------------------------------------------------------------------

  IL_LANG_STR = 'CS';

  IL_CURRENCY_STR    = 'CZK';
  IL_CURRENCY_SYMBOL = 'Kè';

//- ShopFrame ------------------------------------------------------------------

  IL_SHOPFRAME_PREDEFNOTES: array[0..3] of String = (
    'nelze vybrat variantu',
    'konkrétní typ není k dispozici',
    'dostupnost varianty je nejistá',
    'pravdìpodonì nelze vybar variantu');

//- InflatablesList_Data -------------------------------------------------------

  IL_DATA_ITEMTYPE_STRS: array[TILItemType] of String =
    ('neznámı','kruh','kruh s madly','kruh speciální','míè','rider','lehátko',
     'lehátko s opìrkou','sedátko','rukávky','hraèka','ostrov','ostrov extra',
     'èlun','matrace','postel','køeslo','pohovka','balónek','ostatní');

  IL_DATA_ITEMMANUFACTURER_UNKNOWN = 'neznámı';
  IL_DATA_ITEMMANUFACTURER_OTHERS  = 'ostatní';

  IL_DATA_ITEMMATERIAL_STRS: array[TILItemMaterial] of String =
    ('neznámı','polyvinylchlorid (PVC)','polyester (PES)','polyetylen (PE)',
     'polypropylen (PP)','akrylonitrilbutadienstyren (ABS)','polystyren (PS)',
     'polyuretan (PUR)','latex','silikon','gumotextílie','ostatní');

  IL_DATA_ITEMSURFACEFINISH_STRS: array[TILItemSurfaceFinish] of String =
    ('neznámı','lesklı','pololesklı','matnı','polomatnı','perleovı',
     'metalickı','povloèkovanı','rùznı','jinı');  



implementation

end.
