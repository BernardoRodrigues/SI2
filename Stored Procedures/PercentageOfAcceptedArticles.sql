use SI2

go

create procedure GetPercentageOfAcceptedArticles
@conferenceId int,
@percentage float out
as
	declare @numberOfArticles as int
	declare @numberOfAcceptedArticles as int
	select @numberOfArticles = count(*)
	from Article
	where conferenceId = @conferenceId
	select @numberOfAcceptedArticles = count(*)
	from Article
	where conferenceId = @conferenceId AND accepted = 1
	set @percentage = (@numberOfAcceptedArticles * 100)/@numberOfArticles
go