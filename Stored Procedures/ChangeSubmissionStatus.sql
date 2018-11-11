use SI2

go

create procedure ChangeArticleStatus
@conferenceId int,
@grade int
as
begin try
	begin transaction
		declare @articleGrade int
		declare @articleId int
		declare cur cursor local forward_only for
		select Article.id, avg(ArticleReviewer.grade) as grade
		from Article 
			inner join ArticleReviewer on (Article.id = ArticleReviewer.articleId)
		where Article.conferenceId = @conferenceId
		group by Article.id
		open cur
		fetch next from cur into @articleId, @articleGrade
		while @@FETCH_STATUS = 0
			begin
				print N'Grade Average: ' + cast(@articleGrade as nvarchar(6))
				update Article
				set accepted = 
					case
						when @grade <= @articleGrade
							then 1
						else
							0
						end
					,
					stateId = 
						case
							when @grade <= @articleGrade
							then 3
						else
							4
						end
				where id = @articleId
				fetch next from cur into @articleId, @articleGrade
			end
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

create procedure ChangeSubmissionStatus
@conferenceId int,
@grade int
as
begin try
	begin transaction
		if @grade is null
			select @grade = grade from Conference where Conference.id = @conferenceId
		exec ChangeArticleStatus @conferenceId, @grade
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