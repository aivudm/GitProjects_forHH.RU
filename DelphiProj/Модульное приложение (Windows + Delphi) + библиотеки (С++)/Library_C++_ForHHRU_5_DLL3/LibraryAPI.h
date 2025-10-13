#pragma once

#define _CRT_CPP_SECURE_OVELOAD_SECURE_NAMES 1; //--- На всякий случай: если вдруг случайно будет попытка вызвать небезопасную подпрограмму

//--- Блок констант и переменных
#ifndef IID_ILibraryAPI
#define IID_ILibraryAPI = {6D0957A0-EADE-4770-B448-EEE0D92F84CF}
#endif


#ifdef LIBRARYAPI_EXPORTS
#define DLL3_API extern "C" __declspec(dllexport)
#else
#define DLL3_API __declspec(dllimport)
#endif

#define API_CALL_TYPE _stdcall
//constexpr auto API_CALL_TYPE = _stdcall;
//--- Можно не объявлять макрос, а использовать готовый - STDMETHODCALLTYPE

bool bDllInitExecuted = false;

/*
#undef IsEqualGUID 
BOOL WINAPI IsEqualGUID(
    REFGUID rguid1, REFGUID rguid2) {
    return !memcmp(rguid1, rguid2, sizeof(GUID));
}
*/
//--- Предварительное объявление
struct IBSTRItems;
class BSTRItems;

struct ITaskSource;
class TaskSource;
//------------------------------

__declspec(uuid("6D0957A0-EADE-4770-B448-EEE0D92F84CF")) __declspec(novtable)
//MIDL_INTERFACE("6D0957A0-EADE-4770-B448-EEE0D92F84CF")
class ILibraryAPI : public IUnknown
{
    // GUID данного интерфейса - uuid("6D0957A0-EADE-4770-B448-EEE0D92F84CF");
    //const GUID ILibraryAPI_GUID = __GUID("{6D0957A0-EADE-4770-B448-EEE0D92F84CF}");
public:
    virtual HRESULT API_CALL_TYPE GetId(unsigned long& outputId) = 0;
    virtual HRESULT API_CALL_TYPE GetName(BSTR& outputName) = 0;
    virtual HRESULT API_CALL_TYPE GetVersion(BSTR& outputVersion) = 0;
    virtual HRESULT API_CALL_TYPE GetTaskList(void** outputIBSTRItems) = 0;
    virtual HRESULT API_CALL_TYPE GetTaskCount(char& outputTaskCount) = 0;
    virtual HRESULT API_CALL_TYPE NewTaskSource(unsigned short* inputLibraryTaskIndex, unsigned short* inputMainModuleTaskIndex, ITaskSource** outputTaskSource) = 0;
    virtual HRESULT API_CALL_TYPE GetTaskSource(unsigned short* inputLibraryTaskIndex, ITaskSource** outputTaskSource) = 0;
    virtual HRESULT API_CALL_TYPE GetStream(void** outputStream) = 0;
    virtual HRESULT API_CALL_TYPE SetOwnerThread(unsigned long* inputOwnerThread) = 0;
    virtual HRESULT API_CALL_TYPE InitDLL() = 0;
    virtual HRESULT API_CALL_TYPE FinalizeDLL() = 0;
    virtual HRESULT API_CALL_TYPE FreeTaskSource(unsigned short* inputMainModuleTaskIndex) = 0;
    //    __declspec(property(get = GetName)) BSTR Name;  //--- Для использования (совместимости) в главном модуле (Delphi)
//    __declspec(property(get = GetVersion)) BSTR Version;  //--- Для использования (совместимости) в главном модуле (Delphi)
//    __declspec(property(get = GetTaskCount)) char TaskCount;  //--- Для использования (совместимости) в главном модуле (Delphi)
};


class LibraryAPI : public ILibraryAPI
{
private:
    unsigned long m_Ref;
    unsigned long m_libraryId;
    BSTR m_libraryFuncName;
    BSTR m_libraryVersion;
    char m_TaskCount;
    IBSTRItems* m_TaskList;
    unsigned long m_OwnerThread;
    CComPtr<IStream> m_spStream = NULL;
    HGLOBAL m_hGlobalStream = NULL;

public:

