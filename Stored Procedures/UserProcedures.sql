use SI2

go


create procedure InsertUser
@email nvarchar(256),
@institutionName nvarchar(256),
@name nvarchar(256),
@conferenceName nvarchar(256),
@conferenceYear int
as

begin try
	begin transaction
		insert into [User] (email, institutionName, name) values (@email, @institutionName, @name)
		insert into ConferenceUser (conferenceName, conferenceYear, userEmail, registrationDate) values (@conferenceName, @conferenceYear, @email, GETDATE())
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
@email nvarchar(256) not null
as
begin try	
	begin transaction
		delete from ConferenceUser
		where userEmail = @email
		delete from ArticleReviewer
		where reviewerEmail = @email
		delete from ArticleAuthor
		where authorEmail = @email
		delete from Reviewer
		where reviewerEmail = @email
		delete from Author
		where authorEmail = @email
		delete from [User]
		where [User].email = @email	
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
@email nvarchar(256),
@institutionName nvarchar(256),
@name nvarchar(256)
as
-- tran needed?
begin try	
	begin transaction
		update [User]
		set name = @name, institutionName = @institutionName
		where email = @email
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