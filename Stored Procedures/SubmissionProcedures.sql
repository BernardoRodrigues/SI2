use SI2

go

create procedure InsertFile
@articleId int,
@file varbinary(MAX)
as
-- tran needed ?
begin try
	begin transaction
		insert into [File] (articleId, [file], insertionDate) values (@articleId, @file, GETDATE())
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

create type	email_array as table (
	email nvarchar(256)	not null primary key,
	isResponsible bit not null,
	articleId int
)
go

create procedure InsertSubmission
@authorsEmails email_array readonly,
@conferenceName nvarchar(128),
@conferenceYear int,
@summary nvarchar(1024),
@file varbinary(MAX),
@articleId int out
as
begin try
	begin transaction
		declare @maxDate as datetime
		select @maxDate = submissionDate from Conference where Conference.name = @conferenceName AND Conference.[year] = @conferenceYear
		if (@maxDate < GETDATE())
			begin
				declare @id as int
				select @articleId = SCOPE_IDENTITY()
				insert into Article (conferenceName, conferenceYear, summary, submissionDate) 
		
				values (@conferenceName, @conferenceYear, @summary, GETDATE())
				exec InsertFile @articleId = @id, @file = @file
				update @authorsEmails
				set articleId = @articleId
				declare @authorEmail as nvarchar(256)
				declare @isResponsible as bit
				declare cur cursor local forward_only
				for select * from @authorsEmails
				open cur
				fetch next into @authorEmail, @isResponsible, @articleId
				while @@FETCH_STATUS = 0
					begin
						insert into ArticleAuthor(articleId, authorEmail, isResponsible) values (@articleId, @authorEmail, @isResponsible)
						fetch next into @authorEmail, @isResponsible, @articleId
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

create procedure UpdateSubmission
@articleId int,
@summary nvarchar(1024),
@stateId int,
@accepted bit
as
begin try
	begin transaction
		update Article
		set summary = @summary, stateId = @stateId, accepted = @accepted
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