    HRESULT API_CALL_TYPE QueryInterface(REFIID riid, void** ppvObject);
    ULONG   API_CALL_TYPE AddRef();
    ULONG   API_CALL_TYPE Release();

    HRESULT API_CALL_TYPE GetId(unsigned long& outputId);
    HRESULT API_CALL_TYPE GetName(BSTR& outputName);
    HRESULT API_CALL_TYPE GetVersion(BSTR& outputVersion);
    HRESULT API_CALL_TYPE GetTaskList(void** outputIBSTRItems);
    HRESULT API_CALL_TYPE GetTaskCount(char& outputTaskCount);
    HRESULT API_CALL_TYPE NewTaskSource(unsigned short* inputLibraryTaskIndex, unsigned short* inputMainModuleTaskIndex, ITaskSource** outputTaskSource);
    HRESULT API_CALL_TYPE GetTaskSource(unsigned short* inputLibraryTaskIndex, ITaskSource** outputTaskSource);
    HRESULT API_CALL_TYPE GetStream(void** outputStream);
    HRESULT API_CALL_TYPE SetOwnerThread(unsigned long* inputOwnerThread);
    HRESULT API_CALL_TYPE InitDLL();
    HRESULT API_CALL_TYPE FinalizeDLL();
    HRESULT API_CALL_TYPE FreeTaskSource(unsigned short* inputMainModuleTaskIndex);
    LibraryAPI();
    ~LibraryAPI();
};

static LibraryAPI*  pLibraryAPI = nullptr;
static std::list<TaskSource*>  pTaskSourceList = {};
//static BSTRItems*    pLibraryInfoItems;


//extern "C" LibraryAPI* libraryAPI APIENTRY GetLibraryAPI();
DLL3_API HRESULT API_CALL_TYPE GetLibraryAPI (REFGUID guid_in, void** intrf);

__declspec(uuid("7988654F-59FB-401F-9E4C-972FF343C66B"))
class IBSTRItems : public IUnknown
{
    // GUID данного интерфейса - uuid("7988654F-59FB-401F-9E4C-972FF343C66B");
    //__declspec(uuid("7988654F-59FB-401F-9E4C-972FF343C66B"))
public:

    virtual HRESULT API_CALL_TYPE GetCount(unsigned long& outCount) = 0;
    virtual HRESULT API_CALL_TYPE GetString(const unsigned long* inputIndexItem, BSTR& outString) = 0;
//    virtual BSTR API_CALL_TYPE GetString(const int& index) = 0;
};

class BSTRItems : public IBSTRItems
{
private:
    DWORD m_Ref;
    std::vector<BSTR> m_BSTRItems;
public:
    HRESULT API_CALL_TYPE QueryInterface(REFIID riid, void** ppv);
    ULONG   API_CALL_TYPE AddRef();
    ULONG   API_CALL_TYPE Release();

    HRESULT API_CALL_TYPE GetCount(unsigned long& outCount);
    HRESULT API_CALL_TYPE GetString(const unsigned long* inputIndexItem, BSTR& outString);
//    BSTR API_CALL_TYPE GetString(const int& index);
    BSTRItems(const std::vector<BSTR>& inputBSTRItems);
    ~BSTRItems();
};



//--------------------------------------------------------------------------------------------------------------------------------------------------
//--- TaskSource
//--------------------------------------------------------------------------------------------------------------------------------------------------

struct Task_Result
{

};

