use SI2

if OBJECT_ID('dbo.vw_Reviewer') is not null
	drop view dbo.vw_Reviewer

go


create view dbo.vw_Reviewer
as 
	Select * from [User] U inner join dbo.ArticleReviewer R on (U.id = R.reviewerId)
go 