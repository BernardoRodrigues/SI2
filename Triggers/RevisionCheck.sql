use SI2

go

create trigger trg_RevisionCheck 
on ArticleReviewer for insert
as
declare @text nvarchar(1024)
select @text = revisionText from inserted
declare @grade int
select @grade = grade from inserted
if  @text is null or @grade is null
	rollback
go
