use SI2

go

create procedure GiveRoleToUser
@email nvarchar(256),
@isAuthor bit
as
-- transaction needed ?
begin transaction
	begin try
		if @isAuthor = null
			throw
		if @isAuthor = 1
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