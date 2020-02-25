unit InflatablesList_LocalStrings;

{$INCLUDE '.\InflatablesList_defs.inc'}

interface

uses
  InflatablesList_Types;

const

//- common ---------------------------------------------------------------------

  IL_LANG_STR = 'CS';

  IL_CURRENCY_STR    = 'CZK';
  IL_CURRENCY_SYMBOL = 'K�';

//- ShopFrame ------------------------------------------------------------------

  IL_SHOPFRAME_PREDEFNOTES: array[0..3] of String = (
    'nelze vybrat variantu',
    'konkr�tn� typ nen� k dispozici',
    'dostupnost varianty je nejist�',
    'pravd�podon� nelze vybar variantu');

//- InflatablesList_Data -------------------------------------------------------

  IL_DATA_ITEMTYPE_STRS: array[TILItemType] of String =
    ('nezn�m�','kruh','kruh s madly','kruh speci�ln�','m��','rider','leh�tko',
     'leh�tko s op�rkou','sed�tko','ruk�vky','hra�ka','ostrov','ostrov extra',
     '�lun','matrace','postel','k�eslo','pohovka','bal�nek','ostatn�');

  IL_DATA_ITEMMANUFACTURER_UNKNOWN = 'nezn�m�';
  IL_DATA_ITEMMANUFACTURER_OTHERS  = 'ostatn�';

  IL_DATA_ITEMMATERIAL_STRS: array[TILItemMaterial] of String =
    ('nezn�m�','polyvinylchlorid (PVC)','polyester (PES)','polyetylen (PE)',
     'polypropylen (PP)','akrylonitrilbutadienstyren (ABS)','polystyren (PS)',
     'polyuretan (PUR)','latex','silikon','gumotext�lie','ostatn�');

  IL_DATA_ITEMSURFACEFINISH_STRS: array[TILItemSurfaceFinish] of String =
    ('nezn�m�','leskl�','pololeskl�','matn�','polomatn�','perle�ov�',
     'metalick�','povlo�kovan�','r�zn�','jin�');  



implementation

end.
