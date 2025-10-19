#pragma once

#include "pch.h"
#include "LibraryAPI.h"
#include <sstream>
#include <comutil.h>


//--- Блок констант и переменных
//_bstr_t
short dllLibraryId = 2;
BSTR dllFuncName =  ::SysAllocString(L"Функционал работы с Внеш. Устр. (Библиотека №3)");
BSTR dllVersion =   ::SysAllocString(L"1.0");
BSTR task1Name =    ::SysAllocString(L"Обмен с устройством на базе микроконтроллера STM32");
std::vector<BSTR> vNamesTask = { task1Name };
std::string wsLibraryTitle = "Подключена библиотека : %d (%s), кол - во задач - %d";
std::string wsResultStreamTitle = "Библиотека №d, Задача №%d";

//--- Константы, определённые в главном модуле
auto    UserOffset = 2048;
auto    WM_Data_Update = WM_APP + UserOffset;
auto    NotifySignBit = 0x80000000; //--- бит для определения "наших" сообщений между потоками (thread) об обновлении (для wParam)
auto    CMD_SetMemoStreamUpd = 2; //--- Наш код для обновления данных от потока в компоненты отображения
auto    CMD_SetMemoLogStreamUpd = 4;

ULONG const MaxBufferSize_1 = 512;
//--------------------------------------------------------------------------------------


//typedef OLECHAR* BSTR;
//---------------------------------------------------------------------------------------
//--- Подпрограммы общего назначения
//---------------------------------------------------------------------------------------
//static std::string inttostr(unsigned long long inputInt)
template <typename T>
static char* inttostr(const T& inputVal)
{
    char buffer[_MAX_U64TOSTR_BASE10_COUNT] = {};
    _ui64toa_s((long long) inputVal, (char*)buffer, _countof(buffer), 10);
    buffer[_MAX_U64TOSTR_BASE10_COUNT - 1] = 0; //--- Приведём к формату С-строка
    return (char*)buffer;
}

static unsigned long MakeDwordAsSender(unsigned long inputLoWord, unsigned long inputHiWord)
{
    unsigned long result = DWORD(inputHiWord);
    result = (result << 16) | inputLoWord;  //--- wParamHi:= sidTaskItem, wParamLo:= self.FTaskNum
    //--- Установим признак "свой-чужой" для распознавания нашего типа оповещения об обновлении компонентов отображения
    result = result | NotifySignBit; //--- Установка страшего бита wParam в 1

    return result;
}


//---------------------------------------------------------------------------------------

DLL3_API HRESULT API_CALL_TYPE GetLibraryAPI (REFGUID guid_in, void** intrf)
{
    const GUID tmpGUID;
    const GUID* ptmpguid = &tmpGUID;
//    BSTR tmpString = SysAllocString(L"6D0957A0-EADE-4770-B448-EEE0D92F84CF");
    CLSIDFromString((LPCOLESTR) (L"6D0957A0-EADE-4770-B448-EEE0D92F84CF"), (LPCLSID) & tmpGUID);
//    SysFreeString(tmpString);
/*
    if (not IsEqualGUID((const GUID &) tmpGUID, guid_in)) {
        *intrf = nullptr;
        return E_NOINTERFACE;
    };
*/
    *intrf = nullptr;
    pLibraryAPI = new LibraryAPI;
    *intrf = pLibraryAPI; // static_cast<ILibraryAPI*> (pLibraryAPI);
    return (S_OK);
};


//---------------------------------------------------------------------------------------
// 
//--- LibraryAPI
//---------------------------------------------------------------------------------------
// Реализация функий IUnknown
HRESULT LibraryAPI::QueryInterface(REFIID riid, void** ppvObject)
{

//     switch (static_cast<GUID> (riid))
//    {
//      case IID_IUnknown:
//      case IID_ILibraryAPI:
    *ppvObject = this; // static_cast<ILibraryAPI*> (this);
            // Поскольку мы возвращаем новый указатель на
            // интерфейс, необходимо вызвать метод AddRef
            AddRef();
            return (S_OK);

//        default:
//            return (E_NOINTERFACE);
//    }
}

ULONG LibraryAPI::Release()
{
    InterlockedDecrement(&m_Ref);

    // когда значение счетчика обращений
    // становится равным нулю, объект удаляет сам себя
    if (m_Ref == 0)
    {
        //delete this;
        return 0; //--- теперь m_Ref уже не существует
    }
    else
        return m_Ref;
}

