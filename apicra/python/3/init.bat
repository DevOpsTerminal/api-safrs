::#!/usr/bin/env bash
:: Setting environment variables
:: Windows allows environment variables to be configured permanently at both the User level and the System level, or temporarily in a command prompt.
:: To temporarily set environment variables, open Command Prompt and use the set command:
::set PATH=C:\Program Files\Python 3.7;%PATH%
set PATH=C:\Python34;%PATH%
::set PYTHONPATH=%PYTHONPATH%;C:\My_python_lib
::python
[Environment]::SetEnvironmentVariable("Path", "$env:Path;C:\Python34")
[System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";C:\Python34", "user")
echo %PATH%
