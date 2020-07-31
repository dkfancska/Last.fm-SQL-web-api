Declare @ResponseText varchar(max)

exec  Call_WEB_API 
'user.getinfo'
,'dkfancska'
,'786c8508f8087106e3146402b097f57c'
,@ResponseText


select @ResponseText
Select * from parseJSON(@ResponseText)
--SELECT
--	jj.playcount

--    FROM OPENJSON(
--		@ResponseText
--	) WITH(
--		playcount			nvarchar(4000)		'$.playcount'

--	)  jj


