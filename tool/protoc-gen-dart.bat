@echo off
rem protoc-gen-dart wrapper. Runs the protoc_plugin package from the project's
rem dev_dependencies instead of requiring `dart pub global activate protoc_plugin`.
call dart run protoc_plugin:protoc_plugin %*
exit /b %errorlevel%
