USE [DocPro]
GO
/****** Object:  UserDefinedFunction [dbo].[f_CanChangeDocument_User]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






Create  FUNCTION [dbo].[f_CanChangeDocument_User](@input_DocumentId bigint, @inputTargetUser int)
returns tinyint
AS
begin

declare @Result tinyint
set @Result = 0

if dbo.f_GetDocumentItemInitiator(dbo.f_GetDocumentItemId_First(@input_DocumentId)) = @inputTargetUser 
begin
 set @Result = 1
end

done:
return @Result

end


















GO
/****** Object:  UserDefinedFunction [dbo].[f_CanChangeDocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE  FUNCTION [dbo].[f_CanChangeDocumentItem](@input_DocumentItemId bigint)
returns tinyint
AS
begin

declare @Result tinyint
set @Result = 0

set @Result = (dbo.f_CanChangeDocumentItemState_Agree(@input_DocumentItemId) + dbo.f_CanChangeDocumentItemState_Deny(@input_DocumentItemId))

done:
return @Result

end

















GO
/****** Object:  UserDefinedFunction [dbo].[f_CanChangeDocumentItem_User]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





Create  FUNCTION [dbo].[f_CanChangeDocumentItem_User](@input_DocumentItemId bigint, @inputTargetUser int)
returns tinyint
AS
begin

declare @Result tinyint
set @Result = 0

if dbo.f_GetDocumentItemInitiator(@input_DocumentItemId) = @inputTargetUser 
begin
 set @Result = 1
end

done:
return @Result

end

















GO
/****** Object:  UserDefinedFunction [dbo].[f_CanChangeDocumentItemState]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  FUNCTION [dbo].[f_CanChangeDocumentItemState](@input_DocumentItemId bigint)
returns tinyint
AS
begin

declare @Result tinyint
set @Result = 0

-- Маршрут соблюдён ? Т.е. текущий пользователь (фактически - ЭП) пытается изменить состояние ЭД, который находится на данном ЭП;
if (dbo.f_GetJobRole_byProcessItem(dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId)) not in (select JobRole from dbo.f_GetJobRoleTotal_forUser(dbo.f_GetUserName_Current()))
	and
	dbo.f_GetJobRole_byProcessItem(dbo.f_GetProcessItemNext_ProcessItem(dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId))) not in (select JobRole from dbo.f_GetJobRoleTotal_forUser(dbo.f_GetUserName_Current())))
begin
 set @Result = 0
 goto done
end


set @Result = dbo.f_CanChangeDocumentItemState_Agree(@input_DocumentItemId)
set @Result = @Result | dbo.f_CanChangeDocumentItemState_Deny(@input_DocumentItemId)

done:
return @Result

end
















GO
/****** Object:  UserDefinedFunction [dbo].[f_CanChangeDocumentItemState_Agree]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  FUNCTION [dbo].[f_CanChangeDocumentItemState_Agree](@input_DocumentItemId bigint)
returns tinyint
AS
begin

declare @Result tinyint
set @Result = 0


--Текущее состояние "Отказано" и пользователь на текущем ЭП (вдруг передумал и имеет полное право согласовать ЭД)
if dbo.f_GetDocumentItemState_Current(@input_DocumentItemId) = dbo.f_GetJobResult_Denied()
   and (dbo.f_GetJobRole_byProcessItem(dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId)) in (select JobRole from dbo.f_GetJobRoleTotal_forUser(dbo.f_GetUserName_Current())))
begin
 set @Result = 1
 goto done
end

-- текущий пользователь (должность) - владелец текущего состояния и новое состояние равно текущему (фактически — это лишнее и бессмысленное действие, только DocumentItemState засорять дублирующей информацией)
-- но! выявился случай, при котором эта ситуация не бессмысленна, а именно: например, User2 замещает User1 и сначала он согласовывает от себя, а потом тут же ему приходит этот же ЭД на утверждение уже как
-- замещающему User1. И тогда set @Result = 0 не разрешит изменение состояния User2 в роли User1.
if dbo.f_GetDocumentItemState_Current(@input_DocumentItemId) = dbo.f_GetJobResult_Agreed() 
   and (dbo.f_GetJobRole_byProcessItem(dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId)) in (select JobRole from dbo.f_GetJobRoleTotal_forUser(dbo.f_GetUserName_Current())))
begin
 set @Result = 1	-- Изначально было set @Result = 0 (но!)
 goto done
end

-- Последнее состояние - "Отказано", которое было на одном из предшествующих ProcessItem, кроме текущего (текущий ЭП отработан выше)
-- Тут надо подумать, а что если та же JobRole в виде алиаса будет на следующих ЭП (скорее всего она сможет изменить состояние и тогда ЭД перепрыгнет сразу на ЭП, где алиас...)
if dbo.f_GetDocumentItemState_Current(@input_DocumentItemId) = dbo.f_GetJobResult_Denied() and (dbo.f_GetJobRole_byProcessItem(dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId)) in (select JobRole from dbo.f_GetJobRoleTotal_forUser(dbo.f_GetUserName_Current())))
--(dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId))
begin
 set @Result = 0
 goto done
end

-- Проверить факт того, что текущий ЭП является следующим по маршруту для ЭП, которому принадлежит текущее состояние
if (dbo.f_GetJobRole_byProcessItem(dbo.f_GetProcessItemNext_DocumentItem(@input_DocumentItemId, dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId))) in (select JobRole from dbo.f_GetJobRoleTotal_forUser(dbo.f_GetUserName_Current())))
begin
 set @Result = 1
 goto done
end

-- Если не одно из вышеперечисленных условий не выполнено, то констатируем факт - Потльзователь может изменить текущее состояние на "Положительно".
set @Result = 1

done:
return @Result

end















GO
/****** Object:  UserDefinedFunction [dbo].[f_CanChangeDocumentItemState_Alter]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  FUNCTION [dbo].[f_CanChangeDocumentItemState_Alter](@input_DocumentItemId bigint)
returns tinyint
AS
begin

declare @Result tinyint
set @Result = 0
declare @CurrentDocumentItem_State int
declare @CurrentDocumentItem_JobRole int


set @CurrentDocumentItem_JobRole = dbo.f_GetJobRole_byUserName(dbo.f_GetUserName_Current())
set @CurrentDocumentItem_State = dbo.f_GetJobResult_Agreed()


-- Последнее состояние - "Отказано" и JobRole другая
if dbo.f_GetDocumentItemState_Current(@input_DocumentItemId) = dbo.f_GetJobResult_Denied() and (dbo.f_GetJobRoleLastState_DocumentItem(@input_DocumentItemId) != @CurrentDocumentItem_JobRole)
begin
 set @Result = 0
 goto done
end


-- Если не одно из вышеперечисленных условий не выполнено, то констатируем факт - Потльзователь может изменить состояние на требуемое.
set @Result = 1

done:
return @Result

end
















GO
/****** Object:  UserDefinedFunction [dbo].[f_CanChangeDocumentItemState_Deny]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  FUNCTION [dbo].[f_CanChangeDocumentItemState_Deny](@input_DocumentItemId bigint)
returns tinyint
AS
begin

declare @Result tinyint

--Текущее состояние "Положительно" и пользователь на текущем ЭП (вдруг передумал и имеет полное право отказать по данному ЭД)
if dbo.f_GetDocumentItemState_Current(@input_DocumentItemId) = dbo.f_GetJobResult_Agreed()
   and (dbo.f_GetJobRole_byProcessItem(dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId)) in (select JobRole from dbo.f_GetJobRoleTotal_forUser(dbo.f_GetUserName_Current())))
begin
 set @Result = 1
 goto done
end

-- текущий пользователь (должность) - владелец текущего состояния и новое состояние равно текущему (фактически — это лишнее и бессмысленное действие, только DocumentItemState засорять дублирующей информацией)
if dbo.f_GetDocumentItemState_Current(@input_DocumentItemId) = dbo.f_GetJobResult_Denied() 
   and (dbo.f_GetJobRole_byProcessItem(dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId)) in (select JobRole from dbo.f_GetJobRoleTotal_forUser(dbo.f_GetUserName_Current())))
begin
 set @Result = 0
 goto done
end

-- Последнее состояние - "Отказано", которое было на одном из предшествующих ProcessItem, кроме текущего (текущий ЭП отработан выше)
-- Тут надо подумать, а что если та же JobRole в виде алиаса будет на следующих ЭП (скорее всего она сможет изменить состояние и тогда ЭД перепрыгнет сразу на ЭП, где алиас...)
if dbo.f_GetDocumentItemState_Current(@input_DocumentItemId) = dbo.f_GetJobResult_Denied() and (dbo.f_GetJobRole_byProcessItem(dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId)) in (select JobRole from dbo.f_GetJobRoleTotal_forUser(dbo.f_GetUserName_Current())))
--(dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId))
begin
 set @Result = 0
 goto done
end

-- Проверить факт того, что текущий ЭП является следующим по маршруту для ЭП, которому принадлежит текущее состояние
if (dbo.f_GetJobRole_byProcessItem(dbo.f_GetProcessItemNext_DocumentItem(@input_DocumentItemId, dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId))) in (select JobRole from dbo.f_GetJobRoleTotal_forUser(dbo.f_GetUserName_Current())))
begin
 set @Result = 1
 goto done
end

-- Если не одно из вышеперечисленных условий не выполнено, то констатируем факт - Потльзователь может изменить текущее состояние на "Отказано".
set @Result = 1


done:
return @Result

end
















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetActionCode_StockAccepted]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[f_GetActionCode_StockAccepted]()
RETURNS tinyint
AS
BEGIN
	RETURN  4

END












GO
/****** Object:  UserDefinedFunction [dbo].[f_GetDocument_DocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  FUNCTION [dbo].[f_GetDocument_DocumentItem](@input_DocumentItemId bigint)
RETURNS bigint
AS
BEGIN

 declare @DocumentId int
 

 set @DocumentId = (Select di.DocumentId from DocumentItem as di where di.Id = @input_DocumentItemId)

 
return @DocumentId

END















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetDocumentItemCount]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  FUNCTION [dbo].[f_GetDocumentItemCount](@input_DocumentId bigint)
RETURNS bigint
AS
BEGIN

 declare @DocumentItemCount int
 

 set @DocumentItemCount = (Select count(di.id) from DocumentItem as di where di.DocumentId = @input_DocumentId)

 
return @DocumentItemCount

END















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetDocumentItemCycleNumber_Current]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE  FUNCTION [dbo].[f_GetDocumentItemCycleNumber_Current](@input_DocumentItemId bigint)
RETURNS bigint
AS
BEGIN

 declare @DocumentItemCycleNumber_Current int

 set @DocumentItemCycleNumber_Current = (Select di.CycleNumber from DocumentItem as di where di.id = @input_DocumentItemId)
 
return IsNull(@DocumentItemCycleNumber_Current, 0)

END

















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetDocumentItemId_First]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  FUNCTION [dbo].[f_GetDocumentItemId_First](@input_DocumentId bigint)
RETURNS bigint
AS
BEGIN

 declare @FirstDocumentItem int
 

 set @FirstDocumentItem = (Select top 1 di.id from DocumentItem as di where di.DocumentId = @input_DocumentId)

 
return @FirstDocumentItem

END














GO
/****** Object:  UserDefinedFunction [dbo].[f_GetDocumentItemInitiator]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE  FUNCTION [dbo].[f_GetDocumentItemInitiator](@input_DocumentItemId bigint)
RETURNS bigint
AS
BEGIN

 declare @DocumentItemInitiator int
 

 set @DocumentItemInitiator = (Select dl.CreatorOwner from DocumentList as dl where dl.id = dbo.f_GetDocument_DocumentItem(@input_DocumentItemId))

 
return @DocumentItemInitiator

END

















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetDocumentItemNum_New]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  FUNCTION [dbo].[f_GetDocumentItemNum_New](@input_DocumentId bigint)
RETURNS bigint
AS
BEGIN

 --SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 
 Declare @NewDocumentItemNum bigint
 Select @NewDocumentItemNum = max(IsNull(di.ItemNum, 1)) from DocumentItem as di Where di.DocumentId = @input_DocumentId
 
RETURN @NewDocumentItemNum + 1

END














GO
/****** Object:  UserDefinedFunction [dbo].[f_GetDocumentItemState_byUser]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE  FUNCTION [dbo].[f_GetDocumentItemState_byUser](@input_DocumentItemId bigint)
RETURNS bigint
AS
BEGIN

 declare @DocumentItemState_ForUser int

 set @DocumentItemState_ForUser = (Select top 1 dis.JobResult from dbo.f_GetDocumentItem_State(@input_DocumentItemId) as dis where dis.DocumentItem = @input_DocumentItemId
									and dis.JobRole in (select JobRole from dbo.f_GetJobRoleTotal_forUser(dbo.f_GetUserName_Current()))
									order by dis.StateId desc)
 
return IsNull(@DocumentItemState_ForUser, 0)

END

















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetDocumentItemState_Current]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  FUNCTION [dbo].[f_GetDocumentItemState_Current](@input_DocumentItemId bigint)
RETURNS bigint
AS
BEGIN

 declare @DocumentItemState_Current int

 set @DocumentItemState_Current = (Select top 1 dis.JobResult from dbo.f_GetDocumentItem_State(@input_DocumentItemId) as dis where dis.DocumentItem = @input_DocumentItemId 
									and dis.CycleNumber = dbo.f_GetDocumentItemCycleNumber_Current(@input_DocumentItemId)
									order by dis.StateId desc)
 
return IsNull(@DocumentItemState_Current, 0)

END
















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetDocumentItemState_Last_byProcessItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  FUNCTION [dbo].[f_GetDocumentItemState_Last_byProcessItem](@input_DocumentItemId bigint, @input_TargetProcessItemId bigint)
RETURNS bigint
AS
BEGIN

 declare @DocumentItemState_Last int
 

 set @DocumentItemState_Last = (select dis.id as StateId from DocumentItemState as dis
				where dis.DocumentItem = @input_DocumentItemId and dis.ProcessItem = @input_TargetProcessItemId
					 and dis.id = (select max(dis1.id) from DocumentItemState as dis1 where dis1.DocumentItem = @input_DocumentItemId))

 
return @DocumentItemState_Last

END
















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetDocumentNum_New]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  FUNCTION [dbo].[f_GetDocumentNum_New]()
RETURNS bigint
AS
BEGIN

 --SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 
 Declare @NewDocumentNum bigint
 Select @NewDocumentNum = max(IsNull(dl.DocumentNum, 0)) from DocumentList as dl
 

RETURN IsNull(@NewDocumentNum, 0) + 1

END













GO
/****** Object:  UserDefinedFunction [dbo].[f_GetJobResult_Agreed]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  FUNCTION [dbo].[f_GetJobResult_Agreed]()
RETURNS int
AS
BEGIN
	RETURN 1

END








GO
/****** Object:  UserDefinedFunction [dbo].[f_GetJobResult_AgreedCondition]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[f_GetJobResult_AgreedCondition]()
RETURNS tinyint
AS
BEGIN
	RETURN 4

END











GO
/****** Object:  UserDefinedFunction [dbo].[f_GetJobResult_Alter]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[f_GetJobResult_Alter]()
RETURNS tinyint
AS
BEGIN
	RETURN 3

END











GO
/****** Object:  UserDefinedFunction [dbo].[f_GetJobResult_Denied]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[f_GetJobResult_Denied]()
RETURNS tinyint
AS
BEGIN
	RETURN 2

END










GO
/****** Object:  UserDefinedFunction [dbo].[f_GetJobRole_byProcessItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  FUNCTION [dbo].[f_GetJobRole_byProcessItem](@input_ProcessItem bigint)
RETURNS int
AS
BEGIN
	RETURN (Select pii.JobRole From ProcessItemInstance as pii Where pii.id = @input_ProcessItem)

END








GO
/****** Object:  UserDefinedFunction [dbo].[f_GetJobRole_byUserName]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  FUNCTION [dbo].[f_GetJobRole_byUserName](@input_LoginName varchar (256))
RETURNS int
AS
BEGIN
	RETURN (Select _u.JobRole From sprUser as _u Where _u.LoginName = rtrim(@input_LoginName))

END







GO
/****** Object:  UserDefinedFunction [dbo].[f_GetJobRoleLastState_DocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  FUNCTION [dbo].[f_GetJobRoleLastState_DocumentItem](@input_DocumentItemId bigint)
RETURNS bigint
AS
BEGIN

 declare @DocumentItemJobRole_Last int
 

 set @DocumentItemJobRole_Last = (Select top 1 dis.JobRole from dbo.f_GetDocumentItem_State(@input_DocumentItemId) as dis
														  where dis.DocumentItem = @input_DocumentItemId
														  order by dis.StateId desc)

 
return IsNull(@DocumentItemJobRole_Last, 0)

END
















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetJobRoleReal_byVirtual]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  FUNCTION [dbo].[f_GetJobRoleReal_byVirtual](@input_VirtualJobRole int, @input_LoginName varchar (256))
RETURNS int
AS
BEGIN
Declare @UserId int
Declare @RealJobRole int

Select @RealJobRole =
Case When @input_VirtualJobRole = 1 Then dbo.f_GetJobRole_byUserName(@input_LoginName)
	 When @input_VirtualJobRole = 3 Then (Select _jr.Chief From sprJobRole as _jr Where _jr.id = dbo.f_GetJobRole_byUserName(@input_LoginName))
	 End
	RETURN (@RealJobRole)

END






GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessInstance_Document]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  FUNCTION [dbo].[f_GetProcessInstance_Document](@input_DocumentId bigint)
RETURNS bigint
AS
BEGIN

 declare @ProcessInstance bigint
 
 select @ProcessInstance = dl.Process From DocumentList as dl where dl.id = @input_DocumentId

return @ProcessInstance

END















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessInstance_DocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  FUNCTION [dbo].[f_GetProcessInstance_DocumentItem](@input_DocumentItemId bigint)
RETURNS bigint
AS
BEGIN

 declare @Document bigint
 declare @ProcessInstance bigint
 select @Document = di.DocumentId From DocumentItem as di where di.id = @input_DocumentItemId
 select @ProcessInstance = dl.Process From DocumentList as dl where dl.id = @Document

return @ProcessInstance

END














GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessItemActive_DocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  FUNCTION [dbo].[f_GetProcessItemActive_DocumentItem](@input_DocumentItemId bigint)
RETURNS bigint
AS
BEGIN

 Declare @ActiveProcessItem int
 
 -- Активный - это следующий по маршруту ЭП за Текущим ЭП. Он ещё не текущий (!) и может им не стать, вообще, так как предыдущий Role может запретить данный ЭД
 -- до того момента, как Активный не перейдёт в Текущий.
 set @ActiveProcessItem = (dbo.f_GetProcessItemNext_ProcessItem(dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId)))
 
RETURN @ActiveProcessItem

END













GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessItemCount]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  FUNCTION [dbo].[f_GetProcessItemCount](@input_ProcessId bigint)
RETURNS bigint
AS
BEGIN

 declare @ProcessItemCount int
 

 set @ProcessItemCount = (Select count(pii.id) from ProcessItemInstance as pii where pii.Process = @input_ProcessId)

 
return @ProcessItemCount

END














GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessItemCurrent_Document]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  FUNCTION [dbo].[f_GetProcessItemCurrent_Document](@input_DocumentId bigint)
RETURNS bigint
AS
BEGIN
--Примечание: После того, как стал отрабатываться новый алгоритм - «не зависимых ЭД» выявилось, что само понятие «Текущий Этап Процесса» 
-- не актуально в плане применения к объекту Процесс, так как для каждого Элемента Документа существует индивидуальный «Текущий Этап Процесса». 
-- Вывод: Удалить поле CurrentProcessItem из ProcessInstance, TemplateProcess. В качестве альтернативы «Текущий Этап Процесса» для Процесса
-- можно использовать самый меньший Этап процесса из всех Элементов Документа — получать функцией f_GetProcessItemMinimal_Document(TargetProcessId).
 
 
 Declare @CurrentProcessItem int
 set @CurrentProcessItem = dbo.f_GetProcessItemMinimal_Document(@input_DocumentId)
  

 
RETURN @CurrentProcessItem

END













GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessItemCurrent_DocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[f_GetProcessItemCurrent_DocumentItem](@input_DocumentItemId bigint)
RETURNS bigint
AS
BEGIN

 Declare @CurrentProcessItem int
 
 -- Вариант, когда хранение номера текущего ЭП не производится в принципе (в поле ProcessItemId таблицы DocumentItem)
 -- Текущий ЭП "вычисляется" из журнала состояний (DocumentItemState), а следующий ЭП (или текущий, доступный для отработки)
 -- получается вызовом комбинации функций: f_GetProcessItemNext_DocumentItem(f_GetProcessItemLast_DocumentItem(...))
 -- внутри функции f_GetDocumentItem_Input(...)
 set @CurrentProcessItem = (Select top 1 dis.ProcessItem from dbo.f_GetDocumentItem_State(@input_DocumentItemId) as dis where dis.DocumentItem = @input_DocumentItemId order by dis.StateId desc)
 if IsNull(@CurrentProcessItem, 0) = 0
 begin
   set @CurrentProcessItem = (dbo.f_GetProcessItemFirst_DocumentItem(@input_DocumentItemId)) -- Если в журнале состояний (DocumentItemState) нет записей для ЭД
																							-- значит ЭД ещё на этапе "Формирование" (т.е. на первом ЭП).
 end
-- Вариант, когда хранение номера текущего ЭП происходит в поле ProcessItemId таблицы DocumentItem
 --set @CurrentProcessItem = (Select di.ProcessItemId from DocumentItem as di where di.id = @input_DocumentItemId)
 
RETURN IsNull(@CurrentProcessItem, -1)

END












GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessItemCurrent_DocumentItem_ForUser]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  FUNCTION [dbo].[f_GetProcessItemCurrent_DocumentItem_ForUser](@input_DocumentItemId bigint)
RETURNS bigint
AS
BEGIN

 Declare @CurrentProcessItem int
 
 set @CurrentProcessItem = (Select top 1 dis.ProcessItem from DocumentItemState as dis where dis.DocumentItem = @input_DocumentItemId
																						and dis.JobRole = dbo.f_GetUserJobRole_byName(dbo.f_GetUserName_Current())
																						order by dis.ProcessItem desc)


RETURN @CurrentProcessItem

END













GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessItemFirst_Document]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  FUNCTION [dbo].[f_GetProcessItemFirst_Document](@input_DocumentId bigint)
RETURNS bigint
AS
BEGIN

 declare @FirstProcessItem int
 

 set @FirstProcessItem = (Select pii.id from ProcessItemInstance as pii where pii.Process = dbo.f_GetProcessInstance_Document(@input_DocumentId) and pii.ItemLevel = 1)

 
return @FirstProcessItem

END














GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessItemFirst_DocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  FUNCTION [dbo].[f_GetProcessItemFirst_DocumentItem](@input_DocumentItemId bigint)
RETURNS bigint
AS
BEGIN

 declare @FirstProcessItem int
 

 set @FirstProcessItem = (Select pii.id from ProcessItemInstance as pii where pii.Process = dbo.f_GetProcessInstance_DocumentItem(@input_DocumentItemId) and pii.ItemLevel = 1)

 
return @FirstProcessItem

END













GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessItemId_byLevel]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  FUNCTION [dbo].[f_GetProcessItemId_byLevel](@input_ProcessId bigint, @input_ProcessItemLevel int)
returns bigint
AS
begin

 declare @ProcessItemId bigint
 

 set @ProcessItemId = IsNull((Select pii.id from ProcessItemInstance as pii where pii.Process = @input_ProcessId and pii.ItemLevel = @input_ProcessItemLevel), -1)

 
return @ProcessItemId

END














GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessItemId_ExecutingMTR]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  FUNCTION [dbo].[f_GetProcessItemId_ExecutingMTR](@input_ProcessId bigint)
returns bigint
AS
begin

 declare @ProcessItemId bigint
 

-- Когда в ProcessItemInstance и ProcessItemTemplate добавится колонка IsJobExecuting
-- set @ProcessItemId = IsNull((Select pii.id from ProcessItemInstance as pii where pii.Process = @input_ProcessId and IsNull(pii.IsJobExecuting, 0) = 1), -1)
set @ProcessItemId = IsNull((Select pii.id from ProcessItemInstance as pii where pii.Process = @input_ProcessId and pii.ItemLevel = 5), -1)

 
return @ProcessItemId

END















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessItemLast_DocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  FUNCTION [dbo].[f_GetProcessItemLast_DocumentItem](@input_DocumentItemId bigint)
RETURNS bigint
AS
BEGIN

 declare @LastProcessItem int
 

 set @LastProcessItem = IsNull((Select pii.id from ProcessItemInstance as pii where pii.Process = dbo.f_GetProcessInstance_DocumentItem(@input_DocumentItemId) 
																				and pii.ItemLevel = dbo.f_GetProcessItemCount(dbo.f_GetProcessInstance_DocumentItem(@input_DocumentItemId))), -1)

 
return @LastProcessItem

END














GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessItemLevel_byId]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  FUNCTION [dbo].[f_GetProcessItemLevel_byId](@input_ProcessItemId bigint)
returns bigint
AS
begin

 declare @ProcessItemLevel int
 

 set @ProcessItemLevel = (Select pii.ItemLevel from ProcessItemInstance as pii where pii.id = @input_ProcessItemId)

 
return @ProcessItemLevel

END















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessItemMinimal_Document]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  FUNCTION [dbo].[f_GetProcessItemMinimal_Document](@input_DocumentId bigint)
RETURNS bigint
AS
BEGIN

 declare @MinimalProcessItem bigint
 declare @TargetDocumentItem bigint

 set @MinimalProcessItem = (Select min(di.ProcessItemId) from dbo.f_GetDocumentItem_byDocument(@input_DocumentId) as di)

/*
 set @MinimalProcessItem = (Select min(dis.ProcessItem) from dbo.f_GetDocumentItem_State(@input_DocumentId) as dis where dis.DocumentItem in (select di.id from dbo.f_GetDocumentItem(@input_DocumentId) as di))

 set @TargetDocumentItem = (select top 1 dis.DocumentItem from dbo.f_GetDocumentItem_State(@input_DocumentId) as dis where  dis.DocumentItem in (select di.id from dbo.f_GetDocumentItem(@input_DocumentId) as di) and dis.ProcessItem = @MinimalProcessItem)
 
 set @MinimalProcessItem = dbo.f_GetProcessItemNext_DocumentItem(@TargetDocumentItem, Null)
*/

return @MinimalProcessItem

END















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessItemNext_DocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  FUNCTION [dbo].[f_GetProcessItemNext_DocumentItem](@input_DocumentItemId bigint, @input_JobResult int)
RETURNS bigint
AS
BEGIN

 Declare @NextProcessItemId bigint
 Declare @TargetProcessId bigint
 Declare @TargetItemLevel int

 
 set @NextProcessItemId = -1

 set @TargetProcessId = dbo.f_GetProcessInstance_DocumentItem(@input_DocumentItemId)

 --set @NextProcessItemId = dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId)
 --select @NextProcessItemId

 -- Проверка: Если текущее состояние по данному Элементу Документа - "Отказано" или текущее Действие - "Отказано", то просто выдаем на выход текущее состояние (по данному ЭД дальше "ходу" нет)
 
 if dbo.f_GetDocumentItemState_Current(@input_DocumentItemId) = dbo.f_GetJobResult_Denied() or @input_JobResult = dbo.f_GetJobResult_Denied()
 begin
  set @NextProcessItemId = dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId)

  Goto Done
 end

-- if Isnull(@input_JobResult, 0) = 0 or Isnull(@input_JobResult, 0) = dbo.f_GetJobResult_Agreed()

 if @input_JobResult = dbo.f_GetJobResult_Agreed()
 begin
-- Select pii.id from ProcessItemInstance as pii where pii.Process = dbo.f_GetProcessInstance_DocumentItem(@input_DocumentItemId) and pii.ItemLevel = 1
  set @NextProcessItemId = (Select pii.id From ProcessItemInstance as pii Where IsNull(pii.ParentItem, 0) = dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId))
  Goto Done
 end	
 
 if @input_JobResult = dbo.f_GetJobResult_Alter()
 begin
  set @NextProcessItemId = dbo.f_GetProcessItemFirst_DocumentItem(@input_DocumentItemId)
  Goto Done
 end	


Done:
RETURN @NextProcessItemId

END













GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessItemNext_ProcessItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  FUNCTION [dbo].[f_GetProcessItemNext_ProcessItem](@input_ProcessItemId bigint)
RETURNS bigint
AS
BEGIN

 declare @NextProcessItemId bigint
 set @NextProcessItemId = (Select pii.id From ProcessItemInstance as pii Where pii.ParentItem = @input_ProcessItemId)
	
 
Done:
RETURN IsNull(@NextProcessItemId, -1)

END















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessItemPred_ProcessItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  FUNCTION [dbo].[f_GetProcessItemPred_ProcessItem](@input_ProcessItemId bigint)
RETURNS bigint
AS
BEGIN

 declare @PredProcessItemId bigint
 set @PredProcessItemId = (Select pii.ParentItem From ProcessItemInstance as pii Where pii.id = @input_ProcessItemId)
	
 
Done:
RETURN @PredProcessItemId

END














GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessTemplate_Process]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  FUNCTION [dbo].[f_GetProcessTemplate_Process](@input_ProcessId bigint)
RETURNS bigint
AS
BEGIN

 declare @ProcessTemplate bigint
 
 select @ProcessTemplate = pi.ProcessTemplate From ProcessInstance as pi where pi.id = @input_ProcessId

return @ProcessTemplate

END
















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetTemplateJobItemLevel_New]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  FUNCTION [dbo].[f_GetTemplateJobItemLevel_New](@input_TemplateProcessitem bigint)
RETURNS bigint
AS
BEGIN

 --SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 
 Declare @NewJobItemLevelNum bigint
 Select @NewJobItemLevelNum = max(IsNull(tji.JobItemLevel, 0)) from TemplateJobItem as tji where tji.ProcessItemTemplate = @input_TemplateProcessitem
 

RETURN IsNull(@NewJobItemLevelNum, 0) + 1

END














