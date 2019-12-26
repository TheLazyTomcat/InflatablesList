//-----------------------------------------------------------------------------
//
// ImageLib Sources
// Copyright (C) 2000-2017 by Denton Woods
// Last modified: 03/07/2009
//
// Filename: IL/il.h
//
// Description: The main include file for DevIL
//
//-----------------------------------------------------------------------------

// Doxygen comment
(*! \file il.h
    The main include file for DevIL
*)
unit il;

{$INCLUDE '.\devil_defs.inc'}

interface

uses
  SysUtils,
  AuxTypes;

//this define controls if floats and doubles are clamped to [0..1]
//during conversion. It takes a little more time, but it is the correct
//way of doing this. If you are sure your floats are always valid,
//you can undefine this value...
const
  CLAMP_HALF		= 1;
  CLAMP_FLOATS	= 1;
  CLAMP_DOUBLES	= 1;

type
  ILenum     = UInt32;              ILenum_p = ^ILenum;
  ILboolean  = UInt8;               ILboolean_p = ^ILboolean;
  ILbitfield = UInt32;              ILbitfield_p = ^ILbitfield;
  ILbyte     = Int8;                PILbyte_p = ^ILbyte;
  ILshort    = Int16;               ILshort_p = ^ILshort;
  ILint      = Int32;               ILint_p = ^ILint;
  ILsizei    = PtrUInt{size_t};     ILsizei_p = ^ILsizei;
  ILubyte    = UInt8;               ILubyte_p = ^ILubyte;
  ILushort   = UInt16;              ILushort_p = ^ILushort;
  ILuint     = UInt32;              ILuint_p = ^ILuint;
  ILfloat    = Float32;             ILfloat_p = ^ILfloat;
  ILclampf   = Float32;             ILclampf_p = ^ILclampf;
  ILdouble   = Float64;             ILdouble_p = ^ILdouble;
  ILclampd   = Float64;             ILclampd_p = ^ILclampd;

  ILint64  = Int64;                 ILint64_p  = ^ILint64;
  ILuint64 = UInt64;                ILuint64_p = ^ILuint64;

	ILchar         = AnsiChar;        ILchar_p         = ^ILchar;
	ILstring       = PAnsiChar;       ILstring_p       = ^ILstring;
	ILconst_string = PAnsiChar;       ILconst_string_p = ^ILconst_string;

const
  IL_FALSE = 0;
  IL_TRUE  = 1;


  //  Matches OpenGL's right now.
  //! Data formats \link Formats Formats\endlink
  IL_COLOUR_INDEX    = $1900;
  IL_COLOR_INDEX     = $1900;
  IL_ALPHA           = $1906;
  IL_RGB             = $1907;
  IL_RGBA            = $1908;
  IL_BGR             = $80E0;
  IL_BGRA            = $80E1;
  IL_LUMINANCE       = $1909;
  IL_LUMINANCE_ALPHA = $190A;


  //! Data types \link Types Types\endlink
  IL_BYTE           = $1400;
  IL_UNSIGNED_BYTE  = $1401;
  IL_SHORT          = $1402;
  IL_UNSIGNED_SHORT = $1403;
  IL_INT            = $1404;
  IL_UNSIGNED_INT   = $1405;
  IL_FLOAT          = $1406;
  IL_DOUBLE         = $140A;
  IL_HALF           = $140B;


  IL_MAX_BYTE           = High(Int8);
  IL_MAX_UNSIGNED_BYTE  = High(UInt8);
  IL_MAX_SHORT          = High(Int16);
  IL_MAX_UNSIGNED_SHORT = High(UInt16);
  IL_MAX_INT            = High(Int32);
  IL_MAX_UNSIGNED_INT   = High(UInt32);


Function IL_LIMIT(x,min,max: Integer): Integer; overload;
Function IL_LIMIT(x,min,max: Int64): Int64; overload;
Function IL_LIMIT(x,min,max: Single): Single; overload;
Function IL_LIMIT(x,min,max: Double): Double; overload;

Function IL_CLAMP(x: Single): Single; overload;
Function IL_CLAMP(x: Double): Double; overload;

