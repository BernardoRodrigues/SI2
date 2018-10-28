use SI2

go

create procedure AttributeReviewerToRevision
@articleId int,
@reviewerEmail nvarchar(256)
as
begin transaction
	begin try
		insert into ArticleReviewer(articleId, reviewerEmail) values (@articleId, @reviewerEmail)
		update Article
		set stateId = select id from ArticleState where [state] = 'em revisão'
		where id = @articleId
		commit
	end try
	begin catch
		rollback
		throw
	end catch
end transaction
go