GO
/****** Object:  UserDefinedFunction [dbo].[f_GetTemplateProcess__byTemplateProcessItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  FUNCTION [dbo].[f_GetTemplateProcess__byTemplateProcessItem](@input_TemplateProcessItemId bigint)
returns bigint
AS
begin

 declare @ProcessItemId bigint
 

 set @ProcessItemId = IsNull((Select tpi.ProcessTemplate from TemplateProcessItem as tpi where tpi.id = @input_TemplateProcessItemId), -1)

 
return @ProcessItemId

END
















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetTemplateProcessItemCount]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  FUNCTION [dbo].[f_GetTemplateProcessItemCount](@input_TemplateProcessId bigint)
RETURNS int
AS
BEGIN

 declare @TemplateProcessItemCount int
 

 set @TemplateProcessItemCount = (Select count(tpi.id) from TemplateProcessItem as tpi where tpi.ProcessTemplate = @input_TemplateProcessId and IsNull(tpi.IsDeleted, 0) = 0)

 
return @TemplateProcessItemCount

END















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetTemplateProcessItemId_byLevel]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  FUNCTION [dbo].[f_GetTemplateProcessItemId_byLevel](@input_TemplateProcessId bigint, @input_ProcessItemLevel int)
returns bigint
AS
begin

 declare @ProcessItemId bigint
 

 set @ProcessItemId = IsNull((Select tpi.id from TemplateProcessItem as tpi where tpi.ProcessTemplate = @input_TemplateProcessId and tpi.ItemLevel = @input_ProcessItemLevel), -1)

 
return @ProcessItemId

END















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetTemplateProcessItemId_byParentId]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE  FUNCTION [dbo].[f_GetTemplateProcessItemId_byParentId](@input_TemplateProcessId bigint, @input_ParentId bigint)
returns bigint
AS
begin

 declare @ProcessItemLevel int
 

 set @ProcessItemLevel = IsNull((Select tpi.ParentItem from TemplateProcessItem as tpi where tpi.ProcessTemplate = @input_TemplateProcessId and tpi.ParentItem = @input_ParentId), -1)

 
return @ProcessItemLevel

END


















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetTemplateProcessItemId_byProcessItemInstanceId]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  FUNCTION [dbo].[f_GetTemplateProcessItemId_byProcessItemInstanceId](@input_ProcessItemInstanceId bigint)
returns bigint
AS
begin

 declare @ProcessTemplateId bigint
 declare @ProcessItemTemplateId bigint
 
 set @ProcessTemplateId = (select pi.ProcessTemplate from ProcessInstance as pi where pi.id = (Select pii.Process from ProcessItemInstance as pii where pii.id = @input_ProcessItemInstanceId))
 set @ProcessItemTemplateId = (select tpi.id from TemplateProcessItem as tpi where tpi.ItemLevel = (Select pii.ItemLevel from ProcessItemInstance as pii where pii.id = @input_ProcessItemInstanceId))

 
return @ProcessItemTemplateId

END















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetTemplateProcessItemLevel_byId]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  FUNCTION [dbo].[f_GetTemplateProcessItemLevel_byId](@input_TemplateProcessItemId bigint)
returns bigint
AS
begin

 declare @ProcessItemLevel int
 

 set @ProcessItemLevel = (Select tpi.ItemLevel from TemplateProcessItem as tpi where tpi.id = @input_TemplateProcessItemId)

 
return @ProcessItemLevel

END
















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetTemplateProcessItemParent_byId]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE  FUNCTION [dbo].[f_GetTemplateProcessItemParent_byId](@input_TemplateProcessItemId bigint)
returns bigint
AS
begin

 declare @ProcessItemLevel int
 

 set @ProcessItemLevel = IsNull((Select tpi.ParentItem from TemplateProcessItem as tpi where tpi.id = @input_TemplateProcessItemId), -1)

 
return @ProcessItemLevel

END

















GO
/****** Object:  UserDefinedFunction [dbo].[f_GetUniqTransactionName]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[f_GetUniqTransactionName]()
RETURNS Varchar(64)
AS
BEGIN
	DECLARE @ResultVar Varchar(64)
	select @ResultVar = 'tr_' + rtrim(CONVERT(varchar(100), @@TOTAL_WRITE))
	-- Return the result of the function
	RETURN @ResultVar

END






GO
/****** Object:  UserDefinedFunction [dbo].[f_GetUserFullName_byId]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[f_GetUserFullName_byId](@input_UserId int)
RETURNS Varchar(128)
AS
BEGIN
	RETURN (Select _u.FullName From sprUser as _u Where _u.id = @input_UserId)

END










GO
/****** Object:  UserDefinedFunction [dbo].[f_GetUserId_byName]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[f_GetUserId_byName](@input_LoginName varchar (256))
RETURNS int
AS
BEGIN
	RETURN (Select _u.id From sprUser as _u Where _u.LoginName = rtrim(@input_LoginName))

END





GO
/****** Object:  UserDefinedFunction [dbo].[f_GetUserJobRole_byName]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  FUNCTION [dbo].[f_GetUserJobRole_byName](@input_LoginName varchar (256))
RETURNS int
AS
BEGIN
	RETURN (Select _u.JobRole From sprUser as _u Where _u.LoginName = rtrim(@input_LoginName))

END






GO
/****** Object:  UserDefinedFunction [dbo].[f_GetUserLoginName_byId]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  FUNCTION [dbo].[f_GetUserLoginName_byId](@input_UserId int)
RETURNS Varchar(128)
AS
BEGIN
	RETURN (Select _u.LoginName From sprUser as _u Where _u.id = @input_UserId)

END










GO
/****** Object:  UserDefinedFunction [dbo].[f_GetUserName_byId]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[f_GetUserName_byId](@input_UserId int)
RETURNS Varchar(128)
AS
BEGIN
	RETURN (Select _u.ShortName From sprUser as _u Where _u.id = @input_UserId)

END









GO
/****** Object:  UserDefinedFunction [dbo].[f_GetUserName_Current]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  FUNCTION [dbo].[f_GetUserName_Current]()
returns Varchar(64)
as
begin
	return suser_name()
end











GO
/****** Object:  UserDefinedFunction [dbo].[f_GetVirtualJobRoleName]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  FUNCTION [dbo].[f_GetVirtualJobRoleName](@input_VirtualJobRoleId int)
RETURNS varchar(128)
AS
BEGIN
Declare @VirtualJobRoleName varchar(64)

Select @VirtualJobRoleName = _jrv.ShortName From sprJobRole_Virtual as _jrv Where _jrv.id = @input_VirtualJobRoleId


RETURN (@VirtualJobRoleName)

END







GO
/****** Object:  UserDefinedFunction [dbo].[f_IsEDDStatusExists_TemplateProcessItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  FUNCTION [dbo].[f_IsEDDStatusExists_TemplateProcessItem](@input_TemplateProcessItemId bigint)   -- Входной параметр DocumentItem, так как для Document не имеет смысла понятие "Документ находится на ... Этапе Процесса"
RETURNS tinyint
AS
BEGIN

declare @bResult tinyint

Set @bResult = 0
if Exists(select tji.id from TemplateJobItem as tji where tji.ProcessItemTemplate = @input_TemplateProcessItemId and IsNull(tji.IsEDD, 0) > 0  and IsNull(tji.IsDeleted, 0) = 0)
begin
  set @bResult = 1
end

Out:
RETURN @bResult
END







GO
/****** Object:  UserDefinedFunction [dbo].[f_IsEntireDocumentStatusExists_TemplateProcessItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE  FUNCTION [dbo].[f_IsEntireDocumentStatusExists_TemplateProcessItem](@input_TemplateProcessItemId bigint)   -- Входной параметр DocumentItem, так как для Document не имеет смысла понятие "Документ находится на ... Этапе Процесса"
RETURNS tinyint
AS
BEGIN

declare @bResult tinyint

Set @bResult = 0
if Exists(select tji.id from TemplateJobItem as tji where tji.ProcessItemTemplate = @input_TemplateProcessItemId and IsNull(tji.IsEntireDocument, 0) > 0  and IsNull(tji.IsDeleted, 0) = 0)
begin
  set @bResult = 1
end

Out:
RETURN @bResult
END








GO
/****** Object:  UserDefinedFunction [dbo].[f_IsJobExists_Document]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  FUNCTION [dbo].[f_IsJobExists_Document](@input_DocumentId bigint)
RETURNS tinyint
AS
BEGIN

declare @bResult tinyint
declare @bIsActive tinyint
declare @bIsEntireDocument tinyint
Declare @TargetProcessItemId bigint

-- Получим Id текущего Этапа Процесса для первого ЭД (так как в случаее ЭДД у всех ЭД всё одинаковое) (@input_DocumentItemId)
 Set @TargetProcessItemId = dbo.f_GetProcessItemCurrent_DocumentItem(dbo.f_GetDocumentItemId_First(@input_DocumentId))

Set @bResult = 0
if Exists(select jii.id from JobItemInstance as jii where jii.ProcessItem = @TargetProcessItemId and (IsNull(jii.IsEntireDocument, -1) = 1 or IsNull(jii.IsEntireDocument, -1) = -1) and IsNull(jii.IsActive, 0) = 1)
begin
  set @bResult = 1
end

Out:
RETURN @bResult
END






GO
/****** Object:  UserDefinedFunction [dbo].[f_IsJobExists_DocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  FUNCTION [dbo].[f_IsJobExists_DocumentItem](@input_DocumentItemId bigint)
RETURNS tinyint
AS
BEGIN

declare @bResult tinyint
declare @bIsActive tinyint
declare @bIsDone tinyint
Declare @TargetProcessItemId bigint

-- Получим Id текущего Этапа Процесса для требуемого ЭД (@input_DocumentItemId)
 Select @TargetProcessItemId = dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId)

Set @bResult = 0
if Exists(select jii.id from JobItemInstance as jii where jii.ProcessItem = @TargetProcessItemId and IsNull(jii.IsActive, 0) = 1 and IsNull(jii.IsEntireDocument, 0) = 0)
begin
  set @bResult = 1
end

Out:
RETURN @bResult
END





GO
/****** Object:  UserDefinedFunction [dbo].[f_IsJobItemExtendExists_DocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  FUNCTION [dbo].[f_IsJobItemExtendExists_DocumentItem](@input_DocumentItemId bigint)
RETURNS tinyint
AS
BEGIN

declare @bResult tinyint
declare @bIsActive tinyint
declare @bIsDone tinyint

Set @bResult = 0

if Exists( Select jiiem.id From JobItemInstanceExtend_Match as jiiem
							Where IsNull(jiiem.IsDeleted, 0) = 0 and jiiem.JobItem in (select ji.JobItemId from dbo.f_GetJobItem_DocumentItem(@input_DocumentItemId) as ji))
begin
  set @bResult = @bResult | 1
end

if Exists( Select jiiem.id From JobItemInstanceExtend_Date as jiiem
							Where IsNull(jiiem.IsDeleted, 0) = 0 and jiiem.JobItem in (select ji.JobItemId from dbo.f_GetJobItem_DocumentItem(@input_DocumentItemId) as ji))
begin
  set @bResult = @bResult | 1
end

if Exists( Select jiiem.id From JobItemInstanceExtend_Resolution as jiiem
							Where IsNull(jiiem.IsDeleted, 0) = 0 and jiiem.JobItem in (select ji.JobItemId from dbo.f_GetJobItem_DocumentItem(@input_DocumentItemId) as ji))
begin
  set @bResult = @bResult | 1
end

Out:
RETURN @bResult
END






GO
/****** Object:  UserDefinedFunction [dbo].[f_IsProcessItemValid]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  FUNCTION [dbo].[f_IsProcessItemValid](@input_ProcessId int)
RETURNS tinyint
AS
BEGIN
 if IsNull(@input_ProcessId, 0) = 0
	RETURN 0 /*Отрицательный ответ*/

declare @bResult tinyint
/*
if not exists(select _rl.Code from sprRoutesList as _rl where _rl.Code = @input_IdRoute)
begin
 select @ProgramError = 112
 select @strNote = ''
 Goto Error
end     
---------------------------- Проверка № 1 -------------------------------------------------------------------------------------
-------------------- Количество этапов процесса должно быть равно последнему номеру этапа в процессе --------------------------
-------------------------------------------------------------------------------------------------------------------------------
if (Select count(ri.id) from RoutesItems as ri Where IsNull(ri.IsDeleted, 0) = 0 and ri.IdRoute = @input_IdRouteAsInteger) = 
	(Select max(ri1.RoutesPositionLevel) from RoutesItems as ri1 Where IsNull(ri1.IsDeleted, 0) = 0 and ri1.IdRoute = @input_IdRouteAsInteger)
 Set @bResult = 0
else
begin
 Set @bResult = 1
 Goto Out
end

Declare @TargetRoutePositionLevel int
---------------------------- Проверка № 2 -------------------------------------------------------------------------------------
-------------------- Первой позицией в маршруте должно быть - "Формирование" --------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
Set @TargetRoutePositionLevel = (Select min(ri.RoutesPositionLevel) from RoutesItems as ri Where IsNull(ri.IsDeleted, 0) = 0 and ri.IdRoute = @input_IdRouteAsInteger)
if (Select ri1.ProcessStatusId from RoutesItems as ri1 Where IsNull(ri1.IsDeleted, 0) = 0 and ri1.IdRoute = @input_IdRouteAsInteger and ri1.RoutesPositionLevel = @TargetRoutePositionLevel) = dbo.f_GetIdInitiatingProcessStatus()
 Set @bResult = 0
else
begin
 Set @bResult = 2
 Goto Out
end


---------------------------- Проверка № 3 -------------------------------------------------------------------------------------
-------------------- Предпоcледней позицией в маршруте должно быть - "Оприходование на склад" -------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
Set @TargetRoutePositionLevel = (Select max(ri.RoutesPositionLevel)-1 from RoutesItems as ri Where IsNull(ri.IsDeleted, 0) = 0 and ri.IdRoute = @input_IdRouteAsInteger)
if (Select ri1.ProcessStatusId from RoutesItems as ri1 Where IsNull(ri1.IsDeleted, 0) = 0 and ri1.IdRoute = @input_IdRouteAsInteger and ri1.RoutesPositionLevel = @TargetRoutePositionLevel) = (dbo.f_GetIdStoringProcessStatus())
 Set @bResult = 0
else
begin
 Set @bResult = 3
 Goto Out
end

---------------------------- Проверка № 4 -------------------------------------------------------------------------------------
-------------------- Поcледней позицией в маршруте должно быть - "Архив (выполнена)" ------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
Set @TargetRoutePositionLevel = (Select max(ri.RoutesPositionLevel) from RoutesItems as ri Where IsNull(ri.IsDeleted, 0) = 0 and ri.IdRoute = @input_IdRouteAsInteger)
if (Select ri1.ProcessStatusId from RoutesItems as ri1 Where IsNull(ri1.IsDeleted, 0) = 0 and ri1.IdRoute = @input_IdRouteAsInteger and ri1.RoutesPositionLevel = @TargetRoutePositionLevel) = (dbo.f_GetIdExecutedProcessStatus())
 Set @bResult = 0
else
begin
 Set @bResult = 4
 Goto Out
end


---------------------------- Проверка № 5 -------------------------------------------------------------------------------------
-------------------- Кроме первой и последней позиции, во всех остальных должна быть указана должность точки маршрута ---------
-------------------------------------------------------------------------------------------------------------------------------
if (Select count(ri.id) from RoutesItems as ri Where IsNull(ri.IsDeleted, 0) = 0
													 and ri.IdRoute = @input_IdRouteAsInteger
													 and IsNull(ri.JobPosition, 0) = 0
													 and ri.RoutesPositionLevel != 1
													 and ri.RoutesPositionLevel != (Select max(ri1.RoutesPositionLevel) from RoutesItems as ri1 Where IsNull(ri1.IsDeleted, 0) = 0 and ri1.IdRoute = @input_IdRouteAsInteger))
													 = 0
 Set @bResult = 0
else
 Set @bResult = 5
*/

Out:
RETURN @bResult
END




GO
/****** Object:  UserDefinedFunction [dbo].[f_IsProcessTemplateInvolvedInDocument]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[f_IsProcessTemplateInvolvedInDocument](@input_TemplateProcessId bigint)
RETURNS bit
AS
BEGIN

declare @bResult bit
if (Select count(pi.id) from ProcessInstance as pi
								Where pi.ProcessTemplate = @input_TemplateProcessId) > 0
 Set @bResult = 1
else
 Set @bResult = 0

RETURN @bResult
END










GO
/****** Object:  UserDefinedFunction [dbo].[f_IsProgrammabilityObjectExists]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[f_IsProgrammabilityObjectExists](@input_ObjectName varchar(1024) = NULL)
RETURNS bit
AS
BEGIN
 if IsNull(@input_ObjectName, '') = ''
	RETURN 0 /*Отрицательный ответ*/

declare @bResult bit
if (SELECT count(so.id) FROM sysobjects as so WHERE name = @input_ObjectName and (type = 'P' or type = 'FN')) > 0
 Select @bResult = 1
else
 Select @bResult = 0

RETURN @bResult
END











GO
/****** Object:  UserDefinedFunction [dbo].[f_IsRoutePointExists]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[f_IsRoutePointExists](@input_RouteCode int, @input_RoutePositionLevel int)
RETURNS bit
AS
BEGIN
 if (IsNull(@input_RouteCode, 0) = 0) or (IsNull(@input_RoutePositionLevel, 0) = 0)
	RETURN 0 /*Отрицательный ответ*/

declare @bResult bit

if exists(Select ri.id From RoutesItems as ri Where ri.IdRoute = @input_RouteCode
													and ri.RoutesPositionLevel = @input_RoutePositionLevel)
 Set @bResult = 1
else
 Set @bResult = 0


Out:
RETURN @bResult
END












GO
/****** Object:  UserDefinedFunction [dbo].[f_IsRouteValid]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[f_IsRouteValid](@input_IdRouteAsInteger int)
RETURNS tinyint
AS
BEGIN
 if IsNull(@input_IdRouteAsInteger, 0) = 0
	RETURN 0 /*Отрицательный ответ*/

declare @bResult tinyint
---------------------------- Проверка № 1 -------------------------------------------------------------------------------------
-------------------- Количество позиций маршрута должно быть равно последнему номеру в маршруте -------------------------------
-------------------------------------------------------------------------------------------------------------------------------
if (Select count(ri.id) from RoutesItems as ri Where IsNull(ri.IsDeleted, 0) = 0 and ri.IdRoute = @input_IdRouteAsInteger) = 
	(Select max(ri1.RoutesPositionLevel) from RoutesItems as ri1 Where IsNull(ri1.IsDeleted, 0) = 0 and ri1.IdRoute = @input_IdRouteAsInteger)
 Set @bResult = 0
else
begin
 Set @bResult = 1
 Goto Out
end

Declare @TargetRoutePositionLevel int
---------------------------- Проверка № 2 -------------------------------------------------------------------------------------
-------------------- Первой позицией в маршруте должно быть - "Формирование" --------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
Set @TargetRoutePositionLevel = (Select min(ri.RoutesPositionLevel) from RoutesItems as ri Where IsNull(ri.IsDeleted, 0) = 0 and ri.IdRoute = @input_IdRouteAsInteger)
if (Select ri1.ProcessStatusId from RoutesItems as ri1 Where IsNull(ri1.IsDeleted, 0) = 0 and ri1.IdRoute = @input_IdRouteAsInteger and ri1.RoutesPositionLevel = @TargetRoutePositionLevel) = dbo.f_GetIdInitiatingProcessStatus()
 Set @bResult = 0
else
begin
 Set @bResult = 2
 Goto Out
end


---------------------------- Проверка № 3 -------------------------------------------------------------------------------------
-------------------- Предпоcледней позицией в маршруте должно быть - "Оприходование на склад" -------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
Set @TargetRoutePositionLevel = (Select max(ri.RoutesPositionLevel)-1 from RoutesItems as ri Where IsNull(ri.IsDeleted, 0) = 0 and ri.IdRoute = @input_IdRouteAsInteger)
if (Select ri1.ProcessStatusId from RoutesItems as ri1 Where IsNull(ri1.IsDeleted, 0) = 0 and ri1.IdRoute = @input_IdRouteAsInteger and ri1.RoutesPositionLevel = @TargetRoutePositionLevel) = (dbo.f_GetIdStoringProcessStatus())
 Set @bResult = 0
else
begin
 Set @bResult = 3
 Goto Out
end

---------------------------- Проверка № 4 -------------------------------------------------------------------------------------
-------------------- Поcледней позицией в маршруте должно быть - "Архив (выполнена)" ------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
Set @TargetRoutePositionLevel = (Select max(ri.RoutesPositionLevel) from RoutesItems as ri Where IsNull(ri.IsDeleted, 0) = 0 and ri.IdRoute = @input_IdRouteAsInteger)
if (Select ri1.ProcessStatusId from RoutesItems as ri1 Where IsNull(ri1.IsDeleted, 0) = 0 and ri1.IdRoute = @input_IdRouteAsInteger and ri1.RoutesPositionLevel = @TargetRoutePositionLevel) = (dbo.f_GetIdExecutedProcessStatus())
 Set @bResult = 0
else
begin
 Set @bResult = 4
 Goto Out
end


---------------------------- Проверка № 5 -------------------------------------------------------------------------------------
-------------------- Кроме первой и последней позиции, во всех остальных должна быть указана должность точки маршрута ---------
-------------------------------------------------------------------------------------------------------------------------------
if (Select count(ri.id) from RoutesItems as ri Where IsNull(ri.IsDeleted, 0) = 0
													 and ri.IdRoute = @input_IdRouteAsInteger
													 and IsNull(ri.JobPosition, 0) = 0
													 and ri.RoutesPositionLevel != 1
													 and ri.RoutesPositionLevel != (Select max(ri1.RoutesPositionLevel) from RoutesItems as ri1 Where IsNull(ri1.IsDeleted, 0) = 0 and ri1.IdRoute = @input_IdRouteAsInteger))
													 = 0
 Set @bResult = 0
else
 Set @bResult = 5


Out:
RETURN @bResult
END



GO
/****** Object:  UserDefinedFunction [dbo].[f_IsThereAlteringOrderForThis]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[f_IsThereAlteringOrderForThis](@input_IdOrder bigint = NULL)
RETURNS bigint
AS
BEGIN
 if IsNull(@input_IdOrder, 0) = 0
	RETURN 0 /*Отрицательный ответ*/

 Declare @Altering_IdOrder bigint
 Select @Altering_IdOrder = (Select dl.id from DocumentList as dl 
												join DocumentCommonInfo as dci On dl.id = dci.IdOrder
										  Where dci.IdParentOrder = @input_IdOrder and dl.ProcessStatus = dbo.f_GetProcessStatusId_Altering())
 if IsNull(@Altering_IdOrder, 0) != 0
	RETURN @Altering_IdOrder /*Возвращаем номер доп. заявки в состоянии "На переоформлении"*/	

RETURN 0 /*false*/

END









GO
/****** Object:  UserDefinedFunction [dbo].[xxx_f_CanChangeDocumentItemState_Agree]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  FUNCTION [dbo].[xxx_f_CanChangeDocumentItemState_Agree](@input_DocumentItemId bigint)
returns tinyint
AS
begin

declare @Result tinyint
set @Result = 0
declare @DocumentId int
declare @LastDocumentItem_JobRole int
declare @CurrentDocumentItem_State int
declare @CurrentDocumentItem_JobRole int

set @DocumentId = dbo.f_GetDocument_DocumentItem(@input_DocumentItemId)

set @LastDocumentItem_JobRole = (Select top 1 dis.JobRole from dbo.f_GetDocumentItem_State(@DocumentId) as dis order by dis.DocumentItem desc)

set @CurrentDocumentItem_JobRole = dbo.f_GetJobRole_byUserName(dbo.f_GetUserName_Current())
set @CurrentDocumentItem_State = (Select top 1 t1.JobResult From (Select top 1 dis.JobResult, dis.JobRole from dbo.f_GetDocumentItem_State(@DocumentId) as dis order by dis.DocumentItem desc) as t1 where t1.JobRole = @CurrentDocumentItem_JobRole)

-- Предыдущее состояние - отказано
if dbo.f_GetDocumentItemStatus_Last(@input_DocumentItemId) = dbo.f_GetJobResult_Denied() and (@LastDocumentItem_JobRole != @CurrentDocumentItem_JobRole)
begin
 set @Result = 0
 goto done
end

-- Текущее состояние - ещё не присвоено на данном Этапе
if IsNull(@CurrentDocumentItem_State, 0) = 0
begin
 set @Result = 1
 goto done
end

-- текущий пользователь (должность) - владелец данного состояния и новое состояние не равно предыдущему (бессмысленное действие)
if (@LastDocumentItem_JobRole = dbo.f_GetJobRole_byUserName(dbo.f_GetUserName_Current())) and
	(IsNull(@CurrentDocumentItem_State, 0) != dbo.f_GetJobResult_Agreed())	
begin
 set @Result = 1
 goto done
end

 
done:
return @Result

end
















GO
/****** Object:  UserDefinedFunction [dbo].[xxx_f_GetDefaultRouteForUser]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[xxx_f_GetDefaultRouteForUser](@input_UserNameAsString varchar(256))
RETURNS int
AS
BEGIN
 if IsNull(@input_UserNameAsString, '') = ''
	RETURN 0 /*Отрицательный ответ*/


/*Возвращаем номер маршрута по умолчанию*/
RETURN (Select _u.DefaultRoute from sprUsers as _u Where _u.id = dbo.f_GetUserIdByName(@input_UserNameAsString) and IsNull(_u.IsDeleted, 0) = 0)
END










GO
/****** Object:  UserDefinedFunction [dbo].[xxx_f_GetDocumentItemAgreed_Initiator]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[xxx_f_GetDocumentItemAgreed_Initiator](@input_DocumentId bigint)
RETURNS bigint
AS
begin
 declare @CountDocumentItemAgreed bigint
 declare @Initiator_JobRole int
 declare @InitiatorUserId int
 declare @InitiatorUserName varchar(128)

 if dbo.f_GetProcessItemCurrent_DocumentItem(dbo.f_GetDocumentItemId_First(@input_DocumentId)) != 1
 begin
  set @CountDocumentItemAgreed = -1
  goto done
 end

 set @InitiatorUserId = (select dl.CreatorOwner from DocumentList as dl where dl.id = @input_DocumentId)
 set @InitiatorUserName = dbo.f_GetUserLoginName_byId(@InitiatorUserId)
 set @Initiator_JobRole = dbo.f_GetJobRole_byUserName(@InitiatorUserName)

 set @CountDocumentItemAgreed = (select count(di.id) from DocumentItem as di
								left join DocumentItemState as dis on (dis.DocumentItem = di.id)
								where di.DocumentId = @input_DocumentId and
										dis.JobRole = @Initiator_JobRole and
										IsNull(di.IsDeleted, 0) =0)
 
 done:
return @CountDocumentItemAgreed

end









GO
/****** Object:  UserDefinedFunction [dbo].[xxx_f_GetDocumentItemState_Current_ForUser]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE  FUNCTION [dbo].[xxx_f_GetDocumentItemState_Current_ForUser](@input_DocumentItemId bigint)
RETURNS bigint
AS
BEGIN

 declare @DocumentItemState_Current int


 set @DocumentItemState_Current = (Select top 1 dis.JobResult from DocumentItemState as dis where dis.DocumentItem = @input_DocumentItemId 
																								   and dis.ProcessItem = IsNull(dbo.f_GetProcessItemCurrent_DocumentItem_ForUser(@input_DocumentItemId), 0)
																							order by dis.id desc)

 
return @DocumentItemState_Current

END













GO
/****** Object:  UserDefinedFunction [dbo].[xxx_f_GetDocumentItemState_Last]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  FUNCTION [dbo].[xxx_f_GetDocumentItemState_Last](@input_DocumentItemId bigint)
RETURNS bigint
AS
BEGIN

 declare @DocumentItemState_Last int
 

 set @DocumentItemState_Last = (Select top 1 dis.JobResult from dbo.f_GetDocumentItem_State(@input_DocumentItemId) as dis where dis.DocumentItem = @input_DocumentItemId order by dis.StateId desc)

 
return @DocumentItemState_Last

END















GO
/****** Object:  UserDefinedFunction [dbo].[xxx_f_GetDocumentStatus_Agreements]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[xxx_f_GetDocumentStatus_Agreements]()
RETURNS tinyint
AS
BEGIN
	RETURN (Select _ps.Code from sprProcessStatus as _ps Where _ps.id = 2) -- Code = 2  -- Согласование

END









GO
/****** Object:  UserDefinedFunction [dbo].[xxx_f_GetDocumentStatus_Altering]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[xxx_f_GetDocumentStatus_Altering]()
RETURNS tinyint
AS
BEGIN
	RETURN (Select _ps.Code from sprProcessStatus as _ps Where _ps.id = 11) -- Code = 7  -- Для переоформления

END








GO
/****** Object:  UserDefinedFunction [dbo].[xxx_f_GetDocumentStatus_Approves]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[xxx_f_GetDocumentStatus_Approves]()
RETURNS tinyint
AS
BEGIN
	RETURN (Select _ps.Code from sprProcessStatus as _ps Where _ps.id = 3) -- Code = 3  -- Утверждение

END









GO
/****** Object:  UserDefinedFunction [dbo].[xxx_f_GetDocumentStatus_Denied]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[xxx_f_GetDocumentStatus_Denied]()
RETURNS tinyint
AS
BEGIN
	RETURN (Select _ps.Code from sprProcessStatus as _ps Where _ps.id = 10) -- Code = 6  -- Отменённая

END








GO
/****** Object:  UserDefinedFunction [dbo].[xxx_f_GetDocumentStatus_Executed]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[xxx_f_GetDocumentStatus_Executed]()
RETURNS tinyint
AS
BEGIN
	RETURN (Select _ps.Code from sprProcessStatus as _ps Where _ps.id = 5) -- 99  -- Архив (выполненные)

END









GO
/****** Object:  UserDefinedFunction [dbo].[xxx_f_GetDocumentStatus_Executing]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[xxx_f_GetDocumentStatus_Executing]()
RETURNS tinyint
AS
BEGIN
	RETURN (Select _ps.Code from sprProcessStatus as _ps Where _ps.id = 4) -- Code = 4  -- Оприходование на склад

END










GO
/****** Object:  UserDefinedFunction [dbo].[xxx_f_GetDocumentStatus_Initiating]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[xxx_f_GetDocumentStatus_Initiating]()
RETURNS tinyint
AS
BEGIN
	RETURN (Select _ps.Code from sprProcessStatus as _ps Where _ps.id = 1) -- Code = 1 -- Формирование

END








GO
/****** Object:  UserDefinedFunction [dbo].[xxx_f_GetDocumentStatus_Storing]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[xxx_f_GetDocumentStatus_Storing]()
RETURNS tinyint
AS
BEGIN
	RETURN (Select _ps.Code from sprProcessStatus as _ps Where _ps.id = 12) -- Code = 8  -- Оприходование на склад

END


GO
/****** Object:  UserDefinedFunction [dbo].[xxx_f_GetNextRoutePosLevel]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[xxx_f_GetNextRoutePosLevel](@input_TargetRoute int, @input_CurrentRoutePosLevel int)
RETURNS bigint
AS
BEGIN

----------------- Защита от дурака --------------------------------------------------------
 if (IsNull(@input_TargetRoute, 0) = 0) or (IsNull(@input_CurrentRoutePosLevel, 0) = 0)
	RETURN -1 /*Отрицательный ответ*/
-------------------------------------------------------------------------------------------

 Declare @NextRoutePosLevel int
  Set @NextRoutePosLevel = @input_CurrentRoutePosLevel + 1
  if @NextRoutePosLevel > (Select max(ri.RoutesPositionLevel) from RoutesItems as ri where ri.IdRoute = @input_TargetRoute)
  begin
   Set @NextRoutePosLevel = -1
  end
 --Select @NextRoutePosLevel = (Select ri.rouFrom RoutesItems as ri Where ri.IdRoute = @input_TargetRoute)

 
RETURN @NextRoutePosLevel

END













GO
/****** Object:  UserDefinedFunction [dbo].[xxx_f_GetOrderType_MTR]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[xxx_f_GetOrderType_MTR]()
RETURNS tinyint
AS
BEGIN
	RETURN 1

END












GO
/****** Object:  UserDefinedFunction [dbo].[xxx_f_GetProcess_Route]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  FUNCTION [dbo].[xxx_f_GetProcess_Route](@input_TargetProcess int)
RETURNS bigint
AS
BEGIN

RETURN (Select _pl.ProcessRoute from sprProcessList as _pl where _pl.Code = @input_TargetProcess)

END













GO
/****** Object:  UserDefinedFunction [dbo].[f_GetDocumentItem_byDocument]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[f_GetDocumentItem_byDocument](@input_DocumentId bigint)
							
RETURNS TABLE 
AS
RETURN 
(

select di.id, di.DocumentId, di.ProcessItemId, di.ShortName, di.sys_creationdate, di.Notes from DocumentItem as di 
where di.DocumentId = @input_DocumentId and IsNull(di.IsDeleted, 0) =0

)



GO
/****** Object:  UserDefinedFunction [dbo].[f_GetJobRoleAlias_forUser]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[f_GetJobRoleAlias_forUser]
							(@inputLoginName varchar(128))

RETURNS TABLE 
AS
RETURN 
(
 select jra.JobRoleAlias from JobRole_Alias as jra 
					where jra.JobRole = dbo.f_GetJobRole_byUserName(@inputLoginName)
)

GO
/****** Object:  UserDefinedFunction [dbo].[f_GetJobRoleTotal_forUser]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[f_GetJobRoleTotal_forUser]
							(@inputLoginName varchar(128))

RETURNS TABLE 
AS
RETURN 
(
 select dbo.f_GetJobRole_byUserName(@inputLoginName) as JobRole

 union all
 select jra1.JobRoleAlias as JobRole from dbo.f_GetJobRoleAlias_forUser(@inputLoginName) as jra1
)
GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessItem_UserVisibled]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[f_GetProcessItem_UserVisibled]()
							
RETURNS TABLE 
AS
RETURN 
(

select distinct pii1.id, pii1.Process from ProcessItemInstance as pii1	where pii1.JobRole in (select jrt.JobRole from dbo.f_GetJobRoleTotal_forUser(dbo.f_GetUserName_Current()) as jrt)

/*
select distinct pii.id, pii.Process from ProcessItemInstance as pii 
					where pii.Process in (select pi.id from ProcessInstance as pi
													where pi.id in (select pii1.Process as id from ProcessItemInstance as pii1
																							where pii1.JobRole in (select jrt.JobRole from dbo.f_GetJobRoleTotal_forUser(dbo.f_GetUserName_Current()) as jrt)))
*/


)




