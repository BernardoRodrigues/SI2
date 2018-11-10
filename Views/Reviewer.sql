use SI2

if OBJECT_ID('dbo.vw_Reviewer') is not null
	drop view dbo.vw_Reviewer

go


create view dbo.vw_Reviewer
as 
	Select [User].id as id, [User].name as name, [User].email as email, [User].institutionId as institutionId 
	from [User] 
		inner join dbo.ArticleReviewer on ([User].id = ArticleReviewer.reviewerId)
go 