use SI2
if OBJECT_ID('dbo.articleAverageGrade') is not null
	drop proc dbo.ArticleAverageGrade
go

create proc ArticleAverageGrade 
@id int = NULL 
as
if (@id is not null)
	Select AVG(grade) as gradeAverage from ArticleReviewer where articleId = @id
else 
	raiserror('The parameter @id cannot be null', 5, -1)
go

