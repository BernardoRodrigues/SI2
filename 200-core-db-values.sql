-- use master
use SI2

-- Conference
insert into Conference(name,[year], acronym, submissionDate) values('Web Summit', 2015 , 'WS15', DATEFROMPARTS(2015,03,31))
insert into Conference(name,[year], acronym,submissionDate) values('Web Summit', 2016 , 'WS16', DATEFROMPARTS(2016,03,31))
insert into Conference(name,[year], acronym,submissionDate) values('Web Summit', 2017 , 'WS17', DATEFROMPARTS(2017,03,31))

-- Article State
insert into ArticleState([state]) values('Accepted')
insert into ArticleState([state]) values('Rejected')
insert into ArticleState([state]) values('Under Review')

--Institution
insert into Institution(name, address, country, acronym) values ('Instituto Superior de Engenharia de Lisboa','Rua Conselheiro Emídio Navarro, 1 Lisboa','Portugal', 'ISEL')
insert into Institution(name, address, country, acronym) values ('Massachusetts Institute of Technology', '	Cambridge, Massachusetts, U.S','United States of America', 'MIT')
insert into Institution(name, address, country, acronym) values ('Universidad Complutense de Madrid','Avda. de Séneca, 2 Madrid', 'Spain',' UCM')

-- User
insert into [User](email, institutionName, name) values ('0000@isel.ipl.pt', 'Instituto Superior de Engenharia de Lisboa', 'A')
insert into [User](email, institutionName, name) values ('0001@mit.edu.pt', 'Massachusetts Institute of Technology', 'B')
insert into [User](email, institutionName, name) values ('0002@ucm.edu.pt', 'Universidad Complutense de Madrid', 'C')

-- Article
insert into Article(conferenceName, conferenceYear, stateId, summary, submissionDate) values ('Web Summit', 2015, 3, 'TODO', DATETIMEFROMPARTS(2015, 01, 10,20,0,0,0)) 
insert into Article(conferenceName, conferenceYear, stateId, summary, submissionDate) values('Web Summit', 2016, 3, 'TODO', DATETIMEFROMPARTS(2016, 02, 10, 17,0,0,0))
insert into Article(conferenceName, conferenceYear, stateId, summary, submissionDate) values('Web Summit', 2017, 3, 'TODO', DATETIMEFROMPARTS(2017, 03, 10, 15,0,0,0))


-- Conference_User
insert into ConferenceUser(conferenceName, conferenceYear, userEmail, registrationDate) values ('Web Summit', 2015, '0000@isel.ipl.pt',DATETIMEFROMPARTS(2015, 01, 01, 16,0,0,0))
insert into ConferenceUser(conferenceName, conferenceYear, userEmail, registrationDate) values ('Web Summit', 2016, '0000@isel.ipl.pt',DATETIMEFROMPARTS(2016, 01, 01, 14,0,0,0))
insert into ConferenceUser(conferenceName, conferenceYear, userEmail, registrationDate) values ('Web Summit', 2017, '0000@isel.ipl.pt',DATETIMEFROMPARTS(2017, 01, 01,15,0,0,0))

insert into ConferenceUser(conferenceName, conferenceYear, userEmail, registrationDate) values ('Web Summit', 2015, '0001@mit.edu.pt',DATETIMEFROMPARTS(2015, 02, 01,17,0,0,0))
insert into ConferenceUser(conferenceName, conferenceYear, userEmail, registrationDate) values ('Web Summit', 2016, '0001@mit.edu.pt',DATETIMEFROMPARTS(2016, 02, 01,13,0,0,0))
insert into ConferenceUser(conferenceName, conferenceYear, userEmail, registrationDate) values ('Web Summit', 2017, '0001@mit.edu.pt',DATETIMEFROMPARTS(2017, 02, 01,18,0,0,0))

insert into ConferenceUser(conferenceName, conferenceYear, userEmail, registrationDate) values ('Web Summit', 2015, '0002@ucm.edu.pt',DATETIMEFROMPARTS(2015, 03, 01, 19,0,0,0))
insert into ConferenceUser(conferenceName, conferenceYear, userEmail, registrationDate) values ('Web Summit', 2016, '0002@ucm.edu.pt',DATETIMEFROMPARTS(2016, 03, 01,10,0,0,0))
insert into ConferenceUser(conferenceName, conferenceYear, userEmail, registrationDate) values ('Web Summit', 2017, '0002@ucm.edu.pt',DATETIMEFROMPARTS(2017, 03, 01,11,0,0,0))

-- Author
insert into Author(authorEmail) values ('0000@isel.ipl.pt')
insert into Author(authorEmail) values ('0001@mit.edu.pt')
insert into Author(authorEmail) values ('0002@ucm.edu.pt')

-- Reviewer
insert into Reviewer(reviewerEmail) values ('0000@isel.ipl.pt')
insert into Reviewer(reviewerEmail) values ('0001@mit.edu.pt')
insert into Reviewer(reviewerEmail) values ('0002@ucm.edu.pt')

-- Article_Author
insert into ArticleAuthor(articleId,authorEmail,isResponsible) values (4, '0000@isel.ipl.pt', 1)
insert into ArticleAuthor(articleId,authorEmail,isResponsible) values (5, '0001@mit.edu.pt', 1)
insert into ArticleAuthor(articleId,authorEmail,isResponsible) values (6, '0002@ucm.edu.pt', 1)


-- Article_Reviewer
insert into ArticleReviewer(articleId,reviewerEmail,grade,revisionText) values (4, '0001@mit.edu.pt', 50, 'TODO')
insert into ArticleReviewer(articleId,reviewerEmail,grade,revisionText) values (5, '0002@ucm.edu.pt', 75, 'TODO')
insert into ArticleReviewer(articleId,reviewerEmail,grade,revisionText) values (6, '0000@isel.ipl.pt', 40, 'TODO')
