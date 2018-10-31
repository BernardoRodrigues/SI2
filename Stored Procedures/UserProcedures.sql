use SI2

go


create procedure InsertUser
@email nvarchar(256),
@institutionName nvarchar(256),
@name nvarchar(256),
@conferenceName nvarchar(256),
@conferenceYear int
as
begin transaction
	begin try
		insert into [User] (email, institutionName, name) values (@email, @institutionName, @name)
		insert into ConferenceUser (conferenceName, conferenceYear, userEmail, registrationDate) values (@conferenceName, @conferenceYear, @email, GETDATE())
		commit
	end try
	begin catch
		rollback
		throw
	end catch
end transaction
go



create procedure DeleteUser
@email nvarchar(256)
as
-- tran needed?
begin transaction
	begin try	
		delete from [User]
		where [User].email = @email	
		commit
	end try
	begin catch
		rollback
		throw
	end catch
end transaction
go

create procedure UpdateUser
@email nvarchar(256),
@institutionName nvarchar(256),
@name nvarchar(256)
as
-- tran needed?
begin transaction
	begin try	
		update [User]
		set name = @name, institutionName = @institutionName
		where email = @email
		commit
	end try
	begin catch
		rollback
		throw
	end catch
end transaction
go