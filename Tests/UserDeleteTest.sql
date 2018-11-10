use SI2

-- prepare test
prepare_user_deletion:
insert into Institution (name, country, acronym, address) 
values ('Instituto Superior de Engenharia de Lisboa', 'Portugal', 'ISEL', 'Lisbon')
declare @institutionId int
select @institutionId = SCOPE_IDENTITY()
insert into [User] (email, name, institutionId) values ('xpto@gmail.com', 'Jon Doe', @institutionId)
select * from [User]
declare @id int
select @id = id from [User]
goto deletion_test

deletion_test:
exec dbo.DeleteUser @id
select * from [User] where id = @id
goto cleanup

cleanup:
delete from [User]
delete from Institution
DBCC CHECKIDENT ('Institution', RESEED, 0);
DBCC CHECKIDENT ('User', RESEED, 0);
GO