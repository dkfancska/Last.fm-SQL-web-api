
Create or alter procedure Call_WEB_API
@method varchar(max)
,@username varchar(max)
,@token varchar(max)
--, @ResponseText varchar(max) OUTPUT
as
Declare @Object as Int;
Declare @ResponseText as Varchar(8000);
declare @base_url varchar(max)
set @base_url='http://ws.audioscrobbler.com/2.0/?method='+@method+'&user=' +@username+'&api_key='+@token+'&format=json'
          

Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
Exec sp_OAMethod @Object, 'open', NULL, 'get',
 @base_url,
                       'false'
Exec sp_OAMethod @Object, 'send'
Exec sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT

Select @ResponseText

Exec sp_OADestroy @Object
go