const
  IL_VENDOR   = $1F00;
  IL_LOAD_EXT = $1F01;
  IL_SAVE_EXT = $1F02;


  //
  // IL-specific #define's
  //
  IL_VERSION_1_8_0 = 1;
  IL_VERSION       = 180;


  // Attribute Bits
  IL_ORIGIN_BIT          = $00000001;
  IL_FILE_BIT            = $00000002;
  IL_PAL_BIT             = $00000004;
  IL_FORMAT_BIT          = $00000008;
  IL_TYPE_BIT            = $00000010;
  IL_COMPRESS_BIT        = $00000020;
  IL_LOADFAIL_BIT        = $00000040;
  IL_FORMAT_SPECIFIC_BIT = $00000080;
  IL_ALL_ATTRIB_BITS     = $000FFFFF;


  // Palette types
  IL_PAL_NONE   = $0400;
  IL_PAL_RGB24  = $0401;
  IL_PAL_RGB32  = $0402;
  IL_PAL_RGBA32 = $0403;
  IL_PAL_BGR24  = $0404;
  IL_PAL_BGR32  = $0405;
  IL_PAL_BGRA32 = $0406;


  // Image types
  IL_TYPE_UNKNOWN = $0000;
  IL_BMP          = $0420;  //!< Microsoft Windows Bitmap - .bmp extension
  IL_CUT          = $0421;  //!< Dr. Halo - .cut extension
  IL_DOOM         = $0422;  //!< DooM walls - no specific extension
  IL_DOOM_FLAT    = $0423;  //!< DooM flats - no specific extension
  IL_ICO          = $0424;  //!< Microsoft Windows Icons and Cursors - .ico and .cur extensions
  IL_JPG          = $0425;  //!< JPEG - .jpg, .jpe and .jpeg extensions
  IL_JFIF         = $0425;  //!<
  IL_ILBM         = $0426;  //!< Amiga IFF (FORM ILBM) - .iff, .ilbm, .lbm extensions
  IL_PCD          = $0427;  //!< Kodak PhotoCD - .pcd extension
  IL_PCX          = $0428;  //!< ZSoft PCX - .pcx extension
  IL_PIC          = $0429;  //!< PIC - .pic extension
  IL_PNG          = $042A;  //!< Portable Network Graphics - .png extension
  IL_PNM          = $042B;  //!< Portable Any Map - .pbm, .pgm, .ppm and .pnm extensions
  IL_SGI          = $042C;  //!< Silicon Graphics - .sgi, .bw, .rgb and .rgba extensions
  IL_TGA          = $042D;  //!< TrueVision Targa File - .tga, .vda, .icb and .vst extensions
  IL_TIF          = $042E;  //!< Tagged Image File Format - .tif and .tiff extensions
  IL_CHEAD        = $042F;  //!< C-Style Header - .h extension
  IL_RAW          = $0430;  //!< Raw Image Data - any extension
  IL_MDL          = $0431;  //!< Half-Life Model Texture - .mdl extension
  IL_WAL          = $0432;  //!< Quake 2 Texture - .wal extension
  IL_LIF          = $0434;  //!< Homeworld Texture - .lif extension
  IL_MNG          = $0435;  //!< Multiple-image Network Graphics - .mng extension
  IL_JNG          = $0435;  //!<
  IL_GIF          = $0436;  //!< Graphics Interchange Format - .gif extension
  IL_DDS          = $0437;  //!< DirectDraw Surface - .dds extension
  IL_DCX          = $0438;  //!< ZSoft Multi-PCX - .dcx extension
  IL_PSD          = $0439;  //!< Adobe PhotoShop - .psd extension
  IL_EXIF         = $043A;  //!<
  IL_PSP          = $043B;  //!< PaintShop Pro - .psp extension
  IL_PIX          = $043C;  //!< PIX - .pix extension
  IL_PXR          = $043D;  //!< Pixar - .pxr extension
  IL_XPM          = $043E;  //!< X Pixel Map - .xpm extension
  IL_HDR          = $043F;  //!< Radiance High Dynamic Range - .hdr extension
  IL_ICNS         = $0440;  //!< Macintosh Icon - .icns extension
  IL_JP2          = $0441;  //!< Jpeg 2000 - .jp2 extension
  IL_EXR          = $0442;  //!< OpenEXR - .exr extension
  IL_WDP          = $0443;  //!< Microsoft HD Photo - .wdp and .hdp extension
  IL_VTF          = $0444;  //!< Valve Texture Format - .vtf extension
  IL_WBMP         = $0445;  //!< Wireless Bitmap - .wbmp extension
  IL_SUN          = $0446;  //!< Sun Raster - .sun, .ras, .rs, .im1, .im8, .im24 and .im32 extensions
  IL_IFF          = $0447;  //!< Interchange File Format - .iff extension
  IL_TPL          = $0448;  //!< Gamecube Texture - .tpl extension
  IL_FITS         = $0449;  //!< Flexible Image Transport System - .fit and .fits extensions
  IL_DICOM        = $044A;  //!< Digital Imaging and Communications in Medicine (DICOM) - .dcm and .dicom extensions
  IL_IWI          = $044B;  //!< Call of Duty Infinity Ward Image - .iwi extension
  IL_BLP          = $044C;  //!< Blizzard Texture Format - .blp extension
  IL_FTX          = $044D;  //!< Heavy Metal: FAKK2 Texture - .ftx extension
  IL_ROT          = $044E;  //!< Homeworld 2 - Relic Texture - .rot extension
  IL_TEXTURE      = $044F;  //!< Medieval II: Total War Texture - .texture extension
  IL_DPX          = $0450;  //!< Digital Picture Exchange - .dpx extension
  IL_UTX          = $0451;  //!< Unreal (and Unreal Tournament) Texture - .utx extension
  IL_MP3          = $0452;  //!< MPEG-1 Audio Layer 3 - .mp3 extension
  IL_KTX          = $0453;  //!< Khronos Texture - .ktx extension


  IL_JASC_PAL = $0475;  //!< PaintShop Pro Palette


  // Error Types
  IL_NO_ERROR             = $0000;
  IL_INVALID_ENUM         = $0501;
  IL_OUT_OF_MEMORY        = $0502;
  IL_FORMAT_NOT_SUPPORTED = $0503;
  IL_INTERNAL_ERROR       = $0504;
  IL_INVALID_VALUE        = $0505;
  IL_ILLEGAL_OPERATION    = $0506;
  IL_ILLEGAL_FILE_VALUE   = $0507;
  IL_INVALID_FILE_HEADER  = $0508;
  IL_INVALID_PARAM        = $0509;
  IL_COULD_NOT_OPEN_FILE  = $050A;
  IL_INVALID_EXTENSION    = $050B;
  IL_FILE_ALREADY_EXISTS  = $050C;
  IL_OUT_FORMAT_SAME      = $050D;
  IL_STACK_OVERFLOW       = $050E;
  IL_STACK_UNDERFLOW      = $050F;
  IL_INVALID_CONVERSION   = $0510;
  IL_BAD_DIMENSIONS       = $0511;
  IL_FILE_READ_ERROR      = $0512;  // 05/12/2002: Addition by Sam.
  IL_FILE_WRITE_ERROR     = $0512;


  IL_LIB_GIF_ERROR  = $05E1;
  IL_LIB_JPEG_ERROR = $05E2;
  IL_LIB_PNG_ERROR  = $05E3;
  IL_LIB_TIFF_ERROR = $05E4;
  IL_LIB_MNG_ERROR  = $05E5;
  IL_LIB_JP2_ERROR  = $05E6;
  IL_LIB_EXR_ERROR  = $05E7;
  IL_UNKNOWN_ERROR  = $05FF;


  // Origin Definitions
  IL_ORIGIN_SET        = $0600;
  IL_ORIGIN_LOWER_LEFT = $0601;
  IL_ORIGIN_UPPER_LEFT = $0602;
  IL_ORIGIN_MODE       = $0603;


  // Format and Type Mode Definitions
  IL_FORMAT_SET  = $0610;
  IL_FORMAT_MODE = $0611;
  IL_TYPE_SET    = $0612;
  IL_TYPE_MODE   = $0613;


  // File definitions
  IL_FILE_OVERWRITE = $0620;
  IL_FILE_MODE      = $0621;


  // Palette definitions
  IL_CONV_PAL = $0630;


  // Load fail definitions
  IL_DEFAULT_ON_FAIL = $0632;


  // Key colour and alpha definitions
  IL_USE_KEY_COLOUR = $0635;
  IL_USE_KEY_COLOR  = $0635;
  IL_BLIT_BLEND     = $0636;


  // Interlace definitions
  IL_SAVE_INTERLACED = $0639;
  IL_INTERLACE_MODE  = $063A;


  // Quantization definitions
  IL_QUANTIZATION_MODE = $0640;
  IL_WU_QUANT          = $0641;
  IL_NEU_QUANT         = $0642;
  IL_NEU_QUANT_SAMPLE  = $0643;
  IL_MAX_QUANT_INDEXS  = $0644; //XIX : ILint : Maximum number of colors to reduce to, default of 256. and has a range of 2-256
  IL_MAX_QUANT_INDICES = $0644; // Redefined, since the above   is misspelled


  // Hints
  IL_FASTEST          = $0660;
  IL_LESS_MEM         = $0661;
  IL_DONT_CARE        = $0662;
  IL_MEM_SPEED_HINT   = $0665;
  IL_USE_COMPRESSION  = $0666;
  IL_NO_COMPRESSION   = $0667;
  IL_COMPRESSION_HINT = $0668;


  // Compression
  IL_NVIDIA_COMPRESS  = $0670;
  IL_SQUISH_COMPRESS  = $0671;


  // Subimage types
  IL_SUB_NEXT   = $0680;
  IL_SUB_MIPMAP = $0681;
  IL_SUB_LAYER  = $0682;


  // Compression definitions
  IL_COMPRESS_MODE = $0700;
  IL_COMPRESS_NONE = $0701;
  IL_COMPRESS_RLE  = $0702;
  IL_COMPRESS_LZO  = $0703;
  IL_COMPRESS_ZLIB = $0704;


  // File format-specific values
  IL_TGA_CREATE_STAMP        = $0710;
  IL_JPG_QUALITY             = $0711;
  IL_PNG_INTERLACE           = $0712;
  IL_TGA_RLE                 = $0713;
  IL_BMP_RLE                 = $0714;
  IL_SGI_RLE                 = $0715;
  IL_TGA_ID_STRING           = $0717;
  IL_TGA_AUTHNAME_STRING     = $0718;
  IL_TGA_AUTHCOMMENT_STRING  = $0719;
  IL_PNG_AUTHNAME_STRING     = $071A;
  IL_PNG_TITLE_STRING        = $071B;
  IL_PNG_DESCRIPTION_STRING  = $071C;
  IL_TIF_DESCRIPTION_STRING  = $071D;
  IL_TIF_HOSTCOMPUTER_STRING = $071E;
  IL_TIF_DOCUMENTNAME_STRING = $071F;
  IL_TIF_AUTHNAME_STRING     = $0720;
  IL_JPG_SAVE_FORMAT         = $0721;
  IL_CHEAD_HEADER_STRING     = $0722;
  IL_PCD_PICNUM              = $0723;
  IL_PNG_ALPHA_INDEX         = $0724; // currently has no effect!
  IL_JPG_PROGRESSIVE         = $0725;
  IL_VTF_COMP                = $0726;


  // DXTC definitions
  IL_DXTC_FORMAT      = $0705;
  IL_DXT1             = $0706;
  IL_DXT2             = $0707;
  IL_DXT3             = $0708;
  IL_DXT4             = $0709;
  IL_DXT5             = $070A;
  IL_DXT_NO_COMP      = $070B;
  IL_KEEP_DXTC_DATA   = $070C;
  IL_DXTC_DATA_FORMAT = $070D;
  IL_3DC              = $070E;
  IL_RXGB             = $070F;
  IL_ATI1N            = $0710;
  IL_DXT1A            = $0711;  // Normally the same as IL_DXT1, except for nVidia Texture Tools.


  // Environment map definitions
  IL_CUBEMAP_POSITIVEX = $00000400;
  IL_CUBEMAP_NEGATIVEX = $00000800;
  IL_CUBEMAP_POSITIVEY = $00001000;
  IL_CUBEMAP_NEGATIVEY = $00002000;
  IL_CUBEMAP_POSITIVEZ = $00004000;
  IL_CUBEMAP_NEGATIVEZ = $00008000;
  IL_SPHEREMAP         = $00010000;


  // Values
  IL_VERSION_NUM           = $0DE2;
  IL_IMAGE_WIDTH           = $0DE4;
  IL_IMAGE_HEIGHT          = $0DE5;
  IL_IMAGE_DEPTH           = $0DE6;
  IL_IMAGE_SIZE_OF_DATA    = $0DE7;
  IL_IMAGE_BPP             = $0DE8;
  IL_IMAGE_BYTES_PER_PIXEL = $0DE8;
  IL_IMAGE_BITS_PER_PIXEL  = $0DE9;
  IL_IMAGE_FORMAT          = $0DEA;
  IL_IMAGE_TYPE            = $0DEB;
  IL_PALETTE_TYPE          = $0DEC;
  IL_PALETTE_SIZE          = $0DED;
  IL_PALETTE_BPP           = $0DEE;
  IL_PALETTE_NUM_COLS      = $0DEF;
  IL_PALETTE_BASE_TYPE     = $0DF0;
  IL_NUM_FACES             = $0DE1;
  IL_NUM_IMAGES            = $0DF1;
  IL_NUM_MIPMAPS           = $0DF2;
  IL_NUM_LAYERS            = $0DF3;
  IL_ACTIVE_IMAGE          = $0DF4;
  IL_ACTIVE_MIPMAP         = $0DF5;
  IL_ACTIVE_LAYER          = $0DF6;
  IL_ACTIVE_FACE           = $0E00;
  IL_CUR_IMAGE             = $0DF7;
  IL_IMAGE_DURATION        = $0DF8;
  IL_IMAGE_PLANESIZE       = $0DF9;
  IL_IMAGE_BPC             = $0DFA;
  IL_IMAGE_OFFX            = $0DFB;
  IL_IMAGE_OFFY            = $0DFC;
  IL_IMAGE_CUBEFLAGS       = $0DFD;
  IL_IMAGE_ORIGIN          = $0DFE;
  IL_IMAGE_CHANNELS        = $0DFF;


  IL_SEEK_SET = 0;
  IL_SEEK_CUR = 1;
  IL_SEEK_END = 2;
  IL_EOF      = -1;


