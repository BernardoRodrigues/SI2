use SI2

go

create view SubmissionVw as
select Article.id, Article.conferenceId, Article.summary, Article.stateId, 
ArticleState.state, Article.submissionDate, Article.accepted, [File].id as fileId, [File].[file] as submittedFile, [File].insertionDate as fileInsertionDate
from Article
inner join [File] on [File].articleId = (
	select top 1 articleId
	from [File]
	where articleId = Article.id
	order by insertionDate desc
)
inner join ArticleState on Article.stateId = ArticleState.id