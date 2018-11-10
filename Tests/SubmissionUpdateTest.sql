use SI2

go

prepare_submission_update:
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
goto update_test

update_test:
exec dbo.UpdateSubmission @articleId, 'new summary', null, null
select * from Article
goto cleanup


cleanup:
delete from [File]
delete from Article
delete from Conference
delete from ArticleState
dbcc checkident ('Article', RESEED, 0);
dbcc checkident ('File', RESEED, 0);
dbcc checkident ('Conference', RESEED, 0);
go