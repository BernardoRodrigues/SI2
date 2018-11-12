use SI2
go

if OBJECT_ID('dbo.[File]') is not null
	drop table dbo.[File]

if OBJECT_ID('dbo.ConferenceUser') is not null
	drop table dbo.ConferenceUser

if OBJECT_ID('dbo.ArticleReviewer') is not null
	drop table dbo.ArticleReviewer

if OBJECT_ID('dbo.ArticleAuthor') is not null
	drop table dbo.ArticleAuthor

if OBJECT_ID('dbo.Reviewer') is not null
	drop table dbo.Reviewer

if OBJECT_ID('dbo.Author') is not null
	drop table dbo.Author

if OBJECT_ID('dbo.[User]') is not null
	drop table dbo.[User]

if OBJECT_ID('dbo.Article') is not null
	drop table dbo.Article

if OBJECT_ID('dbo.ArticleState') is not null
	drop table dbo.ArticleState

if OBJECT_ID('dbo.Conference') is not null
	drop table dbo.Conference

if OBJECT_ID('dbo.Institution') is not null
	drop table dbo.Institution

go
use master