ULONG LibraryAPI::AddRef()
{
    InterlockedIncrement(&m_Ref);
    return m_Ref;
}
//---------------------------------------------------------------------------------------

LibraryAPI::LibraryAPI()
{
    m_libraryId = dllLibraryId;
    m_libraryFuncName = SysAllocString(dllFuncName);
    m_libraryVersion = SysAllocString(dllVersion);
    m_TaskCount = 1;
    m_Ref = 1; //--- Вместо LibraryAPI::QueryInterface(REFIID riid, void** ppv) для первого раза 

    m_TaskList = new BSTRItems(vNamesTask); // static_cast<IBSTRItems*> (pBSTRItems);

    /*
        const REFGUID tmpGUID = {};
        //    const GUID* ptmpguid = &tmpGUID;
        //    BSTR tmpString = SysAllocString(L"6D0957A0-EADE-4770-B448-EEE0D92F84CF");
        CLSIDFromString((LPCOLESTR)(L"7988654F-59FB-401F-9E4C-972FF343C66B"), (LPCLSID)&tmpGUID);
        m_TaskList->QueryInterface(tmpGUID, outputIBSTRItems);
    */

    //--- Создание потока для передачи информации в журнал событий главного модуля
    if (CreateStreamOnHGlobal(m_hGlobalStream, true, &m_spStream) == S_OK)
    {
        std::string tmpString(wsLibraryTitle);
//--- Для BSTR строк необходимо небольшое преобразование в std::string
//        _bstr_t bstrtString = dllFuncName;
        std::string tmpString1(CW2A((LPCTSTR)CStringW(m_libraryFuncName)));
//        std::string tmpString1((char*) _com_util::ConvertBSTRToString(dllFuncName));
 
//        std::ostringstream tmpOSS;
//        tmpOSS << tmpString1; // m_libraryFuncName;

        char tmpCharBuf [MaxBufferSize_1];
        tmpString.resize(MaxBufferSize_1, '\0');
        ULONG tmpUL = {};
        if (sprintf_s(tmpCharBuf, MaxBufferSize_1, tmpString.c_str(), m_libraryId, tmpString1.c_str()/*tmpOSS.str()*/, m_TaskCount) != -1)
        {
            tmpString = tmpCharBuf;
            if (m_spStream->Write(tmpString.data(), tmpString.size(), &tmpUL) != S_OK)
            {
                MessageBox(NULL, (LPCWSTR)L"Ошибка записи строки в поток (IStream) для журнала бмблиотеки", (LPCWSTR)L"Внутри DLL3: LibraryAPI::LibraryAPI()", MB_OK | MB_ICONINFORMATION | MB_TASKMODAL);
            }
        }
        else
        {
            tmpString = "Ошибка форматирования строки (sprintf_s(...)) для журнала бмблиотеки";
            if (m_spStream->Write(tmpString.data(), tmpString.size(), &tmpUL) != S_OK)
            {
            }
        } 
    }
    else
    {
        MessageBox(NULL, (LPCWSTR)L"Ошибка создания потока IStream для журнала бмблиотеки", (LPCWSTR)L"Внутри DLL3: LibraryAPI::LibraryAPI()", MB_OK | MB_ICONINFORMATION | MB_TASKMODAL);
    };

};


LibraryAPI::~LibraryAPI()
{
    m_libraryId = 0;
    SysFreeString(m_libraryFuncName);
    SysFreeString(m_libraryVersion);
    SysFreeString(task1Name);

    //--- Освобождение ресурсов потоков IStream для самой библиотеки
    m_spStream.Release();
    m_hGlobalStream = NULL; //--- GlobalFree не требуется, так как при создании применён флаг - fDeleteOnRelease = true


    //    m_TaskList->Release();
    //    pLibraryInfoItems->Release();
    //    pLibraryAPI->Release();
};


//----------------------------------------------------------------------------------------

HRESULT API_CALL_TYPE LibraryAPI::GetId(unsigned long& outputId)
{
    outputId = static_cast<unsigned long> (m_libraryId);
    return (S_OK);
};

HRESULT API_CALL_TYPE LibraryAPI::GetName(BSTR& outputName)
{
    outputName = m_libraryFuncName;
    return (S_OK);
};

