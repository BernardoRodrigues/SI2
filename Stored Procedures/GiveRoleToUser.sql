use SI2

if OBJECT_ID ('dbo.GiveRoleToUser') is not null
	drop proc dbo.GiveRoleToUser
go

create procedure GiveRoleToUser
@userId int,
@articleId int,
@role int
as
-- transaction needed ?
begin try
	begin transaction
		if (@role is null OR @userId is null)
			raiserror('The parameters @role and @userId cannot be null', 5, -1)
		if @role = 1
			insert into dbo.ArticleAuthor(articleId,authorId, isResponsible) values (@articleId, @userId, 0)
		else if @role = 0
			insert into dbo.ArticleReviewer(articleId, reviewerId) values (@articleId, @userId)
		else if @role = 2			-- if the user is both
			begin
				insert into dbo.ArticleAuthor(articleId,authorId, isResponsible) values (@articleId, @userId, 0)
				insert into dbo.ArticleReviewer(articleId, reviewerId) values (@articleId, @userId)
			end
		else 
			raiserror(N'The parameter @role can only be: - 1 if the user is an author; - 0 if the user in a reviewer; - 2 if the user is both', 5, -1)
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