type
  ILHANDLE = Pointer;

  // Callback functions for file reading
  fCloseRProc = procedure(H: ILHANDLE); stdcall;
  fEofProc    = Function(H: ILHANDLE): ILboolean; stdcall;
  fGetcProc   = Function(H: ILHANDLE): ILint; stdcall;
  fOpenRProc  = Function(S: ILconst_string): ILHANDLE; stdcall;
  fReadProc   = Function(P: Pointer; A,B: ILuint; H: ILHANDLE): ILint; stdcall;
  fSeekRProc  = Function(H: ILHANDLE; A,B: ILuint): ILint; stdcall;
  fTellRProc  = Function(H: ILHANDLE): ILint; stdcall;

  // Callback functions for file writing
  fCloseWProc = procedure(H: ILHANDLE); stdcall;
  fOpenWProc  = Function(S: ILconst_string): ILHANDLE; stdcall;
  fPutcProc   = Function(B: ILubyte; H: ILHANDLE): ILint; stdcall;
  fSeekWProc  = Function(H: ILHANDLE; A,B: ILint): ILint; stdcall;
  fTellWProc  = Function(H: ILHANDLE): ILint; stdcall;
  fWriteProc  = Function(P: Pointer; A,B: ILuint; H: ILHANDLE): ILint; stdcall;

  // Callback functions for allocation and deallocation
  mAlloc = Function(Size: ILsizei): Pointer; stdcall;
  mFree  = procedure(Ptr: Pointer); stdcall;

  // Registered format procedures
  IL_LOADPROC = Function(x: ILconst_string): ILenum; stdcall;
  IL_SAVEPROC = Function(x: ILconst_string): ILenum; stdcall;


