go
if Exists(select * from sys.databases where name = 'SI2')
begin
	use master
	drop database SI2
end
create database SI2

go

use SI2

-- needs trigger for name and year to be unique
create table dbo.Conference (
	id int identity(1,1) primary key, 
	name nvarchar(128),
	[year] int check (year > 0),
	acronym nvarchar(128) not null,
	grade int check (grade >= 0 AND grade <= 100),
	submissionDate date not null,
	-- revisionDate? -- perguntar ao engenheiro
	--primary key (name, year)

)

create table dbo.ArticleState (
	-- perguntar ao engenheiro e perguntar se podemos ser determinísticos (assumir que eles são postos por ordem)
	-- talvez mais um estado enquanto não é atribuido um revisor ?
	id int primary key,
	[state] nvarchar(256) not null check ([state] in ('Submitted','Under Review', 'Accepted', 'Rejected'))

)

create table dbo.Article (

	id int identity(1, 1) primary key,
	conferenceId int, 
	stateId int references ArticleState(id),
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
	name nvarchar(256) , --primary key
	address nvarchar(256) not null,
	country nvarchar(128) not null,
	acronym nvarchar(128)

)

create table dbo.[User] (
	id int identity(1,1) primary key,
	email nvarchar(256) unique, --primary key,
	institutionId int references Institution(id),
	name nvarchar(256) not null

)

--create table dbo.Author (

--	authorEmail nvarchar(256) primary key references [User](email)

--)

--create table dbo.Reviewer (

--	reviewerEmail nvarchar(256) primary key references [User](email)

--)

create table dbo.ConferenceUser (
	conferenceId int,
	userEmail nvarchar(256) references [User](email),
	registrationDate datetime not null,
	primary key(conferenceId, userEmail),
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