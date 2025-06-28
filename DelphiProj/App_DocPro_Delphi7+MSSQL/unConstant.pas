unit unConstant;

interface
uses Graphics;

const
    captionProgramName: string = 'Тест (2016-11-12)';
    MaxLenMyTransString: word = 1024;
    MaxRoutesPointsCount: word = 10; //--- Максимальное количество точек маршрута согласования/утверждения для заявок
    DocumentTypeCount: word = 10; //--- Максимальное количество
    maxAttachments: word = 10;
    maxObjectItemsCount_Manufacturing = 100;
    maxSavingArrayValues = 10;
    maxProcessItemArrayValues = 10;
    maxResolutionValues = 10;

    ColorZebraGrid: TColor = $EEEEEE;
    DecimalPointDelemiter = '.';
    Space = ' ';

    tsheetOrderInfo_Name: string = 'Заявки';
    tsheetStoreMTRCommonInfo_Name: string = 'Склад МТР';

    FileName_SP_Text: string = 'SP_Text.sql';
    FileName_F_Text: string = 'F_Text.sql';

    MarkerBeginStorageProcedureInFile: string = 'CREATE PROCEDURE';
    MarkerEndStorageProcedureInFile: string = '--End procedure:';
    MarkerBeginStorageProcedureInFile_AsNote: string = '--Begin procedure:';
    MarkerBeginFunctionInFile: string = 'CREATE FUNCTION';
    MarkerEndFunctionInFile: string = '--End function:';
    MarkerBeginFunctionInFile_AsNote: string = '--Begin function:';


//------------------ Наименование полей в базе данных --------------------------
    queryFieldName_SpravId: string = 'Id';
    queryFieldName_SpravCode: string = 'Code';
    queryFieldName_SpravShortName: string = 'ShortName';
    queryFieldName_SpravFullName: string = 'FullName';
    queryFieldName_SpravNotes: string = 'Notes';
    queryFieldName_SpravOrderType: string = 'OrderType';
    queryFieldName_SpravObjectGroupName: string = 'ObjectGroupName';
    queryFieldName_SpravJobItemId: string = 'JobItemIdSprav';
    queryFieldName_SpravJobItemName: string = 'JobItemNameSprav';


    queryFieldName_UserId: string = 'UserId';
    queryFieldName_UserUID: string = 'uid';
    queryFieldName_UserLogin: string = 'LoginName';
    queryFieldName_UserFullName: string = 'FullName';

    queryFieldName_JobRoleId: string = 'JobRole';
    queryFieldName_JobRoleCode: string = 'JobRoleCode';
    queryFieldName_JobRoleName: string = 'JobRoleName';
    queryFieldName_JobRoleType: string = 'JobRoleType';
    queryFieldName_JobStatus: string = 'JobType';
    queryFieldName_JobType: string = 'JobType';
    queryFieldName_JobId: string = 'ProcessJobId';
    queryFieldName_JobCode: string = 'ProcessJobCode';
    queryFieldName_ShortName: string = 'ProcessJobName';
    queryFieldName_FullName: string = 'JobTarget';
    queryFieldName_JobShort: string = 'ProcessJobName';
    queryFieldName_JobResult: string = 'JobResult';
    queryFieldName_JobResultName: string = 'JobResultName';
    queryFieldName_JobItemId: string = 'JobItemId';
    queryFieldName_JobItemLevel: string = 'JobItemLevel';
    queryFieldName_JobIsActive: string = 'IsActive';
    queryFieldName_JobIsEDD: string = 'IsEDD';
    queryFieldName_JobIsEntireDocument: string = 'IsEntireDocument';
    queryFieldName_JobIsDone: string = 'IsDone';
    queryFieldName_JobNotes: string = 'Notes';
    queryFieldName_JobNotesItem: string = 'NotesItem';

    queryFieldName_JobItemName: string = 'JobItemName';
    queryFieldName_JobIsDoneCondition: string = 'IsDoneCondition';
    queryFieldName_JobDoneCondition: string = 'DoneCondition';
    queryFieldName_JobIsDoneResolution: string = 'IsDoneResolution';
    queryFieldName_JobDoneResolution: string = 'DoneResolution';
    queryFieldName_JobConditionDependence: string = 'ConditionDependence';
    queryFieldName_DataTypeJobItem: string = 'DataTypeJobItem';


    queryFieldName_DocumentId: string = 'DocumentId';
    queryFieldName_DocumentNum: string = 'DocumentNum';
    queryFieldName_DocumentShortName: string = 'ShortName';
    queryFieldName_DocumentType: string = 'DocumentType';
    queryFieldName_DocumentStatus: string = 'DocumentStatus';
    queryFieldName_DocumentNote: string = 'Notes';
    queryFieldName_DocumentCreator: string = 'CreatorOwner';
    queryFieldName_DocumentExecutionDate: string = 'ExecutionDate';
    queryFieldName_DocumentCreationDate: string = 'CreationDate';
    queryFieldName_DocumentCycleOfApprovment: string = 'CycleNumber';

    queryFieldName_DocumentItemId: string = 'DocumentItemId';
    queryFieldName_DocumentItemCanChange: string = 'CanChangeDocumentItemState';
    queryFieldName_DocumentItemStateCurrent: string = 'DocumentItemState_Current';

    queryFieldName_ProcessId: string = 'ProcessId';
    queryFieldName_ProcessItemId: string = 'ProcessItemId';
    queryFieldName_ProcessItemLevel: string = 'ProcessItemLevel';
    queryFieldName_ProcessItemName: string = 'ProcessItemName';
    queryFieldName_TemplateProcessId: string = 'TemplateProcessId';
    queryFieldName_TemplateProcessItemId: string = 'TemplateProcessItemId';

    queryFieldName_StateCurrent: string = 'StateCurrent';

    queryFieldNameForCodeGroup: string = 'CodeGroup';
    queryFieldNameForCodeProgramRole: string = 'CodeProgramRole';
    queryFieldNameForItemName: string = 'ShortName';


    queryFieldNameForCommentText: string = 'CommentText';
    queryFieldNameForIdRoute: string = 'idRoute';
    queryFieldNameForIdRouteItem: string = 'idRouteItem';
    queryFieldNameForRouteName: string = 'RouteName';
    queryFieldNameForRoutePositionLevel: string = 'RoutePositionLevel';
    queryFieldNameForCurrentRoutesPositionLevel: string = 'CurrentRoutesPositionLevel';
