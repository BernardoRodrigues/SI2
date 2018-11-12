use SI2

go

prepare_revision_insertion:
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
insert into Article (conferenceId, stateId, summary, submissionDate) 
values (@conferenceId, 1, 'Some random article', getdate())
declare @articleId int
select @articleId = SCOPE_IDENTITY()
insert into [File] (articleId, [file], insertionDate) 
values (@articleId, convert(varbinary(max), 'Random bytes for the file column'), GETDATE())
select * from Article
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
insert into dbo.ArticleReviewer (articleId, reviewerId, revisionText, grade)
values (@articleId, @userId, null, null)
goto insertion_test

insertion_test:
exec RegisterRevision @articleId, 'great article 10/10', 100
select * from ArticleReviewer
goto cleanup

cleanup:
delete from ConferenceUser
delete from ArticleReviewer
--delete from Reviewer
delete from [User]
delete from [File]
delete from Article
delete from ArticleState
delete from Conference
dbcc checkident ('User', reseed, 0)
dbcc checkident ('File', reseed, 0)
dbcc checkident ('Article', reseed, 0)
dbcc checkident ('Conference', reseed, 0)
set nocount off
go