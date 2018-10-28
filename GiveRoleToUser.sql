use SI2

go

create procedure GiveRoleToUser
@email nvarchar(256),
@isAthor bit
as
begin transaction
	begin try
		if @isAthor = null
			throw
		if @isAthor = 1
			insert into Author (authorEmail) values (@email)
		else
			insert into Reviewer (reviewerEmail) values (@email)
		commit
	end try
	begin catch
		rollback
		throw;
	end catch
end transaction
go