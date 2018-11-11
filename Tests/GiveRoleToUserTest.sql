use SI2

go

prepare_give_role_to_user_test:
set nocount on
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
goto give_role_to_user_test

give_role_to_user_test:
exec dbo.GiveRoleToUser @userId1, 1
select * from Author
exec dbo.GiveRoleToUser @userId2, 0
select * from Reviewer
exec dbo.GiveRoleToUser @userId3, 2
select * from Author
select * from Reviewer
goto cleanup

cleanup:
delete from Reviewer
delete from Author
delete from ConferenceUser
delete from [User]
delete from Institution
delete from Conference
dbcc checkident ('User', reseed, 0)
dbcc checkident ('Institution', reseed, 0)
dbcc checkident ('Conference', reseed, 0)
set nocount off
go
