@echo off
setlocal enableextensions disabledelayedexpansion

set "search={{PATH_PLACE_HOLDER}}"
set "replace=%CD%"
set "ProjFileVmg=SOCKETS.vmg"
set "ProjFileServerVmp=%CD%\server\Server.vmp"
set "ProjFileClientVmp=%CD%\client\Client.vmp"
for /f "delims=" %%i in ('type "%ProjFileVmg%" ^& break ^> "%ProjFileVmg%" ') do (
        set "line=%%i"
        setlocal enabledelayedexpansion
        >>"%ProjFileVmg%" echo(!line:%search%=%replace%!
        endlocal
)

for /f "delims=" %%i in ('type "%ProjFileServerVmp%" ^& break ^> "%ProjFileServerVmp%" ') do (
        set "line=%%i"
        setlocal enabledelayedexpansion
        >>"%ProjFileServerVmp%" echo(!line:%search%=%replace%!
        endlocal
)

for /f "delims=" %%i in ('type "%ProjFileClientVmp%" ^& break ^> "%ProjFileClientVmp%" ') do (
        set "line=%%i"
        setlocal enabledelayedexpansion
        >>"%ProjFileClientVmp%" echo(!line:%search%=%replace%!
        endlocal
)


set "search=\"
set "replace=\\"
set "ProjFileVmg=SOCKETS.vmg"

for /f "delims=" %%i in ('type "%ProjFileVmg%" ^& break ^> "%ProjFileVmg%" ') do (
        set "line=%%i"
        setlocal enabledelayedexpansion
        >>"%ProjFileVmg%" echo(!line:%search%=%replace%!
        endlocal
)

for /f "delims=" %%i in ('type "%ProjFileServerVmp%" ^& break ^> "%ProjFileServerVmp%" ') do (
        set "line=%%i"
        setlocal enabledelayedexpansion
        >>"%ProjFileServerVmp%" echo(!line:%search%=%replace%!
        endlocal
)

for /f "delims=" %%i in ('type "%ProjFileClientVmp%" ^& break ^> "%ProjFileClientVmp%" ') do (
        set "line=%%i"
        setlocal enabledelayedexpansion
        >>"%ProjFileClientVmp%" echo(!line:%search%=%replace%!
        endlocal
)
