use SI2

go

create procedure UpdateConference
@conferenceId int,
@name nvarchar(256),
@year int,
@acronym nvarchar(128),
@grade int,
@submissionDate datetime
as
-- tran needed ?
begin try
	begin transaction
		update Conference
		set acronym = isnull(@acronym, acronym), 
		grade = isnull(@grade, grade), 
		submissionDate = isnull(@submissionDate, submissionDate),
		name = isnull(@name, name),
		[year] = isnull(@year, [year])
		where id = @conferenceId
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
