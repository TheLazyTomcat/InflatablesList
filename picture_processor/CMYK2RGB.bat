@ECHO OFF

PUSHD .\ 

CHDIR /D %~dp0

start ILPictureProcessor.exe -C "%~1%"

popd