HRESULT API_CALL_TYPE LibraryAPI::GetVersion(BSTR& outputVersion)
{
    outputVersion = m_libraryVersion;
    return (S_OK);
};

HRESULT API_CALL_TYPE LibraryAPI::GetTaskCount(char& outputTaskCount)
{
    outputTaskCount = m_TaskCount;
    return (S_OK);
};

HRESULT API_CALL_TYPE LibraryAPI::NewTaskSource(unsigned short* inputLibraryTaskIndex, unsigned short* inputMainModuleTaskIndex, ITaskSource** outputTaskSource)
{
    *outputTaskSource = new TaskSource(inputLibraryTaskIndex);
    pTaskSourceList.push_back((TaskSource*) *outputTaskSource);
    auto iterList = pTaskSourceList.end();
    iterList--;
    MessageBox(NULL, (LPCWSTR)((CA2W)inttostr(&iterList)), (LPCWSTR)L"Внутри DLL3: LibraryAPI::NewTaskSource(...). iterList = ", MB_OK | MB_ICONINFORMATION | MB_TASKMODAL);

    (*iterList)->SetTaskMainModuleIndex(inputMainModuleTaskIndex);
//    (TaskSource*) (*outputTaskSource).SetTaskMainModuleIndex(inputMainModuleTaskIndex);
    unsigned short tmpUS = {};
    (*iterList)->GetTaskLibraryIndex(tmpUS);

    return (S_OK);
}

HRESULT API_CALL_TYPE LibraryAPI::GetTaskSource(unsigned short* inputLibraryTaskIndex, ITaskSource** outputTaskSource)
{
    unsigned short libraryTaskIndex;
    for (auto iterList : pTaskSourceList) 
    {
        (*iterList).GetTaskLibraryIndex(libraryTaskIndex);
        if (libraryTaskIndex == *inputLibraryTaskIndex)
        {
            *outputTaskSource = iterList;
            break;
        }
    }

    return (S_OK);
}

HRESULT API_CALL_TYPE LibraryAPI::GetStream(void **outputStream)
{
    *outputStream = m_spStream; // static_cast<IStream*> (m_spStream);

    return (S_OK);
};


 HRESULT API_CALL_TYPE LibraryAPI::GetTaskList(void** outputIBSTRItems)
{
    *outputIBSTRItems = m_TaskList; // pLibraryInfoItems;

    return (S_OK);
};


HRESULT API_CALL_TYPE LibraryAPI::SetOwnerThread(unsigned long* inputOwnerThread)
{
    m_OwnerThread = *inputOwnerThread;
    NotifyReceiver_Thread(); //--- На момент вызова данной плдпрограммы из главного модуля в IStream уже есть информация, записанная в конструкторе TaskSource


    return (S_OK);
};


HRESULT API_CALL_TYPE LibraryAPI::InitDLL()
{
    try
    {
        if (bDllInitExecuted)
        {
            return (S_OK);
        }

        bDllInitExecuted = true;
    }
    catch (...)
    {
        //--- Запись в журнал ошибок (через IStream в главный модуль)
        throw;
    }

    return (S_OK);
};

HRESULT API_CALL_TYPE LibraryAPI::FinalizeDLL()
{
    try
    {
//--- Очистим список-перечень элементов TaskSource
        for (auto iterList : pTaskSourceList)
        {
//            std::list<TaskSource*>(*iterList).erase;
            delete static_cast<TaskSource*>(iterList);

        }
//         pTaskSourceList.clear();



        return (S_OK);
    }
 catch (...)
 {
     //--- Запись в журнал ошибок (через IStream в главный модуль)
     throw;
     //return (E_UNEXPECTED);
 };

 return (S_OK);
};

HRESULT API_CALL_TYPE LibraryAPI::FreeTaskSource(unsigned short* inputMainModuleTaskIndex)
{
    MessageBox(NULL, (LPCWSTR)L"Пока ничего не делается...", (LPCWSTR)L"Внутри DLL3: TaskSource::FreeTaskSource(...)", MB_OK | MB_ICONINFORMATION | MB_TASKMODAL);

    return (S_OK);
}