__declspec(uuid("697522A7-7EEC-47D5-91E1-928242F770FE")) __declspec(novtable)
class ITaskSource : public IUnknown
{
    // GUID данного интерфейса - uuid("697522A7-7EEC-47D5-91E1-928242F770FE");
    //const GUID ILibraryAPI_GUID = __GUID("{697522A7-7EEC-47D5-91E1-928242F770FE}");
public:
    virtual HRESULT API_CALL_TYPE TaskProcedure() = 0;
    virtual HRESULT API_CALL_TYPE AbortTaskSource() = 0;
    virtual HRESULT API_CALL_TYPE GetTaskLibraryIndex(unsigned short& outputLibraryIndex) = 0;
    virtual HRESULT API_CALL_TYPE GetTask_Result(Task_Result& outputTask_Result) = 0;
    virtual HRESULT API_CALL_TYPE GetTask_ResultByIndex(long* inputResultIndex, Task_Result& outputTask_Result) = 0;
    virtual HRESULT API_CALL_TYPE GetTask_TotalResult(DWORD& outputTask_TotalResult) = 0;
    virtual HRESULT API_CALL_TYPE GetTask_ResultStream(void** outputResultStream) = 0;
    virtual HRESULT API_CALL_TYPE GetTask_LogStream(void** outputLogStream) = 0;
    virtual HRESULT API_CALL_TYPE GetAbortExecutionState(bool& outputAbortState) = 0;
    virtual HRESULT API_CALL_TYPE SetAbortExecutionState(bool* inputAbortState) = 0;
    virtual HRESULT API_CALL_TYPE SetTaskMainModuleIndex(unsigned short* inputTaskMainModuleIndex) = 0;
    virtual HRESULT API_CALL_TYPE SetOwnerThread(DWORD* inputOwnerThread) = 0;


//    __declspec(property(get = GetTaskLibraryIndex)) unsigned int TaskLibraryIndex;  //--- Для использования (совместимости) в главном модуле (Delphi)
};

class TaskSource : public ITaskSource
{
private:
    DWORD m_Ref;
    unsigned short   m_TaskLibraryIndex;
    unsigned short   m_TaskMainModuleIndex;
    unsigned short   m_TaskSourceListIndex;
    unsigned long    m_OwnerThread;
    CComPtr<IStream> m_Stream_Result;
//    std::stringstream m_StringStream_Result;
    CComPtr<IStream> m_Stream_Log;
    //    std::stringstream m_StringStream_Log;
    HGLOBAL m_hGlobalStreamResult = NULL;
    HGLOBAL m_hGlobalStreamLog = NULL;

protected:
    DWORD           m_Task_TotalResult;
//    Task_Results    m_Task_Results;
//    Task_Result     m_Task_Result;
    HRESULT API_CALL_TYPE TaskProcedure();

public:
    HRESULT API_CALL_TYPE QueryInterface(REFIID riid, void** ppv);
    ULONG   API_CALL_TYPE AddRef();
    ULONG   API_CALL_TYPE Release();

    bool    m_AbortExecution;

    TaskSource(const unsigned short* inputTaskLibraryIndex);
    ~TaskSource();
    HRESULT API_CALL_TYPE AbortTaskSource();
    HRESULT API_CALL_TYPE GetTaskLibraryIndex(unsigned short& outputLibraryIndex);
    HRESULT API_CALL_TYPE GetTask_Result(Task_Result& outputTask_Result);
    HRESULT API_CALL_TYPE GetTask_ResultByIndex(long* inputResultIndex, Task_Result& outputTask_Result);
    HRESULT API_CALL_TYPE GetTask_TotalResult(DWORD& outputTask_TotalResult);
    HRESULT API_CALL_TYPE GetTask_ResultStream(void** outputResultStream);
    HRESULT API_CALL_TYPE GetTask_LogStream(void** outputLogStream);
    HRESULT API_CALL_TYPE GetAbortExecutionState(bool& outputAbortState);
    HRESULT API_CALL_TYPE SetAbortExecutionState(bool* inputAbortState);
    HRESULT API_CALL_TYPE SetTaskMainModuleIndex(unsigned short* inputTaskMainModuleIndex);
    HRESULT API_CALL_TYPE SetOwnerThread(DWORD* inputOwnerThread);
//    HRESULT API_CALL_TYPE WriteDataToLog(BSTR* inputE_source1, BSTR* inputCurrentProcName, BSTR* inputCurrentUnitName);
//    HRESULT API_CALL_TYPE NotifyReceiver_Thread(bool& outputNotifyResult);



};
