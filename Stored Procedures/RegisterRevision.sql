use SI2

go

create procedure RegisterRevision
@articleId int,
@revisionText nvarchar(1024),
@grade int
as
-- tran needed ?
begin transaction
	begin try
		update ArticleReviewer
		set revisionText = @revisionText, grade = @grade
		where articleId = @articleId
		commit
	end try
	begin catch
		rollback
		throw
	end catch
end transaction
go
