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
begin try
	declare @date2 as datetime
	select @date2 = datefromparts(2018, 12, 30)
	insert into Conference (name, year, acronym, submissionDate)
	values ('Web Summit', 2018, 'WS2', @date2)
	declare @conferenceId2 int
	select @conferenceId2 = SCOPE_IDENTITY()
end try
begin catch
	goto cleanup
end catch

cleanup:
delete from Conference
dbcc checkident ('Conference', reseed, 0)
set nocount off
go
