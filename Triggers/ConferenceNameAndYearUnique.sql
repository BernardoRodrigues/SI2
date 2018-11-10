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
declare @year int
select @name = name, @year = [year] from inserted
if Exists(Select C.name , C.[year] from Conference C where C.name = @name and C.year = @year)
	begin
        rollback transaction;
		raiserror ('The combination of year and name must be unique', 10, -1);	
	end
go