use SI2

if OBJECT_ID('dbo.vw_Author') is not null
	drop view dbo.vw_Author
go


create view dbo.vw_Author
as 
	select [User].id as id, [User].name as name, [User].email as email, [User].institutionId as institutionId
	from [User]
		inner join dbo.ArticleAuthor on ([User].id = ArticleAuthor.authorId)
go 