// ImageLib Functions
var
  ilActiveFace:                 Function(Number: ILuint): ILboolean; stdcall;
  ilActiveImage:                Function(Number: ILuint): ILboolean; stdcall;
  ilActiveLayer:                Function(Number: ILuint): ILboolean; stdcall;
  ilActiveMipmap:               Function(Number: ILuint): ILboolean; stdcall;
  ilApplyPal:                   Function(FileName: ILconst_string): ILboolean; stdcall;
  ilApplyProfile:               Function(InProfile, OutProfile: ILstring): ILboolean; stdcall;
  ilBindImage:                  procedure(Image: ILuint); stdcall;
  ilBlit:                       Function(Source: ILuint; DestX,DestY,DestZ: ILint; SrcX,SrcY,SrcZ: ILuint; Width,Height,Depth: ILuint): ILboolean; stdcall;
  ilClampNTSC:                  Function: ILboolean; stdcall;
  ilClearColour:                procedure(Red,Green,Blue,Alpha: ILclampf); stdcall;
  ilClearImage:                 Function: ILboolean; stdcall;
  ilCloneCurImage:              Function: ILuint; stdcall;
  ilCompressDXT:                Function(Data: ILubyte_p; Width,Height,Depth: ILuint; DXTCFormat: ILenum; DXTCSize: ILuint_p): ILubyte_p; stdcall;
  ilCompressFunc:               Function(Mode: ILenum): ILboolean; stdcall;
  ilConvertImage:               Function(DestFormat: ILenum; DestType: ILenum): ILboolean; stdcall;
  ilConvertPal:                 Function(DestFormat: ILenum): ILboolean; stdcall;
  ilCopyImage:                  Function(Src: ILuint): ILboolean; stdcall;
  ilCopyPixels:                 Function(XOff,YOff,ZOff: ILuint; Width,Height,Depth: ILuint; Format: ILenum; _Type: ILenum; Data: Pointer): ILuint; stdcall;
  ilCreateSubImage:             Function(_Type: ILenum; Num: ILuint): ILuint; stdcall;
  ilDefaultImage:               Function: ILboolean; stdcall;
  ilDeleteImage:                procedure(Num: ILuint); stdcall;
  ilDeleteImages:               procedure(Num: ILsizei; Images: ILuint_p); stdcall;
  ilDetermineType:              Function(FileName: ILconst_string): ILenum; stdcall;
  ilDetermineTypeF:             Function(_File: ILHANDLE): ILenum; stdcall;
  ilDetermineTypeL:             Function(Lump: Pointer; Size: ILuint): ILenum; stdcall;
  ilDisable:                    Function(Mode: ILenum): ILboolean; stdcall;
  ilDxtcDataToImage:            Function: ILboolean; stdcall;
  ilDxtcDataToSurface:          Function: ILboolean; stdcall;
  ilEnable:                     Function(Mode: ILenum): ILboolean; stdcall;
  ilFlipSurfaceDxtcData:        procedure; stdcall;
  ilFormatFunc:                 Function(Mode: ILenum): ILboolean; stdcall;
  ilGenImages:                  procedure(Num: ILsizei; Images: ILuint_p); stdcall;
  ilGenImage:                   Function: ILuint; stdcall;
  ilGetAlpha:                   Function(_Type: ILenum): ILubyte_p; stdcall;
  ilGetBoolean:                 Function(Mode: ILenum): ILboolean; stdcall;
  ilGetBooleanv:                procedure(Mode: ILenum; Param: ILboolean_p); stdcall;
  ilGetData:                    Function: ILubyte_p; stdcall;
  ilGetDXTCData:                Function(Buffer: Pointer; BufferSize: ILuint; DXTCFormat: ILenum): ILuint; stdcall;
  ilGetError:                   Function: ILenum; stdcall;
  ilGetInteger:                 Function(Mode: ILenum): ILint; stdcall;
  ilGetIntegerv:                procedure(Mode: ILenum; Param: ILint_p); stdcall;
  ilGetLumpPos:                 Function: ILuint; stdcall;
  ilGetPalette:                 Function: ILubyte_p; stdcall;
  ilGetString:                  Function(StringName: ILenum): ILconst_string; stdcall;
  ilHint:                       procedure(Target: ILenum; Mode: ILenum); stdcall;
  ilInvertSurfaceDxtcDataAlpha: Function: ILboolean; stdcall;
  ilInit:                       procedure; stdcall;
  ilImageToDxtcData:            Function(Format: ILenum): ILboolean; stdcall;
  ilIsDisabled:                 Function(Mode: ILenum): ILboolean; stdcall;
  ilIsEnabled:                  Function(Mode: ILenum): ILboolean; stdcall;
  ilIsImage:                    Function(Image: ILuint): ILboolean; stdcall;
  ilIsValid:                    Function(_Type: ILenum; FileName: ILconst_string): ILboolean; stdcall;
  ilIsValidF:                   Function(_Type: ILenum; _File: ILHANDLE): ILboolean; stdcall;
  ilIsValidL:                   Function(_Type: ILenum; Lump: Pointer; Size: ILuint): ILboolean; stdcall;
  ilKeyColour:                  procedure(Red,Green,Blue,Alpha: ILclampf); stdcall;
  ilLoad:                       Function(_Type: ILenum; FileName: ILconst_string): ILboolean; stdcall;
  ilLoadF:                      Function(_Type: ILenum; _File: ILHANDLE): ILboolean; stdcall;
  ilLoadImage:                  Function(FileName: ILconst_string): ILboolean; stdcall;
  ilLoadL:                      Function(_Type: ILenum; Lump: Pointer; Size: ILuint): ILboolean; stdcall;
  ilLoadPal:                    Function(FileName: ILconst_string): ILboolean; stdcall;
  ilModAlpha:                   procedure(AlphaValue: ILdouble); stdcall;
  ilOriginFunc:                 Function(Mode: ILenum): ILboolean; stdcall;
  ilOverlayImage:               Function(Source: ILuint; XCoord,YCoord,ZCoord: ILint): ILboolean; stdcall;
  ilPopAttrib:                  procedure; stdcall;
  ilPushAttrib:                 procedure(Bits: ILuint); stdcall;
  ilRegisterFormat:             procedure(Format: ILenum); stdcall;
  ilRegisterLoad:               Function(Ext: ILconst_string; Load: IL_LOADPROC): ILboolean; stdcall;
  ilRegisterMipNum:             Function(Num: ILuint): ILboolean; stdcall;
  ilRegisterNumFaces:           Function(Num: ILuint): ILboolean; stdcall;
  ilRegisterNumImages:          Function(Num: ILuint): ILboolean; stdcall;
  ilRegisterOrigin:             procedure(Origin: ILenum); stdcall;
  ilRegisterPal:                procedure(Pal: Pointer; Size: ILuint; _Type: ILenum); stdcall;
  ilRegisterSave:               Function(Ext: ILconst_string; Save: IL_SAVEPROC): ILboolean; stdcall;
  ilRegisterType:               procedure(_Type: ILenum); stdcall;
  ilRemoveLoad:                 Function(Ext: ILconst_string): ILboolean; stdcall;
  ilRemoveSave:                 Function(Ext: ILconst_string): ILboolean; stdcall;
  ilResetMemory:                procedure; stdcall; // Deprecated
  ilResetRead:                  procedure; stdcall;
  ilResetWrite:                 procedure; stdcall;
  ilSave:                       Function(_Type: ILenum; FileName: ILconst_string): ILboolean; stdcall;
  ilSaveF:                      Function(_Type: ILenum; _File: ILHANDLE): ILuint; stdcall;
  ilSaveImage:                  Function(FileName: ILconst_string): ILboolean; stdcall;
  ilSaveL:                      Function(_Type: ILenum; Lump: Pointer; Size: ILuint): ILuint; stdcall;
  ilSavePal:                    Function(FileName: ILconst_string): ILboolean; stdcall;
  ilSetAlpha:                   Function(AlphaValue: ILdouble): ILboolean; stdcall;
  ilSetData:                    Function(Data: Pointer): ILboolean; stdcall;
  ilSetDuration:                Function(Duration: ILuint): ILboolean; stdcall;
  ilSetInteger:                 procedure(Mode: ILenum; Param: ILint); stdcall;
  ilSetMemory:                  procedure(MemAlloc: mAlloc; MemFree: mFree); stdcall;
  ilSetPixels:                  procedure(XOff,YOff,ZOff: ILint; Width,Height,Depth: ILuint; Format: ILenum; _Type: ILenum; Data: Pointer); stdcall;
  ilSetRead:                    procedure(OpenProc: fOpenRProc; CloseProc: fCloseRProc; EoFProc: fEofProc; GetcProc: fGetcProc; ReadProc: fReadProc; SeekProc: fSeekRProc; TellProc: fTellRProc); stdcall;
  ilSetString:                  procedure(Mode: ILenum; _String: PAnsiChar); stdcall;
  ilSetWrite:                   procedure(OpenProc: fOpenWProc; CloseProc: fCloseWProc; PutcProc: fPutcProc; SeekProc: fSeekWProc; TellProc: fTellWProc; WriteProc: fWriteProc); stdcall;
  ilShutDown:                   procedure; stdcall;
  ilSurfaceToDxtcData:          Function(Format: ILenum): ILboolean; stdcall;
  ilTexImage:                   Function(Width,Height,Depth: ILuint; NumChannels: ILubyte; Format: ILenum; _Type: ILenum; Data: Pointer): ILboolean; stdcall;
  ilTexImageDxtc:               Function(w,h,d: ILint; DxtFormat: ILenum; Data: ILubyte_p): ILboolean; stdcall;
  ilTypeFromExt:                Function(FileName: ILconst_string): ILenum; stdcall;
  ilTypeFunc:                   Function(Mode: ILenum): ILboolean; stdcall;
  ilLoadData:                   Function(FileName: ILconst_string; Width,Height,Depth: ILuint; Bpp: ILubyte): ILboolean; stdcall;
  ilLoadDataF:                  Function(_File: ILHANDLE; Width,Height,Depth: ILuint; Bpp: ILubyte): ILboolean; stdcall;
  ilLoadDataL:                  Function(Lump: Pointer; Size: ILuint;  Width,Height,Depth: ILuint; Bpp: ILubyte): ILboolean; stdcall;
  ilSaveData:                   Function(FileName: ILconst_string): ILboolean; stdcall;

  // For all those weirdos that spell "colour" without the 'u'.
  ilClearColor:                 procedure(Red,Green,Blue,Alpha: ILclampf); stdcall;
  ilKeyColor:                   procedure(Red,Green,Blue,Alpha: ILclampf); stdcall;

