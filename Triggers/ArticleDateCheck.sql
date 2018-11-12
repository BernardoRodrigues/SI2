use SI2
if OBJECT_ID('dbo.trg_ArticleDateCheck') is not null
	drop trigger trg_ArticleDatecheck
go

create trigger trg_ArticleDateCheck
on dbo.Article for insert
as
declare @date date 
select  @date = submissionDate from inserted
declare @confId int
declare @confSubDate date
select @confId = conferenceId from inserted
select  @confSubDate = submissionDate from Conference where Conference.id = @confId

if(@date > @confSubDate) 
	begin
        rollback transaction;
		raiserror ('The submission date has already passed', 8, -1);	
	end
go