GO
/****** Object:  UserDefinedFunction [dbo].[f_GetDocumentItem_Total]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[f_GetDocumentItem_Total]()
							
RETURNS TABLE 
AS
RETURN 
(

select di.id as id, di.DocumentId as DocumentId from DocumentItem as di
	left join ProcessInstance as pi on di.DocumentId = pi.DocumentId
  where pi.id in (select Process from dbo.f_GetProcessItem_UserVisibled()) and IsNull(di.IsDeleted, 0) = 0

)



GO
/****** Object:  UserDefinedFunction [dbo].[f_GetDocumentList_Input]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[f_GetDocumentList_Input]()
							
RETURNS TABLE 
AS
RETURN 
(
-- "Вспомогательный блок выборки" - Документы без Элементов Документов (иначе, не будет видно вновь созданных, которые ещё без Элементов Документа!)
select dl.id as Document, Null as DocumentItem, pi.id as Process, pii.id as ProcessItem, pii.ItemLevel as ItemLevel, pii.JobRole as JobRole, pii.Job as Job, tp.id as DocumentType from DocumentList as dl
	left join ProcessInstance as pi On (pi.id = dl.Process)-- Определяем Процессы для Документов
	left join ProcessItemInstance as pii On (pi.id = pii.Process) and pii.ItemLevel = 1 -- Выбираем Этапы Процессов
	left join TemplateProcess as tp On (pi.ProcessTemplate = tp.id)	-- Выбираем Тип Документа (фактически это Код Шаблона Процесса)
where not exists(select di.id from dbo.f_GetDocumentItem_byDocument(dl.id) as di)
union
-- "Основной блок выборки" - т.к. Работа ведётся с Элементами Документа, а понятие Документ - контейнер для группировки Элементов Документа
select dit.DocumentId as Document, di.id as DocumentItem, pi.id as Process, pii.id as ProcessItem, pii.ItemLevel as ItemLevel, pii.JobRole as JobRole, pii.Job as Job, tp.id as DocumentType from dbo.f_GetDocumentItem_Total() as dit
	left join DocumentList as dl1 On (dit.DocumentId = dl1.id)-- Определяем Документы
	left join DocumentItem as di On (di.Id = dit.id)-- Определяем Элементы Документов для Документов
	left join ProcessInstance as pi On (dl1.Process = pi.id)-- Определяем Процессы для Документов
	left join ProcessItemInstance as pii On (pi.id = pii.Process) and pii.ItemLevel = dbo.f_GetProcessItemLevel_byId(di.ProcessItemId)-- Выбираем Этапы Процессов
	left join TemplateProcess as tp On (pi.ProcessTemplate = tp.id)	-- Выбираем Тип Документа (фактически это Код Шаблона Процесса)
				Where pii.JobRole in (select * from dbo.f_GetJobRoleTotal_forUser(dbo.f_GetUserName_Current())) and 
						IsNull(pi.IsDeleted, 0) =0 and IsNull(pii.IsDeleted, 0) =0

)


GO
/****** Object:  UserDefinedFunction [dbo].[xxx_f_GetDocumentList_CanViewed_forUser]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[xxx_f_GetDocumentList_CanViewed_forUser]
							()

RETURNS TABLE 
AS
RETURN 
(
 select dl.id from DocumentList as dl where dl.id in
 (select di.DocumentId from DocumentItem as di
  left join ProcessItemInstance as pii on di.ProcessItemId = pii.id and pii.JobRole in (select JobRole from dbo.f_GetJobRoleTotal_forUser(dbo.f_GetUserName_Current()))
						where di.DocumentId = dl.id
						)
)

GO
/****** Object:  UserDefinedFunction [dbo].[f_GetDocumentList_Total]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[f_GetDocumentList_Total]()
							
RETURNS TABLE 
AS
RETURN 
(

select di.DocumentId as id from dbo.f_GetDocumentItem_Total() as di
						

/*
select dl.id from DocumentList as dl
		 where dl.Process in (select piuv.Process from f_GetProcessItem_UserVisibled() as piuv)
				and IsNull(dl.IsDeleted, 0) = 0
*/

/*
select dl.id from DocumentList as dl
		 where dl.id in	(select distinct di.DocumentId from DocumentItem as di 
														where di.ProcessItemId in (select piuv.id from f_GetProcessItem_UserVisibled() as piuv))
				and IsNull(dl.IsDeleted, 0) = 0
*/
/*
-- Документы без Элементов Документов (вновь созданные)
select dl.id as Document, Null as DocumentItem, pi.id as Process, pii.id as ProcessItem, pii.ItemLevel as ItemLevel, /*Null as JobResult,*/ pii.JobRole as JobRole, pii.Job as Job, tp.id as DocumentType from DocumentList as dl
	left join ProcessInstance as pi On (pi.id = dl.Process)-- Определяем Процессы для Документов
	left join ProcessItemInstance as pii On (pi.id = pii.Process) and pii.ItemLevel = 1 -- Документ без Элементов может быть только на Этапе Процесса - "Формирование"
	left join TemplateProcess as tp On (pi.ProcessTemplate = tp.id)	-- Выбираем Тип Документа (фактически это Код Шаблона Процесса)
where IsNull(dl.IsDeleted, 0) = 0 and IsNull(pi.IsDeleted, 0) = 0 and IsNull(pii.IsDeleted, 0) = 0
		and not exists(select di.id from DocumentItem as di where di.DocumentId = dl.id)
union
-- Документы с Элементами Документов
select dl.id as Document, di.id as DocumentItem, pi.id as Process, pii.id as ProcessItem, pii.ItemLevel as ItemLevel,/* dis.JobResult as JobResult,*/ pii.JobRole as JobRole, pii.Job as Job, tp.id as DocumentType from DocumentList as dl
	left join DocumentItem as di On (dl.id = di.DocumentId) -- Определяем Элементы Документов для Документов
	left join ProcessInstance as pi On (dl.Process = pi.id)-- Определяем Процессы для Документов
	left join ProcessItemInstance as pii On (pi.id = pii.Process) and (pii.ItemLevel <= dbo.f_GetProcessItemLevel_byId(di.ProcessItemId))  -- dbo.f_GetProcessItemCurrent_DocumentItem(di.id) -- dbo.f_GetProcessItemCurrent_DocumentItem_ForUser(di.id)-- Выбираем Этапы Процессов
--	left join DocumentItemState as dis on (di.id = dis.DocumentItem) and (pii.id = dis.ProcessItem) and IsNull(dis.JobResult, 0) != dbo.f_GetJobResult_Denied() --and IsNull(dis.JobResult, 0) != 0
	left join TemplateProcess as tp On (pi.ProcessTemplate = tp.id)	-- Выбираем Тип Документа (фактически это Код Шаблона Процесса)
				Where  (IsNull(dl.IsDeleted, 0) = 0 and IsNull(pi.IsDeleted, 0) = 0 and IsNull(pii.IsDeleted, 0) = 0)
						--and (pii.ItemLevel > 1 and IsNull(dis.JobResult, 0) = 0)) 
						--and dl.id in (select id from f_GetDocumentList_CanViewed_forUser()))
						--and (IsNull(dbo.f_GetDocumentItemState_Current_ForUser(di.id), 0) != dbo.f_GetJobResult_Denied())
		--	group by pii.ItemLevel, dl.id, di.id, pi.id, pii.id, dis.JobResult, pii.JobRole, pii.Job, tp.id
*/
)


GO
/****** Object:  UserDefinedFunction [dbo].[f_GetDocumentItem_Total_Active]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[f_GetDocumentItem_Total_Active]()
							
RETURNS TABLE 
AS
RETURN 
(
select dit.id as DocumentItem, dit.DocumentId as Document, dbo.f_GetProcessItemCurrent_DocumentItem(dit.id) as ProcessItemCurrent, dbo.f_GetProcessItemLevel_byId(dbo.f_GetProcessItemCurrent_DocumentItem(dit.id)) as ItemLevelCurrent /*, pii.id as CurrentProcessItem_di, pii.id as ProcessItemId_pii*/ from dbo.f_GetDocumentItem_Total() as dit
--	left join DocumentItem as di on dit.id = di.id
--	left join ProcessItemInstance as pii on dit.ProcessItemId = pii.id and pii.id = dbo.f_GetProcessItemId_ExecutingMTR(pii.Process) and (pii.id = dbo.f_GetProcessItemCurrent_DocumentItem(dit.id) or pii.id = dbo.f_GetProcessItemNext_ProcessItem(dbo.f_GetProcessItemCurrent_DocumentItem(dit.id)))
	where dbo.f_GetProcessItemLevel_byId(dbo.f_GetProcessItemCurrent_DocumentItem(dit.id)) = dbo.f_GetProcessItemLevel_byId(dbo.f_GetProcessItemId_ExecutingMTR(dbo.f_GetProcessInstance_DocumentItem(dit.id)))
--																					and dbo.f_GetProcessItemLevel_byId(dbo.f_GetProcessItemCurrent_DocumentItem(dit.id)) = dbo.f_GetProcessItemId_ExecutingMTR(dbo.f_GetProcessInstance_DocumentItem(dit.id)) 
--																					and (dbo.f_GetProcessInstance_Document(dit.DocumentId) in (select Process from dbo.f_GetProcessItem_UserVisibled()))
--																					and (pii.id = dbo.f_GetProcessItemCurrent_DocumentItem(dit.id) or pii.id = dbo.f_GetProcessItemNext_ProcessItem(dbo.f_GetProcessItemCurrent_DocumentItem(dit.id)))
--																					and dbo.f_GetDocumentItemState_Current(dit.id) != dbo.f_GetJobResult_Denied() -- Использовать только как дополнительное условие к другому


/*
select dit.id as DocumentItem, dit.DocumentId as Document, di.ProcessItemId as CurrentProcessItem_di, pii.id as ProcessItemId_pii from dbo.f_GetDocumentItem_Total() as dit
	left join DocumentItem as di on di.id = dit.id
	left join ProcessItemInstance as pii on di.ProcessItemId = pii.id and pii.id = dbo.f_GetProcessItemId_ExecutingMTR(pii.Process) and (pii.id = dbo.f_GetProcessItemCurrent_DocumentItem(dit.id) or pii.id = dbo.f_GetProcessItemNext_ProcessItem(dbo.f_GetProcessItemCurrent_DocumentItem(dit.id)))
	where IsNull(di.IsDeleted, 0) != 1 and dbo.f_GetDocumentItemState_Current(dit.id) != dbo.f_GetJobResult_Denied()
*/					
)



GO
/****** Object:  UserDefinedFunction [dbo].[f_GetDocumentItem_Input]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[f_GetDocumentItem_Input]()
							
RETURNS TABLE 
AS
RETURN 
(
select dit.DocumentId as Document, di.id as DocumentItem, pi.id as Process, pii.id as ProcessItem, pii.ItemLevel as ItemLevel, pii.JobRole as JobRole, pii.Job as Job, tp.id as DocumentType from dbo.f_GetDocumentItem_Total() as dit
	left join DocumentList as dl1 On (dit.DocumentId = dl1.id)-- Определяем Элементы Документов для Документов
	left join DocumentItem as di On (di.Id = dit.id)-- Определяем доп. параметры для Элементов Документов
	left join ProcessInstance as pi On (dl1.Process = pi.id)-- Определяем Процессы для Документов
	left join ProcessItemInstance as pii On (pi.id = pii.Process) and pii.ItemLevel = dbo.f_GetProcessItemLevel_byId(di.ProcessItemId)-- Выбираем Этапы Процессов, не очень "красивый" метод, но пока так
	left join TemplateProcess as tp On (pi.ProcessTemplate = tp.id)	-- Выбираем Тип Документа (фактически это Код Шаблона Процесса)
	Where pii.JobRole in (select * from dbo.f_GetJobRoleTotal_forUser(dbo.f_GetUserName_Current())) and 
		IsNull(di.IsDeleted, 0) =0 and IsNull(pi.IsDeleted, 0) =0 and IsNull(pii.IsDeleted, 0) =0

)



GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessJob_Total]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[f_GetProcessJob_Total](@input_DocumentType smallint)
							
RETURNS TABLE 
AS

RETURN 
(
 Select 'Все документы' as ProcessJobName, 0  as ProcessJobCode, Null as ItemLevel
 union
  select _j.ShortName as ProcessJobName, _j.id as ProcessJobCode, pii.ItemLevel as ItemLevel from f_GetDocumentList_Total() as t1
	left join DocumentList as dl On (t1.Id = dl.id)-- Определяем дополнительные данные для Документов
	left join DocumentItem as di On (di.DocumentId = t1.id)-- Определяем дополнительные данные для Документов
	left join ProcessInstance as pi On (pi.id = dl.Process)-- Определяем Процессы для Документов
	left join ProcessItemInstance as pii On (pi.id = pii.Process)  and pii.id = dbo.f_GetProcessItemCurrent_DocumentItem(di.Id) -- Выбираем текущие Этапы Процессов
	left join sprJob as _j On (pii.Job = _j.id)	-- Выбираем наименование работ Этапов Процесса
	where IsNull(_j.id, 0) != 0
	group by _j.ShortName, _j.id , pii.ItemLevel
--	order by ItemLevel
)




GO
/****** Object:  UserDefinedFunction [dbo].[f_GetDocumentItem_byDocument_withAttachment]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[f_GetDocumentItem_byDocument_withAttachment](@input_DocumentId bigint)
							
RETURNS TABLE 
AS
RETURN 
(

select di.id, di.DocumentId, di.ProcessItemId, di.ShortName, di.sys_creationdate, _u.LoginName as LoginName, _u.ShortName as CreatorOwnerName, _u.FullName, di.Notes, IsNull(dia1.DocumentItemId, 0) as AttachmentId		
from DocumentItem as di 
		left join sprUser As _u On (di.CreatorOwner = _u.id)
		left join (Select dia.DocumentItemId From DocumentItemAttachment as dia Where dia.DocumentItemId in (Select di1.id From DocumentItem as di1 Where di1.DocumentId = @input_DocumentId) Group By dia.DocumentItemId) as dia1 On (di.id = dia1.DocumentItemId)
where di.DocumentId = @input_DocumentId and IsNull(di.IsDeleted, 0) =0

)




GO
/****** Object:  UserDefinedFunction [dbo].[f_GetDocumentItem_State]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[f_GetDocumentItem_State](@input_DocumentItemId bigint)
							
RETURNS TABLE 
AS
RETURN 
(
-- Надстройка типа "вью" для отвязывания от структуры "Состояния ЭД" (может в будущем будет не в одной таблице DocumentItemState)
select dis1.DocumentItem as DocumentItem, t1.*, dis1.JobResult as JobResult, dis1.JobRole as JobRole, dis1.CycleNumber from
(select max(dis.id) as StateId, dis.ProcessItem from DocumentItemState as dis
				where dis.DocumentItem = @input_DocumentItemId group by dis.ProcessItem) as t1
		left join DocumentItemState as dis1 on (dis1.id = t1.StateId)
--		order by t1.StateId -- не работает внутри функций

--where dis.DocumentItem = @input_DocumentItemId and dis.id = (select max(dis1.id) from DocumentItemState as dis1 where dis1.DocumentItem = @input_DocumentItemId)

)




GO
/****** Object:  UserDefinedFunction [dbo].[f_GetJobItem_DocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[f_GetJobItem_DocumentItem](@input_DocumentItemId bigint)
							
RETURNS TABLE 
AS
RETURN 
(

select jii.id as JobItemId from JobItemInstance as jii
							where jii.ProcessItem = dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId)

)





GO
/****** Object:  UserDefinedFunction [dbo].[f_GetProcessItem_UserVisibled_WithoutAlias]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[f_GetProcessItem_UserVisibled_WithoutAlias]()
							
RETURNS TABLE 
AS
RETURN 
(

select distinct pii1.id, pii1.Process from ProcessItemInstance as pii1	where pii1.JobRole = dbo.f_GetJobRole_byUserName(dbo.f_GetUserName_Current())


)





GO
/****** Object:  StoredProcedure [dbo].[GetFirstDocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[GetFirstDocumentItem]
								@input_DocumentId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SET TRANSACTION ISOLATION LEVEL READ COMMITTED


SELECT di.id as DocumentItemId, di.DocumentId as DocumentId, AttachmentName = '' /*Для Grid надо, чтобы значки вложения рисовать*/, di.ShortName as DocumentItemShortName,
       di.sys_creationdate as CreationDate,
       _u.LoginName as LoginName, _u.ShortName as CreatorOwnerName, _u.FullName as CreatorOwnerFullName,
       di.Notes, IsNull(dia1.DocumentItemId, 0) as AttachmentId
FROM DocumentItem as di 
		Left Join sprUser As _u On (di.CreatorOwner = _u.id)
		Left Join (Select dia.DocumentItemId From DocumentItemAttachment as dia Where dia.DocumentItemId in (Select di1.id From DocumentItem as di1 Where di1.DocumentId = @input_DocumentId) Group By dia.DocumentItemId) as dia1 On (di.id = dia1.DocumentItemId)
WHERE di.id = @input_DocumentId and IsNull(di.IsDeleted, 0) =0
ORDER BY di.sys_creationdate


-- Временное решение, чтобы хоть что-то возвращало в приложение и не ругался Query
--select * from DocumentItem as di where di.DocumentId = @input_DocumentId
 
RETURN (@@ERROR)
END











GO
/****** Object:  StoredProcedure [dbo].[sp_adm_AlterSP]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE 	[dbo].[sp_adm_AlterSP] 	
					@input_SP varbinary(max)
											
AS
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
declare @spText varchar(max)
select @spText = cast(@input_SP as varchar(max))
insert into test_uploadSP (text) values (@spText)
--create table #tbl_result (ErrorNumber int, ErrorSeverity int, ErrorState int, ErrorProcedure nvarchar(1024), ErrorLine int, ErrorMessage nvarchar(4000))
Begin Try
 execute(@spText)
 Select @@Error as ErrorNumber
End try
Begin Catch
Select ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;
/*insert into #tbl_result Select ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;
*/
/*
или
 DECLARE @errNumber INT = ERROR_NUMBER()
 */
--        THROW
    End Catch
--Select IsNull(ERROR_NUMBER(), 0) AS ErrorNumber
--Select * from #tbl_result
-- Select @errNumber
RETURN




GO
/****** Object:  StoredProcedure [dbo].[sp_adm_Execute_SP]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[sp_adm_Execute_SP]
					@input_SPName varchar(256),
					@input_Id bigint = Null
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_Execute_SP'

declare @input_LoginName varchar(128)
select @input_LoginName = suser_name()
declare  @SQLText  varchar(2048)
declare @strNote varchar(max)

if IsNull(@input_Id, 0) != 0
begin
 execute @input_SPName @input_Id
 Goto Done
end

execute @input_SPName


Done:
 RETURN (@@ERROR)

---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Exec sp_ErrorLog_Insert 110, @CurrentStorageProcedureName, @input_LoginName, @strNote, @input_Id
 RETURN (-1)


END








GO
/****** Object:  StoredProcedure [dbo].[sp_adm_Get_F_Text]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_adm_Get_F_Text]
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
CREATE TABLE #Table1 (Procedure_ID int, Procedure_Colid int, text1 nvarchar(4000))


  DECLARE Cursor_P CURSOR FOR
      SELECT sc.[id], name, colid
      FROM syscomments as sc
	  left join sysobjects as so On (sc.id = so.id)
      WHERE sc.id IN (SELECT so.id FROM sysobjects as so WHERE type in (N'FN', N'IF', N'TF') and name not like '%diagram%')
      ORDER BY [id], colid
    FOR READ ONLY
     
    DECLARE @Procedure_ID [int]
    DECLARE @Procedure_Name varchar(256)
    DECLARE @Procedure_Colid [int]
     
    OPEN Cursor_P
            
    FETCH Cursor_P INTO  @Procedure_ID, @Procedure_Name, @Procedure_Colid
     
    Declare @CurrentProcedureId int
	sET @CurrentProcedureId =  @Procedure_ID

	Declare @CurrentProcedureName nvarchar(128)
    Set @CurrentProcedureName = @Procedure_Name

	Declare @CurrentProcedure_Colid int
    Set @CurrentProcedure_Colid = @Procedure_Colid

    DECLARE @S nvarchar(4000)
    DECLARE @S1 nvarchar(4000)

	Declare @bFirstStep int
	Set @bFirstStep = 1


	SELECT @S1 = '--Begin function: [' + @CurrentProcedureName + ']'
    Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@CurrentProcedureId, @CurrentProcedure_Colid, @S1)
	Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@CurrentProcedureId, @CurrentProcedure_Colid, char(13) + char(10))
	Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1

    WHILE (@@FETCH_STATUS = 0)
    BEGIN

	  if @CurrentProcedureId !=  @Procedure_ID
	  begin
  
    	If @bFirstStep > 1
 	    begin
		 Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@CurrentProcedureId, @CurrentProcedure_Colid, char(13) + char(10))
		 Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
         SET @S1 = '--End function: [' + @CurrentProcedureName + ']'
		 Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@CurrentProcedureId, @CurrentProcedure_Colid, @S1)
		 Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
	    end

    	SELECT @S1 = '--Begin function: [' + @Procedure_Name + ']'
        Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@Procedure_ID, @CurrentProcedure_Colid, @S1)
        Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1

	    Set @CurrentProcedureId = @Procedure_ID
	    Set @CurrentProcedureName = @Procedure_Name
	  end

      Set @bFirstStep = @bFirstStep + 1

      SELECT @S =  [text]
      FROM syscomments
      WHERE [id] = @Procedure_ID AND colid = @Procedure_Colid
      ORDER BY [id]
	  
      Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@Procedure_ID, @CurrentProcedure_Colid, @S)
      Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
    FETCH Cursor_P INTO  @Procedure_ID, @Procedure_Name, @Procedure_Colid

    END
     
    CLOSE Cursor_P
     
    DEALLOCATE Cursor_P

select * from #Table1 as t1  --where t1.Procedure_ID = 1166627199
		order by t1.Procedure_ID, t1.Procedure_Colid
--drop table #Table1

end








GO
/****** Object:  StoredProcedure [dbo].[sp_adm_Get_SP_Text]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




CREATE PROCEDURE [dbo].[sp_adm_Get_SP_Text]
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
CREATE TABLE #Table1 (Procedure_ID int, Procedure_Colid int, text1 nvarchar(4000))


  DECLARE Cursor_P CURSOR FOR
      SELECT sc.[id], [name], colid
      FROM syscomments as sc
	  left join sysobjects as so On (sc.id = so.id)
      WHERE sc.id IN (SELECT so.id FROM sysobjects as so WHERE type = 'P' and name not like '%diagram%')
      ORDER BY [name], [id], colid
    FOR READ ONLY
     
    DECLARE @Procedure_ID [int]
    DECLARE @Procedure_Name varchar(256)
    DECLARE @Procedure_Colid [int]
     
    OPEN Cursor_P
            
    FETCH Cursor_P INTO  @Procedure_ID, @Procedure_Name, @Procedure_Colid
     
    Declare @CurrentProcedureId int
	sET @CurrentProcedureId =  @Procedure_ID

	Declare @CurrentProcedureName nvarchar(128)
    Set @CurrentProcedureName = @Procedure_Name

	Declare @CurrentProcedure_Colid int
    Set @CurrentProcedure_Colid = @Procedure_Colid

    DECLARE @S nvarchar(4000)
    DECLARE @S1 nvarchar(4000)

	Declare @bFirstStep int
	Set @bFirstStep = 1


	SELECT @S1 = '--Begin procedure: [' + @CurrentProcedureName + ']'
    Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@CurrentProcedureId, @CurrentProcedure_Colid, @S1)
	Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
	Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@CurrentProcedureId, @CurrentProcedure_Colid, char(13) + char(10))
	Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1

    WHILE (@@FETCH_STATUS = 0)
    BEGIN

	  if @CurrentProcedureId !=  @Procedure_ID
	  begin
  
    	If @bFirstStep > 1
 	    begin
		 Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@CurrentProcedureId, @CurrentProcedure_Colid, char(13) + char(10))
		 Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
         SET @S1 = '--End procedure: [' + @CurrentProcedureName + ']'
		 Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@CurrentProcedureId, @CurrentProcedure_Colid, @S1)
		 Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
		 Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@CurrentProcedureId, @CurrentProcedure_Colid, char(13) + char(10))
		 Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
	    end

    	SELECT @S1 = '--Begin procedure: [' + @Procedure_Name + ']'
        Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@Procedure_ID, @CurrentProcedure_Colid, @S1)
        Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
        Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@Procedure_ID, @CurrentProcedure_Colid,  char(13) + char(10))
        Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1

	    Set @CurrentProcedureId = @Procedure_ID
	    Set @CurrentProcedureName = @Procedure_Name
	  end

      Set @bFirstStep = @bFirstStep + 1

      SELECT @S =  [text]
      FROM syscomments
      WHERE [id] = @Procedure_ID AND colid = @Procedure_Colid
      ORDER BY [id]
	  
      Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@Procedure_ID, @CurrentProcedure_Colid, @S)
      Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
    FETCH Cursor_P INTO  @Procedure_ID, @Procedure_Name, @Procedure_Colid

    END
     
    CLOSE Cursor_P
     
    DEALLOCATE Cursor_P


select * from #Table1 as t1  --where t1.Procedure_ID = 1166627199
		order by t1.Procedure_ID, t1.Procedure_Colid
--drop table #Table1

end
--RETURN (@@ERROR)
GO
/****** Object:  StoredProcedure [dbo].[sp_adm_GetSP_FText]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_adm_GetSP_FText]
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
CREATE TABLE #Table1 (Procedure_ID int, Procedure_Colid int, text1 nvarchar(4000))


  DECLARE Cursor_P CURSOR FOR
      SELECT sc.[id], name, colid, so.type
      FROM syscomments as sc
	  left join sysobjects as so On (sc.id = so.id)
      WHERE sc.id IN (SELECT so.id FROM sysobjects as so WHERE type in (N'P', N'FN', N'IF', N'TF') and name not like '%diagram%')
      ORDER BY [id], colid
    FOR READ ONLY
     
    DECLARE @Procedure_ID [int]
    DECLARE @Procedure_Name varchar(256)
    DECLARE @Procedure_Colid [int]
    DECLARE @Procedure_Type char(2)
     
    OPEN Cursor_P
            
    FETCH Cursor_P INTO  @Procedure_ID, @Procedure_Name, @Procedure_Colid, @Procedure_Type
     
    Declare @CurrentProcedureId int
	sET @CurrentProcedureId =  @Procedure_ID

	Declare @CurrentProcedureName nvarchar(128)
    Set @CurrentProcedureName = @Procedure_Name

	Declare @CurrentProcedure_Colid int
    Set @CurrentProcedure_Colid = @Procedure_Colid

    DECLARE @S nvarchar(4000)
    DECLARE @S1 nvarchar(4000)

	Declare @bFirstStep int
	Set @bFirstStep = 1

    Select @S1 = Case 
                    When @Procedure_Type = N'P' Then 'Drop procedure '
                    When @Procedure_Type in (N'FN', N'IF', N'TF') Then 'Drop function '
                 End
	Select @S1 = @S1 + @Procedure_Name

    Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values ( @Procedure_ID, @CurrentProcedure_Colid, @S1)
    Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
    Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values ( @Procedure_ID, @CurrentProcedure_Colid, char(13) + char(10) + 'GO' + char(13) + char(10))
    Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1

    WHILE (@@FETCH_STATUS = 0)
    BEGIN

	  if @CurrentProcedureId !=  @Procedure_ID
	  begin

   
	   If @bFirstStep > 1
	   begin
		Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@CurrentProcedureId, @CurrentProcedure_Colid, char(13) + char(10) + 'GO' + char(13) + char(10))
		Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
        SET @S1 = 'Grant EXECUTE On ' + @CurrentProcedureName
		SET @S1 += ' To OPUsers, OPAdmins'
		Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@CurrentProcedureId, @CurrentProcedure_Colid, @S1)
		Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
		Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@CurrentProcedureId, @CurrentProcedure_Colid, char(13) + char(10) + 'GO' + char(13) + char(10))
		Set @CurrentProcedure_Colid = @Procedure_Colid
	   end

    Select @S1 = Case 
                    When @Procedure_Type = N'P' Then 'Drop procedure '
                    When @Procedure_Type in (N'FN', N'IF', N'TF') Then 'Drop function '
                 End
	Select @S1 = @S1 + @Procedure_Name
       Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@Procedure_ID, @CurrentProcedure_Colid, @S1)
       Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
       Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@Procedure_ID, @CurrentProcedure_Colid, char(13) + char(10) + 'GO' + char(13) + char(10))
       Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1

	   Set @CurrentProcedureId = @Procedure_ID
	   Set @CurrentProcedureName = @Procedure_Name
	  end

      Set @bFirstStep = @bFirstStep + 1

      SELECT @S =  [text]
      FROM syscomments
      WHERE [id] = @Procedure_ID AND colid = @Procedure_Colid
      ORDER BY [id]
	  
      Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@Procedure_ID, @CurrentProcedure_Colid, @S)
      Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
    FETCH Cursor_P INTO  @Procedure_ID, @Procedure_Name, @Procedure_Colid, @Procedure_Type

    END
     
    CLOSE Cursor_P
     
    DEALLOCATE Cursor_P

select * from #Table1 as t1  --where t1.Procedure_ID = 1166627199
		order by t1.Procedure_ID, t1.Procedure_Colid
--drop table #Table1

end






GO
/****** Object:  StoredProcedure [dbo].[sp_adm_GetSpravData]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sp_adm_GetSpravData]
					@input_SpravName varchar(256)
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_GetSpravData'

declare @input_LoginName varchar(128)
select @input_LoginName = dbo.f_GetUserName_Current()
declare  @SQLText  varchar(2048)
declare @strNote varchar(max)

SET @SQLText = 'select * from ' + @input_SpravName
SET @SQLText += ' order by id'
EXECUTE(@SQLText)

Goto Done
---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Exec sp_ErrorLog_Insert 110, @CurrentStorageProcedureName, @input_LoginName, @strNote
 RETURN (-1)

Done:
 RETURN (@@ERROR)
 

END







GO
/****** Object:  StoredProcedure [dbo].[sp_adm_GetSpravList]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





CREATE PROCEDURE [dbo].[sp_adm_GetSpravList]
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

Select so.id, so.name as ShortName From sysobjects as so Where so.type = 'U' and so.name like 'spr_%'
      Order By so.name
     
end

GO
/****** Object:  StoredProcedure [dbo].[sp_adm_SetSP_FText_testing]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_adm_SetSP_FText_testing]
					@input_Procedure_ID bigint,
					@input_Procedure_Name varchar(1024)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
CREATE TABLE #Table1 (Procedure_ID int, Procedure_Colid int, text1 nvarchar(4000))


  DECLARE Cursor_P CURSOR FOR
      SELECT sc.[id], name, colid
      FROM syscomments as sc
	  left join sysobjects as so On (sc.id = so.id)
      WHERE sc.id IN (SELECT so.id FROM sysobjects as so WHERE type = 'P') and sc.id = @input_Procedure_ID
      ORDER BY [id], colid
    FOR Update
     
    DECLARE @Procedure_ID [int]
    DECLARE @Procedure_Name varchar(256)
    DECLARE @Procedure_Colid [int]
     
    OPEN Cursor_P
            
    FETCH Cursor_P INTO  @Procedure_ID, @Procedure_Name, @Procedure_Colid
     
    Declare @CurrentProcedureId int
	Set @CurrentProcedureId =  @Procedure_ID

	Declare @CurrentProcedureName nvarchar(128)
    Set @CurrentProcedureName = @Procedure_Name

	Declare @CurrentProcedure_Colid int
    Set @CurrentProcedure_Colid = @Procedure_Colid

    DECLARE @S nvarchar(4000)
    DECLARE @S1 nvarchar(4000)

	Declare @bFirstStep int
	Set @bFirstStep = 1


	SELECT @S1 = 'Drop procedure ' + @Procedure_Name
    Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values ( @Procedure_ID, @CurrentProcedure_Colid, @S1)
    Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
    Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values ( @Procedure_ID, @CurrentProcedure_Colid, char(13) + char(10) + 'GO' + char(13) + char(10))
    Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1

    WHILE (@@FETCH_STATUS = 0)
    BEGIN

	  if @CurrentProcedureId !=  @Procedure_ID
	  begin

   
	   If @bFirstStep > 1
	   begin
		Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@CurrentProcedureId, @CurrentProcedure_Colid, char(13) + char(10) + 'GO' + char(13) + char(10))
		Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
        SET @S1 = 'Grant EXECUTE On ' + @CurrentProcedureName
		SET @S1 += ' To OPUsers, OPAdmins'
		Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@CurrentProcedureId, @CurrentProcedure_Colid, @S1)
		Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
		Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@CurrentProcedureId, @CurrentProcedure_Colid, char(13) + char(10) + 'GO' + char(13) + char(10))
		Set @CurrentProcedure_Colid = @Procedure_Colid
	   end

       SELECT @S1 = 'Drop procedure ' + @Procedure_Name
       Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@Procedure_ID, @CurrentProcedure_Colid, @S1)
       Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
       Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@Procedure_ID, @CurrentProcedure_Colid, char(13) + char(10) + 'GO' + char(13) + char(10))
       Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1

	   Set @CurrentProcedureId = @Procedure_ID
	   Set @CurrentProcedureName = @Procedure_Name
	  end

      Set @bFirstStep = @bFirstStep + 1

      SELECT @S =  [text]
      FROM syscomments
      WHERE [id] = @Procedure_ID AND colid = @Procedure_Colid
      ORDER BY [id]
	  
      Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@Procedure_ID, @CurrentProcedure_Colid, @S)
      Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
    FETCH Cursor_P INTO  @Procedure_ID, @Procedure_Name, @Procedure_Colid

    END
     
    CLOSE Cursor_P
     
    DEALLOCATE Cursor_P

select * from #Table1 as t1  --where t1.Procedure_ID = 1166627199
		order by t1.Procedure_ID, t1.Procedure_Colid
--drop table #Table1

end



GO
/****** Object:  StoredProcedure [dbo].[sp_adm_Truncate_Table_All]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





CREATE PROCEDURE [dbo].[sp_adm_Truncate_Table_All]
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
Create Table #Table1 (TableName nvarchar(256))
  DECLARE Cursor_P CURSOR FOR
      SELECT name From sysobjects as so
      WHERE so.type = 'U'
      ORDER BY name
    FOR READ ONLY
     
    DECLARE @Procedure_Name varchar(256)
     
    OPEN Cursor_P
            
    FETCH Cursor_P INTO  @Procedure_Name
     
    Declare @SQLText nvarchar(4000)

    WHILE (@@FETCH_STATUS = 0)
    BEGIN

	 If SUBSTRING(@Procedure_Name, 1, 3) != 'spr' and SUBSTRING(@Procedure_Name, 1, 8) != 'Template' and SUBSTRING(@Procedure_Name, 1, 4) != 'xxx_' and SUBSTRING(@Procedure_Name, 1, 3) != 'sys'
	 Begin
   	  Set @SQLText = 'truncate table ' + @Procedure_Name
	  Exec(@SQLText)
	  Insert Into #Table1 (TableName) Values (@Procedure_Name)
	End

    FETCH Cursor_P INTO @Procedure_Name

    END
     
    CLOSE Cursor_P
     
    DEALLOCATE Cursor_P
--Select 'Удалены полностью данные в:'
--Select * From #Table1
end

GO
/****** Object:  StoredProcedure [dbo].[sp_CanChangeState_DocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE procedure [dbo].[sp_CanChangeState_DocumentItem]
								@input_DocumentItemId bigint
AS
BEGIN

declare @bResult tinyint
if dbo.f_CanChangeDocumentItemState(@input_DocumentItemId) = 1
 Set @bResult = 1
else
 Set @bResult = 0

Select @bResult as Result

Done:
RETURN 0
END








GO
/****** Object:  StoredProcedure [dbo].[sp_CreateComment_Document]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[sp_CreateComment_Document]
                    @input_DocumentId bigint,
					@input_JobResult tinyint,
                    @input_Note varchar (4096) = Null
                    
                    
 AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_CreateDocumentComment'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

declare @tranName varchar(100)

select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION @tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @uniqValue varchar(36)
select @uniqValue = NEWID()
declare @CallerUserName varchar(128)
set @CallerUserName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

declare @CreatedDocumentCommentId bigint

declare @Target_CycleNumber int
select @Target_CycleNumber = dl.CycleNumber from DocumentList as dl where dl.id = @input_DocumentId
 
insert into DocumentComment (Document, ProcessItem, CycleNumber, CommentText, CreatorId, JobResult, uniqValue)
	values (@input_DocumentId, dbo.f_GetProcessItemCurrent_Document(@input_DocumentId), @Target_CycleNumber, @input_Note, dbo.f_GetUserId_byName(dbo.f_GetUserName_Current()), @input_JobResult, @uniqValue)

select @CreatedDocumentCommentId = (Select dic.id from DocumentItemComment as dic
                                           where dic.uniqValue = @uniqValue)
                                                 

if IsNull(@CreatedDocumentCommentId, 0) = 0
begin
 set @strNote = 'ФИО инициатора = '
 set @strNote += rtrim(@CallerUserName) + '; '
 set @ProgramError = 51
 GOTO Error
end


set @ProgramEvent = 51
Goto Done

---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Select @outputError = @ProgramError
 ROLLBACK TRANSACTION @tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentId
 SELECT  @outputError
 RETURN (-1)

Done:
 Select @outputError = @ProgramError
 COMMIT TRANSACTION @tranName
 Exec sp_EventLog_Insert @ProgramEvent /*Успешное создание комментария для Элемента Документа*/, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentId
 SELECT  @outputError
 RETURN (@CreatedDocumentCommentId)









