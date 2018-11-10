use SI2

go

prepare_user_update:
insert into Institution (name, country, acronym, address) 
values ('Instituto Superior de Engenharia de Lisboa', 'Portugal', 'ISEL', 'Lisbon')
declare @institutionId int
select @institutionId = SCOPE_IDENTITY()
insert into [User] (email, name, institutionId) values ('xpto@gmail.com', 'Jon Doe', @institutionId)
select * from [User]
declare @id int
select @id = id from [User]
goto update_test

update_test:
exec dbo.UpdateUser @id, null, null, 'Jon Not Doe'
select * from [User]
goto cleanup

cleanup:
delete from [User]
delete from Institution
DBCC CHECKIDENT ('Institution', RESEED, 0);
DBCC CHECKIDENT ('User', RESEED, 0);
GO