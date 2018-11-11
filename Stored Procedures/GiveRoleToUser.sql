use SI2

go

create procedure GiveRoleToUser
@userId int,
@isAuthor int
as
-- transaction needed ?
begin try
	begin transaction
		if (@isAuthor is null OR @userId is null)
			raiserror('The parameters @isAuthor and @userId cannot be null', 5, -1)
		if @isAuthor = 1
			insert into Author (authorId) values (@userId)
		else if @isAuthor = 0
			insert into Reviewer (reviewerId) values (@userId)
		else if @isAuthor = 2			-- if the user is both
			begin
				insert into Author (authorId) values (@userId)
				insert into Reviewer (reviewerId) values (@userId)
			end
		else 
			raiserror(N'The parameter @isAuthor can only be: - 1 if the user is an author; - 0 if the user in a reviewer; - 2 if the user is both', 5, -1)
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