:: Launch "Developer Command Prompt for VS 2017"

cd lua5.1\src

cl /MD /O2 /c /DLUA_BUILD_AS_DLL *.c

link /DLL /IMPLIB:lua5.1.lib /OUT:lua5.1.dll *.obj

mv lua.obj lua.o

link /OUT:lua.exe lua.o lua5.1.lib /DYNAMICBASE "c:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.10.25017\lib\x86\legacy_stdio_definitions.lib"

::lib /OUT:lua5.1-static.lib *.obj

::link /OUT:luac.exe luac.o lua5.1-static.lib

del *.obj *.exp *.manifest

cd ..

mkdir bin

mv src/*.exe bin
mv src/*.dll bin
mv src/*.lib bin

cd ..