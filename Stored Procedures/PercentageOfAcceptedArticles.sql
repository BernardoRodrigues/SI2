use SI2

go

create procedure GetPercentageOfAcceptedArticles
@conferenceName nvarchar(128),
@conferenceYear int,
@percentage float out
as
	declare @numberOfArticles as int
	declare @numberOfAcceptedArticles as int
	select @numberOfArticles = count(*)
	from Article
	where conferenceName = @conferenceName AND conferenceYear = @conferenceYear
	select @numberOfAcceptedArticles = count(*)
	from Article
	where conferenceName = @conferenceName AND conferenceYear = @conferenceYear AND accepted = 1
	set @percentage = (@numberOfAcceptedArticles * 100)/@numberOfArticles
go