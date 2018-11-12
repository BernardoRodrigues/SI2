use SI2
if OBJECT_ID('dbo.GetCompatibleReviewersForArticle') is not null
	drop proc dbo.GetCompatibleReviewersForArticle
go

create procedure GetCompatibleReviewersForArticle
@articleId int 
as
begin try
	begin transaction
		select CompatibleReviewers.id, CompatibleReviewers.userName, CompatibleReviewers.email, CompatibleReviewers.institutionId, CompatibleReviewers.institutionName, CompatibleReviewers.institutionCountry, CompatibleReviewers.institutionAcronym 
			from Article
				inner join Conference on (Article.conferenceId = Conference.id)
				inner join ConferenceUser on (ConferenceUser.conferenceId = Conference.id)
				inner join (
					select distinct ([User].id) as id, [User].name as userName, [User].email as email, Institution.id as institutionId, Institution.name as institutionName, Institution.country as institutionCountry, Institution.acronym as institutionAcronym
							from [User]
								inner join Institution on ([User].institutionId = Institution.id)
								inner join (
									select [User].id,  [User].institutionId, Institution.name
									from vw_Reviewer
										inner join [User] on ([User].id = vw_Reviewer.id)
										inner join Institution on ([User].institutionId = Institution.id)
								) as Reviewers on (Reviewers.id = [User].id)
								inner join (
									select [User].id,  [User].institutionId, Institution.name
									from vw_Author
										inner join [User] on (vw_Author.id = [User].id)
										inner join Institution on ([User].institutionId = Institution.id)
										inner join ArticleAuthor on (ArticleAuthor.authorId = vw_Author.id)
									where ArticleAuthor.articleId = 1 
								) as Authors on (Authors.institutionId != Reviewers.institutionId)
				) as CompatibleReviewers on (CompatibleReviewers.id = ConferenceUser.userId)
			where Article.id = @articleId
	commit transaction
end try
begin catch
	declare @errorMessage nvarchar(max), 
    @errorSeverity int, 
    @errorState int;

    select @errorMessage = ERROR_MESSAGE() + ' Line ' + cast(ERROR_LINE() as nvarchar(5)), @errorSeverity = ERROR_SEVERITY(), @errorState = ERROR_STATE();

    if @@trancount > 0
        rollback transaction;

    raiserror (@errorMessage, @errorSeverity, @errorState);	
end catch
go