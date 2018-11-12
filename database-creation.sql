go
if Exists(select * from sys.databases where name = 'SI2')
begin
	use master
	drop database SI2
end
create database SI2

go

use SI2

create table dbo.Conference (
	id int identity(1,1) primary key, 
	name nvarchar(128) not null,
	[year] int check (year > 0) not null,
	acronym nvarchar(128) not null,
	grade int check (grade >= 0 AND grade <= 100),
	submissionDate date not null,
	-- revisionDate? -- perguntar ao engenheiro
)

create table dbo.ArticleState (
	id int primary key,
	[state] nvarchar(256) not null check ([state] in ('Submitted','Under Review', 'Accepted', 'Rejected'))

)

create table dbo.Article (

	id int identity(1, 1) primary key,
	conferenceId int, 
	stateId int references ArticleState(id) not null,
	summary nvarchar(1024) not null,
	accepted bit,
	submissionDate datetime not null,
	constraint fk_Article_Conference foreign key (conferenceId) references Conference(id)

)

create table dbo.[File] (

	id int identity(1, 1),
	articleId int not null references Article(id),
	[file] varbinary(MAX) not null,
	insertionDate datetime not null,
	primary key (id, articleId)
	
)

create table dbo.Institution (
	id int identity(1,1) primary key,
	name nvarchar(256) unique not null, --primary key
	address nvarchar(256) not null,
	country nvarchar(128) not null,
	acronym nvarchar(128) not null

)

create table dbo.[User] (
	id int identity(1,1) primary key,
	email nvarchar(256) unique not null,
	institutionId int references Institution(id),
	name nvarchar(256) not null

)

--create table dbo.Author (

--	authorId int primary key references [User](id)

--)

--create table dbo.Reviewer (

--	reviewerId int primary key references [User](id)

--)

create table dbo.ConferenceUser (
	conferenceId int,
	userId int references [User](id),
	registrationDate datetime not null,
	primary key(conferenceId, userId),
	--president bit ??
	constraint fk_User_Conference foreign key (conferenceId) references Conference(id)

)

create table dbo.ArticleAuthor (

	articleId int references Article(id),
	authorId int references [User](id),
	isResponsible bit not null,
	primary key(articleId, authorId)
	

)

create table dbo.ArticleReviewer (

	articleId int references Article(id),
	reviewerId int references [User](id),
	revisionText nvarchar(1024),
	grade int check (grade >= 0 AND grade <= 100),
	primary key (articleId, reviewerId)
	
)

if OBJECT_ID('dbo.vw_Reviewer') is not null
	drop view dbo.vw_Reviewer

go


create view dbo.vw_Reviewer
as 
	Select [User].id as id, [User].name as name, [User].email as email, [User].institutionId as institutionId 
	from [User] 
		inner join dbo.ArticleReviewer on ([User].id = ArticleReviewer.reviewerId)
go 

if OBJECT_ID('dbo.vw_Author') is not null
	drop view dbo.vw_Author
go


create view dbo.vw_Author
as 
	select [User].id as id, [User].name as name, [User].email as email, [User].institutionId as institutionId
	from [User]
		inner join dbo.ArticleAuthor on ([User].id = ArticleAuthor.authorId)
go 