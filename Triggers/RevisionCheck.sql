use SI2

go

create trigger trg_RevisionCheck 
on ArticleReviewer for update
as
declare @text nvarchar(1024)
select @text = revisionText from inserted
declare @grade int
select @grade = grade from inserted
if @text is null or @grade is null
	begin
        rollback transaction;
		raiserror ('The revision text and grade must be both not null', 5, -1);	
	end
declare @articleId int
select @articleId = articleId from inserted


-- no need to check if it's compatible
-- 


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