procedure imemclear(var x; y: Integer);

//==============================================================================

const
  DevIL_LibFileName = 'DevIL.dll';

Function DevIL_Initialize(const LibPath: String = DevIL_LibFileName; InitLib: Boolean = True): Boolean;
procedure DevIL_Finalize(FinalLib: Boolean = True);

type EILException = class(Exception);

implementation

uses
  Windows,
  StrRect;

Function IL_LIMIT(x,min,max: Integer): Integer;
begin
If x < min then
  Result := min
else If x > max then
  Result := max
else
  Result := x;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function IL_LIMIT(x,min,max: Int64): Int64;
begin
If x < min then
  Result := min
else If x > max then
  Result := max
else
  Result := x;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function IL_LIMIT(x,min,max: Single): Single;
begin
If x < min then
  Result := min
else If x > max then
  Result := max
else
  Result := x;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function IL_LIMIT(x,min,max: Double): Double;
begin
If x < min then
  Result := min
else If x > max then
  Result := max
else
  Result := x;
end;

//------------------------------------------------------------------------------

Function IL_CLAMP(x: Single): Single;
begin
Result := IL_LIMIT(x,0,1);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function IL_CLAMP(x: Double): Double;
begin
Result := IL_LIMIT(x,0,1);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure imemclear(var x; y: Integer);
begin
FillChar(x,y,0);
end;