void API_CALL_TYPE LibraryAPI::WriteDataToLog(std::string inputE_source1, std::string inputCurrentProcName, std::string inputCurrentUnitName)
{
    std::ostringstream tmpOSS;
    tmpOSS << "--- " << wsResultStreamTitle << "\r\n" << "Сообщение сгенерировано в - " << inputCurrentProcName << "\\" << inputCurrentUnitName << "\r\n" << inputE_source1 << "\r\n";
    std::string tmpString = tmpOSS.str();

    ULONG tmpUL = {};
    if (m_spStream->Write(tmpString.data(), tmpString.size(), &tmpUL) != S_OK)
    {
        std::string tmpString = "Ощибка записи в IStream журнала. Записано байт = ";
        tmpString += inttostr(tmpUL);
        MessageBox(NULL, (LPCWSTR)((CA2W)tmpString.c_str()), (LPCWSTR)L"Внутри DLL3: LibraryAPI::WriteDataToLog(...)", MB_OK | MB_ICONINFORMATION | MB_TASKMODAL);

        return;
    }
    NotifyReceiver_Thread();
}

bool API_CALL_TYPE LibraryAPI::NotifyReceiver_Thread()
{
//--- Обновить информацию в ТМемо (с журналом работы)
//--- Если не от потока задача/ядро задачи, то TaskNum:= 0, чтобы пройти проверку на соответствие TaskNum и TaskList.Count в WndProc
//--- Установить тип отправителя - API Библиотеки
    if (!PostThreadMessage(m_OwnerThread, WM_Data_Update, MakeDwordAsSender(0, WORD(MessageSender.msLibraryAPI)), CMD_SetMemoLogStreamUpd))
    {
        std::string tmpString = "m_OwnerThread = ";
        tmpString += inttostr(m_OwnerThread);

        return false;
    };

    return true;
}


//-------------------------------------------------------------------------------------------------------------------------------------


//---------------------------------------------------------------------------------------
//--- BSTRItems
//---------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

BSTRItems::BSTRItems(const std::vector<BSTR>& inputBSTRItems)
{
    m_Ref = 1; //--- 
    for (size_t itemBSTR = 0; itemBSTR < inputBSTRItems.size(); ++itemBSTR)
    {
        m_BSTRItems.push_back(inputBSTRItems[itemBSTR]);
    }
}

BSTRItems::~BSTRItems()
{
}


// Реализация функий IUnknown
HRESULT BSTRItems::QueryInterface(REFIID riid, void** ppv)
{

    //     switch (static_cast<GUID> (riid))
    //    {
    //      case IID_IBSTRItems:
    *ppv = this; // static_cast<IBSTRItems*> (this);
    // Поскольку мы возвращаем новый указатель на
    // интерфейс, необходимо вызвать метод AddRef
    AddRef();
    return (S_OK);

    //        default:
    //            return (E_NOINTERFACE);
    //    }
}

ULONG BSTRItems::Release()
{
    InterlockedDecrement(&m_Ref);
    
    // когда значение счетчика обращений
    // становится равным нулю, объект удаляет сам себя
    if (m_Ref == 0)
    {
        //delete this;
        // нельзя вернуть m_Ref, поскольку его уже не существует после (delete this)
        return 0;
    }
    else
        return m_Ref;
}

ULONG BSTRItems::AddRef()
{
    InterlockedIncrement(&m_Ref);

    return m_Ref;
}
//---------------------------------------------------------------------------------------


HRESULT API_CALL_TYPE BSTRItems::GetCount(unsigned long& outCount)
{
    outCount = m_BSTRItems.size();

    return (S_OK);
}

HRESULT API_CALL_TYPE BSTRItems::GetString(const unsigned long* inputIndexItem, BSTR& outString)
{
    unsigned long tmpindexItem = *inputIndexItem;
    outString = m_BSTRItems[tmpindexItem]; // CComBSTR(m_BSTRItems[index]); //CComBSTR("Тестовая строка (до преобразования через CComBSTR(...)");

    return (S_OK);
}

//---------------------------------------------------------------------------------------


//---------------------------------------------------------------------------------------
//--- TaskSource
//---------------------------------------------------------------------------------------
// Реализация функий IUnknown
HRESULT TaskSource::QueryInterface(REFIID riid, void** ppv)
{

    //     switch (static_cast<GUID> (riid))
    //    {
    //      case IID_IBSTRItems:
    *ppv = this; // static_cast<IBSTRItems*> (this);
    // Поскольку мы возвращаем новый указатель на
    // интерфейс, необходимо вызвать метод AddRef
    AddRef();
    return (S_OK);

    //        default:
    //            return (E_NOINTERFACE);
    //    }
}

