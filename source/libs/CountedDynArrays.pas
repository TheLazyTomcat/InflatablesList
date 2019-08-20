{-------------------------------------------------------------------------------

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

-------------------------------------------------------------------------------}
{===============================================================================

  Counted Dynamic Arrays

    Basic types and constants

    This library is designed to ease work with dynamic arrays and also slightly
    optimize reallocation of the array.

    The array itself is hidden in a record that must be considered opaque,
    but is in fact completely accessible so the compiler can work around it.
    To allow growing and shrinking optimizations, count of the items inside an
    array is separated from the actual array and its length/capacity (hence
    the name counted dynamic arrays).

    WARNING - It is strictly prohibited to directly access fields of the
              underlying record, use only the provided functions to do so.

    Standard functions like Length, SetLength or Copy are implemented along with
    many more functions that allow accessing the array in a way similar to
    accessing a list object (Add, Remove, IndexOf, Sort, ...). All implemented
    functions have CDA_ prefix (e.g CDA_Length).

    This library comes with preimplemented arrays for several basic types
    (integers, floats, strings, ...), but is designed so the codebase can be
    used with minor or no modifications for any other type (including, but not
    limited to, structured types like records or arrays) - it uses templates
    and type aliases as a kind of generics.
    Arrays of following types are implemented in current version of this
    library:

      Boolean          CountedDynArrayBool.pas

      Int8             CountedDynArrayInt8.pas
      UInt8            CountedDynArrayUInt8.pas
      Int16            CountedDynArrayInt16.pas
      UInt16           CountedDynArrayUInt16.pas
      Int32            CountedDynArrayInt32.pas
      UInt32           CountedDynArrayUInt32.pas
      Int64            CountedDynArrayInt64.pas
      UInt64           CountedDynArrayUInt64.pas
      PtrInt           CountedDynArrayPtrInt.pas
      PtrUInt          CountedDynArrayPtrUInt.pas
      Integer          CountedDynArrayInteger.pas      

      Float32          CountedDynArrayFloat32.pas
      Float64          CountedDynArrayFloat64.pas
      TDateTime        CountedDynArrayDateTime.pas
      Currency         CountedDynArrayCurrency.pas

      Pointer          CountedDynArrayPointer.pas
      TObject          CountedDynArrayTObject.pas

      AnsiChar         CountedDynArrayAnsiChar.pas
      UTF8Char         CountedDynArrayUTF8Char.pas
      WideChar         CountedDynArrayWideChar.pas
      UnicodeChar      CountedDynArrayUnicodeChar.pas
      Char             CountedDynArrayChar.pas

      ShortString      CountedDynArrayShortString.pas
      AnsiString       CountedDynArrayAnsiString.pas
      UTF8String       CountedDynArrayUTF8String.pas
      WideString       CountedDynArrayWideString.pas
      UnicodeString    CountedDynArrayUnicodeString.pas
      String           CountedDynArrayString.pas

      Variant          CountedDynArrayVariant.pas

    Note that given the method used (template with type alias), there is a limit
    of one array type per *.pas file.

    For help with implementing a counted dynamic array for any type, please
    refer to already implemented arrays or contact the author.

  Version 1.2.1 (2019-08-19)
  
  Last changed 2019-08-19

  ©2018-2019 František Milt

  Contacts:
    František Milt: frantisek.milt@gmail.com

  Support:
    If you find this code useful, please consider supporting its author(s) by
    making a small donation using the following link(s):

      https://www.paypal.me/FMilt

  Changelog:
    For detailed changelog and history please refer to this git repository:

      github.com/TheLazyTomcat/Lib.AuxClasses

  Dependencies:
    AuxTypes    - github.com/TheLazyTomcat/Lib.AuxTypes
    AuxClasses  - github.com/TheLazyTomcat/Lib.AuxClasses
    ListSorters - github.com/TheLazyTomcat/Lib.ListSorters
    StrRect     - github.com/TheLazyTomcat/Lib.StrRect

===============================================================================}
unit CountedDynArrays;

{$INCLUDE '.\CountedDynArrays_defs.inc'}

interface

uses
  AuxTypes;

type
  TCDASignature = PtrUInt;
  TCDAChecksum  = PtrUInt;
  
  TCDAIndexArray = array of Integer;
  PCDAIndexArray = ^TCDAIndexArray;

{$IF SizeOf(TCDAIndexArray) <> SizeOf(Pointer)}
  {$MESSAGE Fatal 'Incompatible implementation detail.'}
{$IFEND}

{
  Array is only grown if current count + DeltaMin is larger than current capacity.

  agmSlow           - grow by 1
  agmLinear         - grow by GrowFactor (integer part of the float)
  agmFast           - grow by capacity * GrowFactor
  agmFastAttenuated - if capacity is below DYNARRAY_GROW_ATTENUATE_THRESHOLD,
                      then grow by capacity * GrowFactor
                    - if capacity is above or equal to DYNARRAY_GROW_ATTENUATE_THRESHOLD,
                      grow by 1/16 * DYNARRAY_GROW_ATTENUATE_THRESHOLD

  If mode is other than agmSlow and current capacity is 0, then new capacity is
  set to DYNARRAY_INITIAL_CAPACITY, irrespective of selected grow mode.
}
  TCDAGrowMode = (agmSlow, agmLinear, agmFast, agmFastAttenuated);

{
  asmKeepCap - array is not shrinked, capacity is preserved
  asmNormal  - if capacity is above DYNARRAY_INITIAL_CAPACITY and count is below capacity div 4,
               then capacity is set to capacity div 4, otherwise capacity is preserved
             - if capacity is below or equal to DYNARRAY_INITIAL_CAPACITY, then the array
               is not shinked unless the count is 0, in which case the new capacity is set to 0
  asmToCount - capacity is set to count
}
  TCDAShrinkMode = (asmKeepCap, asmNormal, asmToCount);

const
  CDA_INITIAL_CAPACITY         = 16;
  CDA_GROW_ATTENUATE_THRESHOLD = 16 * 1024 * 1024;

implementation

initialization
  System.Randomize; // required for signature initialization

end.


