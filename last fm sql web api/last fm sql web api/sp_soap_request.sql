USE lastfm
GO
/****** Object:  StoredProcedure [dbo].[sp_soap_request]    Script Date: 31.07.2020 16:05:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create or ALTER PROCEDURE [dbo].[sp_soap_request]
		@url				nvarchar(max)='http://ws.audioscrobbler.com/2.0/'			--	����� �������.
	,	@result				nvarchar(max) OUTPUT	--	�����.
	,	@method				nvarchar(max) = 'GET'	--	����� ��������.
	,	@soap_action		varchar(max) = NULL		--	��������.
	,	@request			varchar(max) = NULL		--	������.

	,	@D_DateLast			varchar(max) = '786c8508f8087106e3146402b097f57c'
AS 
BEGIN	
	SET NOCOUNT ON;
 
	DECLARE
			@ole_obj			int					-- ������ �� OLE ������
		,	@err				int					-- ��� ������
		,	@err_str			varchar(max)		-- ����� ������
		,	@err_src			nvarchar(max)		-- �������� ������
		,	@err_desc			nvarchar(max)		-- �������� ������
		,	@http_status		int					-- ��� ������ �������
		,	@err_id				int					-- ��� ������ ��������� sp_OAGetErrorInfo
		,	@ResolveTimeOut		int = 120 * 1000	-- ����� �������� ������ �����
		,	@ConnectTimeOut		int = 10 * 1000		-- ����� �������� ����������
		,	@SendTimeOut		int = 120 * 1000	-- ����� �������� ��������
		,	@ReceiveTimeOut		int = 240 * 1000	-- ����� �������� ������
		,	@C_Header_UserName		NVARCHAR(4000)	--	��� ������������ ��� ������.
		,	@C_Header_PassWord		NVARCHAR(4000)	--	������ ��� ������.


	EXEC @err = sys.sp_OACreate 'MSXML2.ServerXMLHTTP', @ole_obj OUTPUT
	IF @err = 0 
	BEGIN	
		
	 
		EXEC @err = sys.sp_OAMethod @ole_obj ,'setTimeouts' ,NULL , @ResolveTimeOut, @ConnectTimeOut, @SendTimeOut, @ReceiveTimeOut
		IF @err <> 0 BEGIN SELECT @err_str = '������ ��� ���������� ������ "setTimeouts".' GOTO GETERROR END
 
		EXEC @err = sys.sp_OAMethod @ole_obj ,'setRequestHeader'	,NULL ,'Content-Type','text/xml; charset=utf-8;'
		IF @err <> 0 BEGIN SELECT @err_str = '������ ��� ���������� ������ "setRequestHeader" (Content-Type).' GOTO GETERROR END
			



	

		IF @soap_action IS NOT NULL BEGIN
			EXEC @err = sys.sp_OAMethod @ole_obj ,'setRequestHeader'	,NULL ,'SOAPAction', @soap_action
			IF @err <> 0 BEGIN SELECT @err_str = '������ ��� ���������� ������ "setRequestHeader" (SOAPAction).' GOTO GETERROR END
		END
 
		EXEC @err = sys.sp_OAMethod @ole_obj,'send',NULL,@request
		IF @err <> 0 BEGIN SELECT @err_str = '������ ��� ���������� ������ "SEND".' GOTO GETERROR END
	 
		EXEC @err = sys.sp_OAGetProperty @ole_obj ,'status' ,@http_status OUT
			 
		IF @err <> 0 BEGIN SELECT @err_str = '������ ��� ��������� HTTP ������� ������: ' + CONVERT(varchar(max), @http_status) GOTO GETERROR END
		IF ISNULL(@http_status, -1) not in (200,500) BEGIN SELECT @err=-1, @err_str = '�������� ������ HTTP ������: ' + CONVERT(varchar(max), @http_status) GOTO GETERROR END		
		 
		DECLARE
			@response TABLE (response varchar(max))
		INSERT INTO @response
		EXEC @err = sys.sp_OAGetProperty @ole_obj ,'responseText'
			 
		IF @err <> 0 BEGIN SELECT @err_str = '������ ��� ��������� HTTP ������.' GOTO GETERROR END
		SELECT @result = response FROM @response
		IF @http_status = 500 BEGIN SELECT @err=-1, @err_str = '������ ������� HTTP 500: '+@result GOTO GETERROR END
 
		GOTO DESTROYOLE
		GETERROR:BEGIN
			EXEC @err_id = sys.sp_OAGetErrorInfo @ole_obj, @err_src OUTPUT, @err_desc OUTPUT
			IF @err_id = 0
				SELECT @err_str += ' ��������: ' + ISNULL(@err_src,'NULL') + ' ��������: ' + ISNULL(@err_desc,'NULL') + ' ��� ������: ' + CONVERT(varchar(max), @err)
			ELSE
				SELECT @err_str += ' ��������� sp_OAGetErrorInfo ������� ������: ' + CONVERT(varchar(max), @err_id)
		END
		DESTROYOLE:EXEC sys.sp_OADestroy @ole_obj
		IF @err <> 0 RAISERROR(@err_str, 16, -1)
	END 
	ELSE 
		RAISERROR('�� ������� ������� OLE ������ "MSXML2.ServerXMLHTTP"', 16,-1)


	RETURN @err
END




