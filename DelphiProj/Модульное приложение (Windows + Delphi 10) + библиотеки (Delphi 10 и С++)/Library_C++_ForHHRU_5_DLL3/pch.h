// pch.h: это предварительно скомпилированный заголовочный файл.
// Перечисленные ниже файлы компилируются только один раз, что ускоряет последующие сборки.
// Это также влияет на работу IntelliSense, включая многие функции просмотра и завершения кода.
// Однако изменение любого из приведенных здесь файлов между операциями сборки приведет к повторной компиляции всех(!) этих файлов.
// Не добавляйте сюда файлы, которые планируете часто изменять, так как в этом случае выигрыша в производительности не будет.

#ifndef PCH_H
#define PCH_H

//--- Определим символ-макрос для указания компоновщику, что это библиотека (DLL) для подстановки в заголовочном файле соответствующего для DLL макроса
#ifndef LIBRARYAPI_EXPORTS
#define LIBRARYAPI_EXPORTS
#endif

// Добавьте сюда заголовочные файлы для предварительной компиляции
#include "framework.h"

#include <vector>
#include <string>
#include <list>
#include <objbase.h>
#include <atlbase.h>
#include <atlstr.h>
#include <comutil.h>
//#include <iostream>
#include <format>
//#include <stdio.h>
//#include <stdlib.h>


//#include <combaseapi.h>
//#include <unknwn.h>

//#include <Windows.h>
//#include <windef.h>

//#include <winuser.h>
//#include <uuid.h>

//#include <winerror.h>
//#include <wchar.h>

#endif //PCH_H