GO
/****** Object:  StoredProcedure [dbo].[sp_CreateComment_DocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sp_CreateComment_DocumentItem]
                    @input_DocumentItemId bigint,
					@input_JobResult tinyint,
                    @input_Note varchar (4096) = Null
                    
                    
 AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_CreateComment_DocumentItem'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

declare @tranName varchar(100)

select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION @tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @uniqValue varchar(36)
select @uniqValue = NEWID()
declare @CallerUserName varchar(128)
set @CallerUserName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

declare @CreatedDocumentItemCommentId bigint

declare @Target_CycleNumber int
select @Target_CycleNumber = di.CycleNumber from DocumentItem as di where di.id = @input_DocumentItemId
 
insert into DocumentItemComment (DocumentItem, ProcessItem, CycleNumber, CommentText, CreatorId, JobResult, uniqValue)
	values (@input_DocumentItemId, dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId), @Target_CycleNumber, @input_Note, dbo.f_GetUserId_byName(dbo.f_GetUserName_Current()), @input_JobResult, @uniqValue)

select @CreatedDocumentItemCommentId = (Select dic.id from DocumentItemComment as dic
                                           where dic.uniqValue = @uniqValue)
                                                 

if IsNull(@CreatedDocumentItemCommentId, 0) = 0
begin
 set @strNote = 'ФИО инициатора = '
 set @strNote += rtrim(@CallerUserName) + '; '
 set @ProgramError = 50
 GOTO Error
end


set @ProgramEvent = 50
Goto Done

---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Select @outputError = @ProgramError
 ROLLBACK TRANSACTION @tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentItemId
 SELECT  @outputError
 RETURN (-1)

Done:
 Select @outputError = @ProgramError
 COMMIT TRANSACTION @tranName
 Exec sp_EventLog_Insert @ProgramEvent /*Успешное создание комментария для Элемента Документа*/, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentItemId
 SELECT  @outputError
 RETURN (@CreatedDocumentItemCommentId)








GO
/****** Object:  StoredProcedure [dbo].[sp_CreateDocument]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_CreateDocument]
					@input_TemplateProcess smallint,
                    @input_ExecutionDateAsString varchar (32) = Null,
                    @input_ShortName varchar (64),
                    @input_Notes varchar (1024)	=Null

                                                                   
                                                                 
 AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_CreateDocument'

Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

BEGIN TRANSACTION
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @CreatedIdDocument bigint
declare @CreatedIdProcess bigint
declare @CreationDate datetime
declare @uniqValue varchar(36)
select @uniqValue = NEWID()

declare @sysUserName varchar(128)
select @sysUserName = suser_name()
declare @CallerUserName varchar(128)
set @CallerUserName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

if IsNull(@CallerUserName, '') != ''
begin
 set @sysUserName = @CallerUserName
end

--Проверка корректности Этапов Процесса
if dbo.f_IsProcessItemValid(@input_TemplateProcess) != 0
begin
 Set @strNote = 'Документ не может быть создан, так как шаблон Процесса имеет логические ошибки: '
 Set @strNote += 'TemplateProcessId = ' + rtrim(Convert(varchar(8), @input_TemplateProcess)) + '; '
 Select @ProgramError = 3
 GOTO Error
end


Select @CreationDate = GetDate()

INSERT INTO dbo.DocumentList
	  (Process, CreatorOwner, ShortName, CreationDate, ExecutionDate, DocumentNum, CycleNumber, Notes, uniqValue)
VALUES
      (9999999999 /*Фиктивный № - заменится после создания Процесса*/, dbo.f_GetUserId_byName(@sysUserName), @input_ShortName,
        @CreationDate, CONVERT(datetime, rtrim(@input_ExecutionDateAsString)), dbo.f_GetDocumentNum_New(), 1, @input_Notes, @uniqValue)

IF @@ROWCOUNT != 1 or @@ERROR != 0
begin
 set @ProgramError = 20
 set @strNote = '@@ERROR = '
 set @strNote += rtrim(@@ERROR) + '; '
 GOTO Error
end
Else
 begin
  
  select @CreatedIdDocument = (Select dl.id from dbo.DocumentList as dl 
                                           where dl.uniqValue = @uniqValue)


-- Создание экземпляра Процесса по шаблону из справочника Процессов --------------
exec @CreatedIdProcess = sp_CreateProcessInstance @input_TemplateProcess, @CreatedIdDocument
IF @CreatedIdProcess = -1
begin
 set @ProgramError = 1 -- Ошибка в процедуре sp_CreateProcessInstance
 set @strNote = 'Ошибка создание экземпляра Процесса по шаблону из справочника Процессов: @CreatedIdProcess = -1'
 GOTO Error
end

Update dbo.DocumentList Set Process = @CreatedIdProcess
						Where uniqValue = @uniqValue

----------------------------------------------------------------------------------

GOTO Done
  
end

---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Select @outputError = @@ERROR
 ROLLBACK TRANSACTION
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_TemplateProcess
 select -1
 RETURN (-1)

Done:
 COMMIT TRANSACTION
 Exec sp_EventLog_Insert 4, @CurrentStorageProcedureName, @CallerUserName, @strNote, @CreatedIdDocument
 select @CreatedIdDocument
RETURN (@CreatedIdDocument)
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateDocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[sp_CreateDocumentItem]
                    @input_DocumentId bigint,
                    @input_ShortName varchar (50),
                    @input_FullName varchar (1024) = Null,
                    @input_Notes varchar (1024) = Null
                    
                    
 AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_CreateDocumentItem'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

declare @tranName varchar(100)

select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION @tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @uniqValue varchar(36)
select @uniqValue = NEWID()
declare @CallerUserName varchar(128)
set @CallerUserName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

declare @CreatedDocumentItemId bigint

INSERT INTO dbo.DocumentItem
	  (DocumentId, ProcessItemId, ShortName, FullName, sys_creationdate, CreatorOwner, Notes, ItemNum, CycleNumber, uniqValue)
VALUES
      (@input_DocumentId, dbo.f_GetProcessItemFirst_Document(@input_DocumentId), @input_ShortName, @input_FullName, GetDate(), dbo.f_GetUserId_byName(@CallerUserName), @input_Notes, dbo.f_GetDocumentItemNum_New(@input_DocumentId), 1, @uniqValue)

select @CreatedDocumentItemId = (Select di.id from DocumentItem as di
                                           where di.uniqValue = @uniqValue)
                                                 

if IsNull(@CreatedDocumentItemId, 0) = 0
begin
 set @strNote = 'ФИО инициатора = '
 set @strNote += rtrim(@CallerUserName) + '; '
 set @ProgramError = 30
 GOTO Error
end

/*
-- Запись в журнал состояния ЭД необходимо делать не на этом (самом низком) уровне,
-- а в процедуре выполнения Действия на ЭД, потому что только Действие может изменить состояние.

-- Создание записи состояния Элемента Документа (JobResult = Null)

declare @CreatedDocumentItemState bigint
exec @CreatedDocumentItemState = sp_CreateDocumentItemState @CreatedDocumentItemId, Null

IF @@ROWCOUNT != 1 or @@ERROR != 0 or @CreatedDocumentItemState = -1
begin
 set @strNote = 'ФИО инициатора = '
 set @strNote += rtrim(@CallerUserName) + '; '
 set @ProgramError = 30
 GOTO Error
end
*/

set @ProgramEvent = 30
Goto Done

---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Select @outputError = @ProgramError
 ROLLBACK TRANSACTION @tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentId
 SELECT  @outputError
 RETURN (-1)

Done:
 Select @outputError = @ProgramError
 COMMIT TRANSACTION @tranName
 Exec sp_EventLog_Insert @ProgramEvent /*Успешное создание Элемента Документа*/, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentId
 SELECT  @outputError
 RETURN (@CreatedDocumentItemId)







GO
/****** Object:  StoredProcedure [dbo].[sp_CreateDocumentItem_MTR]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[sp_CreateDocumentItem_MTR]
                    @input_DocumentId bigint,
                    @input_ShortName varchar (50),
                    @input_FullName varchar (1024) = Null,
                    @input_Notes varchar (1024) = Null,
                    @input_ObjectGroupId int,
                    @input_MeasurementUnitId int,
                    @input_ObjectVolume float
                    
                    
 AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_CreateDocumentItem_MTR'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

declare @tranName varchar(100)

select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION @tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @uniqValue varchar(36)
select @uniqValue = NEWID()
declare @CallerUserName varchar(128)
set @CallerUserName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

declare @CreatedDocumentItemId bigint, @CreatedDocumentItemId_MTR bigint

--------------- Создаем базовый Элемент Документа ----------------------------------
exec @CreatedDocumentItemId = sp_CreateDocumentItem @input_DocumentId, @input_ShortName, @input_FullName, @input_Notes
if @CreatedDocumentItemId = -1
begin
 Set @ProgramError = 1 -- Ошибка в процедуре sp_CreateProcessInstance
 GOTO Error
end

--------------- Создаем Элемент Документа МТР (в дополнение к базовому Элементу Документа) ----------------------------------
INSERT INTO dbo.DocumentItem_MTR
	  (DocumentItemId, ObjectGroup, MeasurementUnit, Volume, uniqValue)
VALUES
      (@CreatedDocumentItemId, @input_ObjectGroupId, @input_MeasurementUnitId, @input_ObjectVolume, @uniqValue)

IF @@ROWCOUNT != 1 or @@ERROR != 0
begin
 set @strNote = 'ФИО инициатора = '
 set @strNote += rtrim(@CallerUserName) + '; '
 set @ProgramError = 30
 GOTO Error
end

select @CreatedDocumentItemId_MTR = (Select max(di_mtr.id) from DocumentItem_MTR as di_mtr 
                                           where di_mtr.DocumentItemId = @CreatedDocumentItemId and di_mtr.uniqValue = @uniqValue)
                                                 

if IsNull(@CreatedDocumentItemId_MTR, 0) = 0
begin
 set @strNote = 'DocumentItemId = ' + rtrim(CONVERT(varchar(max), @CreatedDocumentItemId)) + '; '
 set @ProgramError = 31
 GOTO Error
end


set @ProgramEvent = 31
Goto Done

---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Select @outputError = @@ERROR
 ROLLBACK TRANSACTION @tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentId
 SELECT  @outputError
 RETURN (-1)

Done:
 Select @outputError = @@ERROR
 COMMIT TRANSACTION @tranName
 Exec sp_EventLog_Insert @ProgramEvent /*Успешное создание части МТР Элемента Документа*/, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentId
 SELECT  @outputError
 RETURN (@CreatedDocumentItemId)







GO
/****** Object:  StoredProcedure [dbo].[sp_CreateDocumentItemState]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sp_CreateDocumentItemState]
                    @input_DocumentItem bigint,
					@input_JobResult int = Null
                    
                    
 AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_CreateDocumentItemState'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

declare @tranName varchar(100)

select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION @tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @uniqValue varchar(36)
select @uniqValue = NEWID()
declare @CallerUserName varchar(128)
set @CallerUserName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

declare @CreatedDocumentItemState bigint
declare @TargetProcessItemId bigint
declare @TargetJobRoleId int

set @TargetProcessItemId = dbo.f_GetProcessItemActive_DocumentItem(@input_DocumentItem)

if IsNull(@TargetProcessItemId, -1) = -1 and IsNull(@input_JobResult, 0) != 0
begin
  set @ProgramError = 32 /*Ошибка изменения состояния Элемента Документа*/
  set @strNote = 'Ошибка в sp_CreateDocumentItemState: dbo.f_GetProcessItemActive_DocumentItem(' + ltrim(STR(@input_DocumentItem)) + ')='
  if IsNull(@TargetProcessItemId, 0) = 0
  begin
   set @strNote = @strNote + 'Null'
  end
  else
  begin
   set @strNote = @strNote + '-1'
  end
  Goto Error
end

if IsNull(@input_JobResult, 0) = 0
begin
 set @TargetProcessItemId = dbo.f_GetProcessItemFirst_DocumentItem(@input_DocumentItem)
end


set @TargetJobRoleId = dbo.f_GetJobRole_byUserName(@CallerUserName)

if IsNull(@TargetJobRoleId, -1) = -1
begin
  set @ProgramError = 32 /*Ошибка изменения состояния Элемента Документа*/
  set @strNote = 'Ошибка в sp_CreateDocumentItemState: dbo.f_GetJobRole_byUserName(' + ltrim(@CallerUserName) + ')='
  if IsNull(@TargetProcessItemId, 0) = 0
  begin
   set @strNote = @strNote + 'Null'
  end
  else
  begin
   set @strNote = @strNote + '-1'
  end
  Goto Error
end

insert into dbo.DocumentItemState
   (DocumentItem, ProcessItem, JobResult, JobRole, sys_creationtime, CycleNumber, uniqValue)
values
   (@input_DocumentItem, @TargetProcessItemId, @input_JobResult, @TargetJobRoleId, getdate(), dbo.f_GetDocumentItemCycleNumber_Current(@input_DocumentItem), @uniqValue)

 if @@ROWCOUNT != 1 or @@ERROR != 0
 begin
  set @ProgramError = 32 /*Ошибка изменения состояния Элемента Документа*/
  set @strNote = 'Ошибка создания записи в sp_CreateDocumentItemState для Элемента Документа= ' + ltrim(STR(@input_DocumentItem))
  Goto Error
 end

select @CreatedDocumentItemState = (Select dis.id from DocumentItemState as dis
                                           where dis.uniqValue = @uniqValue)
                                                 

if IsNull(@CreatedDocumentItemState, 0) = 0
begin
 set @ProgramError = 32 /*Ошибка изменения состояния Элемента Документа*/
 set @strNote = 'Ошибка записи в sp_CreateDocumentItemState для Элемента Документа= ' + ltrim(STR(@input_DocumentItem))
 Goto Error
end


set @ProgramEvent = 32
Goto Done

---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Select @outputError = @ProgramError
 ROLLBACK TRANSACTION @tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentItem
 SELECT  @outputError
 RETURN (-1)

Done:
 Select @outputError = @ProgramError
 COMMIT TRANSACTION @tranName
 Exec sp_EventLog_Insert @ProgramEvent /*Успешное создание Элемента Документа*/, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentItem
 SELECT  @outputError
 RETURN (@CreatedDocumentItemState)








GO
/****** Object:  StoredProcedure [dbo].[sp_CreateJobItemInstance]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- Создание экземпляра Работа Процесса
CREATE  PROCEDURE [dbo].[sp_CreateJobItemInstance]
					@input_ProcessItemInstance int
	
                                                                   
                                                                 
 AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_CreateJobItemInstance'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int
declare @ROWCOUNT_sys int

--declare @tranName varchar(100)

--select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION tr_CreateProcessJobInstance --@tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @CreatedProcess bigint
declare @uniqValue varchar(36)
select @uniqValue = NEWID()
declare @LoginName varchar(128)
set @LoginName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

Declare @CreatedJobItem_1 bigint  -- Переменная для возврата Id первого Элемента Работы

Declare @CreationDate datetime
Select @CreationDate = GetDate()

declare @ProcessItemTemplateId bigint
set @ProcessItemTemplateId = dbo.f_GetTemplateProcessItemId_byProcessItemInstanceId(@input_ProcessItemInstance)


declare @TemplateProcessItemId_First bigint
set @TemplateProcessItemId_First = dbo.f_GetTemplateProcessItemId_byLevel(dbo.f_GetTemplateProcessItemId_byProcessItemInstanceId(@input_ProcessItemInstance), 1)


INSERT INTO dbo.JobItemInstance
	  (JobItemTemplate, ProcessItem, JobItem, JobItemLevel, DoneCondition, IsActive, ConditionDependence, uniqValue, IsEntireDocument, IsEDD)
      (Select tji.id, @input_ProcessItemInstance, tji.JobItem, tji.JobItemLevel, tji.DoneCondition, tji.IsActive, tji.ConditionDependence, case when tji.id = @TemplateProcessItemId_First then @uniqValue else newid() end, IsEntireDocument, IsEDD From TemplateJobItem as tji 
																			 where tji.ProcessItemTemplate = @ProcessItemTemplateId)


IF @@ERROR != 0 -- @@ROWCOUNT != 1 or !!!! - Не пытаться добавлять это условие, т.к. вставляем больше 1 !!!
begin
 Set @OutputError = @@ERROR
 Set @ROWCOUNT_sys = @@ROWCOUNT 
 select @ProgramError = 41
 set @strNote = 'id шаблона Элемента Работы = '
 set @strNote += rtrim(Convert(varchar(8), @ProcessItemTemplateId)) + '; '
 set @strNote += '@@Error= ' + rtrim(Convert(varchar(8), @OutputError)) + '; '
 set @strNote += '@@ROWCOUNT= ' + rtrim(Convert(varchar(8), @ROWCOUNT_sys)) + '; '
 GOTO Error
end

select @CreatedJobItem_1 = (Select top 1 jii.id from JobItemInstance as jii where jii.uniqValue = @uniqValue)

Goto Done


---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Select @outputError = @@ERROR
 ROLLBACK TRANSACTION tr_CreateProcessJobInstance --@tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @LoginName, @strNote, @input_ProcessItemInstance
 RETURN (-1)

Done:
 Select @outputError = @@ERROR
 COMMIT TRANSACTION tr_CreateProcessJobInstance  --@tranName
 Exec sp_EventLog_Insert 41 /*Успешное создание экземпляра Элемента Работы*/, @CurrentStorageProcedureName, @LoginName, @strNote, @CreatedJobItem_1
 RETURN (@CreatedJobItem_1)










GO
/****** Object:  StoredProcedure [dbo].[sp_CreateProcessInstance]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[sp_CreateProcessInstance]
					@input_ProcessTemplate int,
					@input_DocumentId bigint
	
                                                                   
                                                                 
 AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_CreateProcessInstance'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int
declare @ROWCOUNT_sys int

--declare @tranName varchar(100)

--select @tranName = dbo.f_GetUniqTransactionName()
--BEGIN TRANSACTION @tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @CreatedProcess bigint
declare @uniqValue varchar(36)
select @uniqValue = NEWID()
declare @CallerUserName varchar(128)
set @CallerUserName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

Declare @CreationDate datetime
Select @CreationDate = GetDate()

INSERT INTO dbo.ProcessInstance
	  (ProcessTemplate, Notes, DocumentId, CycleNumber, bItemSeparate, CreationDate, uniqValue)
      (Select id, Notes, @input_DocumentId, 1, 1, GetDate(), @uniqValue From TemplateProcess Where id = @input_ProcessTemplate)

Set @OutputError = @@ERROR
Set @ROWCOUNT_sys = @@ROWCOUNT
IF @@ROWCOUNT != 1 or @@ERROR != 0
begin
 select @ProgramError = 1
 set @strNote = 'id шаблона Процесса = '
 set @strNote += rtrim(Convert(varchar(8), @input_ProcessTemplate)) + '; '
 set @strNote += '@@Error= ' + rtrim(Convert(varchar(8), @OutputError)) + '; '
 set @strNote += '@@ROWCOUNT= ' + rtrim(Convert(varchar(8), @ROWCOUNT_sys)) + '; '
 GOTO Error
end

select @CreatedProcess = (Select pi1.id from ProcessInstance as pi1 where pi1.uniqValue = @uniqValue)

-------------------------- Создание ProcessItem Instance --------------------------------------------------------
Declare @CreatedProcessItemInstance_1 bigint
exec @CreatedProcessItemInstance_1 = sp_CreateProcessItemInstance @input_ProcessTemplate, @CreatedProcess 
if @CreatedProcessItemInstance_1 = -1
begin
 select @ProgramError = 1
 set @strNote = 'Ошибка в вызываемом sp_CreateProcessItemInstance. id шаблона Процесса = '
 set @strNote += rtrim(Convert(varchar(8), @input_ProcessTemplate)) + '; '
 GOTO Error
end


-------------------------- Создание JobProcessItem Instance для каждого ProcessItem ------------------------------
declare @TemplateProcessItemCount int
set @TemplateProcessItemCount = dbo.f_GetTemplateProcessItemCount(@input_ProcessTemplate)
Declare @CreatedJobItemInstance bigint
declare @ProcessItemLevel int
declare @TargetProcessItem bigint

set @ProcessItemLevel = 1

while @TemplateProcessItemCount >= @ProcessItemLevel
begin
 set @TargetProcessItem = dbo.f_GetProcessItemId_byLevel(@CreatedProcess, @ProcessItemLevel)
 exec @CreatedJobItemInstance = sp_CreateJobItemInstance @TargetProcessItem
 if @CreatedJobItemInstance = -1
 begin
  select @ProgramError = 1
  set @strNote = 'Ошибка в вызываемом sp_CreateJobItemInstance. id шаблона Процесса = '
  set @strNote += rtrim(Convert(varchar(8), @input_ProcessTemplate)) + '; '
  set @strNote = ' № Этапа Процесса = '
  set @strNote += rtrim(Convert(varchar(8), @ProcessItemLevel)) + '; '
  GOTO Error
 end
 set @ProcessItemLevel = @ProcessItemLevel + 1
end


Goto Done
---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Select @outputError = @@ERROR
-- ROLLBACK TRANSACTION @tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @CallerUserName, @strNote
 select  -1 as CreatedProcessInstance
 return (-1)

Done:
 Select @outputError = @@ERROR
-- COMMIT TRANSACTION @tranName
 exec sp_EventLog_Insert 1 /*Успешное создание экземпляра процесса*/, @CurrentStorageProcedureName, @CallerUserName, @strNote, @CreatedProcess
 select @CreatedProcess as CreatedProcessInstance
 return (@CreatedProcess)








GO
/****** Object:  StoredProcedure [dbo].[sp_CreateProcessItemInstance]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sp_CreateProcessItemInstance]
					@input_ProcessTemplate int,
					@input_ProcessInstance bigint
	
                                                                   
                                                                 
 AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_CreateProcessItemInstance'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int
declare @ROWCOUNT_sys int

--declare @tranName varchar(100)

--select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION tr_CreateProcessItemInstance --@tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @CreatedProcess bigint
declare @uniqValue varchar(36)
select @uniqValue = NEWID()
declare @CallerUserName varchar(128)
set @CallerUserName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

Declare @CreatedProcessItem_1 bigint  -- Переменная для возврата Id первого Этапа

Declare @CreationDate datetime
Select @CreationDate = GetDate()

INSERT INTO dbo.ProcessItemInstance
	  (Process, ItemLevel, ParentItem, JobRole, Job, CreationDate, uniqValue)
      (Select @input_ProcessInstance, ItemLevel, ParentItem, 
	  (Case When IsNull(IsVirtualJobRole, 0) = 0 Then JobRole Else dbo.f_GetJobRoleReal_byVirtual(JobRole, @CallerUserName) End), 
	  Job, @CreationDate, @uniqValue From TemplateProcessItem Where ProcessTemplate = @input_ProcessTemplate)


IF @@ERROR != 0 -- @@ROWCOUNT != 1 or  !!!! - Не пытаться добавлять это условие, т.к. вставляем больше 1 !!!
begin
 Set @OutputError = @@ERROR
 Set @ROWCOUNT_sys = @@ROWCOUNT 
 select @ProgramError = 2
 set @strNote = 'id шаблона Процесса = '
 set @strNote += rtrim(Convert(varchar(8), @input_ProcessTemplate)) + '; '
 set @strNote += '@@Error= ' + rtrim(Convert(varchar(8), @OutputError)) + '; '
 set @strNote += '@@ROWCOUNT= ' + rtrim(Convert(varchar(8), @ROWCOUNT_sys)) + '; '
 GOTO Error
end

select @CreatedProcessItem_1 = (Select top 1 pil.id from ProcessItemInstance as pil where pil.uniqValue = @uniqValue)

---------------------------- Сделать переопределение ссылок Parent, так как они назначена в Template и содержат id из Template ------------
update ProcessItemInstance set ParentItem = (dbo.f_GetProcessItemId_byLevel(@input_ProcessInstance, ItemLevel-1))
							where Process = @input_ProcessInstance and uniqValue = @uniqValue and ItemLevel > 1
---------------------------------------------------------------------------------------------------------------------------------------------------
Goto Done


---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Select @outputError = @@ERROR
 ROLLBACK TRANSACTION tr_CreateProcessItemInstance --@tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @CallerUserName, @strNote
 RETURN (-1)

Done:
 Select @outputError = @@ERROR
 COMMIT TRANSACTION tr_CreateProcessItemInstance  --@tranName
 Exec sp_EventLog_Insert 2 /*Успешное создание экземпляра Этапа Процесса*/, @CurrentStorageProcedureName, @CallerUserName, @strNote, @CreatedProcessItem_1
 RETURN (@CreatedProcessItem_1)









GO
/****** Object:  StoredProcedure [dbo].[sp_CreateStoreObject]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[sp_CreateStoreObject]
                    @input_DocumentId bigint,
                    @input_DocumentItemId bigint,
                    @input_ObjectGroupId int,
                    @input_MeasurementUnitId int,
                    @input_ObjectShortName varchar (256),
                    @input_ObjectFullName varchar (1024),
                    @input_ObjectVolume int,
                    @input_Notes varchar (1024),
                    @input_CreationDateAsString varchar (32)
                    
 AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_CreateStoreObject'
---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

declare @tranName varchar(100)

select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION @tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @uniqValue varchar(36)
select @uniqValue = NEWID()
declare @CallerUserName varchar(128)
set @CallerUserName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

declare @dateCreationDate datetime
Select @dateCreationDate = GetDate()

declare @CreatedStoreObjectMTR_Id bigint

INSERT INTO dbo.StoreObjectMTR
	  (DocumentId, DocumentItemId, ObjectGroup, ShortName, FullName, MeasurementUnit, Volume, CreationDate, CreatorOwner, sys_creationdate, Notes, uniqValue)
VALUES
      (@input_DocumentId, @input_DocumentItemId, @input_ObjectGroupId, @input_ObjectShortName, @input_ObjectFullName, @input_MeasurementUnitId, @input_ObjectVolume, 
	   CONVERT(datetime, rtrim(@input_CreationDateAsString)), dbo.f_GetUserId_byName(dbo.f_GetUserName_Current()), @dateCreationDate, @input_Notes, @uniqValue)

IF @@ROWCOUNT != 1 or @@ERROR != 0
begin
 select @ProgramError = 60
 set @strNote = 'Документ № ' + rtrim(Convert(varchar(8), @input_DocumentId))
 set @strNote += 'Элемент Документа № ' + rtrim(Convert(varchar(8), @input_DocumentItemId))
 GOTO Error
end

select @CreatedStoreObjectMTR_Id = (Select so_mtr.id from StoreObjectMTR as so_mtr
                                           where so_mtr.uniqValue = @uniqValue)
										   
                                               

if IsNull(@CreatedStoreObjectMTR_Id, 0) = 0
begin
 select @ProgramError = 60
 set @strNote = 'StoreObjectMTR_Id = ' + rtrim(CONVERT(varchar(max), @CreatedStoreObjectMTR_Id)) + '; '
 GOTO Error
end

set @ProgramEvent = 60
Goto Done

---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Select @outputError = @ProgramError
 ROLLBACK TRANSACTION @tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentId
 SELECT  @outputError
 RETURN (-1)

Done:
 Select @outputError = @ProgramError
 COMMIT TRANSACTION @tranName
 Exec sp_EventLog_Insert @ProgramEvent /*Успешное создание объекта на складе*/, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentId
 SELECT  @outputError
 RETURN (@CreatedStoreObjectMTR_Id)












