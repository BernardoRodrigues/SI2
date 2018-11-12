use SI2

go

prepare_submission_status_change_test:
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
insert into [User] (email, name, institutionId) values ('xpto2@gmail.com', 'Jon Doe 2', @institutionId)
declare @userId2 int
select @userId2 = SCOPE_IDENTITY()
insert into ConferenceUser (conferenceId, userId, registrationDate) values (@conferenceId, @userId2, getdate())
--insert into dbo.Reviewer(reviewerId) values (@userId)
--insert into dbo.Reviewer(reviewerId) values (@userId2)
insert into dbo.ArticleReviewer (articleId, reviewerId, revisionText, grade)
values (@articleId, @userId, null, null)
insert into dbo.ArticleReviewer (articleId, reviewerId, revisionText, grade)
values (@articleId, @userId2, null, null)
insert into dbo.ArticleReviewer(articleId, reviewerId, revisionText, grade) 
values (@articleId2, @userId, null, null)

update ArticleReviewer
set grade = 70, revisionText = 'great article 7/10'
where articleId = @articleId AND reviewerId = @userId
update ArticleReviewer
set grade = 40, revisionText = 'it sucks'
where articleId = @articleId2 AND reviewerId = @userId
update ArticleReviewer
set grade = 53, revisionText = 'not bad but not great'
where articleId = @articleId AND reviewerId = @userId2
goto submission_status_change

submission_status_change:
select * 
from Article
	inner join ArticleState on (Article.stateId = ArticleState.id)
exec dbo.ChangeArticleStatus @conferenceId, 60
select * 
from Article
	inner join ArticleState on (Article.stateId = ArticleState.id)
goto cleanup

cleanup:
delete from ArticleReviewer
--delete from Reviewer
delete from ConferenceUser
delete from [User]
delete from [File]
delete from Article
delete from Conference
delete from ArticleState
dbcc checkident ('File', reseed, 0)
dbcc checkident ('User', reseed, 0)
dbcc checkident ('Article', reseed, 0)
dbcc checkident ('Conference', reseed, 0)
set nocount off
go