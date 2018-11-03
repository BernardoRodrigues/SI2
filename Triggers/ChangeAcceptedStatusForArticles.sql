use SI2

go

create trigger ChangeAcceptedCollumnInArticle
on dbo.Conference after update
as
	declare @conferenceName as nvarchar(128)
	declare @conferenceYear as int
	select @conferenceName = [name], @conferenceYear = [year] from inserted
	declare @grade as int
	select @grade = grade from inserted
	
	declare cur cursor LOCAL FORWARD_ONLY for
	select Article.id, ArticleReviewer.grade
	from Article
		inner join ArticleReviewer on (Article.id = ArticleReviewer.articleId)
		where Article.conferenceName = @conferenceName AND Article.conferenceYear = @conferenceYear
	open cur
	declare @articleId as int
	declare @articleGrade as int
	fetch next from cur into @articleId, @articleGrade
	declare @index as int
	set @index = 0
	while @@FETCH_STATUS = 0
		begin
			update Article
			set accepted = 
				case 
					when @articleGrade < @grade
						then 0
					else
						1
					end
				,
				stateId = 
					case
						when @articleGrade < @grade
							then 1
						else
							2
						end
			where Article.id = @articleId
			fetch next from cur into @articleId, @articleGrade
		end
	close cur
	deallocate cur
go