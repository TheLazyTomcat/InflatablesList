@ECHO OFF

PUSHD .\ 

CHDIR /D %~dp0

start ILPictureProcessor.exe -R "%~1%"

popd