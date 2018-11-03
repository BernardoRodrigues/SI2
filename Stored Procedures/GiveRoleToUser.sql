use SI2

go

create procedure GiveRoleToUser
@email nvarchar(256),
@isAuthor bit
as
-- transaction needed ?
begin try
	begin transaction
		if (@isAuthor is null)
			raiserror('The parameters @isAuthor cannot be null', 5, -1)
		if @isAuthor = 1
			insert into Author (authorEmail) values (@email)
		else
			insert into Reviewer (reviewerEmail) values (@email)
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