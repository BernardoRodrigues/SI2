use SI2

go

unique_year_and_name_for_conference_test:
set nocount on
declare @date as datetime
select @date = datefromparts(2018, 12, 20)
insert into Conference (name, year, acronym, submissionDate)
values ('Web Summit', 2018, 'WS', @date)
declare @conferenceId int
select @conferenceId = SCOPE_IDENTITY()

-- will raise error
declare @date2 as datetime
select @date2 = datefromparts(2018, 12, 30)
insert into Conference (name, year, acronym, submissionDate)
values ('Web Summit 2', 2018, 'WS2', @date)
declare @conferenceId2 int
select @conferenceId2 = SCOPE_IDENTITY()
goto cleanup

cleanup:
delete from Conference
dbcc checkident ('Conference', reseed, 0)
set nocount off
go