use SI2

prepare_conference_update:
set nocount on
declare @date as datetime
select @date = datefromparts(2018, 12, 20)
insert into Conference (name, year, acronym, submissionDate)
values ('Web Summit', 2018, 'WS', @date)
declare @conferenceId int
select @conferenceId = SCOPE_IDENTITY()
select * from Conference
goto update_test

update_test:
select @date = datefromparts(2019, 12, 20)
exec UpdateConference @conferenceId, 'Web Summit Lisbon', 2019, 'WSL', null,@date 
select * from Conference
goto cleanup

cleanup:
delete from Conference
dbcc CHECKIDENT ('Conference', reseed, 0);
set nocount off
go