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

        protected override string DeleteCommandText => throw new NotImplementedException();

        protected override string InsertCommandText => throw new NotImplementedException();

        protected override void DeleteParameters(IDbCommand command, Article entity) => throw new NotImplementedException();
        protected override void InsertParameters(IDbCommand command, Article entity) => throw new NotImplementedException();
        protected override Article Map(IDataRecord record) => throw new NotImplementedException();
        protected override void SelectParameters(IDbCommand command, int? id) => throw new NotImplementedException();
        protected override Article UpdateEntityId(IDbCommand command, Article entity) => throw new NotImplementedException();
        protected override void UpdateParameters(IDbCommand command, Article entity) => throw new NotImplementedException();
    }
}
