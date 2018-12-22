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

        internal List<File> LoadFiles(Article article)
        {
            var files = new List<File>();
            var mapper = new FileMapper(this.context);

            var parameters = new List<IDataParameter>
            {
                new SqlParameter("@id", article.Id)
            };

            using (var reader = this.ExecuteReader("select fileId from [File] where articleId = @id", parameters))
            {
                while (reader.Read()) files.Add(mapper.Read(new Tuple<int, int?>(article.Id.Value, reader.GetInt32(0))));
            }
            return files;
        }

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

        protected override CommandType UpdateCommandType => CommandType.StoredProcedure;

        protected override string DeleteCommandText => "DeleteArticle";

        protected override CommandType DeleteCommandType => CommandType.StoredProcedure;

        protected override string InsertCommandText => "InsertArticle";

        protected override CommandType InsertCommandType => CommandType.StoredProcedure;

        protected override void DeleteParameters(IDbCommand command, Article entity) => command.Parameters.Add(new SqlParameter("@articleId", entity.Id));

        protected override void InsertParameters(IDbCommand command, Article entity)
        {

            var parameters = new List<IDataParameter>
            {
                new SqlParameter("@conferenceId", entity.ConferenceId),
                new SqlParameter("@summary", entity.Summary),
                new SqlParameter("@articleId", DbType.Int32)
                {
                    Direction = ParameterDirection.Output
                }
            };
            command.Parameters.AddRange(parameters);

        }

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

        protected override void SelectParameters(IDbCommand command, int? id) => command.Parameters.Add(new SqlParameter("@id", id));

        protected override Article UpdateEntityId(IDbCommand command, Article entity)
        {
            var parameter = command.Parameters["@id"] as SqlParameter;
            entity.Id = int.Parse(parameter.Value.ToString());
            return entity;
        }

        protected override void UpdateParameters(IDbCommand command, Article entity)
        {
            var parameters = new List<IDataParameter>
            {
                new SqlParameter("@conferenceId", entity.ConferenceId),
                new SqlParameter("@summary", entity.Summary),
                new SqlParameter("@articleId", entity.Id)
            };
        }
    }
}
