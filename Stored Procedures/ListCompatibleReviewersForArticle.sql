use SI2

go

create procedure GetCompatibleReviewersForArticle
@articleId int --, @out param to say if results exist
as
begin transaction
	begin try
		select 
		from Reviewer
		inner join [User] on ([User].email = Reviewer.reviewerEmail)
		left join (
		-- usar um stored proc / func ?
			select [User].email, [User].instituionName 
			from Author
			inner join ArticleAuthor on (ArticleAuthor.articleId <> @articleId)
			inner join [User] on ([User].email = Author.email)
		) as Aux on Aux.email = [User].email
		where Aux.instituionName <> [User].instituionName
	end try
	begin catch
		throw
	end catch
end transaction
go