GO
/****** Object:  StoredProcedure [dbo].[sp_CreateTemplateJobItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- Создание экземпляра Работа Процесса
CREATE  PROCEDURE [dbo].[sp_CreateTemplateJobItem]
					@input_ProcessItemTemplate bigint,
					@input_JobItemLevel int,
					@input_JobItem bigint,
					@input_IsActive bit,
					@input_IsEntireDocument bit,
					@input_IsEDD bit,
					@input_DoneCondition bigint,
					@input_DoneResolution bigint,
					@input_ConditionDependence bigint,
					@input_DoneResolutionText varchar(1024),
					@input_Notes varchar(1024),
					@input_IsDone bit

 AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_CreateTemplateJobItem'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int
declare @ROWCOUNT_sys int

--declare @tranName varchar(100)

--select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION tr_CreateTemplateJobItem --@tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @CreatedProcess bigint
declare @uniqValue varchar(36)
select @uniqValue = NEWID()
declare @LoginName varchar(128)
set @LoginName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

declare @CreatedJobItemTemplate int
Declare @CreationDate datetime
Select @CreationDate = GetDate()

if @input_IsEDD > 0 and dbo.f_IsEDDStatusExists_TemplateProcessItem(@input_ProcessItemTemplate) = 1 and dbo.f_IsEntireDocumentStatusExists_TemplateProcessItem(@input_ProcessItemTemplate) = 1
begin
 set @ProgramError = 42
 set @strNote = 'Уже существует работа "ЭДД" для данного шаблона Этапа Процесса = '
 set @strNote += rtrim(Convert(varchar(8), @input_ProcessItemTemplate)) + '; '
 Goto Error
end

insert into dbo.TemplateJobItem
	  (ProcessItemTemplate, JobItemLevel, JobItem, DoneCondition, IsActive, ConditionDependence, IsEntireDocument, IsEDD, IsDone, uniqValue)
	values(@input_ProcessItemTemplate, @input_JobItemLevel, @input_JobItem, @input_DoneCondition, @input_IsActive, 
		   @input_ConditionDependence, @input_IsEntireDocument, @input_IsEDD, @input_IsDone, @uniqValue)	

IF @@ERROR != 0
begin
 Set @OutputError = @@ERROR
 Set @ROWCOUNT_sys = @@ROWCOUNT 
 set @ProgramError = 42
 set @strNote = 'id шаблона Этапа Процесса = '
 set @strNote += rtrim(Convert(varchar(8), @input_ProcessItemTemplate)) + '; '
 set @strNote += '@@Error= ' + rtrim(Convert(varchar(8), @OutputError)) + '; '
 set @strNote += '@@ROWCOUNT= ' + rtrim(Convert(varchar(8), @ROWCOUNT_sys)) + '; '
 GOTO Error
end

select @CreatedJobItemTemplate = (Select tji.id from TemplateJobItem as tji where tji.uniqValue = @uniqValue)

set @ProgramEvent = 42
Goto Done


---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Select @outputError = @@ERROR
 ROLLBACK TRANSACTION tr_CreateTemplateJobItem --@tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @LoginName, @strNote
 select -1
 RETURN (-1)

Done:
 Select @outputError = @@ERROR
 COMMIT TRANSACTION tr_CreateTemplateJobItem  --@tranName
 Exec sp_EventLog_Insert @ProgramEvent, @CurrentStorageProcedureName, @LoginName, @strNote, @CreatedJobItemTemplate
 select @CreatedJobItemTemplate
 RETURN (@CreatedJobItemTemplate)











GO
/****** Object:  StoredProcedure [dbo].[sp_CreateTemplateProcess]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sp_CreateTemplateProcess]
					@input_ShortName varchar(256),
					@input_FullName varchar(1024),
					@input_Notes varchar(1024)
	
                                                                   
                                                                 
 AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_CreateProcessTemplate'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

declare @tranName varchar(100)

select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION @tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @CreatedProcessTemplate bigint
declare @uniqValue varchar(36)
select @uniqValue = NEWID()

Declare @CreationDate datetime
Select @CreationDate = GetDate()
declare @LoginName varchar(128)
set @LoginName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки


Insert Into dbo.TemplateProcess
	  (ShortName, FullName, Notes, CycleNumber, CreationDate, uniqValue)
     Values (@input_ShortName, @input_FullName, @input_Notes, 1, @CreationDate, @uniqValue)

IF @@ROWCOUNT != 1 or @@ERROR != 0
begin
 select @ProgramError = 5
 Select @OutputError = @@ERROR
 GOTO Error
end

---------- Начало - "Стандартный конец транзакции в конце процедуре" -------------------------------------------
Error:
 Select @outputError = @@ERROR
 ROLLBACK TRANSACTION @tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @LoginName, @strNote
 select -1
 RETURN (-1)

Done:
 Select @outputError = @@ERROR
 COMMIT TRANSACTION @tranName
 Exec sp_EventLog_Insert @ProgramEvent /*Создание маршрута*/, @CurrentStorageProcedureName, @LoginName, @strNote, @CreatedProcessTemplate
 SELECT @CreatedProcessTemplate
 RETURN (@CreatedProcessTemplate)









GO
/****** Object:  StoredProcedure [dbo].[sp_CreateTemplateProcessItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[sp_CreateTemplateProcessItem]
					@input_TemplateProcess bigint,
					@input_ItemLevel int,
					@input_Job int,
					@input_JobRole int,
					@input_IsVirtualJobRole bit
	
                                                                   
                                                                 
 AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_CreateTemplateProcessItem'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

declare @tranName varchar(100)

select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION @tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @uniqValue varchar(36)
select @uniqValue = NEWID()

Declare @CreationDate datetime
Select @CreationDate = GetDate()
declare @LoginName varchar(128)
set @LoginName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

declare @CreatedTemplateProcessItem bigint
declare @OldTemplateProcessItem bigint
declare @TargetParentItem int

set @OldTemplateProcessItem = dbo.f_GetTemplateProcessItemId_byLevel(@input_TemplateProcess, @input_ItemLevel)

if @input_ItemLevel > 1
begin
 set @TargetParentItem = dbo.f_GetTemplateProcessItemId_byLevel(@input_TemplateProcess, @input_ItemLevel - 1)
end
else
 set @TargetParentItem = Null

update TemplateProcessItem set ItemLevel = ItemLevel + 1
						   where ItemLevel >= @input_ItemLevel 

Insert Into dbo.TemplateProcessItem
	  (ProcessTemplate, ItemLevel, ParentItem, JobRole, IsVirtualJobRole, Job, uniqValue)
     Values (@input_TemplateProcess, @input_ItemLevel, @TargetParentItem, @input_JobRole, @input_IsVirtualJobRole, @input_Job, @uniqValue)

IF @@ROWCOUNT != 1 or @@ERROR != 0
begin
 select @ProgramError = 70
 Select @OutputError = @@ERROR
 GOTO Error
end

select @CreatedTemplateProcessItem = (Select tpi.id from TemplateProcessItem as tpi where tpi.uniqValue = @uniqValue)

update TemplateProcessItem set ParentItem = @CreatedTemplateProcessItem
						   where id = @OldTemplateProcessItem

set @ProgramEvent = 70
goto Done


---------- Начало - "Стандартный конец транзакции в конце процедуре" -------------------------------------------
Error:
 Select @outputError = @@ERROR
 ROLLBACK TRANSACTION @tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @LoginName, @strNote
 select -1
 return (-1)

Done:
 Select @outputError = @@ERROR
 COMMIT TRANSACTION @tranName
 Exec sp_EventLog_Insert @ProgramEvent /*Создание маршрута*/, @CurrentStorageProcedureName, @LoginName, @strNote, @CreatedTemplateProcessItem
 select @CreatedTemplateProcessItem
 return (@CreatedTemplateProcessItem)










GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteDocument]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[sp_DeleteDocument]
					@input_DocumentId bigint
                  

                                                                   
                                                                 
 AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_DeleteDocument'

Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

BEGIN TRANSACTION
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @sysUserName varchar(128)
select @sysUserName = suser_name()
declare @CallerUserName varchar(128)
set @CallerUserName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

Update dbo.DocumentList Set IsDeleted = 1
						Where id = @input_DocumentId


IF @@ROWCOUNT != 1 or @@ERROR != 0
begin
 set @ProgramError = 22
 GOTO Error
end
----------------------------------------------------------------------------------
set @ProgramEvent = 22
GOTO Done
  

---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Select @outputError = @@ERROR
 ROLLBACK TRANSACTION
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentId
 select -1
 RETURN (-1)

Done:
 Select @outputError = @@ERROR
 COMMIT TRANSACTION
 Exec sp_EventLog_Insert @ProgramEvent, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentId
 select @input_DocumentId
RETURN (@input_DocumentId)

GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteTemplateProcessItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  PROCEDURE [dbo].[sp_DeleteTemplateProcessItem]
					@input_TemplateProcessItem bigint
                                                                 
 AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_DeleteTemplateProcessItem'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

declare @tranName varchar(100)

select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION @tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @uniqValue varchar(36)
select @uniqValue = NEWID()

Declare @CreationDate datetime
Select @CreationDate = GetDate()
declare @LoginName varchar(128)
set @LoginName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

declare @TargetProcessItemForChangeParent int
declare @TargetParentItem int
declare @TargetItemLevel int

set @TargetProcessItemForChangeParent = dbo.f_GetTemplateProcessItemId_byParentId(dbo.f_GetTemplateProcess__byTemplateProcessItem(@input_TemplateProcessItem), @input_TemplateProcessItem)
set @TargetParentItem = dbo.f_GetTemplateProcessItemParent_byId(@input_TemplateProcessItem)

if @TargetProcessItemForChangeParent != -1
begin
 update TemplateProcessItem set ParentItem =  @TargetParentItem
      					    where id = @TargetProcessItemForChangeParent
 if @@ROWCOUNT != 1 or @@ERROR != 0
 begin
  select @ProgramError = 71
  select @OutputError = @@ERROR
  goto Error
 end

 set @TargetItemLevel = dbo.f_GetTemplateProcessItemLevel_byId(@input_TemplateProcessItem)

 -- Сдвинем номера ItemLevel у всех ЭП, которые следуют за исключаемым
 -- У исключаемого номер не меняется - для истории
 update TemplateProcessItem set ItemLevel = ItemLevel - 1
						    where ItemLevel > @TargetItemLevel
end

/*
set @TargetLevel = dbo.f_GetTemplateProcessItemLevel_byId(@input_TemplateProcessItem)

if @TargetLevel < dbo.f_GetTemplateProcessItemCount(dbo.f_GetTemplateProcess__byTemplateProcessItem(@input_TemplateProcessItem))
begin
 set @TargetParentItem = dbo.f_GetTemplateProcessItemId_byLevel(@input_TemplateProcess, @input_ItemLevel - 1)
end
else
 set @TargetParentItem = Null
*/

update TemplateProcessItem set IsDeleted = 1
						   where id = @input_TemplateProcessItem

-- Если ещё нет ни одного экземпляра ЭП, созданного по данному шаблону, у которого были операции на данном ЭП,
-- то можно исключить данный ЭП из всех созданных экземпляров ЭП


IF @@ROWCOUNT != 1 or @@ERROR != 0
begin
 select @ProgramError = 71
 Select @OutputError = @@ERROR
 GOTO Error
end

set @ProgramEvent = 71
goto Done


---------- Начало - "Стандартный конец транзакции в конце процедуре" -------------------------------------------
Error:
 Select @outputError = @@ERROR
 ROLLBACK TRANSACTION @tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @LoginName, @strNote
 select -1
 return (-1)

Done:
 Select @outputError = @@ERROR
 COMMIT TRANSACTION @tranName
 Exec sp_EventLog_Insert @ProgramEvent /*Создание маршрута*/, @CurrentStorageProcedureName, @LoginName, @strNote, @input_TemplateProcessItem
 select 0
 return (0)











GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteUser]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE 	[dbo].[sp_DeleteUser] 	
                    @input_TargetUserId int
											
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_DeleteUser'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @input_CallerUserName varchar(128)
set @input_CallerUserName = suser_name() --'user3' -- Только для отработки

--------------------- Проверки --------------------------------------------------------------------------
if IsNull(@input_TargetUserId, 0) = 0
begin
 select @ProgramError = 124
 select @strNote = 'Пользовательский логин не существует...'
 Goto Error
end                                                 

---------------------------------------------------------------------------------------------------------

Update dbo.sprUser Set IsDeleted = 1
                        Where Id = @input_TargetUserId

IF @@ROWCOUNT = 1 AND @@ERROR=0
begin
 select @strNote = ''
 select @ProgramEvent = 192 /*Удаление пользователя произведено*/
 GOTO Done
end
Else
 select @ProgramError = 195 /*Ошибка в процессе удаления пользователя*/

---------- Начало - "Стандартный конец транзакции в конце процедуре" -------------------------------------------
Error:
 Select @outputError = @@ERROR
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @input_CallerUserName, @strNote
 SELECT  @outputError
 RETURN (@outputError)

Done:
 Select @outputError = @@ERROR
 Exec sp_EventLog_Insert @ProgramEvent /*Успешное удаление Пользователя*/, @CurrentStorageProcedureName, @input_CallerUserName, @strNote
 SELECT  @outputError
 RETURN (@outputError)









GO
/****** Object:  StoredProcedure [dbo].[sp_Document_EDD]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE 	[dbo].[sp_Document_EDD] 	
							@input_DocumentId bigint,
							@input_JobResult tinyint,
							@input_Note varchar(4096) = Null
																		
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_Document_EDD'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int
--declare @ItemsCount int

declare @tranName varchar(100)

select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION @tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @uniqValue varchar(36)
select @uniqValue = NEWID()
declare @CallerUserName varchar(128)
--set @CallerUserName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

declare @AffectedDocumentItem int
set @AffectedDocumentItem = 0
set @ProgramError = 0

declare @Result int
Declare Cursor_DocumentItem Cursor For
      Select di.id From DocumentItem as di
      Where di.DocumentId = @input_DocumentId
      Order By di.id
    For Read Only
     
Declare @TargetDocumentItemId bigint
    
Open Cursor_DocumentItem
            
Fetch Cursor_DocumentItem Into @TargetDocumentItemId
     
 While (@@FETCH_STATUS = 0)
 Begin

  exec @Result = sp_DocumentItem_EDD @TargetDocumentItemId, @input_JobResult
  if @Result != 0
  begin
	Close Cursor_DocumentItem
	Deallocate Cursor_DocumentItem
	set @outputError = 21
	Goto Error
  end

  set @AffectedDocumentItem = @AffectedDocumentItem + 1
  Fetch Cursor_DocumentItem Into @TargetDocumentItemId

 End     
Close Cursor_DocumentItem
Deallocate Cursor_DocumentItem

-- Записать замечания (комментарии) в DocumentComment
if IsNull(@input_Note, '') != ''
begin
-- declare @Target_CycleNumber int
-- select @Target_CycleNumber = di.CycleNumber from DocumentItem as di where di.id = @input_DocumentId

declare @CreatedDocumentComment bigint

exec @CreatedDocumentComment = sp_CreateComment_Document @input_DocumentId, @input_JobResult, @input_Note
IF @CreatedDocumentComment = -1
begin
 set @ProgramError = 51 /*Ошибка создания комментария для Документа*/
 set @strNote = 'Ошибка в  sp_CreateDocumentComment ' + ltrim(STR(@input_DocumentId))
 Goto Error
end

end
set @ProgramEvent = 21
Goto Done


--------------- Стандартное завершение процедуры с явными транзакциями ----------------------------------------
Error:
 ROLLBACK TRANSACTION @tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @CallerUserName, @strNote
 SELECT  -1
 RETURN (-1)
 
Done:
 Select @outputError = 21
 COMMIT TRANSACTION @tranName
 Exec sp_EventLog_Insert @ProgramEvent, @CurrentStorageProcedureName, @CallerUserName, @strNote
 SELECT @AffectedDocumentItem 
 RETURN (@AffectedDocumentItem)



















GO
/****** Object:  StoredProcedure [dbo].[sp_Document_JobExec]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  PROCEDURE 	[dbo].[sp_Document_JobExec] 	
							@input_DocumentId bigint,
							@input_JobResult tinyint,
							@input_Note varchar(4096) = Null
											
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_Document_JobExec'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int
declare @ItemsCount int

declare @tranName varchar(100)

select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION @tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @uniqValue varchar(36)
select @uniqValue = NEWID()
declare @CallerUserName varchar(128)
set @CallerUserName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

declare @AffectedDocumentItem int
set @AffectedDocumentItem = 0

set @OutputError = 0

 exec @AffectedDocumentItem = sp_Document_EDD @input_DocumentId, @input_JobResult, @input_Note
 if @AffectedDocumentItem != dbo.f_GetDocumentItemCount(@input_DocumentId)
 begin
  set @OutputError = 21
  set @strNote = 'Элементарное Действие было применена не ко всем Элементам Документа'
  goto Error
 end


set @ProgramEvent = 21
goto Done
--------------- Стандартное завершение процедуры с явными транзакциями ----------------------------------------
Error:
 ROLLBACK TRANSACTION @tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @CallerUserName, @strNote
 SELECT  0 as Result
 RETURN (-1)
 
Done:
 COMMIT TRANSACTION @tranName
 Exec sp_EventLog_Insert @ProgramEvent, @CurrentStorageProcedureName, @CallerUserName, @strNote
 SELECT  1 as Result
 RETURN (1)




















GO
/****** Object:  StoredProcedure [dbo].[sp_DocumentItem_Add]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE 	[dbo].[sp_DocumentItem_Add]
											@input_CallerUserAsString varchar(256) = NULL,
											@input_IdOrder bigint,											
											@input_IdOrderItem bigint,											
											@input_Notes varchar(1024),
											@input_IdRoute int,
											@input_RoutesPositionLevel int,
											@input_CycleOfApprovments int,
											@input_ActionsCode int
											


AS
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_AddActionToOrderItem'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

declare @tranName varchar(100)

select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION @tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @sysUserName varchar(100)
select @sysUserName = suser_name()
declare @EventsDate Datetime
Select @EventsDate = GetDate()

INSERT INTO dbo.OrdersItemsActions
	  (IdOrder, idOrdersItem, Notes, IdRoute, RoutesPositionLevel, CycleOfApprovments, ActionsCode)
VALUES
      (@input_IdOrder, @input_IdOrderItem, @input_Notes, @input_IdRoute,  @input_RoutesPositionLevel, @input_CycleOfApprovments, @input_ActionsCode)

IF @@ROWCOUNT != 1 AND @@ERROR != 0
begin
 select @ProgramError = 41 /*Ошибка изменения статуса*/
 set @strNote = 'Ошибка записи в OrdersItemsActions для IdOrder= ' + ltrim(STR(@input_IdOrder)) + ltrim(STR(@input_IdOrderItem))
 Goto Error
end

Goto Done
--------------- Стандартное завершение процедуры с явными транзакциями ----------------------------------------
Error:
 Select @outputError = @@ERROR
 ROLLBACK TRANSACTION @tranName
 Exec sp_AddError @ProgramError, @CurrentStorageProcedureName, @strNote, @input_CallerUserAsString, @input_IdOrder
-- SELECT  @outputError
 RETURN (@outputError)
 
Done:
 Select @outputError = @@ERROR
 COMMIT TRANSACTION @tranName
 Exec sp_AddEvent @ProgramEvent, @CurrentStorageProcedureName, @input_IdOrder, @input_CallerUserAsString
-- SELECT  @outputError
 RETURN (@outputError)










GO
/****** Object:  StoredProcedure [dbo].[sp_DocumentItem_AddAttachment]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_DocumentItem_AddAttachment]
                    @input_DocumentItemId bigint,
                    @input_AttachmentName varchar (256),
					@input_UNCFileName varchar (4096),
                    @input_BLOBDate varbinary(max)
                                                                 
 AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_AddAttachmentOrderItem'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

declare @tranName varchar(100)

select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION @tranName

declare @CreatedAttachmentId bigint
declare @uniqValue varchar(36)
select @uniqValue = NEWID()
declare @CallerUserName varchar(128)
set @CallerUserName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

/*   Только для примера - вариант передачи имени файла и загрузка с сервака, а не передача BLOB Data с клиента
INSERT INTO dbo.OrderAttachments (IdOrderItem, fileDATA)
SELECT 81, *
FROM OPENROWSET(BULK N'D:\oradb_iops.JPG', SINGLE_BLOB) AS [File]
*/


insert into dbo.DocumentItemAttachment
	  (DocumentItemId, AttachmentName, UNCFileName, fileDATA, uniqValue)
values
      (@input_DocumentItemId, @input_AttachmentName, @input_UNCFileName, @input_BLOBDate, @uniqValue)

select @CreatedAttachmentId = (Select dia.id from DocumentItemAttachment as dia
                                           where dia.uniqValue = @uniqValue)

if IsNull(@CreatedAttachmentId, 0) = 0
begin
 select @ProgramError = 34
end

select @ProgramEvent = 34
goto Done

---------- Начало - "Стандартный конец транзакции в конце процедуре" -------------------------------------------
Error:
 Select @outputError = @@ERROR
 ROLLBACK TRANSACTION tr_CreateProcessItemInstance --@tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentItemId

 return (-1)

Done:
 Select @outputError = @@ERROR
 COMMIT TRANSACTION tr_CreateProcessItemInstance  --@tranName
 Exec sp_EventLog_Insert 2 /*Успешное создание экземпляра Этапа Процесса*/, @CurrentStorageProcedureName, @CallerUserName, @strNote, @CreatedAttachmentId

 select @CreatedAttachmentId
 return (@CreatedAttachmentId)







GO
/****** Object:  StoredProcedure [dbo].[sp_DocumentItem_EDD]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE 	[dbo].[sp_DocumentItem_EDD] 	
							@input_DocumentItemId bigint,											
							@input_JobResult smallint,
							@input_Note varchar(4096) = Null

AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_DocumentItem_EDD'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int
declare @ItemsCount int

declare @tranName varchar(100)

select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION @tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @uniqValue varchar(36)
select @uniqValue = NEWID()
declare @CallerUserName varchar(128)
set @CallerUserName = 'user3' --dbo.f_GetUserName_Current() --'user3' -- Только для отработки

set @ProgramError = 0

-- Общая проверка на возможность изменения состояния в принципе.
if dbo.f_CanChangeDocumentItemState(@input_DocumentItemId) = 0
begin
  set @ProgramError = 32 /*Ошибка изменения состояния Элемента Документа*/
  set @strNote = 'f_CanChangeDocumentItemState(' + ltrim(STR(@input_DocumentItemId)) + ') = 0 '
  goto error
end

if @input_JobResult = dbo.f_GetJobResult_Agreed()
begin
 if dbo.f_CanChangeDocumentItemState_Agree(@input_DocumentItemId) = 0
 begin
  set @ProgramError = 32 /*Ошибка изменения состояния Элемента Документа*/
  set @strNote = 'f_CanChangeDocumentItemState_Agree(' + ltrim(STR(@input_DocumentItemId)) + ') = 0 '
  goto error
 end
end

if @input_JobResult = dbo.f_GetJobResult_Denied()
begin
 if dbo.f_CanChangeDocumentItemState_Deny(@input_DocumentItemId) = 0
 begin
  set @ProgramError = 32 /*Ошибка изменения состояния Элемента Документа*/
  set @strNote = 'f_CanChangeDocumentItemState_Deny(' + ltrim(STR(@input_DocumentItemId)) + ') = 0 '
  goto error
 end
end

if @input_JobResult = dbo.f_GetJobResult_Alter()
begin
 if dbo.f_CanChangeDocumentItemState_Alter(@input_DocumentItemId) = 0
 begin
  set @ProgramError = 32 /*Ошибка изменения состояния Элемента Документа*/
  set @strNote = 'f_CanChangeDocumentItemState_Altered(' + ltrim(STR(@input_DocumentItemId)) + ') = 0 '
  goto error
 end
end


-- Отражаем Действие над ЭД в журнале состояний
declare @CreatedDocumentItemState bigint

exec @CreatedDocumentItemState = sp_CreateDocumentItemState @input_DocumentItemId, @input_JobResult


IF @CreatedDocumentItemState = -1
begin
 set @ProgramError = 32 /*Ошибка изменения состояния Элемента Документа*/
 set @strNote = 'Ошибка в  sp_DocumentItem_EDD: вызов sp_CreateDocumentItemState ' + str(@input_DocumentItemId) + ', ' + str(@input_JobResult) + ' вернул "-1")'
 Goto Error
end

-- Вычисление и запись следующего Этапа Процесса для ЭД.

declare @NextProcessItem bigint
set @NextProcessItem = dbo.f_GetProcessItemNext_DocumentItem(@input_DocumentItemId, @input_JobResult)

IF IsNull(@NextProcessItem, -1) = -1
begin
 set @ProgramError = 4 /*Ошибка вычисления следующего Элемента Процесса*/
 set @strNote = 'Ошибка: вызов f_GetProcessItemNext_DocumentItem(' + ltrim(STR(@input_DocumentItemId)) + ') = -1)'
 Goto Error
end

update DocumentItem set ProcessItemId = @NextProcessItem
	where Id = @input_DocumentItemId


-- Для ЭДД - "На доработку" оформим переход на первый ЭП и на следующий цикл согласования данного Элемента Документа
-- У каждого ЭД свой номер цикла, т.е. необходимо увеличить номер цикла на 1 и сделать текущим первый Этап Процесса
if @input_JobResult = dbo.f_GetJobResult_Alter()
begin
 update DocumentItem set ProcessItemId = dbo.f_GetProcessItemFirst_DocumentItem(@input_DocumentItemId),
						 CycleNumber = CycleNumber + 1
					 where Id = @input_DocumentItemId
end

-- Записать замечания (комментарии) в DocumentItemComment
if IsNull(@input_Note, '') != ''
begin
 declare @Target_CycleNumber int
 select @Target_CycleNumber = di.CycleNumber from DocumentItem as di where di.id = @input_DocumentItemId

-- Отражаем Действие над ЭД в журнале состояний
declare @CreatedDocumentItemComment bigint

exec @CreatedDocumentItemComment = sp_CreateComment_DocumentItem @input_DocumentItemId, @input_JobResult, @input_Note
IF @CreatedDocumentItemComment = -1
begin
 set @ProgramError = 50 /*Ошибка создания комментария для Элемента Документа*/
 set @strNote = 'Ошибка в  sp_CreateDocumentItemComment ' + ltrim(STR(@input_DocumentItemId))
 Goto Error
end

end


set @ProgramEvent = 33 /*Успешное изменение состояния Элемента Документа*/
Goto Done


--------------- Стандартное завершение процедуры с явными транзакциями ----------------------------------------
Error:
 Select @outputError = @@ERROR
 ROLLBACK TRANSACTION @tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentItemId
 SELECT  @outputError
 RETURN (@outputError)
 
Done:
 Select @outputError = @@ERROR
 COMMIT TRANSACTION @tranName
 Exec sp_EventLog_Insert @ProgramEvent, @CurrentStorageProcedureName, @CallerUserName, @input_DocumentItemId
 SELECT  @outputError
 RETURN (@outputError)


















GO
/****** Object:  StoredProcedure [dbo].[sp_DocumentItem_JobExec]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE 	[dbo].[sp_DocumentItem_JobExec] 	
							@input_DocumentItemId bigint,
							@input_JobResult tinyint,
							@input_Note varchar(4096) = Null
											
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_DocumentItem_JobExec'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

declare @tranName varchar(100)

select @tranName = dbo.f_GetUniqTransactionName()
--BEGIN TRANSACTION @tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @uniqValue varchar(36)
select @uniqValue = NEWID()
declare @CallerUserName varchar(128)
set @CallerUserName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

exec sp_DocumentItem_EDD @input_DocumentItemId, @input_JobResult, @input_Note
set @ProgramEvent = 32
goto Done

--------------- Стандартное завершение процедуры с явными транзакциями ----------------------------------------
Error:
 Select @outputError = @@ERROR
-- ROLLBACK TRANSACTION @tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @CallerUserName, @strNote
 SELECT  0
 RETURN (@outputError)
 
Done:
 Select @outputError = @@ERROR
 --COMMIT TRANSACTION @tranName
 Exec sp_EventLog_Insert @ProgramEvent, @CurrentStorageProcedureName, @CallerUserName, @strNote
 SELECT  1
 RETURN (@outputError)


















GO
/****** Object:  StoredProcedure [dbo].[sp_DocumentItem_ToStor]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE 	[dbo].[sp_DocumentItem_ToStor] 	
							@input_DocumentItemId bigint,											
							@input_JobResult smallint,
							@input_Note varchar(4096) = Null

AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_DocumentItem_ToStor'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int
declare @ItemsCount int

declare @tranName varchar(100)

select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION @tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @uniqValue varchar(36)
select @uniqValue = NEWID()
declare @CallerUserName varchar(128)
set @CallerUserName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

set @ProgramError = 0

-- Общая проверка на возможность изменения состояния в принципе.
if dbo.f_CanChangeDocumentItemState(@input_DocumentItemId) = 0
begin
  set @ProgramError = 32 /*Ошибка изменения состояния Элемента Документа*/
  set @strNote = 'f_CanChangeDocumentItemState(' + ltrim(STR(@input_DocumentItemId)) + ') = 0 '
  goto error
end

if @input_JobResult = dbo.f_GetJobResult_Agreed()
begin
 if dbo.f_CanChangeDocumentItemState_Agree(@input_DocumentItemId) = 0
 begin
  set @ProgramError = 32 /*Ошибка изменения состояния Элемента Документа*/
  set @strNote = 'f_CanChangeDocumentItemState_Agree(' + ltrim(STR(@input_DocumentItemId)) + ') = 0 '
  goto error
 end
end

if @input_JobResult = dbo.f_GetJobResult_Denied()
begin
 if dbo.f_CanChangeDocumentItemState_Deny(@input_DocumentItemId) = 0
 begin
  set @ProgramError = 32 /*Ошибка изменения состояния Элемента Документа*/
  set @strNote = 'f_CanChangeDocumentItemState_Deny(' + ltrim(STR(@input_DocumentItemId)) + ') = 0 '
  goto error
 end
end

if @input_JobResult = dbo.f_GetJobResult_Alter()
begin
 if dbo.f_CanChangeDocumentItemState_Alter(@input_DocumentItemId) = 0
 begin
  set @ProgramError = 32 /*Ошибка изменения состояния Элемента Документа*/
  set @strNote = 'f_CanChangeDocumentItemState_Altered(' + ltrim(STR(@input_DocumentItemId)) + ') = 0 '
  goto error
 end
end


-- Отражаем Действие над ЭД в журнале состояний
declare @CreatedDocumentItemState bigint

exec @CreatedDocumentItemState = sp_CreateDocumentItemState @input_DocumentItemId, @input_JobResult


IF @CreatedDocumentItemState = -1
begin
 set @ProgramError = 32 /*Ошибка изменения состояния Элемента Документа*/
 set @strNote = 'Ошибка в  sp_CreateDocumentItemState ' + ltrim(STR(@input_DocumentItemId))
 Goto Error
end

-- Вычисление и запись следующего Этапа Процесса для ЭД.

declare @NextProcessItem bigint
set @NextProcessItem = dbo.f_GetProcessItemNext_DocumentItem(@input_DocumentItemId, @input_JobResult)

IF @NextProcessItem = -1
begin
 set @ProgramError = 4 /*Ошибка вычисления следующего Элемента Процесса*/
 set @strNote = 'Ошибка в f_GetProcessItemNext_DocumentItem(' + ltrim(STR(@input_DocumentItemId)) + ') = -1)'
 Goto Error
end

update DocumentItem set ProcessItemId = @NextProcessItem
	where Id = @input_DocumentItemId


-- Для ЭДД - "На доработку" оформим переход на первый ЭП и на следующий цикл согласования данного Элемента Документа
-- У каждого ЭД свой номер цикла, т.е. необходимо увеличить номер цикла на 1 и сделать текущим первый Этап Процесса
if @input_JobResult = dbo.f_GetJobResult_Alter()
begin
 update DocumentItem set ProcessItemId = dbo.f_GetProcessItemFirst_DocumentItem(@input_DocumentItemId),
						 CycleNumber = CycleNumber + 1
					 where Id = @input_DocumentItemId
end

-- Записать замечания (комментарии) в DocumentComment
if IsNull(@input_Note, '') != ''
begin
 declare @Target_CycleNumber int
 select @Target_CycleNumber = di.CycleNumber from DocumentItem as di where di.id = @input_DocumentItemId

-- Отражаем Действие над ЭД в журнале состояний
declare @CreatedDocumentItemComment bigint

exec @CreatedDocumentItemComment = sp_CreateComment_DocumentItem @input_DocumentItemId, @input_Note
IF @CreatedDocumentItemState = -1
begin
 set @ProgramError = 50 /*Ошибка создания комментария для Элемента Документа*/
 set @strNote = 'Ошибка в  sp_CreateDocumentItemComment ' + ltrim(STR(@input_DocumentItemId))
 Goto Error
end

end


set @ProgramEvent = 33 /*Успешное изменение состояния Элемента Документа*/
Goto Done


--------------- Стандартное завершение процедуры с явными транзакциями ----------------------------------------
Error:
 Select @outputError = @@ERROR
 ROLLBACK TRANSACTION @tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentItemId
 SELECT  @outputError
 RETURN (@outputError)
 
