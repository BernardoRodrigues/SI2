use SI2
go

if OBJECT_ID('trg_ConferenceNameYear') is not null
	drop trigger trg_ConferenceNameYear
go

-- seems to be working
create trigger trg_ConferenceNameYear
on dbo.Conference
for insert 
as
declare @name nvarchar(128)
select @name = name from inserted  
declare @year int
select @year = year from inserted

if Exists(Select C.name , C.[year] from Conference C where C.name = @name and C.year = @year)
	-- some kind of message to warn 
	rollback tran

go