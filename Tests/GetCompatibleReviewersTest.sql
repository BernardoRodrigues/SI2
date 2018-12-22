--use master 
use  SI2
go

prepare_list_compatible_reviewers_for_article_test:
set nocount on
declare @date as datetime
select @date = datefromparts(2018, 12, 20)
insert into Conference (name, year, acronym, submissionDate)
values ('Web Summit', 2018, 'WS', @date)
declare @conferenceId int
select @conferenceId = SCOPE_IDENTITY()

-- first Institution
insert into Institution (name, country, acronym, address) 
values ('Instituto Superior de Engenharia de Lisboa', 'Portugal', 'ISEL', 'Lisbon')
declare @institutionId int
select @institutionId = SCOPE_IDENTITY()

-- second Institution
insert into Institution (name, country, acronym, address) 
values ('Instituto Superior de Lisboa', 'Portugal', 'ISL', 'Lisbon')
declare @institutionId2 int
select @institutionId2= SCOPE_IDENTITY()

-- third Institution
insert into Institution (name, country, acronym, address) 
values ('Instituto Superior do Porto', 'Portugal', 'ISP', 'Porto')
declare @institutionId3 int
select @institutionId3 = SCOPE_IDENTITY()

--insert into ArticleState (id, state) values (1, 'Submitted');
--insert into ArticleState (id, state) values (2, 'Under Review');
--insert into ArticleState (id, state) values (3, 'Accepted');
--insert into ArticleState (id, state) values (4, 'Rejected');

-- not compatible Reviewer
insert into [User] (email, name, institutionId) values ('xpto@gmail.com', 'Jon Doe', @institutionId)
declare @userId int
select @userId = SCOPE_IDENTITY()
insert into ConferenceUser (conferenceId, userId, registrationDate) values (@conferenceId, @userId, getdate())
insert into dbo.Reviewer(reviewerId) values (@userId)

-- compatible Reviewer
insert into [User] (email, name, institutionId) values ('xpto2@gmail.com', 'Jon Doe 2', @institutionId2)
declare @userId2 int
select @userId2 = SCOPE_IDENTITY()
insert into ConferenceUser (conferenceId, userId, registrationDate) values (@conferenceId, @userId2, getdate())
insert into dbo.Reviewer(reviewerId) values (@userId2)

-- not compatible Reviewer
insert into [User] (email, name, institutionId) values ('xpto3@gmail.com', 'Jon Doe 3', @institutionId)
declare @userId3 int
select @userId3 = SCOPE_IDENTITY()
insert into ConferenceUser (conferenceId, userId, registrationDate) values (@conferenceId, @userId3, getdate())
insert into Reviewer (reviewerId) values (@userId3)
insert into Author (authorId) values (@userId3)

-- author, not reviewer
insert into [User] (email, name, institutionId) values ('xpto4@gmail.com', 'Jon Doe 4', @institutionId)
declare @userId4 int
select @userId4 = SCOPE_IDENTITY()
insert into ConferenceUser (conferenceId, userId, registrationDate) values (@conferenceId, @userId4, getdate())
insert into Author (authorId) values (@userId4)

-- compatible Reviewer
insert into [User] (email, name, institutionId) values ('xpto5@gmail.com', 'Jon Doe 5', @institutionId2)
declare @userId5 int
select @userId5 = SCOPE_IDENTITY()
insert into ConferenceUser (conferenceId, userId, registrationDate) values (@conferenceId, @userId5, getdate())
insert into Reviewer (reviewerId) values (@userId5)
insert into Author (authorId) values (@userId5)

-- compatible Reviewer
insert into [User] (email, name, institutionId) values ('xpto6@gmail.com', 'Jon Doe 6', @institutionId3)
declare @userId6 int
select @userId6 = SCOPE_IDENTITY()
insert into ConferenceUser (conferenceId, userId, registrationDate) values (@conferenceId, @userId6, getdate())
insert into Reviewer (reviewerId) values (@userId6)


-- first Article
insert into Article (conferenceId, stateId, summary, submissionDate) 
values (@conferenceId, 1, 'Some random article', getdate())
declare @articleId int
select @articleId = SCOPE_IDENTITY()
insert into [File] (articleId, [file], insertionDate) 
values (@articleId, convert(varbinary(max), 'Random bytes for the file column'), GETDATE())


-- second Article
insert into Article (conferenceId, stateId, summary, submissionDate) 
values (@conferenceId, 1, 'Some random article 2', getdate())
declare @articleId2 int
select @articleId2 = SCOPE_IDENTITY()
insert into [File] (articleId, [file], insertionDate) 
values (@articleId2, convert(varbinary(max), 'Random bytes for the file column 2'), GETDATE())


insert into ArticleAuthor (articleId, authorId, isResponsible) values (@articleId, @userId3, 1)
insert into ArticleAuthor (articleId, authorId, isResponsible) values (@articleId, @userId4, 1)
insert into ArticleAuthor (articleId, authorId, isResponsible) values (@articleId2, @userId5, 1)
goto list_compatible_reviewers_for_article_test

list_compatible_reviewers_for_article_test:
exec dbo.GetCompatibleReviewersForArticle @articleId
goto cleanup

cleanup:
delete from ArticleAuthor
delete from ArticleReviewer
delete from ConferenceUser
delete from Reviewer
delete from Author
delete from [User]
delete from Institution
delete from [File]
delete from Article
delete from Conference
dbcc checkident ('User', reseed, 0)
dbcc checkident ('Institution', reseed, 0)
dbcc checkident ('File', reseed, 0)
dbcc checkident ('Article', reseed, 0)
dbcc checkident ('Conference', reseed, 0)
set nocount off
go