use SI2

go


prepare_attribute_reviewer_to_article_test:
set nocount on
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
--insert into dbo.Reviewer(reviewerId) values (@userId)
goto attribute_reviewer_to_article_test

attribute_reviewer_to_article_test:
exec dbo.AttributeReviewerToRevision @articleId, @userId
select * from ArticleReviewer
select * from Article
inner join ArticleState on (Article.stateId = ArticleState.id)
where Article.id = @articleId
exec dbo.AttributeReviewerToRevision @articleId2, @userId
select * from ArticleReviewer
select * from Article
inner join ArticleState on (Article.stateId = ArticleState.id)
where Article.id = @articleId2
goto cleanup

cleanup:
delete from ArticleReviewer
--delete from Reviewer
delete from ConferenceUser
delete from [User]
delete from [File]
delete from Institution
delete from Article
delete from Conference
delete from ArticleState
dbcc checkident ('User', reseed, 0)
dbcc checkident ('File', reseed, 0)
dbcc checkident ('Article', reseed, 0)
dbcc checkident ('Conference', reseed, 0)
dbcc checkident ('Institution', reseed, 0)
set nocount off
go