use SI2



go

create procedure InsertUser
@email nvarchar(256),
@institutionId nvarchar(256),
@name nvarchar(256),
@conferenceId int,
@id int out
as

begin try
	begin transaction
		if not exists (select * from [User] where email = @email)
		begin
			insert into [User] (email, institutionId, name) values (@email, @institutionId, @name)
			select @id = SCOPE_IDENTITY()
		end
		else
			select @id = id from [User] where email = @email
			insert into ConferenceUser (conferenceId, userId, registrationDate) values (@conferenceId, @id, GETDATE())
	commit transaction
end try
begin catch
	declare @ErrorMessage nvarchar(max), 
        @ErrorSeverity int, 
        @ErrorState int;

    select @ErrorMessage = ERROR_MESSAGE() + ' Line ' + cast(ERROR_LINE() as nvarchar(5)), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();

    if @@trancount > 0
        rollback transaction;

    raiserror (@ErrorMessage, @ErrorSeverity, @ErrorState);
end catch
go

create procedure DeleteUser
@id int
as
begin try	
	begin transaction
		delete from ConferenceUser
		where userId = @id
		delete from ArticleReviewer
		where reviewerId = @id
		delete from ArticleAuthor
		where authorId = @id
		delete from [User]
		where [User].id = @id
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

create procedure UpdateUser
@id int,
@email nvarchar(256),
@institutionId int,
@name nvarchar(256)
as
begin try	
	begin transaction
		update [User]
		set 
			name = isnull(@name, name), 
			institutionId = isnull(@institutionId, institutionId), 
		email = isnull(@email, email)
		where id = @id
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