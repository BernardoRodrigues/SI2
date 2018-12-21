-- use master
use SI2

-- Conference
insert into dbo.Conference(name,[year], acronym, submissionDate) values('Web Summit', 2015 , 'WS15', DATEFROMPARTS(2015,03,31))
insert into dbo.Conference(name,[year], acronym,submissionDate) values('Web Summit', 2016 , 'WS16', DATEFROMPARTS(2016,03,31))
insert into dbo.Conference(name,[year], acronym,submissionDate) values('Web Summit', 2017 , 'WS17', DATEFROMPARTS(2017,03,31))

--Institution
insert into dbo.Institution(name, address, country, acronym) values ('Instituto Superior de Engenharia de Lisboa','Rua Conselheiro Emídio Navarro, 1 Lisboa','Portugal', 'ISEL')
insert into dbo.Institution(name, address, country, acronym) values ('Massachusetts Institute of Technology', '	Cambridge, Massachusetts, U.S','United States of America', 'MIT')
insert into dbo.Institution(name, address, country, acronym) values ('Universidad Complutense de Madrid','Avda. de Séneca, 2 Madrid', 'Spain',' UCM')

-- User
declare @user1 int
declare @user2 int
declare @user3 int
insert into dbo.[User](email, institutionId, name) values ('0000@isel.ipl.pt', 1, 'A'); Select @user1 = SCOPE_IDENTITY();
insert into dbo.[User](email, institutionId, name) values ('0001@mit.edu.pt', 2, 'B'); Select @user2 = SCOPE_IDENTITY();
insert into dbo.[User](email, institutionId, name) values ('0002@ucm.edu.pt', 3, 'C'); Select @user3 = SCOPE_IDENTITY();

-- Author
insert into Author(authorId) values (@user1)
insert into Author(authorId) values (@user2)
insert into Author(authorId) values (@user3)

-- Reviewer
insert into Reviewer(reviewerId) values (@user1)
insert into Reviewer(reviewerId) values (@user2)
insert into Reviewer(reviewerId) values (@user3)

-- Article
insert into dbo.Article(conferenceId, stateId, summary, submissionDate) values (1, 1, 'TODO', DATETIMEFROMPARTS(2015, 01, 10,20,0,0,0)) 
insert into dbo.Article(conferenceId, stateId, summary, submissionDate) values(2, 1, 'TODO', DATETIMEFROMPARTS(2016, 02, 10, 17,0,0,0))
insert into dbo.Article(conferenceId, stateId, summary, submissionDate) values(3, 1, 'TODO', DATETIMEFROMPARTS(2017, 03, 10, 15,0,0,0))


-- Conference_User
insert into dbo.ConferenceUser(conferenceId, userId, registrationDate) values (1, 1, DATETIMEFROMPARTS(2015, 01, 01, 16,0,0,0))
insert into dbo.ConferenceUser(conferenceId, userId, registrationDate) values (2, 1, DATETIMEFROMPARTS(2016, 01, 01, 14,0,0,0))
insert into dbo.ConferenceUser(conferenceId, userId, registrationDate) values (3, 1, DATETIMEFROMPARTS(2017, 01, 01,15,0,0,0))

insert into dbo.ConferenceUser(conferenceId, userId, registrationDate) values (1, 2, DATETIMEFROMPARTS(2015, 02, 01,17,0,0,0))
insert into dbo.ConferenceUser(conferenceId, userId, registrationDate) values (2, 2, DATETIMEFROMPARTS(2016, 02, 01,13,0,0,0))
insert into dbo.ConferenceUser(conferenceId, userId, registrationDate) values (3, 2, DATETIMEFROMPARTS(2017, 02, 01,18,0,0,0))

insert into dbo.ConferenceUser(conferenceId, userId, registrationDate) values (1, 3, DATETIMEFROMPARTS(2015, 03, 01, 19,0,0,0))
insert into dbo.ConferenceUser(conferenceId, userId, registrationDate) values (2, 3, DATETIMEFROMPARTS(2016, 03, 01,10,0,0,0))
insert into dbo.ConferenceUser(conferenceId, userId, registrationDate) values (3, 3, DATETIMEFROMPARTS(2017, 03, 01,11,0,0,0))

-- Article_Author
insert into dbo.ArticleAuthor(articleId,authorId,isResponsible) values (1, 1, 1)
insert into dbo.ArticleAuthor(articleId,authorId,isResponsible) values (2, 2, 1)
insert into dbo.ArticleAuthor(articleId,authorId,isResponsible) values (3, 3, 1)


-- Article_Reviewer
insert into dbo.ArticleReviewer(articleId,reviewerId,grade,revisionText) values (1, 2, 50, 'TODO')
insert into dbo.ArticleReviewer(articleId,reviewerId,grade,revisionText) values (2, 3, 75, 'TODO')
insert into dbo.ArticleReviewer(articleId,reviewerId,grade,revisionText) values (3, 1, 40, 'TODO')

use master 
go
