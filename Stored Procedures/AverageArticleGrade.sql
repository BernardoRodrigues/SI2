use SI2
if OBJECT_ID('dbo.articleAverageGrade') is not null
	drop proc dbo.ArticleAverageGrade
go

create proc ArticleAverageGrade 
@id int 
as
if (@id is not null)
	select AVG(ArticleReviewer.grade) as gradeAverage, Article.id as id
	from Article
		inner join ArticleReviewer on (Article.id = ArticleReviewer.articleId)
	where Article.id = @id
	group by Article.id
else 
	raiserror('The parameter @id cannot be null', 5, -1)
go

