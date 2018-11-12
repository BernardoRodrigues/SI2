use SI2
if OBJECT_ID ('dbo.InsertFile') is not null
	drop proc dbo.InsertFile
go

create procedure InsertFile
@articleId int,
@file varbinary(MAX)
as
begin try
	insert into [File] (articleId, [file], insertionDate) values (@articleId, @file, GETDATE())
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

if OBJECT_ID('dbo.authors') is not null
	drop type dbo.authors
go

create type	authors as table (
	authorId int primary key not null,
	isResponsible bit not null,
	articleId int
)
go

if OBJECT_ID ('dbo.InsertSubmission') is not null
	drop proc dbo.InsertSubmission
go

create procedure InsertSubmission
@authors authors readonly,
@conferenceId int,
@summary nvarchar(1024),
@file varbinary(MAX),
@articleId int out
as
begin try
	begin transaction
		declare @maxDate as datetime
		select @maxDate = submissionDate from Conference where Conference.id = @conferenceId
		if (@maxDate > GETDATE())
			begin
				declare @id as int
				insert into Article (conferenceId, summary, submissionDate, stateId) 
				values (@conferenceId, @summary, GETDATE(), 1)
				select @articleId = SCOPE_IDENTITY()
				exec InsertFile @articleId, @file
				declare @table as authors
				insert into @table select * from @authors
				update @table
				set articleId = @articleId
				declare @authorId as int
				declare @isResponsible as bit
				declare cur cursor local forward_only
				for select * from @table
				open cur
				fetch next from cur into @authorId, @isResponsible, @articleId
				while @@FETCH_STATUS = 0
					begin
						exec dbo.InsertArticleAuthor @articleId, @authorId, @isResponsible
						fetch next from cur into @authorId, @isResponsible, @articleId
					end
				close cur
				deallocate cur
				commit transaction
			end
		else
			begin
				set @articleId = -1
				raiserror('The submission date has already passed', 5, -1)
			end
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

if OBJECT_ID('dbo.DeleteSubmission') is not null
	drop proc dbo.DeleteSubmission
go


create procedure DeleteSubmission
@articleId int
as
begin try
	begin transaction
		delete from [File]
		where articleId = @articleId
		delete from ArticleAuthor
		where articleId = @articleId
		delete from ArticleReviewer
		where articleId = @articleId
		delete from Article
		where id = @articleId
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

if OBJECT_ID('dbo.UpdateSubmission') is not null 
	drop proc dbo.UpdateSubmission
go

create procedure UpdateSubmission
@articleId int,
@summary nvarchar(1024),
@stateId int,
@accepted bit
as
begin try
	begin transaction
		update Article
		set summary = isnull(@summary, summary),
		 stateId = isnull(@stateId, stateId),
		 accepted = isnull(@accepted, accepted)
		where id = @articleId
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