//==============================================================================

var
  DevIL_LibHandle: THandle = 0;

Function DevIL_Initialize(const LibPath: String = DevIL_LibFileName; InitLib: Boolean = True): Boolean;

  Function GetAndCheckProc(const ProcName: String): Pointer;
  begin
    Result := GetProcAddress(DevIL_LibHandle,PChar(StrToWin(ProcName)));
    If not Assigned(Result) then
      raise EILException.CreateFmt('DevIL_Initialize:GetAndCheckProc: Address of function "%s" could not be obtained.',[ProcName]);
  end;

begin
If DevIL_LibHandle = 0 then
  begin
    DevIL_LibHandle := LoadLibraryEx(PChar(StrToWin(LibPath)),0,0);
    If DevIL_LibHandle <> 0 then
      begin
        ilActiveFace                 := GetAndCheckProc('ilActiveFace');
        ilActiveImage                := GetAndCheckProc('ilActiveImage');
        ilActiveLayer                := GetAndCheckProc('ilActiveLayer');
        ilActiveMipmap               := GetAndCheckProc('ilActiveMipmap');
        ilApplyPal                   := GetAndCheckProc('ilApplyPal');
        ilApplyProfile               := GetAndCheckProc('ilApplyProfile');
        ilBindImage                  := GetAndCheckProc('ilBindImage');
        ilBlit                       := GetAndCheckProc('ilBlit');
        ilClampNTSC                  := GetAndCheckProc('ilClampNTSC');
        ilClearColour                := GetAndCheckProc('ilClearColour');
        ilClearImage                 := GetAndCheckProc('ilClearImage');
        ilCloneCurImage              := GetAndCheckProc('ilCloneCurImage');
        ilCompressDXT                := GetAndCheckProc('ilCompressDXT');
        ilCompressFunc               := GetAndCheckProc('ilCompressFunc');
        ilConvertImage               := GetAndCheckProc('ilConvertImage');
        ilConvertPal                 := GetAndCheckProc('ilConvertPal');
        ilCopyImage                  := GetAndCheckProc('ilCopyImage');
        ilCopyPixels                 := GetAndCheckProc('ilCopyPixels');
        ilCreateSubImage             := GetAndCheckProc('ilCreateSubImage');
        ilDefaultImage               := GetAndCheckProc('ilDefaultImage');
        ilDeleteImage                := GetAndCheckProc('ilDeleteImage');
        ilDeleteImages               := GetAndCheckProc('ilDeleteImages');
        ilDetermineType              := GetAndCheckProc('ilDetermineType');
        ilDetermineTypeF             := GetAndCheckProc('ilDetermineTypeF');
        ilDetermineTypeL             := GetAndCheckProc('ilDetermineTypeL');
        ilDisable                    := GetAndCheckProc('ilDisable');
        ilDxtcDataToImage            := GetAndCheckProc('ilDxtcDataToImage');
        ilDxtcDataToSurface          := GetAndCheckProc('ilDxtcDataToSurface');
        ilEnable                     := GetAndCheckProc('ilEnable');
        ilFlipSurfaceDxtcData        := GetAndCheckProc('_ilFlipSurfaceDxtcData@0'); // dunno...
        ilFormatFunc                 := GetAndCheckProc('ilFormatFunc');
        ilGenImages                  := GetAndCheckProc('ilGenImages');
        ilGenImage                   := GetAndCheckProc('ilGenImage');
        ilGetAlpha                   := GetAndCheckProc('ilGetAlpha');
        ilGetBoolean                 := GetAndCheckProc('ilGetBoolean');
        ilGetBooleanv                := GetAndCheckProc('ilGetBooleanv');
        ilGetData                    := GetAndCheckProc('ilGetData');
        ilGetDXTCData                := GetAndCheckProc('ilGetDXTCData');
        ilGetError                   := GetAndCheckProc('ilGetError');
        ilGetInteger                 := GetAndCheckProc('ilGetInteger');
        ilGetIntegerv                := GetAndCheckProc('ilGetIntegerv');
        ilGetLumpPos                 := GetAndCheckProc('ilGetLumpPos');
        ilGetPalette                 := GetAndCheckProc('ilGetPalette');
        ilGetString                  := GetAndCheckProc('ilGetString');
        ilHint                       := GetAndCheckProc('ilHint');
        ilInvertSurfaceDxtcDataAlpha := GetAndCheckProc('_ilInvertSurfaceDxtcDataAlpha@0'); // see ilFlipSurfaceDxtcData
        ilInit                       := GetAndCheckProc('ilInit');
        ilImageToDxtcData            := GetAndCheckProc('ilImageToDxtcData');
        ilIsDisabled                 := GetAndCheckProc('ilIsDisabled');
        ilIsEnabled                  := GetAndCheckProc('ilIsEnabled');
        ilIsImage                    := GetAndCheckProc('ilIsImage');
        ilIsValid                    := GetAndCheckProc('ilIsValid');
        ilIsValidF                   := GetAndCheckProc('ilIsValidF');
        ilIsValidL                   := GetAndCheckProc('ilIsValidL');
        ilKeyColour                  := GetAndCheckProc('ilKeyColour');
        ilLoad                       := GetAndCheckProc('ilLoad');
        ilLoadF                      := GetAndCheckProc('ilLoadF');
        ilLoadImage                  := GetAndCheckProc('ilLoadImage');
        ilLoadL                      := GetAndCheckProc('ilLoadL');
        ilLoadPal                    := GetAndCheckProc('ilLoadPal');
        ilModAlpha                   := GetAndCheckProc('ilModAlpha');
        ilOriginFunc                 := GetAndCheckProc('ilOriginFunc');
        ilOverlayImage               := GetAndCheckProc('ilOverlayImage');
        ilPopAttrib                  := GetAndCheckProc('ilPopAttrib');
        ilPushAttrib                 := GetAndCheckProc('ilPushAttrib');
        ilRegisterFormat             := GetAndCheckProc('ilRegisterFormat');
        ilRegisterLoad               := GetAndCheckProc('ilRegisterLoad');
        ilRegisterMipNum             := GetAndCheckProc('ilRegisterMipNum');
        ilRegisterNumFaces           := GetAndCheckProc('ilRegisterNumFaces');
        ilRegisterNumImages          := GetAndCheckProc('ilRegisterNumImages');
        ilRegisterOrigin             := GetAndCheckProc('ilRegisterOrigin');
        ilRegisterPal                := GetAndCheckProc('ilRegisterPal');
        ilRegisterSave               := GetAndCheckProc('ilRegisterSave');
        ilRegisterType               := GetAndCheckProc('ilRegisterType');
        ilRemoveLoad                 := GetAndCheckProc('ilRemoveLoad');
        ilRemoveSave                 := GetAndCheckProc('ilRemoveSave');
        ilResetMemory                := GetAndCheckProc('ilResetMemory');
        ilResetRead                  := GetAndCheckProc('ilResetRead');
        ilResetWrite                 := GetAndCheckProc('ilResetWrite');
        ilSave                       := GetAndCheckProc('ilSave');
        ilSaveF                      := GetAndCheckProc('ilSaveF');
        ilSaveImage                  := GetAndCheckProc('ilSaveImage');
        ilSaveL                      := GetAndCheckProc('ilSaveL');
        ilSavePal                    := GetAndCheckProc('ilSavePal');
        ilSetAlpha                   := GetAndCheckProc('ilSetAlpha');
        ilSetData                    := GetAndCheckProc('ilSetData');
        ilSetDuration                := GetAndCheckProc('ilSetDuration');
        ilSetInteger                 := GetAndCheckProc('ilSetInteger');
        ilSetMemory                  := GetAndCheckProc('ilSetMemory');
        ilSetPixels                  := GetAndCheckProc('ilSetPixels');
        ilSetRead                    := GetAndCheckProc('ilSetRead');
        ilSetString                  := GetAndCheckProc('ilSetString');
        ilSetWrite                   := GetAndCheckProc('ilSetWrite');
        ilShutDown                   := GetAndCheckProc('ilShutDown');
        ilSurfaceToDxtcData          := GetAndCheckProc('ilSurfaceToDxtcData');
        ilTexImage                   := GetAndCheckProc('ilTexImage');
        ilTexImageDxtc               := GetAndCheckProc('ilTexImageDxtc');
        ilTypeFromExt                := GetAndCheckProc('ilTypeFromExt');
        ilTypeFunc                   := GetAndCheckProc('ilTypeFunc');
        ilLoadData                   := GetAndCheckProc('ilLoadData');
        ilLoadDataF                  := GetAndCheckProc('ilLoadDataF');
        ilLoadDataL                  := GetAndCheckProc('ilLoadDataL');
        ilSaveData                   := GetAndCheckProc('ilSaveData');
        // aliassed functions
        ilClearColor := @ilClearColour;
        ilKeyColor   := @ilKeyColour;
        // all is well if here...
        If InitLib then
          ilInit
        else
          Result := True;
      end
    else Result := False;
  end
else Result := True;
end;

//------------------------------------------------------------------------------

procedure DevIL_Finalize(FinalLib: Boolean = True);
begin
If DevIL_LibHandle <> 0 then
  begin
    If FinalLib then
            ilShutDown;
    FreeLibrary(DevIL_LibHandle);
    DevIL_LibHandle := 0;
  end;
end;

end.