Done:
 Select @outputError = @@ERROR
 COMMIT TRANSACTION @tranName
 Exec sp_EventLog_Insert @ProgramEvent, @CurrentStorageProcedureName, @CallerUserName, @input_DocumentItemId
 SELECT  @outputError
 RETURN (@outputError)



















GO
/****** Object:  StoredProcedure [dbo].[sp_EditDocument]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE 	[dbo].[sp_EditDocument] 	
					@input_DocumentId bigint,
                    @input_ExecutionDateAsString varchar(32),
                    @input_Notes varchar (1024),
                    @input_DocumentShortName varchar (256),
                    @input_DocumentNum varchar (256)
AS
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_DeleteDocument'

Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

BEGIN TRANSACTION
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

declare @CreatedIdDocument bigint
declare @CreatedIdProcess bigint
declare @CreationDate datetime

declare @sysUserName varchar(128)
select @sysUserName = suser_name()
declare @CallerUserName varchar(128)
set @CallerUserName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

Update dbo.DocumentList Set CreationDate = CONVERT(datetime, rtrim(@input_ExecutionDateAsString)),
							Notes = @input_Notes, 
							ShortName = @input_DocumentShortName,
							DocumentNum = @input_DocumentNum
						Where id = @input_DocumentId


IF @@ROWCOUNT != 1 or @@ERROR != 0
begin
 set @ProgramError = 23
 GOTO Error
end
----------------------------------------------------------------------------------
set @ProgramEvent = 23
GOTO Done
  

---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Select @outputError = @@ERROR
 ROLLBACK TRANSACTION
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentId
 select -1
 RETURN (-1)

Done:
 Select @outputError = @@ERROR
 COMMIT TRANSACTION
 Exec sp_EventLog_Insert @ProgramEvent, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentId
 select @input_DocumentId
RETURN (@input_DocumentId)










GO
/****** Object:  StoredProcedure [dbo].[sp_EditDocumentItem_MTR]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_EditDocumentItem_MTR]
                    @input_DocumentItemId bigint,
                    @input_ObjectGroupId int,
                    @input_MeasurementUnitId int,
                    @input_ObjectName varchar (1024),
                    @input_ObjectVolume int,
                    @input_Notes varchar (1024),
                    @input_ExecutionDateAsString varchar (32) = Null
                    
	
                                                                   
                                                                 
 AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_EditDocumentItem_MTR'


---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

declare @tranName varchar(100)

select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION @tranName

declare @CreatedAttachmentId bigint
declare @uniqValue varchar(36)
select @uniqValue = NEWID()
declare @CallerUserName varchar(128)
set @CallerUserName = dbo.f_GetUserName_Current() --'user3' -- Только для отработки

---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------
/*
declare @NestingLevel tinyint
select @NestingLevel = (select max(dih.NestingLevel) from DocumentItemHistory as dih Where dih.DocumentItemId = @input_DocumentItemId)
select @NestingLevel = ISNULL(@NestingLevel, 0) + 1 -- Определим следующее значение для уровня следования (вложенности)

-- Сначала скопируем содержимое позиции заявки в таблицу оригиналов (удаленных) для сохранения истории изменения позиций заявок
Insert into OrdersItemsHistory
	  (idOrder, idOrdersItem, ObjectsGroup, ShortName, MeasurementUnit, Volume, CreatorOwner, Notes,
	    sys_creationdate, ProcessStatus, NestingLevel, ExpirationDate)
 
	(Select idOrder, id, ObjectsGroup, ShortName, MeasurementUnit, Volume, CreatorOwner, Notes,
	    sys_creationdate, ProcessStatus, @NestingLevel, CONVERT(datetime, rtrim(@input_ExperationDateAsString))
								From OrdersItems Where IdOrder = @input_IdOrder and id = @input_IdOrdersItem)

IF @@ROWCOUNT != 1 or @@ERROR != 0
begin
 set @strNote = 'Не возможно скопировать строку заявки в архив'
 select @ProgramError = 40
 GOTO Error
end
*/	
-- Редактируем существующую запись (позицию заявки) под новые значения
Update dbo.DocumentItem Set
      ShortName  = @input_ObjectName,
      Notes = @input_Notes
--      ExpirationDate = CONVERT(datetime, rtrim(@input_ExperationDateAsString))
    where id = @input_DocumentItemId

IF @@ROWCOUNT != 1 or @@ERROR != 0
begin
 select @ProgramError = 35
 GOTO Error
end

Update dbo.DocumentItem_MTR Set
      ObjectGroup = @input_ObjectGroupId, --(Select _og.id From sprObjectsGroups as _og Where (_og.ShortName like rtrim(@input_ObjectsGroupsAsString) or _og.FullName like rtrim(@input_ObjectsGroupsAsString))),
      MeasurementUnit = @input_MeasurementUnitId, --(Select _mu.id From sprMeasurementUnits as _mu Where (_mu.ShortName like rtrim(@input_MeasurementsUnitsAsString) or _mu.FullName like rtrim(@input_MeasurementsUnitsAsString))), 
      Volume = @input_ObjectVolume 
    where id = @input_DocumentItemId


IF @@ROWCOUNT != 1 or @@ERROR != 0
begin
 set @strNote = 'Ошибка редактирования Элемента Документа типа МТР'
 select @ProgramError = 35
 GOTO Error
end

/*
-- Если редактирование производится по причине "отправлено на доработку инициатору", то необходимо сделать запись об этом в OrdersComments
if (Select oi.ActionsCode from OrdersItems as oi Where oi.id = @input_IdOrdersItem) = dbo.f_GetIdAlternedActionCode()
begin
 Declare @IdCurrentRoutesPosLevel int
 Declare @IdCurrentRouteCode int
 Declare @CurrentCycleOfApprovments int
 Select @IdCurrentRoutesPosLevel = (Select oci.IdCurrentRoutesPositionLevel From OrdersCommonInfo as oci Where oci.IdOrder = @input_IdOrder)
 Select @IdCurrentRouteCode = (Select oci.IdRoute From OrdersCommonInfo as oci Where oci.IdOrder = @input_IdOrder)
 Select @CurrentCycleOfApprovments = (select CycleOfApprovments from OrdersCommonInfo where IdOrder = @input_IdOrder)

 INSERT INTO dbo.OrdersItemsActions
 	  (IdOrder, idOrdersItem, Notes, IdRoute, RoutesPositionLevel, CycleOfApprovments, ActionsCode)
 VALUES
      (@input_IdOrder, @input_IdOrdersItem, 'Произведено редактирование', @IdCurrentRouteCode, 1, @CurrentCycleOfApprovments, dbo.f_GetIdAlternedActionCode() /*Action 3 = Alterned*/)
 
end
*/

set @ProgramEvent = 35
goto Done

---------- Начало - "Стандартный конец транзакции в конце процедуре" -------------------------------------------
Error:
 Select @outputError = @@ERROR
 ROLLBACK TRANSACTION tr_CreateProcessItemInstance --@tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentItemId

 return (-1)

Done:
 Select @outputError = @@ERROR
 COMMIT TRANSACTION tr_CreateProcessItemInstance  --@tranName
 Exec sp_EventLog_Insert 2 /*Успешное создание экземпляра Этапа Процесса*/, @CurrentStorageProcedureName, @CallerUserName, @strNote, @input_DocumentItemId

 select @input_DocumentItemId
 return (@input_DocumentItemId)







GO
/****** Object:  StoredProcedure [dbo].[sp_EditUser]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_EditUser]
                    @input_LoginName nvarchar (256),
                    @input_ShortName nvarchar (512),
                    @input_FullName nvarchar (512),
                    @input_JobRole smallint,
					@input_Notes nvarchar (1024)

	
                                                                   
                                                                 
 AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_CreateUser'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

--declare @tranName varchar(100)
--select @tranName = dbo.f_GetUniqTransactionName()
--BEGIN TRANSACTION @tranName

declare @input_CreatorLoginName varchar(128)
select @input_CreatorLoginName = suser_name()
declare @uniqValue varchar(36)
select @uniqValue = NEWID()

---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

--------------------- Проверки --------------------------------------------------------------------------
if exists((Select _u.id from sprUsers as _u where _u.ShortName = @input_LoginName))
begin
 select @ProgramError = 123
 select @strNote = 'Пользовательский логин уже существует'
 Goto Error
end                                                 

if not exists((Select _jr.id from sprJobRole as _jr where _jr.id = @input_JobRole))
begin
 select @ProgramError = 121
 select @strNote = 'Недопустимый код должности пользователя'
 Goto Error
end                                                 
---------------------------------------------------------------------------------------------------------

declare @CreatedUserId int
if IsNull(dbo.f_GetUserId_byName(@input_LoginName), 0) = 0
begin
INSERT INTO dbo.sprUser
	  (LoginName, ShortName, FullName, JobRole, Notes, uniqValue)
VALUES
      (@input_LoginName, @input_ShortName, @input_FullName, @input_JobRole, @input_Notes, @uniqValue)
end
else
begin
Update dbo.sprUser Set 
						ShortName = @input_ShortName,
						FullName = @input_FullName,
						JobRole = @input_JobRole,
						Notes = @input_Notes
					Where LoginName = @input_LoginName
end

IF @@ROWCOUNT != 1 or @@ERROR != 0
begin
 set @ProgramError = 190
 set @strNote = ''
 Set @OutputError = @@ERROR
 GOTO Error
end

select  @CreatedUserId = _u.id from sprUsers as _u where _u.uniqValue = @uniqValue
Set @ProgramEvent = 190
Goto Done  

---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Select @outputError = @@ERROR
-- ROLLBACK TRANSACTION @tranName
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @strNote, @input_CreatorLoginName
 SELECT  @outputError
 RETURN (-1)

Done:
 Select @outputError = @@ERROR
-- COMMIT TRANSACTION @tranName
 Exec sp_EventLog_Insert @ProgramEvent, @CurrentStorageProcedureName, @CreatedUserId, @input_CreatorLoginName
 RETURN (@CreatedUserId)







GO
/****** Object:  StoredProcedure [dbo].[sp_ErrorLog_Insert]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE 	[dbo].[sp_ErrorLog_Insert] 	
											@input_ErrorCode int,
											@input_SourceEvent VARCHAR(50),
											@input_ProgramUser varchar(50),
											@input_Note Varchar(1024),
											@input_SourceObject bigint = null

AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @tranName varchar(100)
select @tranName = dbo.f_GetUniqTransactionName()

BEGIN TRANSACTION @tranName
declare @sysUserName varchar(128)
select @sysUserName = suser_name()

declare @EventsDate Datetime
Select @EventsDate = GetDate()

INSERT INTO dbo.EventLog
	  (EventType, EventCode, EventDate, SourceEvent, ProgramUser, sysUser, Notes, SourceObjectId)
VALUES
      (2 /*Error*/, @input_ErrorCode, @EventsDate, @input_SourceEvent, @input_ProgramUser, rtrim(@sysUserName), rtrim(@input_Note), @input_SourceObject)

IF @@ROWCOUNT = 1 AND @@ERROR=0
 GOTO Done

Error:
 ROLLBACK TRANSACTION @tranName
 RETURN (@@ERROR)

Done:
 COMMIT TRANSACTION @tranName
 RETURN (@@ERROR)









GO
/****** Object:  StoredProcedure [dbo].[sp_EventLog_Insert]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE 	[dbo].[sp_EventLog_Insert] 	@input_EventCode int,
											@input_SourceEvent VARCHAR(50),
											@input_ProgramUser varchar(256),
											@input_Note Varchar(1024) = Null,
											@input_SourceObjectId bigint = null

AS
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_EventLog_Insert'
declare @strNote varchar(max)
declare @sysUserName varchar(100)
select @sysUserName = suser_name()
declare @EventDate Datetime
Select @EventDate = GetDate()

INSERT INTO dbo.EventLog
	  (EventType, EventCode, EventDate, SourceEvent, ProgramUser, sysUser, Notes, SourceObjectId)
VALUES
      (1 /*Notification*/, @input_EventCode, @EventDate, @input_SourceEvent, @input_ProgramUser, @sysUserName, @input_Note, @input_SourceObjectId)

/*
if @@ROWCOUNT = 1 and @@ERROR = 0
 goto Done

Error:
 Set @strNote = 'EventsType = ' + rtrim(CONVERT(varchar(max), 1));
 Set @strNote += 'EventsCode = ' + rtrim(CONVERT(varchar(max), @input_EventCode));
 Set @strNote += 'EventsDate = ' + rtrim(CONVERT(varchar(max), @EventDate));
 Set @strNote += 'SourceEvent = ' + rtrim(CONVERT(varchar(max), @input_SourceEvent));
 Set @strNote += 'ProgramUser = ' + rtrim(CONVERT(varchar(max), @input_ProgramUser))
 Set @strNote += 'UserName = ' + rtrim(CONVERT(varchar(max), @sysUserName))
 Set @strNote += '; '
 exec sp_ErrorLog_Insert 110, @CurrentStorageProcedureName, @sysUserName, @strNote, @input_SourceObjectId
 RETURN (@@ERROR)
*/

Done:
 RETURN (@@ERROR)









GO
/****** Object:  StoredProcedure [dbo].[sp_GetAttachment]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE 	[dbo].[sp_GetAttachment] 	
							@input_DocumentItemId bigint,
							@input_AttachmentName varchar (256),
							@input_AttachmentId bigint

											
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


SELECT dia.AttachmentName as AttachmentName, dia.UNCFileName as AttachmentUNCFileName, dia.fileDATA as AttachmentData FROM DocumentItemAttachment AS dia
	Where dia.DocumentItemId = @input_DocumentItemId and
		 IsNull(dia.IsDeleted, 0) =0 and
		 dia.Id = @input_AttachmentId and
		 dia.AttachmentName = @input_AttachmentName




RETURN (@@ERROR)













GO
/****** Object:  StoredProcedure [dbo].[sp_GetAttachmentFilesNameForDocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE 	[dbo].[sp_GetAttachmentFilesNameForDocumentItem] 	
							@input_DocumentItemId bigint
											
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


SELECT dia.AttachmentName as AttachmentName, dia.Id as AttachmentId, 
		dia.IsDeleted /*Это поле для того, чтобы работать в приложении при редактировании вложений - "пометка к удалению" для ListBox*/ FROM DocumentItemAttachment AS dia
	Where dia.DocumentItemId = @input_DocumentItemId and IsNull(dia.IsDeleted, 0) =0
ORDER BY dia.Id


RETURN (@@ERROR)













