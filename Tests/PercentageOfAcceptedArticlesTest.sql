use SI2

go


prepare_average_article_grade_test:
SET NOCOUNT ON
declare @date as datetime
select @date = datefromparts(2018, 12, 20)
insert into Conference (name, year, acronym, submissionDate)
values ('Web Summit', 2018, 'WS', @date)
declare @conferenceId int
select @conferenceId = SCOPE_IDENTITY()
insert into ArticleState (id, state) values (1, 'Submitted');
insert into ArticleState (id, state) values (2, 'Under Review');
insert into ArticleState (id, state) values (3, 'Accepted');
insert into ArticleState (id, state) values (4, 'Rejected');
-- first Article
insert into Article (conferenceId, stateId, summary, submissionDate) 
values (@conferenceId, 1, 'Some random article', getdate())
declare @articleId int
select @articleId = SCOPE_IDENTITY()
insert into [File] (articleId, [file], insertionDate) 
values (@articleId, convert(varbinary(max), 'Random bytes for the file column'), GETDATE())

--second Article
insert into Article (conferenceId, stateId, summary, submissionDate) 
values (@conferenceId, 1, 'Another random article', getdate())
declare @articleId2 int
select @articleId2 = SCOPE_IDENTITY()
insert into [File] (articleId, [file], insertionDate) 
values (@articleId2, convert(varbinary(max), 'More random bytes for the file column'), GETDATE()) 

-- third Article
insert into Article (conferenceId, stateId, summary, submissionDate) 
values (@conferenceId, 1, 'And another random article', getdate())
declare @articleId3 int
select @articleId3 = SCOPE_IDENTITY()
insert into [File] (articleId, [file], insertionDate) 
values (@articleId3, convert(varbinary(max), 'More random bytes for the file column'), GETDATE()) 


-- fourth Article
insert into Article (conferenceId, stateId, summary, submissionDate) 
values (@conferenceId, 1, 'And yet another random article', getdate())
declare @articleId4 int
select @articleId4 = SCOPE_IDENTITY()
insert into [File] (articleId, [file], insertionDate) 
values (@articleId4, convert(varbinary(max), 'More random bytes for the file column'), GETDATE()) 

select * 
from Article
	inner join ArticleState on (Article.stateId = ArticleState.id)
select * from [File]
insert into Institution (name, country, acronym, address) 
values ('Instituto Superior de Engenharia de Lisboa', 'Portugal', 'ISEL', 'Lisbon')
declare @institutionId int
select @institutionId = SCOPE_IDENTITY()
insert into [User] (email, name, institutionId) values ('xpto@gmail.com', 'Jon Doe', @institutionId)
declare @userId int
select @userId = SCOPE_IDENTITY()
insert into ConferenceUser (conferenceId, userId, registrationDate) values (@conferenceId, @userId, getdate())
insert into dbo.Reviewer(reviewerId) values (@userId)
insert into dbo.ArticleReviewer (articleId, reviewerId, revisionText, grade)
values (@articleId, @userId, null, null)
insert into dbo.ArticleReviewer(articleId, reviewerId, revisionText, grade) 
values (@articleId2, @userId, null, null)
insert into dbo.ArticleReviewer(articleId, reviewerId, revisionText, grade) 
values (@articleId3, @userId, null, null)
insert into dbo.ArticleReviewer(articleId, reviewerId, revisionText, grade) 
values (@articleId4, @userId, null, null)

update ArticleReviewer
set grade = 70, revisionText = 'great article 7/10'
where articleId = @articleId
update Article
set accepted = 1
where id = @articleId

update ArticleReviewer
set grade = 16, revisionText = 'damn, it sucks'
where articleId = @articleId2
update Article
set accepted = 0
where id = @articleId2

update ArticleReviewer
set grade = 92, revisionText = 'great article 9.2/10'
where articleId = @articleId3
update Article
set accepted = 1
where id = @articleId3

update ArticleReviewer
set grade = 37, revisionText = 'it sucks'
where articleId = @articleId4
update Article
set accepted = 0
where id = @articleId4

goto average_article_grade_test

average_article_grade_test:
declare @percentage float
exec dbo.GetPercentageOfAcceptedArticles @conferenceId, @percentage out
print N'Percentage Of Accepted Articles: ' + cast(@percentage as nvarchar(6)) + '%'
goto cleanup


cleanup:
delete from ArticleReviewer
delete from ConferenceUser
delete from Reviewer
delete from [User]
delete from [File]
delete from Article
delete from Conference
delete from ArticleState
dbcc checkident ('User', reseed, 0)
dbcc checkident ('File', reseed, 0)
dbcc checkident ('Article', reseed, 0)
dbcc checkident ('Conference', reseed, 0)
SET NOCOUNT off
go