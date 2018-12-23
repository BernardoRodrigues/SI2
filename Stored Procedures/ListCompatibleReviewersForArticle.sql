-- use master
use SI2
if OBJECT_ID('dbo.GetCompatibleReviewersForArticle') is not null
	drop proc dbo.GetCompatibleReviewersForArticle
go

create procedure GetCompatibleReviewersForArticle
@articleId int 
as
begin try
	begin transaction
	select U.id, U.name, U.email, U.institutionId from [User] U where not exists(
			select * from ArticleAuthor AA where articleId = @articleId and AA.authorId = U.id 
			) 
			and not exists(							
			Select  distinct institutionId from [User] inner join ArticleAuthor on(
			 ArticleAuthor.articleId = @articleId and ArticleAuthor.authorId = [User].id)
			 where U.id = institutionId
	 )

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