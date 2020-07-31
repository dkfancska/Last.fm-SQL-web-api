USE lastfm
GO
/****** Object:  StoredProcedure [dbo].[sp_soap_request]    Script Date: 31.07.2020 16:05:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create or ALTER PROCEDURE [dbo].[sp_soap_request]
		@url				nvarchar(max)='http://ws.audioscrobbler.com/2.0/'			--	Адрес сервера.
	,	@result				nvarchar(max) OUTPUT	--	Ответ.
	,	@method				nvarchar(max) = 'GET'	--	Метод передачи.
	,	@soap_action		varchar(max) = NULL		--	Действие.
	,	@request			varchar(max) = NULL		--	Запрос.

	,	@D_DateLast			varchar(max) = '786c8508f8087106e3146402b097f57c'
AS 
BEGIN	
	SET NOCOUNT ON;
 
	DECLARE
			@ole_obj			int					-- Ссылка на OLE объект
		,	@err				int					-- Код ошибки
		,	@err_str			varchar(max)		-- Текст ошибки
		,	@err_src			nvarchar(max)		-- Источник ошибки
		,	@err_desc			nvarchar(max)		-- Описание ошибки
		,	@http_status		int					-- Код ответа сервера
		,	@err_id				int					-- Код ошибки процедуры sp_OAGetErrorInfo
		,	@ResolveTimeOut		int = 120 * 1000	-- Время ожидания поиска хоста
		,	@ConnectTimeOut		int = 10 * 1000		-- Время ожидания соединения
		,	@SendTimeOut		int = 120 * 1000	-- Время ожидания отправки
		,	@ReceiveTimeOut		int = 240 * 1000	-- Время ожидания ответа
		,	@C_Header_UserName		NVARCHAR(4000)	--	Имя пользователя для хидера.
		,	@C_Header_PassWord		NVARCHAR(4000)	--	Пароль для хидера.


	EXEC @err = sys.sp_OACreate 'MSXML2.ServerXMLHTTP', @ole_obj OUTPUT
	IF @err = 0 
	BEGIN	
		
	 
		EXEC @err = sys.sp_OAMethod @ole_obj ,'setTimeouts' ,NULL , @ResolveTimeOut, @ConnectTimeOut, @SendTimeOut, @ReceiveTimeOut
		IF @err <> 0 BEGIN SELECT @err_str = 'Ошибка при выполнении метода "setTimeouts".' GOTO GETERROR END
 
		EXEC @err = sys.sp_OAMethod @ole_obj ,'setRequestHeader'	,NULL ,'Content-Type','text/xml; charset=utf-8;'
		IF @err <> 0 BEGIN SELECT @err_str = 'Ошибка при выполнении метода "setRequestHeader" (Content-Type).' GOTO GETERROR END
			



	

		IF @soap_action IS NOT NULL BEGIN
			EXEC @err = sys.sp_OAMethod @ole_obj ,'setRequestHeader'	,NULL ,'SOAPAction', @soap_action
			IF @err <> 0 BEGIN SELECT @err_str = 'Ошибка при выполнении метода "setRequestHeader" (SOAPAction).' GOTO GETERROR END
		END
 
		EXEC @err = sys.sp_OAMethod @ole_obj,'send',NULL,@request
		IF @err <> 0 BEGIN SELECT @err_str = 'Ошбика при выполнении метода "SEND".' GOTO GETERROR END
	 
		EXEC @err = sys.sp_OAGetProperty @ole_obj ,'status' ,@http_status OUT
			 
		IF @err <> 0 BEGIN SELECT @err_str = 'Ошбика при получении HTTP статуса ответа: ' + CONVERT(varchar(max), @http_status) GOTO GETERROR END
		IF ISNULL(@http_status, -1) not in (200,500) BEGIN SELECT @err=-1, @err_str = 'Неверный статус HTTP ответа: ' + CONVERT(varchar(max), @http_status) GOTO GETERROR END		
		 
		DECLARE
			@response TABLE (response varchar(max))
		INSERT INTO @response
		EXEC @err = sys.sp_OAGetProperty @ole_obj ,'responseText'
			 
		IF @err <> 0 BEGIN SELECT @err_str = 'Ошбика при получении HTTP ответа.' GOTO GETERROR END
		SELECT @result = response FROM @response
		IF @http_status = 500 BEGIN SELECT @err=-1, @err_str = 'Ошибка сервера HTTP 500: '+@result GOTO GETERROR END
 
		GOTO DESTROYOLE
		GETERROR:BEGIN
			EXEC @err_id = sys.sp_OAGetErrorInfo @ole_obj, @err_src OUTPUT, @err_desc OUTPUT
			IF @err_id = 0
				SELECT @err_str += ' Источник: ' + ISNULL(@err_src,'NULL') + ' Описание: ' + ISNULL(@err_desc,'NULL') + ' Код ошибки: ' + CONVERT(varchar(max), @err)
			ELSE
				SELECT @err_str += ' Процедура sp_OAGetErrorInfo вернула ошибку: ' + CONVERT(varchar(max), @err_id)
		END
		DESTROYOLE:EXEC sys.sp_OADestroy @ole_obj
		IF @err <> 0 RAISERROR(@err_str, 16, -1)
	END 
	ELSE 
		RAISERROR('Не удалось создать OLE объект "MSXML2.ServerXMLHTTP"', 16,-1)


	RETURN @err
END




