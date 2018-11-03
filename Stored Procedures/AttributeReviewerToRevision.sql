use SI2

go

create procedure AttributeReviewerToRevision
@articleId int,
@reviewerEmail nvarchar(256)
as
begin try
	begin transaction
		insert into ArticleReviewer(articleId, reviewerEmail) values (@articleId, @reviewerEmail)
		declare @stateId as int
		select @stateId = id from ArticleState where [state] = 'em revisão'
		update Article
		set stateId  = @stateId
		where id = @articleId
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