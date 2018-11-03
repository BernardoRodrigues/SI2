use SI2

go

create procedure InsertArticleAuthor
@articleId int,
@authorEmail nvarchar(256),
@isResponsible bit
as
begin try
	begin transaction
		insert into ArticleAuthor (articleId, authorEmail, isResponsible) values (@articleId, @authorEmail, @isResponsible)
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
