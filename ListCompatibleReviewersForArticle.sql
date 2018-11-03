use SI2

go

create procedure GetCompatibleReviewersForArticle
@articleId int
as
begin transaction
	begin try
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
		) as Aux on Aux.email = [User].email
		where Aux.institutionName != [User].institutionName
	end try
	begin catch
		throw
	end catch
go