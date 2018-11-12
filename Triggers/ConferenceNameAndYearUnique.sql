use SI2

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
declare @count int
select @count = count(*) from Conference where Conference.name = @name and Conference.year = @year
if @count > 1
	begin
        rollback transaction;
		raiserror ('The combination of year and name must be unique', 5, -1);	
	end
go