ULONG TaskSource::Release()
{
    InterlockedDecrement(&m_Ref);

    // когда значение счетчика обращений
    // становится равным нулю, объект удаляет сам себя
    if (m_Ref == 0)
    {
        //delete this;
        // нельзя вернуть m_Ref, поскольку его уже не существует после (delete this)
        return 0;
    }
    else
        return m_Ref;
}

ULONG TaskSource::AddRef()
{
    InterlockedIncrement(&m_Ref);

    return m_Ref;
}
//---------------------------------------------------------------------------------------
TaskSource::TaskSource(const unsigned short* inputTaskLibraryIndex)
{
     m_TaskLibraryIndex = *inputTaskLibraryIndex;

     //--- Создание потока для передачи результата в главный модуль
     if (CreateStreamOnHGlobal(m_hGlobalStreamResult, true, &m_spStream_Result) != S_OK)
     {
         MessageBox(NULL, (LPCWSTR) L"Ошибка создания потока IStream для результата задачи", (LPCWSTR)L"Внутри DLL3: TaskSource::TaskSource", MB_OK | MB_ICONINFORMATION | MB_TASKMODAL);
     };
//     MessageBox(NULL, (LPCWSTR)L"Создан поток IStream для результата задачи", (LPCWSTR)L"Внутри DLL3: TaskSource::TaskSource", MB_OK | MB_ICONINFORMATION | MB_TASKMODAL);


     //--- Создание потока для передачи информации в журнал событий главного модуля
     if (CreateStreamOnHGlobal(m_hGlobalStreamLog, true, &m_spStream_Log) == S_OK)
     {
         std::string tmpString = wsResultStreamTitle;
         this->WriteDataToLog(tmpString, "", "");
     }
     else
     {
         MessageBox(NULL, (LPCWSTR)L"Ошибка создания потока IStream для журнала задачи", (LPCWSTR)L"Внутри DLL3: TaskSource::TaskSource", MB_OK | MB_ICONINFORMATION | MB_TASKMODAL);
     };
//     MessageBox(NULL, (LPCWSTR)L"Создан поток IStream для журнала задачи", (LPCWSTR)L"Внутри DLL3: TaskSource::TaskSource", MB_OK | MB_ICONINFORMATION | MB_TASKMODAL);
     

     m_Ref = 1; //--- Вместо TaskSource::QueryInterface(REFIID riid, void** ppv) для первого раза 
//     MessageBox(NULL, (LPCWSTR)((CA2W)inttostr(m_Ref)), (LPCWSTR)L"Внутри DLL3: TaskSource::TaskSource. m_Ref = ", MB_OK | MB_ICONINFORMATION | MB_TASKMODAL);

     m_AbortExecution = false; //--- флаг для немедленного (без создания исключения) прекращения и удаления объекта TaskSource

}

TaskSource::~TaskSource()
{
    //--- Освобождение ресурсов потоков IStream для каждого TaskSource
    m_spStream_Result.Release();
    m_spStream_Log.Release();
    m_hGlobalStreamResult = NULL; //--- GlobalFree не требуется, так как при создании применён флаг - fDeleteOnRelease = true
    m_hGlobalStreamLog = NULL; //--- GlobalFree не требуется, так как при создании применён флаг - fDeleteOnRelease = true

}

HRESULT API_CALL_TYPE TaskSource::TaskProcedure()
{
    switch (this->m_TaskLibraryIndex)
    {
    case 0:
    {
        MessageBox(NULL, (LPCWSTR)L"Задача в процессе разработки...", (LPCWSTR)L"Внутри DLL3: TaskSource::TaskProcedure(...)", MB_OK | MB_ICONINFORMATION | MB_TASKMODAL);
    }
    default:
    {
        return (S_FALSE); //--- Пока
    }
    }

    return (S_OK);
}

HRESULT API_CALL_TYPE TaskSource::AbortTaskSource()
{
    MessageBox(NULL, (LPCWSTR)L"В разработке...", (LPCWSTR)L"Внутри DLL3: TaskSource::AbortTaskSource()", MB_OK | MB_ICONINFORMATION | MB_TASKMODAL);

    return (S_OK);
}

