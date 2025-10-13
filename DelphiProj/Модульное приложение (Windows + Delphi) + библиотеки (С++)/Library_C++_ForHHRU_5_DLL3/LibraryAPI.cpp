#pragma once

#include "pch.h"
#include "LibraryAPI.h"
#include <sstream>
#include <comutil.h>


//--- Блок констант и переменных
//_bstr_t
short dllLibraryId = 2;
BSTR dllFuncName = SysAllocString(L"Функционал работы с Внеш. Устр. (Библиотека №3)");
BSTR dllVersion = SysAllocString(L"1.0");
BSTR task1Name = SysAllocString(L"Обмен с устройством на базе микроконтроллера STM32");
std::vector<BSTR> vNamesTask = { task1Name };

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


DLL3_API HRESULT API_CALL_TYPE GetLibraryAPI (REFGUID guid_in, void** intrf)
{
    const GUID tmpGUID;
    const GUID* ptmpguid = &tmpGUID;
//    BSTR tmpString = SysAllocString(L"6D0957A0-EADE-4770-B448-EEE0D92F84CF");
    CLSIDFromString((LPCOLESTR) (L"6D0957A0-EADE-4770-B448-EEE0D92F84CF"), (LPCLSID) & tmpGUID);
//    SysFreeString(tmpString);
/*
    if (not IsEqualGUID((const GUID &) tmpGUID, guid_in)) {
        MessageBox(NULL, (LPCWSTR)L"IsEqualGUID(tmpGUID, guid_in) != 0", (LPCWSTR)L"Внутри DLL3: return E_NOINTERFACE", MB_OK | MB_ICONINFORMATION | MB_TASKMODAL);
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
    if (CreateStreamOnHGlobal(m_hGlobalStream, true, &m_spStream) != S_OK)
    {
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
        delete this;
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

    return (S_OK);
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
     if (CreateStreamOnHGlobal(m_hGlobalStreamResult, true, &m_Stream_Result) != S_OK)
     {
     };


     //--- Создание потока для передачи информации в журнал событий главного модуля
     if (CreateStreamOnHGlobal(m_hGlobalStreamLog, true, &m_Stream_Log) != S_OK)
     {
     };
     
     m_Ref = 1; //--- Вместо TaskSource::QueryInterface(REFIID riid, void** ppv) для первого раза 

     m_AbortExecution = false; //--- флаг для немедленного (без создания исключения) прекращения и удаления объекта TaskSource

}

TaskSource::~TaskSource()
{
    //--- Освобождение ресурсов потоков IStream для каждого TaskSource
    m_Stream_Result.Release();
    m_Stream_Log.Release();
    m_hGlobalStreamResult = NULL; //--- GlobalFree не требуется, так как при создании применён флаг - fDeleteOnRelease = true
    m_hGlobalStreamLog = NULL; //--- GlobalFree не требуется, так как при создании применён флаг - fDeleteOnRelease = true

}

HRESULT API_CALL_TYPE TaskSource::TaskProcedure()
{
    switch (this->m_TaskLibraryIndex)
    {
    case 0:
    {
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

    return (S_OK);
}

HRESULT API_CALL_TYPE TaskSource::GetTaskLibraryIndex(unsigned short& outputLibraryIndex)
{
    outputLibraryIndex = (unsigned short)dllLibraryId;

    return (S_OK);
}

HRESULT API_CALL_TYPE TaskSource::GetTask_Result(Task_Result& outputTask_Result)
{

    return (S_OK);
}

HRESULT API_CALL_TYPE TaskSource::GetTask_ResultByIndex(long* ResultIndex, Task_Result& outputTask_Result)
{

    return (S_OK);
}

HRESULT API_CALL_TYPE TaskSource::GetTask_TotalResult(DWORD& outputTask_TotalResult)
{

    return (S_OK);
}

HRESULT API_CALL_TYPE TaskSource::GetTask_ResultStream(void** outputResultStream)
{
    *outputResultStream = m_Stream_Result;

    return (S_OK);
}

HRESULT API_CALL_TYPE TaskSource::GetTask_LogStream(void** outputLogStream)
{
    *outputLogStream = m_Stream_Log;

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

HRESULT API_CALL_TYPE TaskSource::SetOwnerThread(DWORD* inputOwnerThread)
{
    m_OwnerThread = *inputOwnerThread;

    return (S_OK);
}

//---------------------------------------------------------------------------------------

