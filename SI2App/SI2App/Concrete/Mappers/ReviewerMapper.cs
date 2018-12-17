namespace SI2App.Concrete.Mappers
{
    using SI2App.Dal;
    using SI2App.Mapper;
    using SI2App.Mapper.Proxy;
    using SI2App.Model;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.SqlClient;
    using System.Transactions;

    public class ReviewerMapper : AbstractMapper<Reviewer, int?, List<Reviewer>>, IReviewerMapper
    {
        public ReviewerMapper(IContext context) : base(context)
        {
        }

        #region LOADER METHODS
        internal List<Article> LoadArticles(Reviewer r)
        {
            List<Article> res = new List<Article>();
            ArticleMapper am = new ArticleMapper(context);
            List<IDataParameter> parameters = new List<IDataParameter>();
            parameters.Add(new SqlParameter("@id", r.Id));
            var query = "Select articleId from dbo.ArticleReviewer where reviewerId=@id";
            using(IDataReader rd = ExecuteReader(query, parameters))
            {
                while (rd.Read())
                {
                    int key = rd.GetInt32(0);
                    res.Add(am.Read(key));
                }
            }
            return res;
        }
        #endregion

        public override Reviewer Delete(Reviewer entity)
        {
            CheckEntityForNull(entity, typeof(Reviewer));
            using (TransactionScope ts = new TransactionScope(TransactionScopeOption.Required))
            {
                EnsureContext();
                context.EnlistTransaction();
                var articles = entity.Articles;
                if (articles != null && articles.Count > 0)
                {
                    SqlParameter p = new SqlParameter("@reviewerId", entity.Id);
                    List<IDataParameter> parameters = new List<IDataParameter>();
                    parameters.Add(p);
                    ExecuteNonQuery("delete from dbo.ArticleReviewer where reviewerId=@reviewerId", parameters);
                }
                Reviewer del = base.Delete(entity);
                ts.Complete();
                return del;
            }
        }

        protected override string Table => "Reviewer";

        protected override string SelectAllCommandText => $"select [User].id as id, [User].name as name, [User].email as email, [User].institutionId as institutionId from {this.Table} inner join [User] on [User].id = {this.Table}.reviewerId";

        protected override string SelectCommandText => $"{this.SelectAllCommandText} where reviewerId = @id";

        protected override string UpdateCommandText => "UpdateUser";

        protected override CommandType UpdateCommandType => CommandType.StoredProcedure;

        protected override string DeleteCommandText => $"delete from {this.Table} where reviewerId = @id";

        protected override string InsertCommandText => $"insert into {this.Table} (reviewerId) values (@id)";

        protected override void DeleteParameters(IDbCommand command, Reviewer entity) => this.SelectParameters(command, entity.Id);

        protected override void InsertParameters(IDbCommand command, Reviewer entity) => this.SelectParameters(command, entity.Id);

        protected override Reviewer Map(IDataRecord record)
        {
            Reviewer r = new Reviewer
            {
                Id = record.GetInt32(0),
                Name = record.GetString(1),
                Email = record.GetString(2),
            };

            return new ReviewerProxy(r, context);
        }
           

        protected override void SelectParameters(IDbCommand command, int? id) => command.Parameters.Add(new SqlParameter("@id", id));

        protected override Reviewer UpdateEntityId(IDbCommand command, Reviewer entity)
        {
            var parameter = command.Parameters["@id"] as SqlParameter;
            entity.Id = int.Parse(parameter.Value.ToString());
            return entity;
        }

        protected override void UpdateParameters(IDbCommand command, Reviewer entity)
        {
            var id = new SqlParameter("@id", entity.Id);
            var name = new SqlParameter("@name", entity.Name);
            var email = new SqlParameter("@email", entity.Email);
            var institutionId = new SqlParameter("@institutionId", entity.Institution == null ? null : entity.Institution.Id);
            var parameters = new List<SqlParameter>
            {
                id, name, email, institutionId
            };

            command.Parameters.AddRange(parameters);
        }
    }
}
