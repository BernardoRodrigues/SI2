use SI2

go

prepare_user_insertion:
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
goto insertion_test

insertion_test:
exec dbo.InsertUser 'xtpo@gmail.com', @institutionId, 'Jon Doe', @conferenceId
select * from [User]
select * from ConferenceUser
goto cleanup

cleanup:
delete from ConferenceUser
delete from Conference
delete from [User]
delete from Institution
dbcc checkident ('Institution', RESEED, 0);
dbcc checkident ('User', RESEED, 0);
dbcc checkident ('Conference', RESEED, 0);
GO