
declare
@method varchar(max)='user.getTopArtists'
,@username varchar(max)='dkfancska'
,@token varchar(max)='786c8508f8087106e3146402b097f57c'

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


print(@base_url)
Select @ResponseText
Select * from parseJSON(@ResponseText)

--Exec sp_OADestroy @Object
