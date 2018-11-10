use SI2

go

prepare_submission_insertion:
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
insert into Institution (name, country, acronym, address) 
values ('Instituto Superior de Engenharia de Lisboa', 'Portugal', 'ISEL', 'Lisbon')
declare @institutionId int
select @institutionId = SCOPE_IDENTITY()
insert into [User] (email, name, institutionId) values ('xpto1@gmail.com', 'Jon Doe 1', @institutionId)
insert into [User] (email, name, institutionId) values ('xpto2@gmail.com', 'Jon Doe 2', @institutionId)
insert into [User] (email, name, institutionId) values ('xpto3@gmail.com', 'Jon Doe 3', @institutionId)
insert into [User] (email, name, institutionId) values ('xpto4@gmail.com', 'Jon Doe 4', @institutionId)
goto insertion_test

insertion_test:
declare @file as varbinary(max)
select @file = convert(varbinary(max), 'some bytes to test file')
declare @authors as authors
insert into @authors values (1, 0, null)
insert into @authors values (2, 1, null)
insert into @authors values (3, 0, null)
insert into @authors values (4, 0, null)
declare @articleId int
exec dbo.InsertSubmission @authors, @conferenceId, 'Summary for test', @file, @articleId
select * from [File]
select * from Article
select * from ArticleAuthor
goto cleanup

cleanup:
delete from [File]
delete from ArticleAuthor
delete from [User]
delete from Article
delete from Conference
delete from ArticleState
dbcc checkident ('Article', RESEED, 0);
dbcc checkident ('File', RESEED, 0);
dbcc checkident ('Conference', RESEED, 0);
dbcc checkident ('User', RESEED, 0);
go