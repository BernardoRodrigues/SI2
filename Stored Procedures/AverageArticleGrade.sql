use SI2
if OBJECT_ID('dbo.articleAverageGrade') is not null
	drop proc dbo.articleAverageGrade
go

create proc articleAverageGrade @id int=NULL 
as
if(@id is not null)
	Select AVG(grade) from ArticleReviewer where articleId = @id
else 
	-- error
return 1