HRESULT API_CALL_TYPE TaskSource::GetTaskLibraryIndex(unsigned short& outputLibraryIndex)
{
    outputLibraryIndex = (unsigned short)dllLibraryId;

    return (S_OK);
}

HRESULT API_CALL_TYPE TaskSource::GetTask_Result(Task_Result& outputTask_Result)
{
    MessageBox(NULL, (LPCWSTR)L"В разработке...", (LPCWSTR)L"Внутри DLL3: TaskSource::GetTask_Result", MB_OK | MB_ICONINFORMATION | MB_TASKMODAL);

    return (S_OK);
}

HRESULT API_CALL_TYPE TaskSource::GetTask_ResultByIndex(long* ResultIndex, Task_Result& outputTask_Result)
{
    MessageBox(NULL, (LPCWSTR)L"В разработке...", (LPCWSTR)L"Внутри DLL3: TaskSource::GetTask_ResultByIndex(...)", MB_OK | MB_ICONINFORMATION | MB_TASKMODAL);

    return (S_OK);
}

HRESULT API_CALL_TYPE TaskSource::GetTask_TotalResult(DWORD& outputTask_TotalResult)
{
    MessageBox(NULL, (LPCWSTR)L"В разработке...", (LPCWSTR)L"Внутри DLL3: TaskSource::GetTask_TotalResult(...)", MB_OK | MB_ICONINFORMATION | MB_TASKMODAL);

    return (S_OK);
}

HRESULT API_CALL_TYPE TaskSource::GetTask_ResultStream(void** outputResultStream)
{
    *outputResultStream = m_spStream_Result;

    return (S_OK);
}

HRESULT API_CALL_TYPE TaskSource::GetTask_LogStream(void** outputLogStream)
{
    *outputLogStream = m_spStream_Log;

    return (S_OK);
}

HRESULT API_CALL_TYPE TaskSource::GetAbortExecutionState(bool& outputAbortState)
{
    outputAbortState = m_AbortExecution;

    return (S_OK);
}

HRESULT API_CALL_TYPE TaskSource::SetAbortExecutionState(bool* inputAbortState)
{
    m_AbortExecution = inputAbortState;

    return (S_OK);
}


HRESULT API_CALL_TYPE TaskSource::SetTaskMainModuleIndex(unsigned short* inputTaskMainModuleIndex)
{
    this->m_TaskMainModuleIndex = *inputTaskMainModuleIndex;

    return (S_OK);
}

HRESULT API_CALL_TYPE TaskSource::SetOwnerThread(unsigned long* inputOwnerThread)
{
    m_OwnerThread = *inputOwnerThread;
    NotifyReceiver_Thread(); //--- На момент вызова данной плдпрограммы из главного модуля в IStream уже есть информация, записанная в конструкторе TaskSource

    return (S_OK);
}

void API_CALL_TYPE TaskSource::WriteDataToLog(std::string inputE_source1, std::string inputCurrentProcName, std::string inputCurrentUnitName)
{
    std::ostringstream tmpOSS;
    tmpOSS << "--- " << wsResultStreamTitle << "\r\n" << "Сообщение сгенерировано в - " << inputCurrentProcName << "\\" << inputCurrentUnitName << "\r\n" << inputE_source1 << "\r\n";
    std::string tmpString = tmpOSS.str();

    ULONG tmpUL = {};
    if (m_spStream_Log->Write(tmpString.data(), tmpString.size(), &tmpUL) != S_OK)
    {
        std::string tmpString = "Ощибка записи в IStream журнала. Записано байт = ";
        tmpString += inttostr(tmpUL);

        return;
    }
    NotifyReceiver_Thread();
    
}

bool API_CALL_TYPE TaskSource::NotifyReceiver_Thread()
{
    if (!PostThreadMessage(m_OwnerThread, WM_Data_Update, MakeDwordAsSender(m_TaskMainModuleIndex, WORD(MessageSender.msTaskCore)), CMD_SetMemoLogStreamUpd))
    {
        std::string tmpString = "m_OwnerThread = ";
        tmpString += inttostr(m_OwnerThread);
    };

    return true;
}


//---------------------------------------------------------------------------------------

