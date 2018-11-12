use SI2

go

prepare_give_role_to_user_test:
set nocount on
insert into ArticleState (id, state) values (1, 'Submitted');
insert into ArticleState (id, state) values (2, 'Under Review');
insert into ArticleState (id, state) values (3, 'Accepted');
insert into ArticleState (id, state) values (4, 'Rejected');
declare @date as datetime
select @date = datefromparts(2018, 12, 20)
insert into Conference (name, year, acronym, submissionDate)
values ('Web Summit', 2018, 'WS', @date)
declare @conferenceId int
select @conferenceId = SCOPE_IDENTITY()
insert into Institution (name, country, acronym, address) 
values ('Instituto Superior de Engenharia de Lisboa', 'Portugal', 'ISEL', 'Lisbon')
declare @institutionId int
select @institutionId = SCOPE_IDENTITY()
insert into [User] (email, name, institutionId) values ('xtpo1@gmail.com', 'Jon Doe 1', @institutionId)
declare @userId1 int
select @userId1 = SCOPE_IDENTITY()
insert into ConferenceUser (conferenceId, userId, registrationDate) values (@conferenceId, @userId1, getdate())
insert into [User] (email, name, institutionId) values ('xtpo2@gmail.com', 'Jon Doe 2', @institutionId)
declare @userId2 int
select @userId2 = SCOPE_IDENTITY()
insert into ConferenceUser (conferenceId, userId, registrationDate) values (@conferenceId, @userId2, getdate())
insert into [User] (email, name, institutionId) values ('xtpo3@gmail.com', 'Jon Doe 3', @institutionId)
declare @userId3 int
select @userId3 = SCOPE_IDENTITY()
insert into ConferenceUser (conferenceId, userId, registrationDate) values (@conferenceId, @userId3, getdate())

-- first Article
insert into Article (conferenceId, stateId, summary, submissionDate) 
values (@conferenceId, 1, 'Some random article', getdate())
declare @articleId int
select @articleId = SCOPE_IDENTITY()
insert into [File] (articleId, [file], insertionDate) 
values (@articleId, convert(varbinary(max), 'Random bytes for the file column'), GETDATE())
goto give_role_to_user_test


give_role_to_user_test:
exec dbo.GiveRoleToUser @userId1, @articleId, 1
select * from vw_Author
--exec dbo.GiveRoleToUser @userId2, 0
--select * from vw_Reviewer
--exec dbo.GiveRoleToUser @userId3, 2
--select * from vw_Author
--select * from vw_Reviewer
goto cleanup

cleanup:
--delete from Reviewer
--delete from Author
delete from ArticleAuthor
delete from [File]
delete from Article
delete from ConferenceUser
delete from [User]
delete from Institution
delete from Conference
delete from ArticleState
dbcc checkident ('User', reseed, 0)
dbcc checkident ('Institution', reseed, 0)
dbcc checkident ('Conference', reseed, 0)
set nocount off
go
