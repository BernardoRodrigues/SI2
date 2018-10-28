use SI2

go

create procedure UpdateConference
@name nvarchar(256),
@year int,
@acronym nvarchar(128),
@grade int,
@submissionDate datetime
as
begin transaction
	begin try	
		update Conference
		set acronym = @acronym, grade = @grade, submissionDate = @submissionDate
		where name = @name AND [year] = @year
		commit
	end try
	begin catch
		rollback
		throw
	end catch
end transaction
go
