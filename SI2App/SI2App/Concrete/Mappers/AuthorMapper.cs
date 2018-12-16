namespace SI2App.Concrete.Mappers
{
    using SI2App.Dal;
    using SI2App.Mapper;
    using SI2App.Model;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.SqlClient;

    public class AuthorMapper : AbstractMapper<Author, int?, List<Author>>, IAuthorMapper
    {

        internal List<Article> LoadArticles(Author author)
        {
            var articles = new List<Article>();
            var mapper = new ArticleMapper(this.context);

            var parameters = new List<IDataParameter>
            {
                new SqlParameter("@id", author.Id)
            };

            using (var reader = this.ExecuteReader("select articleId from ArticleAuthor where authorId = @id", parameters))
            {
                while (reader.Read()) articles.Add(mapper.Read(reader.GetInt32(0)));
            }
            return articles;
        }

        public AuthorMapper(IContext context) : base(context)
        {
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

        protected override Author Map(IDataRecord record) => new Author
        {
            Id = record.GetInt32(0),
            Name = record.GetString(1),
            Email = record.GetString(2),
            InstitutionId = record.GetInt32(3)
        };

        protected override void SelectParameters(IDbCommand command, int? id) => command.Parameters.Add(new SqlParameter("@id", id));

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
            var institutionId = new SqlParameter("@institutionId", entity.InstitutionId);
            var parameters = new List<SqlParameter>
            {
                id, name, email, institutionId
            };

            command.Parameters.AddRange(parameters);
        }
    }
}
