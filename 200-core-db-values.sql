-- use master
use SI2

-- Conference
insert into Conference([name],[year], [acronym],[submissionDate]) values('Web Summit', 2015 , 'WS15', DATEFROMPARTS(2015,03,31))
insert into Conference([name],[year], [acronym],[submissionDate]) values('Web Summit', 2016 , 'WS16', DATEFROMPARTS(2016,03,31))
insert into Conference([name],[year], [acronym],[submissionDate]) values('Web Summit', 2017 , 'WS17', DATEFROMPARTS(2017,03,31))

-- Article State
insert into ArticleState([state]) values('Accepted')
insert into ArticleState([state]) values('Rejected')
insert into ArticleState([state]) values('Under Review')

--Institution
insert into Institution([name], [address], [country], [acronym]) values ('Instituto Superior de Engenharia de Lisboa','Rua Conselheiro Emídio Navarro, 1 Lisboa','Portugal', 'ISEL')
insert into Institution([name], [address], [country], [acronym]) values ('Massachusetts Institute of Technology', '	Cambridge, Massachusetts, U.S','United States of America', 'MIT')
insert into Institution([name], [address], [country], [acronym]) values ('Universidad Complutense de Madrid','Avda. de Séneca, 2 Madrid', 'Spain',' UCM')

-- User
insert into [User]([email], [institutionName], [name]) values ('0000@isel.ipl.pt', 'Instituto Superior de Engenharia de Lisboa', 'A')
insert into [User]([email], [institutionName], [name]) values ('0001@mit.edu.pt', 'Massachusetts Institute of Technology', 'B')
insert into [User]([email], [institutionName], [name]) values ('0002@ucm.edu.pt', 'Universidad Complutense de Madrid', 'C')

-- Article
insert into Article([conferenceName], [conferenceYear], [stateId], [summary], [submissionDate]) values ('Web Summit', 2015, 3, 'TODO', DATEFROMPARTS(2015, 01, 10 )) 
insert into Article([conferenceName], [conferenceYear], [stateId], [summary], [submissionDate]) values ('Web Summit', 2016, 3, 'TODO', DATEFROMPARTS(2016, 02, 10 ))
insert into Article([conferenceName], [conferenceYear], [stateId], [summary], [submissionDate]) values ('Web Summit', 2017, 3, 'TODO', DATEFROMPARTS(2017, 03, 10 ))

-- Conference_User
insert into ConferenceUser([conferenceName], [conferenceYear], [userEmail], [registrationDate]) values ('Web Summit', 2015, '0000@isel.ipl.pt',DATEFROMPARTS(2015, 01, 01))
insert into ConferenceUser([conferenceName], [conferenceYear], [userEmail], [registrationDate]) values ('Web Summit', 2016, '0000@isel.ipl.pt',DATEFROMPARTS(2016, 01, 01))
insert into ConferenceUser([conferenceName], [conferenceYear], [userEmail], [registrationDate]) values ('Web Summit', 2017, '0000@isel.ipl.pt',DATEFROMPARTS(2017, 01, 01))

insert into ConferenceUser([conferenceName], [conferenceYear], [userEmail], [registrationDate]) values ('Web Summit', 2015, '0001@mit.edu.pt',DATEFROMPARTS(2015, 02, 01))
insert into ConferenceUser([conferenceName], [conferenceYear], [userEmail], [registrationDate]) values ('Web Summit', 2016, '0001@mit.edu.pt',DATEFROMPARTS(2016, 02, 01))
insert into ConferenceUser([conferenceName], [conferenceYear], [userEmail], [registrationDate]) values ('Web Summit', 2017, '0001@mit.edu.pt',DATEFROMPARTS(2017, 02, 01))

insert into ConferenceUser([conferenceName], [conferenceYear], [userEmail], [registrationDate]) values ('Web Summit', 2015, '0002@ucm.edu.pt',DATEFROMPARTS(2015, 03, 01))
insert into ConferenceUser([conferenceName], [conferenceYear], [userEmail], [registrationDate]) values ('Web Summit', 2016, '0002@ucm.edu.pt',DATEFROMPARTS(2016, 03, 01))
insert into ConferenceUser([conferenceName], [conferenceYear], [userEmail], [registrationDate]) values ('Web Summit', 2017, '0002@ucm.edu.pt',DATEFROMPARTS(2017, 03, 01))

-- Author
insert into Author([authorEmail]) values ('0000@isel.ipl.pt')
insert into Author([authorEmail]) values ('0001@mit.edu.pt')
insert into Author([authorEmail]) values ('0002@ucm.edu.pt')

-- Reviewer
insert into Reviewer([reviewerEmail]) values ('0000@isel.ipl.pt')
insert into Reviewer([reviewerEmail]) values ('0001@mit.edu.pt')
insert into Reviewer([reviewerEmail]) values ('0002@ucm.edu.pt')

-- Article_Author
insert into ArticleAuthor([articleId],[authorEmail],[isResponsible]) values (1, '0000@isel.ipl.pt', 1)
insert into ArticleAuthor([articleId],[authorEmail],[isResponsible]) values (2, '0001@mit.edu.pt', 1)
insert into ArticleAuthor([articleId],[authorEmail],[isResponsible]) values (3, '0002@ucm.edu.pt', 1)

-- Article_Reviewer
insert into ArticleReviewer([articleId],[reviewerEmail],[grade],[revisionText]) values(1, '0001@mit.edu.pt', 50, 'TODO')
insert into ArticleReviewer([articleId],[reviewerEmail],[grade],[revisionText]) values(2, '0002@ucm.edu.pt', 75, 'TODO')
insert into ArticleReviewer([articleId],[reviewerEmail],[grade],[revisionText]) values(3, '0000@isel.ipl.pt', 40, 'TODO')
