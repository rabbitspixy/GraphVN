@echo off
setlocal

set cmd=%~1

if /i "%~1"=="build_runner" (
    dart run build_runner build --delete-conflicting-outputs
) else if /i "%~1"=="windows" (
    flutter run -d windows
) else if /i "%~1"=="protoc" (
    protoc --dart_out=lib/generated-proto/ data.proto --plugin=protoc-gen-dart=tool\protoc-gen-dart.bat
) else if /i "%~1 %~2"=="build windows" (
    flutter build windows
) else (
    echo Unknown command: %cmd%
    exit /b 1
)

endlocal

