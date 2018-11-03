use SI2

go

create procedure RegisterRevision
@articleId int,
@revisionText nvarchar(1024),
@grade int
as
begin try
	begin transaction
		update ArticleReviewer
		set revisionText = @revisionText, grade = @grade
		where articleId = @articleId
	commit transaction
end try
begin catch
	declare @errorMessage nvarchar(max), 
    @errorSeverity int, 
    @errorState int;

    select @errorMessage = ERROR_MESSAGE() + ' Line ' + cast(ERROR_LINE() as nvarchar(5)), @errorSeverity = ERROR_SEVERITY(), @errorState = ERROR_STATE();

    if @@trancount > 0
        rollback transaction;

    raiserror (@errorMessage, @errorSeverity, @errorState);	
end catch
go