GO
/****** Object:  StoredProcedure [dbo].[sp_GetComment_Document]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[sp_GetComment_Document]
					@input_DocumentId bigint = NULL
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_GetComment_Document'
select _jr.ShortName as JobRoleName, dbo.f_GetUserFullName_byId(dc.CreatorId), _jr1.ShortName as JobResultName, dc.CycleNumber, dc.CommentText from DocumentComment as dc
		left join ProcessItemInstance as pii on (dc.ProcessItem = pii.id)
		left join sprJobRole as _jr on (pii.JobRole = _jr.id)
		left join sprJobResult as _jr1 on (dc.JobResult = _jr1.id)
		where dc.Document = @input_DocumentId

--Select -1 as CycleOfApprovment
Done:
RETURN (@@ERROR)

END
















GO
/****** Object:  StoredProcedure [dbo].[sp_GetComment_DocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetComment_DocumentItem]
					@input_DocumentItemId bigint = NULL
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_GetComment_DocumentItem'
select _jr.ShortName as JobRoleName, dbo.f_GetUserFullName_byId(dic.CreatorId), _jr1.ShortName as JobResultName, dic.CycleNumber, dic.CommentText from DocumentItemComment as dic
		left join ProcessItemInstance as pii on (dic.ProcessItem = pii.id)
		left join sprJobRole as _jr on (pii.JobRole = _jr.id)
		left join sprJobResult as _jr1 on (dic.JobResult = _jr1.id)
		where dic.DocumentItem = @input_DocumentItemId

--Select -1 as CycleOfApprovment
Done:
RETURN (@@ERROR)

END















GO
/****** Object:  StoredProcedure [dbo].[sp_GetDocument_Input]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetDocument_Input]
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_GetDocumentList_Input'

Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int
declare @input_LoginName varchar(128)
set @input_LoginName = dbo.f_GetUserName_Current()
--set @input_LoginName = 'user3' -- Для отработки

---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

select t1.Document as DocumentId, dl.DocumentNum, dl.ShortName, dl.FullName, dl.CreatorOwner as CreatorOwner, dl.CreationDate, dl.ExecutionDate, dl.Notes, dl.DocumentStatus, _j.ShortName as ProcessJobName, _j.id as ProcessJobCode, t1.DocumentType from f_GetDocumentList_Input() as t1
	left join DocumentList as dl On (dl.id = t1.Document)-- Выберем недостающие поля для Документов
	left join sprJob as _j On (t1.Job = _j.id)	-- Выбираем наименование работ Этапов Процесса
	where IsNull(dl.IsDeleted, 0) = 0
	group by t1.Document, dl.DocumentNum, dl.ShortName, dl.FullName, dl.CreatorOwner, dl.CreationDate, dl.ExecutionDate, dl.Notes, dl.DocumentStatus, _j.ShortName, _j.id, t1.DocumentType


---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Goto Done
Error:
 Select @outputError = @@ERROR
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @input_LoginName, @strNote
 RETURN (-1)

Done:

 RETURN (@@ROWCOUNT)
END






GO
/****** Object:  StoredProcedure [dbo].[sp_GetDocument_Input_byJob]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[sp_GetDocument_Input_byJob]
					@input_TargetJobAsString varchar(256),
					@input_DocumentType int = Null,
					@input_SortingType int = 0
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

declare @CurrentStorageProcedureName varchar(64)
set @CurrentStorageProcedureName = 'sp_GetDocumentList_Input_byJob'
declare  @SQLText  varchar(2048)
declare @strNote varchar(max)
declare  @SQLOrdering varchar(512)

declare @input_LoginName varchar(128)
select @input_LoginName = dbo.f_GetUserName_Current()
--set @input_LoginName = 'user3'  -- Для отработки

SET @SQLText = 'select t1.Document as DocumentId, t1.DocumentType, dl.ShortName, _u.ShortName as CreatorOwner, _u.ShortName + '' ('' + _u.FullName + '')'' as CreatorOwnerFullViewing, dl.CreationDate, dl.ExecutionDate, dl.DocumentNum, dl.Notes, dl.DocumentStatus, _j.ShortName as Job/*, _j.id as ProcessJobCode, _j.ShortName as ProcessJobName*/'
SET @SQLText += ' from f_GetDocumentList_Input() as t1'
SET @SQLText += ' left join DocumentList as dl On (dl.id = t1.Document)'	-- Выберем недостающие поля для Документов
SET @SQLText += ' left join sprJob as _j On (t1.Job = _j.id)'	-- Выбираем наименование работ Этапов Процесса
--SET @SQLText += ' left join TemplateProcess as tp On (tp.id = dbo.f_GetProcessTemplate_Process(t1.Process))'	-- Выбираем Тип Документа (фактически это Код Шаблона Процесса)
SET @SQLText += ' join sprUser as _u On (_u.id = dl.CreatorOwner) '
SET @SQLText += ' where _j.ShortName like ''' + @input_TargetJobAsString + ''''
SET @SQLText += ' and IsNull(dl.IsDeleted, 0) = 0'
SET @SQLText += ' group by t1.Document, t1.DocumentType, dl.ShortName,  _u.ShortName, _u.ShortName + '' ('' + _u.FullName + '')'', dl.CreationDate, dl.ExecutionDate, dl.DocumentNum, dl.Notes, dl.DocumentStatus, _j.ShortName'

SET @SQLOrdering =  ''

IF @input_SortingType = 0
BEGIN
 SET @SQLOrdering =  ' ORDER BY _j.ShortName'
END

IF @input_SortingType = 1
BEGIN
 SET @SQLOrdering =  ' ORDER BY t1.DocumentNum'
END

IF @input_SortingType = 2
BEGIN
 SET @SQLOrdering =  ' ORDER BY t1.CreationDate'
END

IF @input_SortingType = 3
BEGIN
 SET @SQLOrdering =  ' ORDER BY t1.CreatorOwner'
END

SET @SQLText += @SQLOrdering

EXECUTE(@SQLText)
--select @SQLText

Goto Done
---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Exec sp_ErrorLog_Insert 110, @CurrentStorageProcedureName, @input_LoginName, @strNote
 RETURN (-1)

Done:
 RETURN (@@ERROR)
 

END








GO
/****** Object:  StoredProcedure [dbo].[sp_GetDocument_Total]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetDocument_Total]
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

--declare @input_LoginName varchar(128)
--select @input_LoginName = dbo.f_GetUserName_Current()
--set @input_LoginName = 'user3' -- Для отработки

select t1.Id as DocumentId, dl.DocumentNum, dl.ShortName, dl.FullName, dl.CreatorOwner as CreatorOwner, dl.CreationDate, dl.ExecutionDate, dl.Notes, dl.DocumentStatus, _j.ShortName as ProcessJobName, _j.id as ProcessJobCode, pii.JobRole, pi.ProcessTemplate from f_GetDocumentList_Total() as t1
	left join DocumentList as dl On (t1.Id = dl.id)-- Выберем недостающие поля для Документов
	left join ProcessInstance as pi On (dl.Process = pi.id)-- Определяем Процессы для Документов
	left join ProcessItemInstance as pii On (pi.id = pii.Process) and (pii.id in (select di1.ProcessItemId from DocumentItem as di1 where di1.DocumentId = t1.id))
--	left join DocumentItemState as dis on (di.id = dis.DocumentItem) and (pii.id = dis.ProcessItem) and IsNull(dis.JobResult, 0) != dbo.f_GetJobResult_Denied() --and IsNull(dis.JobResult, 0) != 0
	left join TemplateProcess as tp On (pi.ProcessTemplate = tp.id)	-- Выбираем Тип Документа (фактически это Код Шаблона Процесса)
	left join sprJob as _j On (pii.Job = _j.id)	-- Выбираем наименование работ Этапов Процесса
	group by t1.Id, dl.DocumentNum, dl.ShortName, dl.FullName, dl.CreatorOwner, dl.CreationDate, dl.ExecutionDate, dl.Notes, dl.DocumentStatus, _j.ShortName, pii.JobRole, _j.id, pi.ProcessTemplate


Done:
RETURN (@@ERROR)


Error:
RETURN (-1)

END







GO
/****** Object:  StoredProcedure [dbo].[sp_GetDocument_Total_byJob]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sp_GetDocument_Total_byJob]
					@input_TargetJobAsString varchar(256),
					@input_DocumentType int = Null,
					@input_SortingType int = 0
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

declare @CurrentStorageProcedureName varchar(64)
set @CurrentStorageProcedureName = 'sp_GetDocumentList_Total_byJob'
declare  @SQLText  varchar(2048)
declare @strNote varchar(max)
declare  @SQLOrdering varchar(512)

declare @input_LoginName varchar(128)
select @input_LoginName = dbo.f_GetUserName_Current()
--set @input_LoginName = 'user3'  -- Для отработки

if IsNull(@input_LoginName, '') = ''
begin
 goto Error
end

Declare @CallerUserId bigint
-- Определяем id Пользователя, который вызвал эту процедуру
Select @CallerUserId = dbo.f_GetUserId_byName(@input_LoginName)

CREATE TABLE #Table1 (DocumentId bigint, DocumentNum int, ShortName Varchar(256), FullName Varchar(1024), CreatorOwner smallint, CreationDate datetime, ExecutionDate datetime, Notes Varchar(1024), DocumentStatus smallint, ProcessJobName varchar(256), ProcessJobCode smallint, JobRole smallint, ProcessTemplate int)
Insert Into #Table1 exec dbo.sp_GetDocument_Total

SET @SQLText = 'select distinct DocumentId, ProcessTemplate as DocumentType, t1.ShortName, _u.ShortName as CreatorOwner, _u.ShortName + '' ('' + _u.FullName + '')'' as CreatorOwnerFullViewing, CreationDate, ExecutionDate, DocumentNum, t1.Notes, DocumentStatus, ProcessJobName'
SET @SQLText += ' from #Table1 as t1'
SET @SQLText += ' join sprUser as _u On (_u.id = t1.CreatorOwner) '
SET @SQLText += ' where t1.ProcessJobName like ''' + @input_TargetJobAsString + ''''
SET @SQLText += ' group by DocumentId, t1.ProcessTemplate, t1.ShortName, _u.ShortName, _u.ShortName + '' ('' + _u.FullName + '')'', t1.CreationDate, t1.ExecutionDate, t1.DocumentNum, t1.Notes, t1.DocumentStatus, t1.ProcessJobName'

/*
SET @SQLText = 'select t1.id as DocumentId, pi.ProcessTemplate as DocumentType, dl.ShortName, _u.ShortName as CreatorOwner, _u.ShortName + '' ('' + _u.FullName + '')'' as CreatorOwnerFullViewing, dl.CreationDate, dl.ExecutionDate, dl.DocumentNum, dl.Notes, dl.DocumentStatus, _j.ShortName /*, _j.id as ProcessJobCode, _j.ShortName as ProcessJobName*/'
SET @SQLText += ' from f_GetDocumentList_Total() as t1'
SET @SQLText += ' left join DocumentList as dl On (t1.id = dl.id)'	-- Выберем недостающие поля для Документов
SET @SQLText += ' left join ProcessInstance as pi On (dl.Process = pi.id)'-- Определяем Процессы для Документов
SET @SQLText += ' left join ProcessItemInstance as pii On (pi.id = pii.Process)'
SET @SQLText += ' left join sprJob as _j On (pii.Job = _j.id)'	-- Выбираем наименование работ Этапов Процесса
--SET @SQLText += ' left join TemplateProcess as tp On (tp.id = dbo.f_GetProcessTemplate_Process(t1.Process))'	-- Выбираем Тип Документа (фактически это Код Шаблона Процесса)
SET @SQLText += ' join sprUser as _u On (dl.CreatorOwner = _u.id) '
SET @SQLText += ' where _j.ShortName like ''' + @input_TargetJobAsString + ''''
SET @SQLText += ' and IsNull(dl.IsDeleted, 0) = 0'
SET @SQLText += ' group by t1.id, pi.ProcessTemplate, dl.ShortName, _u.ShortName, _u.ShortName + '' ('' + _u.FullName + '')'', dl.CreationDate, dl.ExecutionDate, dl.DocumentNum, dl.Notes, dl.DocumentStatus, _j.ShortName'
*/

SET @SQLOrdering =  ''

IF @input_SortingType = 0
BEGIN
 SET @SQLOrdering =  ' ORDER BY t1.ProcessJobName'
END

IF @input_SortingType = 1
BEGIN
 SET @SQLOrdering =  ' ORDER BY t1.DocumentNum'
END

IF @input_SortingType = 2
BEGIN
 SET @SQLOrdering =  ' ORDER BY t1.CreationDate'
END

IF @input_SortingType = 3
BEGIN
 SET @SQLOrdering =  ' ORDER BY t1.CreatorOwner'
END

SET @SQLText += @SQLOrdering

EXECUTE(@SQLText)
--select @SQLText

Goto Done
---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Exec sp_ErrorLog_Insert 110, @CurrentStorageProcedureName, @input_LoginName, @strNote
 RETURN (-1)

Done:
 RETURN (@@ERROR)
 

END







GO
/****** Object:  StoredProcedure [dbo].[sp_GetDocumentItem_First]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sp_GetDocumentItem_First]
								@input_DocumentId bigint
AS
BEGIN
set NOCOUNT ON;
set TRANSACTION ISOLATION LEVEL READ COMMITTED

select dbo.f_GetDocumentItemId_First(@input_DocumentId) as result
return (dbo.f_GetDocumentItemId_First(@input_DocumentId))
END











GO
/****** Object:  StoredProcedure [dbo].[sp_GetDocumentItem_MTR]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetDocumentItem_MTR]
								@input_DocumentId bigint,
								@input_IsInputViewing bit = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SET TRANSACTION ISOLATION LEVEL READ COMMITTED

select di.id as DocumentItemId, di.ShortName, di.FullName, LoginName, CreatorOwnerName, di_mtr.ObjectGroup, _og.ShortName as ObjectGroupName, 
		di_mtr.MeasurementUnit, _mu.ShortName as MeasurmentUnitName, di_mtr.Volume, di.Notes, AttachmentName = '' /*Для Grid надо, чтобы значки вложения рисовать*/,
		AttachmentId as AttachmentId, (case when @input_IsInputViewing = 1 then dbo.f_GetDocumentItemState_byUser(di.id) else dbo.f_GetDocumentItemState_byUser(di.id) end) as DocumentItemState_Current, dbo.f_CanChangeDocumentItemState(di.id) as CanChangeDocumentItemState from dbo.f_GetDocumentItem_byDocument_withAttachment(@input_DocumentId) as di 
		left join DocumentItem_MTR as di_mtr On (di.id = di_mtr.DocumentItemId)
        left join sprObjectMTRGroup as _og On (di_mtr.ObjectGroup = _og.id)
		left join sprMeasurementUnit as _mu On (di_mtr.MeasurementUnit = _mu.id)
		--left join (select * from dbo.f_GetDocumentItem_State(@input_DocumentId)) as dis1 on (di.id = dis1.DocumentItem) 


where di.DocumentId = @input_DocumentId



RETURN (@@ERROR)
END









GO
/****** Object:  StoredProcedure [dbo].[sp_GetDocumentItemInfo_MTR]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[sp_GetDocumentItemInfo_MTR]
								@input_DocumentItemId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SET TRANSACTION ISOLATION LEVEL READ COMMITTED

select di.id as DocumentItemId, di.DocumentId, pii.ItemLevel as ProcessItemLevel, di.ShortName, di.FullName, _u.ShortName as CreatorOwnerName, di_mtr.ObjectGroup, _og.ShortName as ObjectGroupName, 
		di_mtr.MeasurementUnit, _mu.ShortName as MeasurmentUnitName, di_mtr.Volume, di.Notes, di.CreatorOwner, di.sys_creationdate as CreationDate, pii.Process as ProcessId, pii.id as ProcessItemId from DocumentItem as di 
		left join ProcessItemInstance as pii On (di.ProcessItemId = pii.id)
		left join DocumentItem_MTR as di_mtr On (di.id = di_mtr.DocumentItemId)
		left join sprUser as _u On (di.CreatorOwner = _u.id)
        left join sprObjectMTRGroup as _og On (di_mtr.ObjectGroup = _og.id)
		left join sprMeasurementUnit as _mu On (di_mtr.MeasurementUnit = _mu.id)

where di.Id = @input_DocumentItemId
/*
SELECT oi.id as idOrderItem, idOrder as IdOrder, AttachmentName = '' /*Для Grid надо, чтобы значки вложения рисовать*/, _og.ShortName as ObjectGroupName, oi.ShortName, oi.FullName, _mu.ShortName as MeasurmentUnitName, oi.Volume,
       oi.ExpirationDate, oi.sys_creationdate as CreationDate,
       _u.ShortName as CreatorOwnerName, _u.ShortName + ' (' + _u.FullName + ')' as CreatorOwnerFullViewing,
       oi.Notes, oi.ActionsCode as ActionsCode, oi.ProcessStatus, IsNull(oia1.IdOrderItem, 0) as IdAttachment
FROM OrdersItems AS oi Left Join sprUsers As _u On (oi.CreatorOwner = _u.id)
					   Left Join sprObjectMTRGroups as _og On (oi.ObjectsGroup = _og.id)
					   Left Join sprMeasurementUnits as _mu On (oi.MeasurementUnit = _mu.id)
					   Left Join (Select oia.IdOrderItem From OrdersItemAttachments as oia Where oia.IdOrderItem in (Select oi1.id From OrdersItems as oi1 Where oi1.idOrder = @input_IdOrder) Group By oia.IdOrderItem) AS oia1 On (oi.id = oia1.IdOrderItem)
WHERE oi.idOrder = @input_IdOrder and IsNull(oi.IsDeleted, 0) =0
ORDER BY oi.ObjectsGroup, oi.sys_creationdate
*/


RETURN (@@ERROR)
END










GO
/****** Object:  StoredProcedure [dbo].[sp_GetEditStatus_Document]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE procedure [dbo].[sp_GetEditStatus_Document]
								@input_DocumentId bigint
AS
BEGIN

declare @bResult bit
if dbo.f_CanChangeDocument_User(@input_DocumentId, dbo.f_GetUserId_byName(dbo.f_GetUserName_Current())) = 1
 Set @bResult = 1
else
 Set @bResult = 0

Select @bResult as Result

Done:
RETURN @bResult
END










GO
/****** Object:  StoredProcedure [dbo].[sp_GetEditStatus_DocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE procedure [dbo].[sp_GetEditStatus_DocumentItem]
								@input_DocumentItemId bigint
AS
BEGIN

declare @bResult bit
if dbo.f_CanChangeDocumentItem_User(@input_DocumentItemId, dbo.f_GetUserId_byName(dbo.f_GetUserName_Current())) = 1
 Set @bResult = 1
else
 Set @bResult = 0

Select @bResult as Result

Done:
RETURN @bResult
END









GO
/****** Object:  StoredProcedure [dbo].[sp_GetErrorLog_ByDate_All]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetErrorLog_ByDate_All]
									@input_ErrorBeginDate DateTime = Null,
									@input_ErrorEndDate DateTime = Null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

declare @CurrentTimeStamp DateTime
set @CurrentTimeStamp = GetDate()

if IsNull(@input_ErrorBeginDate, @CurrentTimeStamp) = @CurrentTimeStamp
begin
 select @input_ErrorBeginDate = min(el.EventDate) from EventLog AS el
end

if IsNull(@input_ErrorEndDate, @CurrentTimeStamp) = @CurrentTimeStamp
begin
 select @input_ErrorEndDate = max(el.EventDate) from EventLog AS el
end

SELECT el.EventDate as EventDate, el.EventCode as EventCode, _ec.EventText as EventText, el.SourceEvent as EventSource, el.Notes as Notes, el.ProgramUser as ProgramUser, el.sysUser
 FROM EventLog AS el 
 left join sprEventCode AS _ec ON (el.EventCode = _ec.EventCode)
 Where (el.EventDate between @input_ErrorBeginDate and @input_ErrorEndDate) and el.EventType = 2
 Order by el.EventDate
RETURN (@@ERROR)
END










GO
/****** Object:  StoredProcedure [dbo].[sp_GetEventLog_ByDate_All]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetEventLog_ByDate_All]
									@input_EventBeginDate DateTime = Null,
									@input_EventEndDate DateTime = Null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
Declare @DateLikeNullDate date
Select @DateLikeNullDate = '01.01.2000'
if IsNull(@input_EventBeginDate, @DateLikeNullDate) = @DateLikeNullDate
begin
 select @input_EventBeginDate = (Select MIN(al.EventDate) From EventLog as al)
end

if IsNull(@input_EventEndDate, @DateLikeNullDate) = @DateLikeNullDate
begin
 select @input_EventEndDate = GETDATE()
end

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SELECT el.EventDate as EventDate, el.EventCode as EventCode, _ec.EventText as EventText, el.SourceEvent as EventSource, el.Notes as Notes, el.ProgramUser as ProgramUser
 FROM EventLog AS el LEFT JOIN sprEventCode AS _ec ON (_ec.EventCode = el.EventCode)
 Where el.EventDate between @input_EventBeginDate and @input_EventEndDate and el.EventType = 1 /*Events*/
 Order by el.EventDate
RETURN (@@ERROR)
END











GO
/****** Object:  StoredProcedure [dbo].[sp_GetJobCode_byName]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[sp_GetJobCode_byName]
					@input_ProcessInstance bigint,
					@input_JobName varchar(128)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

Select _j.id as JobCode From sprJob as _j
	left join ProcessItemInstance as pii On (pii.Process = @input_ProcessInstance)
	Where /*(IsNull(_j.IsDeleted, 0) =0) and*/ (pii.Job = _j.id) and (_j.ShortName like @input_JobName)

Done:
RETURN (@@ERROR)
END













GO
/****** Object:  StoredProcedure [dbo].[sp_GetJobExistsStatus_Document]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE procedure [dbo].[sp_GetJobExistsStatus_Document]
								@input_DocumentId bigint
AS
BEGIN

declare @bResult bit
if dbo.f_IsJobExists_Document(@input_DocumentId) = 1
 Set @bResult = 1
else
 Set @bResult = 0

Select @bResult as Result

Done:
RETURN 0
END








GO
/****** Object:  StoredProcedure [dbo].[sp_GetJobExistsStatus_DocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE procedure [dbo].[sp_GetJobExistsStatus_DocumentItem]
								@input_DocumentItemId bigint = NULL
AS
BEGIN

declare @bResult bit
if dbo.f_IsJobExists_DocumentItem(@input_DocumentItemId) = 1
 Set @bResult = 1
else
 Set @bResult = 0

Select @bResult as Result

Done:
RETURN 0
END







GO
/****** Object:  StoredProcedure [dbo].[sp_GetJobItemExtendExistsStatus_DocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE procedure [dbo].[sp_GetJobItemExtendExistsStatus_DocumentItem]
								@input_DocumentItemId bigint
AS
BEGIN

declare @bResult bit

if dbo.f_IsJobItemExtendExists_DocumentItem(@input_DocumentItemId) = 1 and dbo.f_CanChangeDocumentItemState(@input_DocumentItemId) > 0
 Set @bResult = 1
else
 Set @bResult = 0

Select @bResult as Result

Done:
RETURN 0
END








GO
/****** Object:  StoredProcedure [dbo].[sp_GetJobItemParameter]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sp_GetJobItemParameter]
					@input_JobItemId	bigint
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_GetJobItemParameter'

Declare @TargetProcessId int
Declare @TargetProcessItemId int

Select jii.id as JobItemId From JobItemInstance as jii
							left join TemplateJobItem as tji On (jii.JobItemTemplate = tji.id and IsNull(tji.IsDeleted, 0) = 0)

			Where IsNull(jii.IsDeleted, 0) = 0 and jii.ProcessItem = @input_JobItemId


return (@@ERROR)

END
















GO
/****** Object:  StoredProcedure [dbo].[sp_GetJobNameProcessItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetJobNameProcessItem]
					@input_DocumentId bigint
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

select _j.id, _j.ShortName as ProcessJobName, _jr.ShortName as JobRoleName, pii.ItemLevel as ProcessItemLevel From sprJob as _j
	join ProcessItemInstance as pii On (_j.id = pii.Job)-- Выбираем Этап Процесса
	join ProcessInstance as pi On (pii.Process = pi.id)-- Определяем Процесс для Документа
	join sprJobRole as _jr On (_jr.id = pii.JobRole)-- Выбираем Роли Этапов Процесса
	Where pi.DocumentId = @input_DocumentId and IsNull(pi.IsDeleted, 0) =0 and IsNull(pii.IsDeleted, 0) = 0
	group by _j.id, _j.ShortName, _jr.ShortName, pii.ItemLevel
	order by pii.ItemLevel


RETURN

END













GO
/****** Object:  StoredProcedure [dbo].[sp_GetJobNameProcessItem_DocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[sp_GetJobNameProcessItem_DocumentItem]
					@input_DocumentItemId bigint
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

select _j.id, _j.ShortName as ProcessJobName, _jr.ShortName as JobRoleName, pii.ItemLevel as ProcessItemLevel, dis.JobRole as JobRole, IsNull(dis.JobResult, 0 /*Null может быть только у "не инициализированного" ЭП)*/) as StateCurrent, dis.StateId as StateId From sprJob as _j
	left join ProcessItemInstance as pii On (_j.id = pii.Job)-- Выбираем Этапы Процесса
	left join ProcessInstance as pi On (pii.Process = pi.id)-- Определяем Процесс для Документа
	left join sprJobRole as _jr On (_jr.id = pii.JobRole)-- Выбираем Роли Этапов Процесса
	left join dbo.f_GetDocumentItem_State(@input_DocumentItemId) as dis On (dis.ProcessItem = pii.id) --and (dis.StateId = dbo.f_GetDocumentItemState_Last_byProcessItem(@input_DocumentItemId, pii.id)) -- Выбираем Роли Этапов Процесса
	Where pi.DocumentId = dbo.f_GetDocument_DocumentItem(@input_DocumentItemId) and IsNull(pi.IsDeleted, 0) = 0 and IsNull(pii.IsDeleted, 0) = 0 --and dis.ProcessItem = pii.id
	group by _j.id, _j.ShortName, _jr.ShortName, pii.ItemLevel, dis.JobRole, dis.JobResult, dis.StateId
	order by pii.ItemLevel


RETURN

END














GO
/****** Object:  StoredProcedure [dbo].[sp_GetJobProcessItem_MTR]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[sp_GetJobProcessItem_MTR]
					@input_DocumentItemId	bigint
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_GetJobProcessItem_MTR'

Declare @TargetProcessItemId int
Declare @TargetProcessItem_ItemLevel int

-- Получим Id текущего Этапа Процесса для требуемого ЭД (@input_DocumentItemId)
 Select @TargetProcessItemId = dbo.f_GetProcessItemCurrent_DocumentItem(@input_DocumentItemId)

-- Получим № текущего Этапа Процесса для требуемого ЭД (@input_DocumentItemId)
 Select @TargetProcessItem_ItemLevel = dbo.f_GetProcessItemLevel_byId(@TargetProcessItemId)

-- Получим наименование Работы для Этапа Процесса
 Select 0 as JobType, _j.ShortName as ProcessJobName, _j.FullName as JobTarget, Null as JobItemId, Null as IsActive, Null as IsEDD, Null as IsEntireDocument, Null as Notes, Null as NotesItem From ProcessItemInstance as pii
							left join sprJob as _j On (pii.Job = _j.id)
			Where IsNull(pii.IsDeleted, 0) = 0 and pii.id = @TargetProcessItemId and pii.ItemLevel = @TargetProcessItem_ItemLevel

 union all
-- Получим Элементы Работы для Документа вцелом,
-- на данный момент видится только работа типа: "Приостановить работу над Документом", "Полностью закрыть Документ для отработки".
-- Получить наименование Элементов Работы для Этапа Процесса
 Select (Case When IsNull(jii.IsEntireDocument, 0) = 0 Then 1 Else 0 End) as JobType,
		 _ji.ShortName as ProcessJobName, _ji.FullName as JobTarget, jii.id as JobItemId, IsNull(jii.IsActive, 0) as IsEDD, IsNull(jii.IsEDD, 0) as IsEDD, IsNull(jii.IsEntireDocument, 0) as IsEntireDocument, _ji.Notes as Notes1, tji.Notes as NotesItem From JobItemInstance as jii
							left join TemplateJobItem as tji On (jii.JobItemTemplate = tji.id and IsNull(tji.IsDeleted, 0) = 0)
							left join sprJobItem as _ji On (tji.JobItem = _ji.id) -- Выбираем Наименования Элементов Работы

			Where IsNull(jii.IsDeleted, 0) = 0 and jii.ProcessItem = @TargetProcessItemId
 order by JobType, IsEntireDocument


RETURN (@@ERROR)

END















GO
/****** Object:  StoredProcedure [dbo].[sp_GetJobRole]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[sp_GetJobRole]
					@input_UserId int = Null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

if IsNull(@input_UserId, 0) = 0
begin
 select _jr.id, _jr.Code, _jr.ShortName, _jr.FullName, _jr.Notes from sprJobRole as _jr
				Where (IsNull(_jr.IsDeleted, 0) =0) and (_jr.ShortName is not Null)
 order by _jr.id
 Goto Done
end

declare @SourceJobRole int
select @SourceJobRole = _u.JobRole from sprUser as _u where _u.id = @input_UserId

select _jr.id, _jr.Code, _jr.ShortName, _jr.FullName, _jr.Notes from sprJobRole as _jr
	Where (IsNull(_jr.IsDeleted, 0) = 0) and (_jr.ShortName is not Null) and (_jr.id = @SourceJobRole)
union all
select _jr1.id, _jr1.Code, _jr1.ShortName, _jr1.FullName, _jr1.Notes from sprJobRole as _jr1
	Where (IsNull(_jr1.IsDeleted, 0) =0) and (_jr1.ShortName is not Null) 
	and (_jr1.id in (select jra.JobRoleAlias from JobRole_Alias as jra where jra.JobRole = @SourceJobRole))


Done:
RETURN (@@ERROR)
END











GO
/****** Object:  StoredProcedure [dbo].[sp_GetJobRoleAlias_byUser]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sp_GetJobRoleAlias_byUser]
					@input_UserLoginName varchar(128)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

select jra.JobRole from dbo.f_GetJobRoleAlias_forUser(@input_UserLoginName) as jra

Done:
RETURN (@@ERROR)
END












GO
/****** Object:  StoredProcedure [dbo].[sp_GetJobRoleVirtual_byUser]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sp_GetJobRoleVirtual_byUser]
					@input_UserId int = Null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

if IsNull(@input_UserId, 0) = 0
begin
 select _jr.id, _jr.Code, _jr.ShortName, _jr.FullName, _jr.Notes from sprJobRole as _jr
				Where (IsNull(_jr.IsDeleted, 0) =0) and (_jr.ShortName is not Null)
 order by _jr.id
 Goto Done
end

declare @SourceJobRole int
select @SourceJobRole = _u.JobRole from sprUser as _u where _u.id = @input_UserId

select _jr.id, _jr.Code, _jr.ShortName, _jr.FullName, _jr.Notes from sprJobRole as _jr
	Where (IsNull(_jr.IsDeleted, 0) = 0) and (_jr.ShortName is not Null) and (_jr.id = @SourceJobRole)
union all
select _jr1.id, _jr1.Code, _jr1.ShortName, _jr1.FullName, _jr1.Notes from sprJobRole as _jr1
	Where (IsNull(_jr1.IsDeleted, 0) =0) and (_jr1.ShortName is not Null) 
	and (_jr1.id in (select jra.JobRoleAlias from JobRole_Alias as jra where jra.JobRole = @SourceJobRole))


Done:
RETURN (@@ERROR)
END












GO
/****** Object:  StoredProcedure [dbo].[sp_GetObjectInfo_Manufacturing]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetObjectInfo_Manufacturing]
								@input_IdOrderItem bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SET TRANSACTION ISOLATION LEVEL READ COMMITTED


SELECT oiom.id as idOrderItem, oiom.idOrder as IdOrder, AttachmentName = '' /*Для Grid надо, чтобы значки вложения рисовать*/, Null as ObjectGroupName /*Для унификации запроса*/,
	   oiom.ShortName, oiom.FullName, _mu.ShortName as MeasurmentUnitName, oiom.Volume,
	   oiom.IdParent,
       oiom.sys_creationdate as CreationDate,
       _u.ShortName as CreatorOwnerName,
	   _u.ShortName + ' (' + _u.FullName + ')' as CreatorOwnerFullViewing,
       oiom.Notes,
	   oiom.ActionsCode as ActionsCode
	  -- , IsNull(oia1.IdOrderItem, 0) as IdAttachment
FROM OrdersItems_ObjectManufacturing AS oiom Left Join sprUsers As _u On (oiom.CreatorOwner = _u.id) -- and IsNull(oiom.IdParent, 0) = 0)
					   Left Join sprMeasurementUnits as _mu On (oiom.MeasurementUnit = _mu.id)
					   --Left Join (Select oia.IdOrderItem From OrdersItemAttachments as oia Where oia.IdOrderItem in (Select oi1.id From OrdersItems as oi1 Where oi1.idOrder = @input_IdOrder) Group By oia.IdOrderItem) AS oia1 On (oiom.id = oia1.IdOrderItem)
WHERE oiom.id = @input_IdOrderItem and IsNull(oiom.IsDeleted, 0) = 0
ORDER BY oiom.sys_creationdate


 
RETURN (@@ERROR)
END












GO
/****** Object:  StoredProcedure [dbo].[sp_GetObjectItems_Manufacturing]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetObjectItems_Manufacturing]
								@input_IdObject bigint
								--@input_ObjectName varchar(1024)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SET TRANSACTION ISOLATION LEVEL READ COMMITTED

-- Рекурсия через динамическое представление
if exists (select * from dbo.sysobjects where id = object_id(N'#DepNestLevel') and OBJECTPROPERTY(id, N'IsTmpTable') = 1)
begin
 Drop Table [#DepNestLevel]
end
CREATE TABLE #DepNestLevel ([ID] int, [ShortName] varchar(1024), [IDParent] int, NestingLevel int)

/*
Declare @TargetIdObject bigint
Select @TargetIdObject = oiom.id From OrdersItems_ObjectManufacturing as oiom Where lower(oiom.ShortName) = lower(@input_ObjectName)
*/

if IsNull(@input_IdObject, 0) != 0
begin
Insert Into #DepNestLevel
	SELECT oiom.[ID], oiom.[ShortName], oiom.[IDParent], 1 FROM OrdersItems_ObjectManufacturing AS oiom 
														WHERE oiom.ID = @input_IdObject
end
 
Begin
WITH cteDCENestingLevel ([ID], [ShortName], [IDParent], NestingLevel) AS
(
	SELECT oiom.[ID], oiom.[ShortName], oiom.[IDParent], 2 FROM OrdersItems_ObjectManufacturing AS oiom
														WHERE IsNull(IDParent, 0) = @input_IdObject
	UNION ALL
	SELECT oiom.[ID], oiom.[ShortName], oiom.[IDParent], (NestingLevel + 2) FROM OrdersItems_ObjectManufacturing AS oiom
		INNER JOIN cteDCENestingLevel ON (cteDCENestingLevel.[ID] = oiom.[IDParent] )
)
Insert Into #DepNestLevel
	SELECT * FROM cteDCENestingLevel order by NestingLevel
End

SELECT dnl.*, _om.FullName, _om.ItemType, _om.MeasurementUnit, _om.Volume, _om.Notes FROM #DepNestLevel as dnl
		 Left Join OrdersItems_ObjectManufacturing as _om On (dnl.ID = _om.id)
		 Where IsNull(_om.IdParent, 0) != 0
		 Order by dnl.ID, dnl.IDParent
End






GO
/****** Object:  StoredProcedure [dbo].[sp_GetProcessItemMinimal_Document]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE procedure [dbo].[sp_GetProcessItemMinimal_Document]
								@input_DocumentId bigint
AS
BEGIN

declare @bResult bigint
set @bResult = dbo.f_GetProcessItemLevel_byId(dbo.f_GetProcessItemMinimal_Document(@input_DocumentId))

Select @bResult as Result

Done:
RETURN @bResult
END









GO
/****** Object:  StoredProcedure [dbo].[sp_GetProcessJob_Input]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetProcessJob_Input]
					@input_DocumentType int = Null
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_GetProcessJob_Input'

declare @inputLoginName varchar(128)
select @inputLoginName = dbo.f_GetUserName_Current() --set @inputLoginName = 'user3'  -- Для отработки

declare @strNote varchar(max)

Declare @CallerUserId bigint
-- Определяем id Пользователя, который вызвал эту процедуру
Select @CallerUserId = dbo.f_GetUserId_byName(@inputLoginName)

if IsNull(@input_DocumentType, 0) = 0
 Select 'Входящие документы' as ProcessJobName, Null  as ProcessJobCode
 union
 select distinct _j.ShortName as ProcessJobName, _j.id as ProcessJobCode from f_GetDocumentList_Input() as t1
	left join sprJob as _j On (t1.Job = _j.id)	-- Выбираем наименование работ Этапов Процесса
	group by _j.ShortName, _j.id
	order by ProcessJobCode
else
 Select 'Входящие документы' as ProcessJobName, Null  as ProcessJobCode, Null as DocumentType
 union
 select distinct _j.ShortName as ProcessJobName, _j.id as ProcessJobCode, t1.DocumentType from f_GetDocumentList_Input() as t1
	left join sprJob as _j On (t1.Job = _j.id)	-- Выбираем наименование работ Этапов Процесса
	 	Where (t1.DocumentType = @input_DocumentType or ISNULL(t1.DocumentType, 0) = 0)
		group by _j.ShortName, _j.Id, t1.DocumentType
        order by ProcessJobCode

Goto Done
---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Exec sp_ErrorLog_Insert 110, @CurrentStorageProcedureName, @inputLoginName, @strNote, @input_DocumentType
 RETURN (-1)

Done:
 RETURN (@@ERROR)
 

END





GO
/****** Object:  StoredProcedure [dbo].[sp_GetProcessJob_Total]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[sp_GetProcessJob_Total]
					@input_DocumentType int = Null
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_GetProcessJob_Total'

declare @inputLoginName varchar(128)
select @inputLoginName = dbo.f_GetUserName_Current()

--set @inputLoginName = 'user3'  -- Для отработки

declare @strNote varchar(max)
Declare @CallerUserId bigint

-- Вариант для случая, когда пользователь видит Документ в группе "Все документы" сразу после создания Документа, а не после того, как до него доходит очередь отработки.
-- Документ видится только, если данный пользователь должен отрабатывать данный Документ.

if IsNull(@input_DocumentType, 0) = 0
 Select 'Все документы' as ProcessJobName, 0  as ProcessJobCode, Null as ItemLevel
 union
  select _j.ShortName as ProcessJobName, _j.id as ProcessJobCode, pii.ItemLevel as ItemLevel from f_GetDocumentList_Total() as t1
	left join DocumentList as dl On (t1.Id = dl.id)-- Определяем дополнительные данные для Документов
	left join DocumentItem as di On (di.DocumentId = t1.id)-- Определяем дополнительные данные для Документов
	left join ProcessInstance as pi On (pi.id = dl.Process)-- Определяем Процессы для Документов
	left join ProcessItemInstance as pii On (pi.id = pii.Process)  and pii.id = dbo.f_GetProcessItemCurrent_DocumentItem(di.Id) -- Выбираем текущие Этапы Процессов
	left join sprJob as _j On (pii.Job = _j.id)	-- Выбираем наименование работ Этапов Процесса
	where IsNull(_j.id, 0) != 0
	group by _j.ShortName, _j.id , pii.ItemLevel
	order by ItemLevel
else
 Select 'Все документы' as ProcessJobName, 0  as ProcessJobCode, Null as DocumentType, Null as ItemLevel
 union
 select _j.ShortName as ProcessJobName, _j.id as ProcessJobCode, pi.ProcessTemplate as DocumentType, pii.ItemLevel as ItemLevel from f_GetDocumentList_Total() as t1
	left join DocumentList as dl On (t1.Id = dl.id)-- Определяем дополнительные данные для Документов
	left join DocumentItem as di On (di.DocumentId = dl.id)-- Определяем дополнительные данные для Документов
	left join ProcessInstance as pi On (dl.Process = pi.id)-- Определяем Процессы для Документов
	left join ProcessItemInstance as pii On (pi.id = pii.Process) and pii.id = di.ProcessItemId -- Выбираем текущие Этапы Процессов
	left join TemplateProcess as tp On (pi.ProcessTemplate = tp.id)	-- Выбираем Тип Документа (фактически это Код Шаблона Процесса)
	left join sprJob as _j On (pii.Job = _j.id)	-- Выбираем наименование работ Этапов Процесса
	 	Where (pi.ProcessTemplate = @input_DocumentType or ISNULL(pi.ProcessTemplate, 0) = 0) and IsNull(_j.id, 0) != 0
		group by _j.ShortName, _j.Id, pi.ProcessTemplate, pii.ItemLevel
        order by ItemLevel


/*
-- Вариант для случая, когда пользователь видит документ во группе "Все документы" только после того, как до него доходит очередь отработки,
-- т.е. до момента, когда документ появится в папке "Входящие"
if IsNull(@input_DocumentType, 0) = 0
 Select 'Все документы' as ProcessJobName, Null  as ProcessJobCode, Null as ItemLevel
 union
 select _j.ShortName as ProcessJobName, _j.id as ProcessJobCode, pii.ItemLevel as ItemLevel from f_GetDocumentList_Total() as t1
	left join DocumentList as dl On (t1.Id = dl.id)-- Определяем дополнительные данные для Документов
	left join ProcessInstance as pi On (dl.Process = pi.id)-- Определяем Процессы для Документов
	left join (select piuv.id, piuv.Process from dbo.f_GetProcessItem_UserVisibled() as piuv) as pii1 On (pi.id = pii1.Process)-- and pii.ItemLevel = 1 -- Выбираем Этапы Процессов
	left join ProcessItemInstance as pii On (pii1.id = pii.id) and pii.ItemLevel in (select dbo.f_GetProcessItemLevel_byId(di.ProcessItemId) from DocumentItem as di where di.DocumentId = t1.id) -- Выбираем Этапы Процессов, только те, на которых в данный момент находятся Элементы Документов
	left join sprJob as _j On (pii.Job = _j.id)	-- Выбираем наименование работ Этапов Процесса
	where IsNull(_j.id, 0) != 0
	group by _j.ShortName, _j.id, pii.ItemLevel
	order by ItemLevel
else
 Select 'Все документы' as ProcessJobName, Null  as ProcessJobCode, Null as DocumentType, Null as ItemLevel
 union
 select _j.ShortName as ProcessJobName, _j.id as ProcessJobCode, pi.ProcessTemplate as DocumentType, pii.ItemLevel as ItemLevel from f_GetDocumentList_Total() as t1
	left join DocumentList as dl On (t1.Id = dl.id)-- Определяем дополнительные данные для Документов
	left join ProcessInstance as pi On (dl.Process = pi.id)-- Определяем Процессы для Документов
	left join (select piuv.id, piuv.Process from dbo.f_GetProcessItem_UserVisibled() as piuv) as pii1 On (pi.id = pii1.Process)-- and pii.ItemLevel = 1 -- Выбираем Этапы Процессов
	left join ProcessItemInstance as pii On (pii1.id = pii.id) and pii.ItemLevel in (select dbo.f_GetProcessItemLevel_byId(di.ProcessItemId) from DocumentItem as di where di.DocumentId = t1.id) -- Выбираем Этапы Процессов, только те, на которых в данный момент находятся Элементы Документов
	left join TemplateProcess as tp On (pi.ProcessTemplate = tp.id)	-- Выбираем Тип Документа (фактически это Код Шаблона Процесса)
	left join sprJob as _j On (pii.Job = _j.id)	-- Выбираем наименование работ Этапов Процесса
	 	Where (pi.ProcessTemplate = @input_DocumentType or ISNULL(pi.ProcessTemplate, 0) = 0) and IsNull(_j.id, 0) != 0
		group by _j.ShortName, _j.Id, pi.ProcessTemplate, pii.ItemLevel
        order by ItemLevel
*/
Goto Done
---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Exec sp_ErrorLog_Insert 110, @CurrentStorageProcedureName, @inputLoginName, @strNote, @input_DocumentType
 RETURN (-1)

Done:
 RETURN (@@ERROR)
 

END






GO
/****** Object:  StoredProcedure [dbo].[sp_GetSpravData_byId]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[sp_GetSpravData_byId]
					@input_SpravName varchar(256),
					@input_Id int
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_GetSpravData_byId'

declare @input_LoginName varchar(128)
select @input_LoginName = suser_name()
declare  @SQLText  varchar(2048)
declare @strNote varchar(max)

SET @SQLText = 'select * from ' + @input_SpravName + ' '
SET @SQLText += ' where id = ' + rtrim(convert(varchar(4), @input_Id))
EXECUTE(@SQLText)

Goto Done
---------- Начало - "Стандартный конец транзакции в начале процедуре" -------------------------------------------
Error:
 Exec sp_ErrorLog_Insert 110, @CurrentStorageProcedureName, @input_LoginName, @strNote, @input_Id
 RETURN (-1)

Done:
 RETURN (@@ERROR)
 

END








GO
/****** Object:  StoredProcedure [dbo].[sp_GetSpravDataSource_ForDataType]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[sp_GetSpravDataSource_ForDataType]
								@input_DataType int = Null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT _dsji.id as DataSourceJobItem, _dsji.ShortName, _dsji.FullName, _dsji.Notes FROM sprDataSource_JobItem AS _dsji
				Where (IsNull(_dsji.DataType, 0) = 0 or IsNull(_dsji.DataType, 0) = IsNull(@input_DataType, 0)) and (IsNull(_dsji.IsDeleted, 0) =0)
ORDER BY _dsji.id


RETURN (@@ERROR) -- 0
END













GO
/****** Object:  StoredProcedure [dbo].[sp_GetSpravDataType]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sp_GetSpravDataType]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT _dtji.id as DataTypeJobItem, _dtji.ShortName, _dtji.FullName, _dtji.Notes FROM sprDataType_JobItem AS _dtji
				Where (IsNull(_dtji.IsDeleted, 0) =0)
ORDER BY _dtji.id


RETURN (@@ERROR) -- 0
END












GO
/****** Object:  StoredProcedure [dbo].[sp_GetSpravDocumentType]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetSpravDocumentType]
											
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


SELECT tp.id, tp.ShortName, tp.FullName, tp.code, tp.Notes FROM TemplateProcess AS tp
Where IsNull(tp.IsDeleted, 0) = 0
ORDER BY tp.id

RETURN (@@ERROR)
END



GO
/****** Object:  StoredProcedure [dbo].[sp_GetSpravJob]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[sp_GetSpravJob]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT _j.id as ProcessJobId, _j.ShortName, _j.FullName, _j.Notes FROM sprJob AS _j
				Where (IsNull(_j.IsDeleted, 0) =0) and (_j.ShortName is not Null)
ORDER BY _j.id


RETURN (@@ERROR)
END











GO
/****** Object:  StoredProcedure [dbo].[sp_GetSpravJobCode_byName]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[sp_GetSpravJobCode_byName]
					@input_JobName varchar(128)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

Select tpj.id as id, tpj.ShortName as ShortName, tpj.FullName as FullName, tpj.ProcessTemplate as ProcessTemplate, tpj.ProcessItemTemplate as ProcessItemTemplate From TemplateProcessJob as tpj
	Where (IsNull(tpj.IsDeleted, 0) =0) and (tpj.id = dbo.f_GetJobId_byName(@input_JobName)) 

Done:
RETURN (@@ERROR)
END













GO
/****** Object:  StoredProcedure [dbo].[sp_GetSpravJobItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sp_GetSpravJobItem]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT _ji.id as JobItemId, _ji.ShortName, _ji.FullName, _ji.Notes FROM sprJobItem AS _ji
				Where (IsNull(_ji.IsDeleted, 0) =0) and (_ji.ShortName is not Null)
ORDER BY _ji.id


RETURN (@@ERROR)
END












GO
/****** Object:  StoredProcedure [dbo].[sp_GetSpravJobRole]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetSpravJobRole]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT _jrv.id, _jrv.Code, _jrv.ShortName, _jrv.FullName, _jrv.Notes, 1 as JobRoleType FROM sprJobRole_Virtual AS _jrv
				Where (IsNull(_jrv.IsDeleted, 0) =0) and (_jrv.ShortName is not Null)
union all
SELECT _jr.id, _jr.Code, _jr.ShortName, _jr.FullName, _jr.Notes, 0 as JobRoleType FROM sprJobRole AS _jr
				Where (IsNull(_jr.IsDeleted, 0) =0) and (_jr.ShortName is not Null)
--ORDER BY _jr.id


RETURN (@@ERROR)
END










GO
/****** Object:  StoredProcedure [dbo].[sp_GetSpravMaxRouteId]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetSpravMaxRouteId]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT max(_rl.id) as IdRoute FROM sprRoutesList AS _rl Where IsNull(_rl.IsDeleted, 0) = 0

RETURN (@@ERROR)
END









GO
/****** Object:  StoredProcedure [dbo].[sp_GetSpravMeasurementUnit]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetSpravMeasurementUnit]
											
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


SELECT _mu.id, _mu.Code_OKEI, _mu.ShortName, _mu.FullName FROM sprMeasurementUnit AS _mu
Where IsNull(_mu.IsDeleted, 0) =0
Order by _mu.ReferenceCount desc


RETURN (@@ERROR)
END









GO
/****** Object:  StoredProcedure [dbo].[sp_GetSpravMeasurementUnitById]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetSpravMeasurementUnitById]
                    @input_MeasurmentUnitId int
											
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


SELECT _mu.ShortName, _mu.FullName FROM sprMeasurementUnits AS _mu
Where IsNull(_mu.IsDeleted, 0) = 0 and _mu.Id = @input_MeasurmentUnitId


RETURN (@@ERROR)
END











GO
/****** Object:  StoredProcedure [dbo].[sp_GetSpravObjectGroup_MTR]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetSpravObjectGroup_MTR]
											
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


SELECT _og.id, _og.Code, _og.ShortName, _og.FullName FROM sprObjectMTRGroup AS _og
Where IsNull(_og.IsDeleted, 0) =0
ORDER BY _og.Code

RETURN (@@ERROR)
END








GO
/****** Object:  StoredProcedure [dbo].[sp_GetSpravObjectItemsById_Manufacturing]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetSpravObjectItemsById_Manufacturing]
								@input_IdParentItem bigint = Null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SET TRANSACTION ISOLATION LEVEL READ COMMITTED


-- Рекурсия через динамическое представление
if exists (select * from dbo.sysobjects where id = object_id(N'#DepNestLevel') and OBJECTPROPERTY(id, N'IsTmpTable') = 1)
begin
 Drop Table [#DepNestLevel]
end
CREATE TABLE #DepNestLevel ([ID] int, [ShortName] varchar(1024), [IDParent] int, NestingLevel int)


if IsNull(@input_IdParentItem, 0) != 0
begin
Insert Into #DepNestLevel
	SELECT _om.[ID], _om.[ShortName], _om.[IDParent], 1 FROM sprObjectManufacturingItem AS _om 
														WHERE _om.ID = @input_IdParentItem
end
 
Begin
WITH cteDCENestingLevel ([ID], [ShortName], [IDParent], NestingLevel) AS
(
	SELECT _om.[ID], _om.[ShortName], _om.[IDParent], 2 FROM sprObjectManufacturingItem AS _om
														WHERE IsNull(IDParent, 0) = @input_IdParentItem
	UNION ALL
	SELECT _om.[ID], _om.[ShortName], _om.[IDParent], (NestingLevel + 2) FROM sprObjectManufacturingItem AS _om
		INNER JOIN cteDCENestingLevel ON (cteDCENestingLevel.[ID] = _om.[IDParent] )
)
Insert Into #DepNestLevel
	SELECT * FROM cteDCENestingLevel order by NestingLevel
End

SELECT dnl.*, _om.FullName, _om.ItemType, _om.MeasurementUnit, _om.Volume, _om.Notes FROM #DepNestLevel as dnl
		 Left Join sprObjectManufacturingItem as _om On (dnl.ID = _om.id)
		 Where IsNull(_om.IdParent, 0) != 0
		 order by NestingLevel


RETURN (@@ERROR)
END












GO
/****** Object:  StoredProcedure [dbo].[sp_GetSpravObjectManufacturing]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetSpravObjectManufacturing]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT _om.id, _om.Code, _om.ShortName as ShortName, _om.FullName, _om.Notes, _om.MeasurementUnit as MeasurementUnit FROM sprObjectManufacturing AS _om
				Where (IsNull(_om.IsDeleted, 0) =0)
ORDER BY _om.id


RETURN (@@ERROR)
END












GO
/****** Object:  StoredProcedure [dbo].[sp_GetSpravStoreObjectParentLink]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetSpravStoreObjectParentLink]
											
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


SELECT _sopl.id, _sopl.Code, _sopl.ShortName, _sopl.FullName FROM sprStoreObjectParentLink AS _sopl
Where IsNull(_sopl.IsDeleted, 0) =0
ORDER BY _sopl.Code

RETURN (@@ERROR)
END









GO
/****** Object:  StoredProcedure [dbo].[sp_GetSpravUser]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetSpravUser]
											
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


SELECT _u.id, _u.ShortName, _u.FullName FROM sprUser AS _u
ORDER BY _u.ShortName

RETURN (@@ERROR)
END










GO
/****** Object:  StoredProcedure [dbo].[sp_GetStoreMTRObject]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetStoreMTRObject]
								@input_SortingType int = 0,
--								@input_CallerUserAsString varchar(256) = NULL,
								@input_FilterObjectInitiatorOwnerAsString varchar(256) = NULL,
								@input_FilterObjectGroupAsString varchar(256) = Null,
								@input_FilterPeriodBeginPutOnStockAsString varchar(32) = Null,
								@input_FilterPeriodEndPutOnStockAsString varchar(32) = Null,
								@input_FilterPeriodBeginLinkedOrderCreationAsString varchar(32) = Null,
								@input_FilterPeriodEndLinkedOrderCreationAsString varchar(32) = Null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SET TRANSACTION ISOLATION LEVEL READ COMMITTED

DECLARE  @SQLText  varchar(4096)
DECLARE  @SQLText1 varchar(2048)
DECLARE  @SQLOrdering varchar(512)
Declare @NeededProcessStatusAsInteger int
Declare @CallerUserId bigint
Declare @ObjectInitiatorOwnerId bigint
Declare @ObjectGroupId bigint



SET @SQLText = 'SELECT somtr.id as idStoreObject, _og.ShortName as ObjectGroupName, somtr.ShortName, somtr.FullName, _mu.ShortName as MeasurmentUnitName, somtr.Volume,'
SET @SQLText += '        somtr.CreationDate as CreationDate, somtr.sys_creationdate as sysCreationDate,'
SET @SQLText += '        _u.ShortName as CreatorOwnerName, _u.ShortName + '' ('' + _u.FullName + '')'' as CreatorOwnerFullViewing,'
SET @SQLText += '        somtr.Notes, ol.id as IdParentOrder, somtr.DocumentItemId, ol.CreationDate as OrderCreationDate'
 SET @SQLText += ' FROM StoreObjectMTR AS somtr Left Join sprUser As _u On (somtr.CreatorOwner = _u.id)'
 SET @SQLText += '					    Left Join sprObjectMTRGroup as _og On (somtr.ObjectGroup = _og.id)'
 SET @SQLText += '					    Left Join sprMeasurementUnit as _mu On (somtr.MeasurementUnit = _mu.id)'
 SET @SQLText += '					    Left Join DocumentList as ol On (somtr.DocumentId = ol.id)'
 SET @SQLText += ' WHERE IsNull(somtr.IsDeleted, 0) = 0'

IF ISNULL(@input_FilterObjectGroupAsString, '') != ''
BEGIN
 Select @ObjectGroupId = (Select _og.id From sprObjectMTRGroups as _og Where _og.ShortName like rtrim(@input_FilterObjectGroupAsString) or _og.FullName like rtrim(@input_FilterObjectGroupAsString))
  if ISNULL(@ObjectGroupId, 0) != 0
   Begin
    SET @SQLText += ' and somtr.ObjectsGroup ='
    SET @SQLText += ltrim(rtrim(Convert(varchar(16), @ObjectGroupId)))
   End
END

if IsNull(@input_FilterObjectInitiatorOwnerAsString, '') != ''
begin
 Select @ObjectInitiatorOwnerId = (Select _u.id From sprUsers as _u Where _u.ShortName like rtrim(@input_FilterObjectInitiatorOwnerAsString) or _u.FullName like rtrim(@input_FilterObjectInitiatorOwnerAsString))
 
 SET @SQLText += ' and ol.CreatorOwner = '
 SET @SQLText += ltrim(rtrim(Convert(varchar(16), @ObjectInitiatorOwnerId)))
end

if IsNull(@input_FilterPeriodBeginPutOnStockAsString, '') != ''
begin
 if IsNull(@input_FilterPeriodEndPutOnStockAsString, '') != ''
 begin
  SET @SQLText += ' and somtr.CreationDate between Convert(datetime, ''' + @input_FilterPeriodBeginPutOnStockAsString + ''', 120) and Convert(datetime, ' + '''' + @input_FilterPeriodEndPutOnStockAsString + ''', 120)'
 end
 else
  SET @SQLText += ' and somtr.CreationDate > Convert(datetime, ' + '''' + @input_FilterPeriodBeginPutOnStockAsString + ''', 120)'
