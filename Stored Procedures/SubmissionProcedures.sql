use SI2

go

create procedure InsertFile
@articleId int,
@file varbinary(MAX)
as
-- tran needed ?
begin transaction
	begin try
		insert into [File] values (articleId, [file], insertionDate) values (@articleId, @file, GETDATE())
		commit
	end try
	begin catch
		rollback
		throw
	end catch
end transaction
go

create procedure InsertSubmission
@conferenceName nvarhcar(256),
@conferenceYear int,
@summary nvarchar(1024),
@file varbinary(MAX)
-- @articleId int output ??
as
begin transaction
	begin try
		declare @maxDate as datetime
		@maxDate = select submissionDate from Conference where --?
		declare @id as int
		insert into Article (conferenceName, conferenceYear, summary, submissionDate) 
		output @articleId = Article.id -- ver acima
		values (@conferenceName, @conferenceYear, @summary, GETDATE())
		
		exec InsertFile @articleId = @id, @file = @file
		commit
		return @id
	end try
	begin catch
		rollback
		throw
	end catch
end transaction
go

create procedure DeleteSubmission
@articleId int
as
begin transaction
	begin try
		delete from [File]
		where articleId = @articleId
		delete from Article
		where id = @articleId
		commit
	end try
	begin catch
		rollback
		throw
	end catch
end transaction
go

create procedure UpdateSubmission
@articleId int,
@summary nvarchar(1024),
@stateId int,
@accepted bit
as
begin transaction
	begin try
		update Article
		set summary = @summary, stateId = @stateId, accepted = @accepted
		where id = @articleId
		commit
	end try
	begin catch
		rollback
		throw
	end catch
end transaction
go
