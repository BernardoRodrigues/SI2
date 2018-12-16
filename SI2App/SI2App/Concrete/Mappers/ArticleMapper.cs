namespace SI2App.Concrete.Mappers
{
    using SI2App.Dal;
    using SI2App.Mapper;
    using SI2App.Model;
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.SqlClient;

    public class ArticleMapper : AbstractMapper<Article, int?, List<Article>>, IArticleMapper
    {

        internal List<Author> LoadAuthors(Article article)
        {
            var authors = new List<Author>();
            var mapper = new AuthorMapper(this.context);

            var parameters = new List<IDataParameter>
            {
                new SqlParameter("@id", article.Id)
            };

            using (var reader = this.ExecuteReader("select authorId from ArticleAuthor where articleId = @id", parameters))
            {
                while (reader.Read()) authors.Add(mapper.Read(reader.GetInt32(0)));
            }
            return authors;
        }

        internal List<Reviewer> LoadReviewers(Article article)
        {
            var reviewers = new List<Reviewer>();
            var mapper = new ReviewerMapper(this.context);

            var parameters = new List<IDataParameter>
            {
                new SqlParameter("@id", article.Id)
            };

            using (var reader = this.ExecuteReader("select reviewerId from ArticleReviewer where articleId = @id", parameters))
            {
                while (reader.Read()) reviewers.Add(mapper.Read(reader.GetInt32(0)));
            }
            return reviewers;
        }

        public ArticleMapper(IContext context) : base(context)
        {
        }

        protected override string Table => "Article";

        protected override string SelectAllCommandText => $"select id, conferenceId, stateId, summary, accepted, submissionDate from {this.Table}";

        protected override string SelectCommandText => $"{this.SelectAllCommandText} where id = @id";

        protected override string UpdateCommandText => $"UpdateSubmission";

        protected override string DeleteCommandText => "DeleteSubmission";

        protected override string InsertCommandText => "InsertSubmission";

        public override Article Create(Article entity) => base.Create(entity);

        protected override void DeleteParameters(IDbCommand command, Article entity) => throw new NotImplementedException();
        protected override void InsertParameters(IDbCommand command, Article entity) => throw new NotImplementedException();

        protected override Article Map(IDataRecord record) =>
            new ArticleProxy(
                record.GetInt32(0),
                (ArticleState)record.GetInt32(2),
                record.GetInt32(1),
                record.GetString(3),
                record.GetBoolean(4),
                record.GetDateTime(5),
                this.context
            );

        protected override void SelectParameters(IDbCommand command, int? id) => throw new NotImplementedException();
        protected override Article UpdateEntityId(IDbCommand command, Article entity) => throw new NotImplementedException();
        protected override void UpdateParameters(IDbCommand command, Article entity) => throw new NotImplementedException();
    }
}
