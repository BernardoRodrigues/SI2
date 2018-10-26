go
if Exists(select * from sys.databases where name= 'si2')
begin
	use master
	drop database si2
end
create database si2

go

use si2

create table Conference (
	
	[name] nvarchar(100),
	[year] int check ([year] > 0),
	[acronym] nvarchar(128) not null,
	[grade] int check (grade >= 0 AND grade <= 100),
	[submissionDate] date not null,
	primary key (name, [year])

)

create table ArticleState (

	[id] int identity (1, 1) primary key, -- ??
	[state] nvarchar(256) not null check (state IN('Under Review','Accepted','Rejected'))

)

-- Maybe have title collumn for primary key 
create table Article (

	[id] int identity(1, 1) primary key,
	[conferenceName] nvarchar(100),
	[conferenceYear] int,
	[stateId] int not null references ArticleState(id), -- ??
	[summary] nvarchar(1024) not null,
	[accepted] bit,
	[submissionDate] date not null
	constraint fk_Article_Conference foreign key ([conferenceName],[conferenceYear]) references Conference

)

create table [File] (

	[id] int identity(1, 1),
	[articleId] int not null references Article(id),
	[file] varbinary(MAX) not null,
	[timestamp] timestamp not null,
	primary key (id, articleId)
	
)

create table Institution (

	[name] nvarchar(256) primary key,
	[address] nvarchar(256) not null,
	[country] nvarchar(128) not null,
	[acronym] nvarchar(128)

)

create table [User] (

	[email] nvarchar(256) primary key,
	[institutionName] nvarchar(256) not null references Institution(name),
	[name] nvarchar(256) not null

)

create table Author (

	[authorEmail] nvarchar(256) primary key references [User](email)

)

create table Reviewer (

	[reviewerEmail] nvarchar(256) primary key references [User](email)

)

create table ConferenceUser (
	[conferenceName] nvarchar(100),
	[conferenceYear] int,
	[userEmail] nvarchar(256) references [User](email),
	[registrationDate] date not null,
	primary key([conferenceName], [conferenceYear], userEmail),
	constraint fk_User_Conference foreign key ([conferenceName],[conferenceYear]) references Conference

)

create table ArticleAuthor (

	[articleId] int references Article(id) not null,
	[authorEmail] nvarchar(256) references Author(authorEmail),
	[isResponsible] bit not null,
	primary key(articleId, authorEmail)

)

-- check if Reviewer is in Conference ?
create table ArticleReviewer (

	[articleId] int references Article(id),
	[reviewerEmail] nvarchar(256) references Reviewer(reviewerEmail),
	[revisionText] nvarchar(1024),
	[grade] int check (grade >= 0 AND grade <= 100),
	primary key (articleId, reviewerEmail)
	
)