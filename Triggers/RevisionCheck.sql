use SI2

go

create trigger trg_RevisionCheck 
on ArticleReviewer for insert
as
declare @text nvarchar(1024)
select @text = revisionText from inserted
declare @grade int
select @grade = grade from inserted
if  @text is null or @grade is null
	rollback
declare @articleId int
select @articleId = articleId from inserted

-- check if reviewer is compatible


--declare @articleId int
--select @articleId = articleId from inserted
--declare @confDate date

--declare @confName date
--declare @confYear date
--select @confName = conferenceName, @confYear = conferenceYear from Article where id = @articleId
--select @confDate = revisionDate from Conference C where C.name = @confName and C.year = @confYear

--declare @revDate date
--select @revDate = revisionDate from inserted
--if(@revDate > @confDate)
--	rollback

go
