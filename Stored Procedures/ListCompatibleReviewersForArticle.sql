use SI2

go

create procedure GetCompatibleReviewersForArticle
@articleId int --, @out param to say if results exist
as
begin try
	begin transaction
		select [User].name as name, [User].email as email, [User].institutionName
		from Reviewer
		inner join [User] on ([User].email = Reviewer.reviewerEmail)
		left join (
			select [User].email, [User].institutionName 
			from Article
			inner join Conference on (Conference.name = Article.conferenceName AND Conference.year = Article.conferenceYear)
			inner join ArticleAuthor on (ArticleAuthor.articleId = Article.id)
			inner join Author on (Author.authorEmail = ArticleAuthor.authorEmail)
			inner join [User] on ([User].email = Author.authorEmail)
			where ArticleAuthor.articleId <> @articleId
		-- usar um stored proc / func ?
		) as Aux on Aux.email = [User].email
		where Aux.institutionName != [User].institutionName
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