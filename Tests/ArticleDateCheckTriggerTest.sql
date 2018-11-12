use SI2

go

prepare_article_date_check_trigger_test:
set nocount on
declare @date as datetime
select @date = datefromparts(2018, 11, 10)
insert into Conference (name, year, acronym, submissionDate)
values ('Web Summit', 2018, 'WS', @date)
declare @conferenceId int
select @conferenceId = SCOPE_IDENTITY()
insert into ArticleState (id, state) values (1, 'Submitted');
insert into ArticleState (id, state) values (2, 'Under Review');
insert into ArticleState (id, state) values (3, 'Accepted');
insert into ArticleState (id, state) values (4, 'Rejected');

goto article_date_check_trigger_test

article_date_check_trigger_test:

-- will raise error
begin try
	insert into Article (conferenceId, stateId, summary, submissionDate) 
	values (@conferenceId, 1, 'Some random article', getdate())
end try
begin catch
	goto cleanup
end catch

cleanup:
delete from ArticleState
delete from Conference
dbcc checkident ('Conference', reseed, 0)
set nocount off
go
