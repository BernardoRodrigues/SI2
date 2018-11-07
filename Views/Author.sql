use SI2

if OBJECT_ID('dbo.vw_Author') is not null
	drop view dbo.vw_Author

go


create view dbo.vw_Author
as 
	Select * from [User] U inner join dbo.ArticleAuthor A on (U.id = A.authorId)
go 