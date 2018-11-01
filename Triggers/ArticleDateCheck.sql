use SI2
go

create trigger trg_ArticleDateCheck
on dbo.Article for insert
as 
declare @date date 
select  @date = submissionDate from inserted
declare @confName nvarchar(128)
declare @confYear int
declare @confSubDate date
select  @confName = conferenceName from inserted
select  @confYear = conferenceYear from inserted
select  @confSubDate = submissionDate from Conference C where C.name = @confName and C.year = @confYear

if(@date > @confSubDate)
	rollback

go