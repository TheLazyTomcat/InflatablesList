{-------------------------------------------------------------------------------

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

-------------------------------------------------------------------------------}
{===============================================================================

  Counted dynamic arrays

    Basic types and constants

  This library is designed to ease work with dynamic arrays and also slightly
  optimize reallocation of the array.

  The array itself is hidden in a record that should be considered opaque,
  but is in fact completely acessible so the compiler can work around it. It is
  not recommended to directly access fields of this record, but it should not
  cause any problem when you are cautious.
  To allow growing and shrinking optimizations, count of the items inside an
  array is trictly separated from the actual array and its length/capacity
  (hence counted dynamic arrays).

  Standard functions like Length, SetLength or Copy are implemented along with
  many more functions that allows acessing the array in a way similar to
  accessing a list object (Add, Remove, IndexOf, ...).

  This library implements counted arrays for several basic types (integers,
  floats, strings, ...), but is designed so the codebase can be used with minor
  or no modifications for any other type - it uses templates and type aliases
  as a kind of generics.
  For examples on how to implement a counted dynamic array, refer to files
  CountedDynArray*.pas, where * is name of the base type.

  Arrays of following types are implemented in current version of this library:

    Boolean    in CountedDynArrayBool.pas
    Integer    in CountedDynArrayInteger.pas
    TDateTime  in CountedDynArrayDateTime.pas
    String     in CountedDynArrayString.pas
    Pointer    in CountedDynArrayPointer.pas
    TObject    in CountedDynArrayTObject.pas
    Int8       in CountedDynArrayInt8.pas
    UInt8      in CountedDynArrayUInt8.pas
    Int16      in CountedDynArrayInt16.pas
    UInt16     in CountedDynArrayUInt16.pas
    Int32      in CountedDynArrayInt32.pas
    UInt32     in CountedDynArrayUInt32.pas
    Int64      in CountedDynArrayInt64.pas
    UInt64     in CountedDynArrayUInt64.pas
    Float32    in CountedDynArrayFloat32.pas
    Float64    in CountedDynArrayFloat64.pas

  Note that given the method used (template with type alias), there is a limit
  of one array type per *.pas file.

  If you want to override any preimplemented method, define symbol
  CDA_DisableFunc_<FunctionName> and write your own implementation.
  Example how to do it can be found in unit CountedDynArrayString.pas.

  If you want to call the original implementation from the override, define
  symbol CDA_HideFunc_<FunctionName>. The original function will then be
  renamed to _<FunctionName> (original name prepended with underscore) and
  removed from interface section.

  WARNING - before using any counted dynamic array variable, you have to
            pass it to CDA_Init for proper initialization.

  ©František Milt 2019-01-26

  Version 1.0.3

  Dependencies:
    AuxTypes    - github.com/ncs-sniper/Lib.AuxTypes
    ListSorters - github.com/ncs-sniper/Lib.ListSorters

===============================================================================}
unit CountedDynArrays;

{$INCLUDE '.\CountedDynArrays_defs.inc'}

interface

type
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

  CDA_SIGA = $AF05C0F3;
  CDA_SIGB = $F23CF3E8;

implementation

end.


