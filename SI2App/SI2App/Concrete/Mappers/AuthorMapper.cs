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

    public class AuthorMapper : AbstractMapper<Author, int?, List<Author>>, IAuthorMapper
    {
        public AuthorMapper(IContext context) : base(context)
        {
        }

        #region LOADER METHODS
        internal List<Article> LoadArticles(Author a)
        {
            List<Article> res = new List<Article>();
            ArticleMapper am = new ArticleMapper(context);
            List<IDataParameter> parameters = new List<IDataParameter>();
            parameters.Add(new SqlParameter("@id", a.Id));
            var query = "Select articleId from dbo.ArticleAuthor where authorId=@id";
            using (IDataReader rd = ExecuteReader(query, parameters))
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

        public override Author Delete(Author entity)
        {
            CheckEntityForNull(entity, typeof(Author));
            using (TransactionScope ts = new TransactionScope(TransactionScopeOption.Required))
            {
                EnsureContext();
                context.EnlistTransaction();
                var articles = entity.Articles;
                if(articles != null && articles.Count > 0)
                {
                    SqlParameter p = new SqlParameter("@authorId", entity.Id);
                    List<IDataParameter> parameters = new List<IDataParameter>();
                    parameters.Add(p);
                    ExecuteNonQuery("delete from dbo.ArticleAuthor where authorId=@authorId", parameters);
                }
                Author del = base.Delete(entity);
                ts.Complete();
                return del;
            }
        }

        protected override string Table => "Author";

        protected override string SelectAllCommandText => 
            $"select [User].id as id, [User].name as name, [User].email as email, [User].institutionId as institutionId from {this.Table} inner join [User] on [User].id = Author.authorId";

        protected override string SelectCommandText => $"{this.SelectAllCommandText} where authorId = @id";

        protected override string UpdateCommandText => "UpdateUser";

        protected override CommandType UpdateCommandType => CommandType.StoredProcedure;

        protected override string DeleteCommandText => $"delete from {this.Table} where authorId = @id";

        protected override string InsertCommandText => $"insert into {this.Table} (authorId) values (@id)";

        protected override void DeleteParameters(IDbCommand command, Author entity) => this.SelectParameters(command, entity.Id);

        protected override void InsertParameters(IDbCommand command, Author entity) => this.SelectParameters(command, entity.Id);

        protected override Author Map(IDataRecord record)
        {
            Author a = new Author
            {
                Id = record.GetInt32(0),
                Name = record.GetString(1),
                Email = record.GetString(2),
            };
            return new AuthorProxy(a, context);
        }

        protected override void SelectParameters(IDbCommand command, int? id) => 
            command.Parameters.Add(new SqlParameter("@id", id));

        protected override Author UpdateEntityId(IDbCommand command, Author entity)
        {
            var parameter = command.Parameters["@id"] as SqlParameter;
            entity.Id = int.Parse(parameter.Value.ToString());
            return entity;
        }

        protected override void UpdateParameters(IDbCommand command, Author entity)
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
