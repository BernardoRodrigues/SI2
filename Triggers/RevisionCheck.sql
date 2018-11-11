use SI2

go

create trigger trg_RevisionCheck 
on ArticleReviewer for update
as
declare @text nvarchar(1024)
select @text = revisionText from inserted
declare @grade int
select @grade = grade from inserted
if @text is null or @grade is null
	begin
        rollback transaction;
		raiserror ('The revision text and grade must be both not null', 5, -1);	
	end
go
