using System.Data.SqlClient;

namespace SI2App.Concrete.Mappers
{
    using SI2App.Dal;
    using SI2App.Mapper;
    using SI2App.Model;
    using System;
    using System.Collections.Generic;
    using System.Data;

    public class ArticleMapper : AbstractMapper<Article, int?, List<Article>>, IArticleMapper
    {
        public ArticleMapper(IContext context) : base(context)
        {
        }

        protected override string Table => "Article";

        protected override string SelectAllCommandText => $"select id, conferenceId, stateId, summary, accepted, submissionDate from {this.Table}";

        protected override string SelectCommandText => $"{this.SelectAllCommandText} where id = @id";

        protected override string UpdateCommandText => $"";

        protected override string DeleteCommandText => $"Delete from {this.Table} where articleId = @id";

        protected override string InsertCommandText => $"Insert into {this.Table}";

        protected override void DeleteParameters(IDbCommand command, Article entity) => throw new NotImplementedException();
        protected override void InsertParameters(IDbCommand command, Article entity) => throw new NotImplementedException();
        protected override Article Map(IDataRecord record) => 
            new Article
            {
                Id = record.GetInt32(0),
                //StateId = record.GetInt32(1),
                ConferenceId = record.GetInt32(2),
                Summary = record.GetString(3),
                Accepted = record.GetBoolean(4),
                SubmissionDate = record.GetDateTime(5)
            };
        protected override void SelectParameters(IDbCommand command, int? id) => 
            command.Parameters.Add(new SqlParameter("@id", id));
        
        protected override Article UpdateEntityId(IDbCommand command, Article entity) => 
            throw new NotImplementedException();
        protected override void UpdateParameters(IDbCommand command, Article entity) => throw new NotImplementedException();
    }
}
