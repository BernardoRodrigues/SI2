use SI2

go

create procedure AttributeReviewerToRevision
@articleId int,
@reviewerId nvarchar(256)
as
begin try
	begin transaction
		insert into ArticleReviewer(articleId, reviewerId) values (@articleId, @reviewerId)
		update Article
		set stateId  = 2
		where id = @articleId
	commit transaction
end try
begin catch
	declare @errorMessage nvarchar(max), 
    @errorSeverity int, 
    @errorState int;

    select @errorMessage = 
				ERROR_MESSAGE() + ' Line ' + cast(ERROR_LINE() as nvarchar(5)), @errorSeverity = ERROR_SEVERITY(), @errorState = ERROR_STATE();

    if @@trancount > 0
        rollback transaction;

    raiserror (@errorMessage, @errorSeverity, @errorState);	
end catch
go