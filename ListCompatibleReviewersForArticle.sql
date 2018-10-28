use SI2

go

create procedure GetCompatibleReviewersForArticle
@articleId int
as
begin transaction
	begin try
		select 
		from Reviewer
		inner join [User] on ([User].email = Reviewer.reviewerEmail)
		left join (
			
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