end
else
begin
 if IsNull(@input_FilterPeriodEndPutOnStockAsString, '') != ''
 begin
  SET @SQLText += ' and somtr.CreationDate < Convert(datetime, ' + '''' + @input_FilterPeriodEndPutOnStockAsString + ''', 120)'
 end
end


if IsNull(@input_FilterPeriodBeginLinkedOrderCreationAsString, '') != ''
begin
 if IsNull(@input_FilterPeriodEndLinkedOrderCreationAsString, '') != ''
 begin
  SET @SQLText += ' and ol.CreationDate between Convert(datetime, ''' + @input_FilterPeriodBeginLinkedOrderCreationAsString + ''', 120) and Convert(datetime, ' + '''' + @input_FilterPeriodEndLinkedOrderCreationAsString + ''', 120)'
 end
 else
  SET @SQLText += ' and ol.CreationDate > Convert(datetime, ' + '''' + @input_FilterPeriodBeginLinkedOrderCreationAsString + ''', 120)'
end
else
begin
 if IsNull(@input_FilterPeriodEndLinkedOrderCreationAsString, '') != ''
 begin
  SET @SQLText += ' and ol.CreationDate < Convert(datetime, ' + '''' + @input_FilterPeriodEndLinkedOrderCreationAsString + ''', 120)'
 end
end



SET @SQLOrdering =  ' ORDER BY ObjectGroupName, somtr.CreationDate'
/*
IF @input_SortingType = 0
BEGIN
 SET @SQLOrdering =  ' ORDER BY ol.ProcessStatus'
END

IF @input_SortingType = 1
BEGIN
 SET @SQLOrdering =  ' ORDER BY ol.OrderNum'
END

IF @input_SortingType = 2
BEGIN
 SET @SQLOrdering =  ' ORDER BY ol.CreationDate'
END

IF @input_SortingType = 3
BEGIN
 SET @SQLOrdering =  ' ORDER BY ol.CreatorOwner'
END
*/
SET @SQLText += @SQLOrdering

EXECUTE(@SQLText)
--Select @SQLText as SQLTxt
 
RETURN (@@ERROR)
END











GO
/****** Object:  StoredProcedure [dbo].[sp_GetStoreMTRObject_SearchByName]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetStoreMTRObject_SearchByName]
								@input_SortingType int = 0,
								@input_FilterObjectInitiatorOwnerAsString varchar(256) = NULL,
								@input_FilterObjectGroup varchar(256) = Null,
								@input_FilterPeriodBeginPutOnStockAsString varchar(32) = Null,
								@input_FilterPeriodEndPutOnStockAsString varchar(32) = Null,
								@input_FilterPeriodBeginLinkedOrderCreationAsString varchar(32) = Null,
								@input_FilterPeriodEndLinkedOrderCreationAsString varchar(32) = Null,
								@input_NameTarget Varchar(256) = Null

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SET TRANSACTION ISOLATION LEVEL READ COMMITTED

CREATE TABLE #Table1 (idStoreObject bigint, ObjectGroupName varchar(256), ShortName varchar(256), FullName varchar(1024), MeasurmentUnitName varchar(256), Volume int,
        CreationDate datetime, sysCreationDate datetime, CreatorOwnerName varchar(256), CreatorOwnerFullViewing varchar(1024), Notes varchar(1024), IdParentOrder bigint,
		IdParentOrderItem bigint, OrderCreationDate datetime)

Insert Into #Table1 exec sp_GetStoreMTRObject 0, @input_FilterObjectInitiatorOwnerAsString, @input_FilterObjectGroup,
											   @input_FilterPeriodBeginPutOnStockAsString, @input_FilterPeriodEndPutOnStockAsString,
											   @input_FilterPeriodBeginLinkedOrderCreationAsString, @input_FilterPeriodEndLinkedOrderCreationAsString


If IsNull(@input_NameTarget, '') != ''
 Select * From #Table1 as t1	WHERE lower(t1.ShortName) like lower(rtrim(@input_NameTarget)) or lower(t1.FullName) like lower(rtrim(@input_NameTarget)) or lower(t1.Notes) like lower(rtrim(@input_NameTarget))
Else
 Select * From #Table1 as t1
 
RETURN (@@ERROR)
END











GO
/****** Object:  StoredProcedure [dbo].[sp_GetTemplateJobItem_Document]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sp_GetTemplateJobItem_Document]
					@input_TemplateProcessItem bigint
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

select tji.id as JobItemId, tji.IsActive, tji.JobItemLevel as JobItemLevel, _ji.FullName as JobItemName, _ji.FullName, _ji.Notes From TemplateJobItem as tji
	inner join sprJobItem as _ji On (tji.JobItem = _ji.id) -- Выбираем Наименования Элементов Работы
	where tji.ProcessItemTemplate = @input_TemplateProcessItem and IsNull(tji.IsEntireDocument, 0) > 0
	order by tji.JobItemLevel


RETURN

END















GO
/****** Object:  StoredProcedure [dbo].[sp_GetTemplateJobItem_DocumentItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[sp_GetTemplateJobItem_DocumentItem]
					@input_TemplateProcessItem bigint
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

select tji.id as JobItemId, tji.IsActive, tji.JobItemLevel as JobItemLevel, _ji.id as JobItemIdSprav, _ji.FullName as JobItemNameSprav, _ji.FullName, _ji.Notes, tji.ProcessItemTemplate as TemplateProcessItemId,
		tji.IsActive, tji.IsDone, tji.IsEntireDocument, tji.IsEDD
	From TemplateJobItem as tji
	inner join sprJobItem as _ji On (tji.JobItem = _ji.id) -- Выбираем Наименования Элементов Работы
	where tji.ProcessItemTemplate = @input_TemplateProcessItem and IsNull(tji.IsEntireDocument, 0) = 0
	order by tji.JobItemLevel


RETURN

END














GO
/****** Object:  StoredProcedure [dbo].[sp_GetTemplateJobItemLevel_Next]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE procedure [dbo].[sp_GetTemplateJobItemLevel_Next]
								@input_TemplateProcessItemId bigint
AS
BEGIN

declare @bResult bigint
set @bResult = IsNull(dbo.f_GetTemplateJobItemLevel_New(@input_TemplateProcessItemId), 1)

Select @bResult as Result

Done:
RETURN @bResult
END










GO
/****** Object:  StoredProcedure [dbo].[sp_GetTemplateProcessInvolvedStatus]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE procedure [dbo].[sp_GetTemplateProcessInvolvedStatus]
								@input_TemplateProcessId bigint
AS
BEGIN

declare @bResult bit
if dbo.f_IsProcessTemplateInvolvedInDocument(@input_TemplateProcessId) = 1
 Select @bResult = 1
else
 Select @bResult = 0

Select @bResult as Result

Done:
RETURN 0
END






GO
/****** Object:  StoredProcedure [dbo].[sp_GetTemplateProcessItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sp_GetTemplateProcessItem]
					@input_TemplateProcessId bigint
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

select tpi.id as TemplateProcessItemId, tpi.ProcessTemplate as ProcessTemplateId, tpi.Job, tpi.ItemLevel as ProcessItemLevel, _j.ShortName as ProcessItemName,
	 (Case When IsNull(IsVirtualJobRole, 0) = 0 Then _jr.ShortName Else dbo.f_GetVirtualJobRoleName(tpi.JobRole) End) as JobRoleName From TemplateProcessItem as tpi
	inner join sprJob as _j On (tpi.Job = _j.id)-- Выбираем Наименования Этапов Процесса
	inner join sprJobRole as _jr On (_jr.id = tpi.JobRole)-- Выбираем Роли Этапов Процесса
	where tpi.ProcessTemplate = @input_TemplateProcessId and IsNull(tpi.IsDeleted, 0) = 0
	order by tpi.ItemLevel


RETURN

END















GO
/****** Object:  StoredProcedure [dbo].[sp_GetTemplateProcessItem_Count]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sp_GetTemplateProcessItem_Count]
					@input_TemplateProcessId bigint
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

declare @ProcessItemCount int
select dbo.f_GetTemplateProcessItemCount(@input_TemplateProcessId) as Result
return(@ProcessItemCount)

END















GO
/****** Object:  StoredProcedure [dbo].[sp_GetTemplateProcessItem_Info]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[sp_GetTemplateProcessItem_Info]
					@input_TemplateProcessItemId bigint
						
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

select tpi.id as TemplateProcessItemId, tpi.ProcessTemplate as ProcessTemplateId, tpi.Job, tpi.ItemLevel as ProcessItemLevel, _j.ShortName as ProcessItemName,
	 (Case When IsNull(IsVirtualJobRole, 0) = 0 Then _jr.ShortName Else dbo.f_GetVirtualJobRoleName(tpi.JobRole) End) as JobRoleName From TemplateProcessItem as tpi
	inner join sprJob as _j On (tpi.Job = _j.id)-- Выбираем Наименования Этапов Процесса
	inner join sprJobRole as _jr On (_jr.id = tpi.JobRole)-- Выбираем Роли Этапов Процесса
	where tpi.id = @input_TemplateProcessItemId



RETURN

END
















GO
/****** Object:  StoredProcedure [dbo].[sp_GetTemplateProcessList]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[sp_GetTemplateProcessList]
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_GetTemplateProcessList'

Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

Select @OutputError = 0

declare @input_LoginName varchar(128)
select @input_LoginName = dbo.f_GetUserName_Current()

select tp.id as TemplateProcessId, tp.*  FROM TemplateProcess AS tp
--                   left join sprJobRole as _jr On (_u.JobRole = _jr.id)
                   Where IsNull(tp.IsDeleted, 0) = 0
				   order by tp.id



Done:
 RETURN (@outputError)

END








GO
/****** Object:  StoredProcedure [dbo].[sp_GetUserInfo]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetUserInfo]
								 @input_UserId int = Null -- Null == Полный перечень пользователей
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_GetUserInfo'

Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

Select @OutputError = 0

declare @input_LoginName varchar(128)
select @input_LoginName = dbo.f_GetUserName_Current()

if IsNull(@input_UserId, 0) = 0
begin
 select _u.id as UserId, _u.LoginName, _u.ShortName, _jr.id as JobRole, _jr.ShortName as JobRoleName, _u.FullName, _u.Notes  FROM sprUser AS _u
                   left join sprJobRole as _jr On (_u.JobRole = _jr.id)
                   Where IsNull(_u.IsDeleted, 0) = 0
				   order by _u.ShortName
end
else
begin
 select _u.id as UserId, _u.LoginName, _u.ShortName, _jr.id as JobRole, _jr.ShortName as JobRoleName, _u.FullName, _u.Notes FROM sprUser AS _u
                   left join sprJobRole as _jr On (_u.JobRole = _jr.id)
                   Where IsNull(_u.IsDeleted, 0) = 0 and _u.id = @input_UserId
				   order by _u.ShortName
end
Done:
 RETURN (@outputError)

Error:
 Exec sp_ErrorLog_Insert @ProgramError, @CurrentStorageProcedureName, @input_LoginName, @strNote, @input_UserId
 RETURN (@outputError)

END







GO
/****** Object:  StoredProcedure [dbo].[sp_GetUserInfo_byLoginName]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[sp_GetUserInfo_byLoginName]
								 @input_LoginName varchar(128)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_GetUserInfo_byLoginName'

Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

declare @input_UserId int
set @input_UserId = dbo.f_GetUserId_byName(@input_LoginName)

CREATE TABLE #Table1 (UserId smallint, LoginName varchar(256), ShortName Varchar(256), JobRole int, JobRoleName Varchar(256), FullName Varchar(256), Notes varchar(1024))
Insert Into #Table1 exec sp_GetUserInfo @input_UserId
Select * From #Table1

Return

END








GO
/****** Object:  StoredProcedure [dbo].[sp_GetUserProgramRoleName]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetUserProgramRoleName]
								 @input_NeedUserName Varchar(128) = Null
AS
BEGIN


Declare @CurrUser varchar(32)
Select @CurrUser = IsNull (@input_NeedUserName, User)

select _pr.ShortName as RoleName  from sprProgramsRoles as _pr
						 where _pr.Code = (Select _u.IdRole From sprUsers as _u Where _u.ShortName = rtrim(@CurrUser) or _u.FullName = rtrim(@CurrUser))
END








GO
/****** Object:  StoredProcedure [dbo].[sp_GetUserProgramRolesInfo]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetUserProgramRolesInfo]
								@input_CallerUserAsString Varchar(128),
								@input_IdOrder bigint = Null
AS
BEGIN


Declare @CallerUserId bigint
Declare @TargetRouteId bigint

-- Определяем id Пользователя, который вызвал эту процедуру
Select @CallerUserId = (Select _u.id From sprUsers as _u Where _u.ShortName like rtrim(@input_CallerUserAsString) or _u.FullName like rtrim(@input_CallerUserAsString))
-- Определяем Code маршрута для требуемого номера ордера (заявки)
Select @TargetRouteId = (Select oci.IdRoute From OrdersCommonInfo as oci Where oci.IdOrder = @input_IdOrder)

select distinct id, ShortName as RoleName, Code as CodeProgramRole  from sprProgramsRoles as _pr
						join (select ri.ProcessStatusId from RoutesItems as ri
							join (select jpi.Code from JobPositionsItems as jpi where jpi.UserId = @CallerUserId) as t1
							    On (ri.JobPosition = t1.Code)  where ri.IdRoute = @TargetRouteId) as t2
							On (_pr.CodeProcessStatus = t2.ProcessStatusId)
				order by CodeProgramRole  
				
END








GO
/****** Object:  StoredProcedure [dbo].[sp_GetUserSystemRoleName]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_GetUserSystemRoleName]
								 @input_NeedUserName Varchar(128) = Null
AS
BEGIN


Declare @CurrUser varchar(32)
Select @CurrUser = IsNull (@input_NeedUserName, User)

   -- EXEC sp_helpuser @CurrUser
select name as RoleName  from sysusers

where uid in (select groupuid from sysmembers 

                  where memberuid=(select uid from sysusers where  Name=@CurrUser ))
END






GO
/****** Object:  StoredProcedure [dbo].[sp_RenameAttachmentOrderItem]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_RenameAttachmentOrderItem]
                    @input_IdOrder bigint,
                    @input_IdOrderItem bigint,
					@input_CallerUserAsString varchar (256),
					@input_AttachmentName varchar (256),
                    @input_IdAttachment bigint
                                                                 
 AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_RenameAttachmentOrderItem'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
declare @strNote varchar(max)
declare @ProgramError int
declare @ProgramEvent int

declare @tranName varchar(100)

select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION @tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

---------- Начало блока "Защита от дурака" --------------------------------------------------------------

------------------------------------------------------------------------------------------------------------
-- А существует ли, вообще, такой input_IdOrderItem для input_IdOrder? ------------
------------------------------------------------------------------------------------------------------------
if not Exists(Select oi.id From OrdersItems as oi Where oi.id = @input_IdOrderItem and oi.idOrder = @input_IdOrder)
begin
 select @ProgramError = 116
 set @strNote = 'Запрошен не существующий OrderItem для IdOrder= ' + STR(@input_IdOrderItem)
 Select @OutputError = @@ERROR
 GOTO Error
end

---------- Конец блока "Защита от дурака" --------------------------------------------------------------

/*   Только для примера - вариант передачи имени файла и загрузка с сервака, а не передача BLOB Data с клиента
INSERT INTO dbo.OrderAttachments (IdOrderItem, fileDATA)
SELECT 81, *
FROM OPENROWSET(BULK N'D:\oradb_iops.JPG', SINGLE_BLOB) AS [File]
*/

Declare @oldAttachmentName varchar(256)
Select @oldAttachmentName = oia.AttachmentName From dbo.OrdersItemAttachments as oia
		Where
		idOrderItem = @input_IdOrderItem and
		IdAttachment = @input_IdAttachment

Update dbo.OrdersItemAttachments Set AttachmentName = @input_AttachmentName
		Where
		idOrderItem = @input_IdOrderItem and
		IdAttachment = @input_IdAttachment

IF @@ROWCOUNT = 1 and @@ERROR = 0
begin
 select @strNote = 'Вложение ^' + @oldAttachmentName + '^ переименовано в заявке' + rtrim(CONVERT(varchar(max), @input_IdOrder, Null))
 select @ProgramEvent = 170
 GOTO Done
end


IF @@ROWCOUNT = 0 or @@ERROR != 0
begin
 set @strNote = 'ФИО инициатора = '
 set @strNote += rtrim(@input_CallerUserAsString) + '; '
 select @ProgramError = 119
end

---------- Начало - "Стандартный конец транзакции в конце процедуре" -------------------------------------------
Error:
 Select @outputError = @@ERROR
 ROLLBACK TRANSACTION @tranName
 Exec sp_AddError @ProgramError, @CurrentStorageProcedureName, @strNote, @input_CallerUserAsString, @input_IdOrder
 SELECT  @outputError
 RETURN (@outputError)

Done:
 Select @outputError = @@ERROR
 COMMIT TRANSACTION @tranName
 Exec sp_AddEvent @ProgramEvent, @CurrentStorageProcedureName, @input_IdOrder, @input_CallerUserAsString
 SELECT  @outputError
 RETURN (@outputError)








GO
/****** Object:  StoredProcedure [dbo].[sp_Report_MTR_ForBuying]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_Report_MTR_ForBuying]
								 @input_ObjectGroupId integer = Null
								
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SET TRANSACTION ISOLATION LEVEL READ COMMITTED


-- Получим входящие ЭД

 select di_i.Document as DocumentId, di_i.DocumentItem as DocumentItem, dl1.DocumentNum, dl1.Notes as DocumentNotes, dl1.CreationDate as CreationDate, dl1.ExecutionDate, di.Notes as DocumentItemNotes, _og.Code as CodeGroup, _og.ShortName as ObjectsGroupName, di.ShortName as ObjectName, di_mtr.Volume, _mu.ShortName as MeasurementsUnit from dbo.f_GetDocumentItem_Input() AS di_i
			left join DocumentList as dl1 on (di_i.Document = dl1.id)        -- Для получения доп. сведений
			left join DocumentItem as di on (di_i.DocumentItem = di.id)
			left join DocumentItem_MTR as di_mtr on (di_i.DocumentItem = di_mtr.DocumentItemId)
			left join sprObjectMTRGroup as _og on (di_mtr.ObjectGroup = _og.id)
			left join sprMeasurementUnit as _mu on (di_mtr.MeasurementUnit = _mu.id)

union all
 -- Получим все ЭД, которые уже отработаны, но всё ещё активны на данном ЭП
 select di_t_a.Document as DocumentId, di_t_a.DocumentItem as DocumentItem, dl1.DocumentNum, dl1.Notes as DocumentNotes, dl1.CreationDate as CreationDate, dl1.ExecutionDate, di.Notes as DocumentItemNotes, _og.Code as CodeGroup, _og.ShortName as ObjectsGroupName, di.ShortName as ObjectName, di_mtr.Volume, _mu.ShortName as MeasurementsUnit from dbo.f_GetDocumentItem_Total_Active() AS di_t_a
			left join DocumentList as dl1 on (di_t_a.Document = dl1.id)        -- Для получения доп. сведений
			left join DocumentItem as di on (di_t_a.DocumentItem = di.id)
			left join DocumentItem_MTR as di_mtr on (di_t_a.DocumentItem = di_mtr.DocumentItemId)
			left join sprObjectMTRGroup as _og on (di_mtr.ObjectGroup = _og.id)
			left join sprMeasurementUnit as _mu on (di_mtr.MeasurementUnit = _mu.id)
 order by CodeGroup, dl1.ExecutionDate, dl1.CreationDate, dl1.DocumentNum


RETURN (@@ERROR)
END






GO
/****** Object:  StoredProcedure [dbo].[sp_SetSP_FText]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_SetSP_FText]
					@input_Procedure_ID bigint,
					@input_Procedure_Name varchar(1024)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
CREATE TABLE #Table1 (Procedure_ID int, Procedure_Colid int, text1 nvarchar(4000))


  DECLARE Cursor_P CURSOR FOR
      SELECT sc.[id], name, colid
      FROM syscomments as sc
	  left join sysobjects as so On (sc.id = so.id)
      WHERE sc.id IN (SELECT so.id FROM sysobjects as so WHERE type = 'P') and sc.id = @input_Procedure_ID
      ORDER BY [id], colid
    FOR Update
     
    DECLARE @Procedure_ID [int]
    DECLARE @Procedure_Name varchar(256)
    DECLARE @Procedure_Colid [int]
     
    OPEN Cursor_P
            
    FETCH Cursor_P INTO  @Procedure_ID, @Procedure_Name, @Procedure_Colid
     
    Declare @CurrentProcedureId int
	Set @CurrentProcedureId =  @Procedure_ID

	Declare @CurrentProcedureName nvarchar(128)
    Set @CurrentProcedureName = @Procedure_Name

	Declare @CurrentProcedure_Colid int
    Set @CurrentProcedure_Colid = @Procedure_Colid

    DECLARE @S nvarchar(4000)
    DECLARE @S1 nvarchar(4000)

	Declare @bFirstStep int
	Set @bFirstStep = 1


	SELECT @S1 = 'Drop procedure ' + @Procedure_Name
    Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values ( @Procedure_ID, @CurrentProcedure_Colid, @S1)
    Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
    Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values ( @Procedure_ID, @CurrentProcedure_Colid, char(13) + char(10) + 'GO' + char(13) + char(10))
    Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1

    WHILE (@@FETCH_STATUS = 0)
    BEGIN

	  if @CurrentProcedureId !=  @Procedure_ID
	  begin

   
	   If @bFirstStep > 1
	   begin
		Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@CurrentProcedureId, @CurrentProcedure_Colid, char(13) + char(10) + 'GO' + char(13) + char(10))
		Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
        SET @S1 = 'Grant EXECUTE On ' + @CurrentProcedureName
		SET @S1 += ' To OPUsers, OPAdmins'
		Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@CurrentProcedureId, @CurrentProcedure_Colid, @S1)
		Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
		Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@CurrentProcedureId, @CurrentProcedure_Colid, char(13) + char(10) + 'GO' + char(13) + char(10))
		Set @CurrentProcedure_Colid = @Procedure_Colid
	   end

       SELECT @S1 = 'Drop procedure ' + @Procedure_Name
       Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@Procedure_ID, @CurrentProcedure_Colid, @S1)
       Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
       Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@Procedure_ID, @CurrentProcedure_Colid, char(13) + char(10) + 'GO' + char(13) + char(10))
       Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1

	   Set @CurrentProcedureId = @Procedure_ID
	   Set @CurrentProcedureName = @Procedure_Name
	  end

      Set @bFirstStep = @bFirstStep + 1

      SELECT @S =  [text]
      FROM syscomments
      WHERE [id] = @Procedure_ID AND colid = @Procedure_Colid
      ORDER BY [id]
	  
      Insert Into #Table1 (Procedure_ID, Procedure_Colid, text1) values (@Procedure_ID, @CurrentProcedure_Colid, @S)
      Set @CurrentProcedure_Colid = @CurrentProcedure_Colid + 1
    FETCH Cursor_P INTO  @Procedure_ID, @Procedure_Name, @Procedure_Colid

    END
     
    CLOSE Cursor_P
     
    DEALLOCATE Cursor_P

select * from #Table1 as t1  --where t1.Procedure_ID = 1166627199
		order by t1.Procedure_ID, t1.Procedure_Colid
--drop table #Table1

end





GO
/****** Object:  StoredProcedure [dbo].[sp_SwitchOnOffRoute]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE 	[dbo].[sp_SwitchOnOffRoute] 	
								@input_CallerUserAsString varchar (256),
								@input_IdRoute Bigint

											
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @CurrentStorageProcedureName varchar(64)
Set @CurrentStorageProcedureName = 'sp_SwitchOnOffRoute'

---------- Начало - "Стандартное начало транзакции в начале процедуре" -------------------------------------------
Declare @OutputError int
Declare @strNote varchar(max)
Declare @ProgramError int
Declare @ProgramEvent int

Declare @tranName varchar(100)

select @tranName = dbo.f_GetUniqTransactionName()
BEGIN TRANSACTION @tranName
---------- Конец - "Стандартное начало транзакции в начале процедуре" -----------------------------------

Declare @SwitchValue bit
Select @SwitchValue = _rl.IsDeleted from sprRoutesList as _rl Where Id = @input_IdRoute

if IsNull(@SwitchValue, 0) = 0
begin
 Select @SwitchValue = 1
 select @ProgramEvent = 80 /*Включение активности маршрута произведено*/
 select @ProgramError = 80 /*Ошибка включения активности маршрута */
end
Else
begin
 Select @SwitchValue = 0
 select @ProgramEvent = 81 /*Выключение активности маршрута произведено*/
 select @ProgramError = 81 /*Ошибка выключения активности маршрута */
end


 Update dbo.sprRoutesList Set IsDeleted = @SwitchValue
                        Where Id = @input_IdRoute

IF @@ROWCOUNT = 1 AND @@ERROR=0
begin
 select @strNote = ''
 GOTO Done
end


---------- Начало - "Стандартный конец транзакции в конце процедуре" -------------------------------------------
Error:
 Select @outputError = @@ERROR
 ROLLBACK TRANSACTION @tranName
 Exec sp_AddError @ProgramError, @CurrentStorageProcedureName, @input_IdRoute, @input_CallerUserAsString 
 SELECT  @outputError
 RETURN (@outputError)

Done:
 Select @outputError = @@ERROR
 COMMIT TRANSACTION @tranName
 Exec sp_AddEvent @ProgramEvent, @CurrentStorageProcedureName, @input_IdRoute, @input_CallerUserAsString
 SELECT  @outputError
 RETURN (@outputError)








GO
/****** Object:  StoredProcedure [dbo].[TestTMP]    Script Date: 30.06.2025 15:40:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[TestTMP]
					--@OrderNum varchar (1024) ,
                    --@CreatorOwner varchar (32),
                    --@Notes varchar (1024),
                    --@ExecutionDate varchar (32)
                    
	
                                                                   
                                                                 
 AS

declare @tmpDateTime datetime
select @tmpDateTime = CAST('20/06/2012' as datetime)

select @tmpDateTime







GO