//    queryFieldNameForRoutesPositionLevel: string = 'RoutesPositionLevel';
    queryFieldNameForDefaultRouteForUser: string = 'DefaultRoute';
    queryFieldNameForRoutePointName: string = 'RoutePointName';

    queryFieldNameForActiveStateOfRoute: string = 'IsDeleted';

    queryFieldName_AttachmentName: string = 'AttachmentName';
    queryFieldName_AttachmentUNCFileName: string = 'AttachmentUNCFileName';
    queryFieldName_AttachmentId: string = 'AttachmentId';
    queryFieldName_AttachmentData: string = 'AttachmentData';
    queryFieldName_IdStoreObject: string = 'idStoreObject';
    queryFieldName_IdParentOrderForStoreObject: string = 'IdParentOrder';
    queryFieldName_IdParentOrderItemForStoreObject: string = 'IdParentOrderItem';

    queryFieldName_IdObjectManufacture: string = 'id';
    queryFieldName_CodeObjectManufacture: string = 'Code';
    queryFieldName_ParentIdObjectManufacture: string = 'IdParent';
    queryFieldName_ShortNameObjectManufacture: string = 'ShortName';
    queryFieldName_FullNameObjectManufacture: string = 'FullName';
    queryFieldName_MeasurmentUnitNameObjectManufacture: string = 'MeasurmentUnitName';


    tvInputObjectName: string = 'tvObjectsInput';
    tvTotalObjectName: string = 'tvObjectsTotal';

//------------------ Значения ширины колонок Grids -----------------------------
    colOrdersIdWidth = 56;
    colOrdersNotesWidth = 477;
    colOrdersCreationDateWidth = 82;
    colOrdersCreatorOwnerWidth = 174;
    colOrdersExecutionDateWidth = 83;
    col_ShiftForSysCol = 20;
    colOrdersAttachmentIconWidth = 32;
//------------------------------------------------------------------------------

//---- Базовая панель для всех компонентов левой части формы интерфейса
     pnlBase_LeftSide_Width = 280;

//------------------ Наименования справочников ---------------------------------
//------------------ Блок на удалении! Не актуально в связи с Execute_SP ----------
    spravUser = 'sprUser';
    spravProcessStatusName = 'sprProcessStatus';
    spravJobRole = 'sprJobRole';
    spravJobName = 'TemplateProcessJob';
    spravProcessList = 'TemplateProcess';
    spravProductManufacturing = 'sprObjectManufacturing';
    SpravDocumentType = 'sprDocumentType';
    SpravObjectGroup_MTR = 'sprObjectMTRGroup';
    SpravMeasurementUnit = 'sprMeasurementUnit';
    SpravStoreObjectParentLink = 'sprStoreObjectParentLink';
//------------------------------------------------------------------------------

    INISectionForOrderFilterState = 'Filter_Orders';
    INISectionForObjectFilterState = 'Filter_StoreObjects';
implementation

end.
