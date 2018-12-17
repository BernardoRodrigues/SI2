namespace SI2App.Concrete.Mappers
{
    using SI2App.Dal;
    using SI2App.Mapper;
    using SI2App.Model;
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.SqlClient;

    public class FileMapper : AbstractMapper<File, Tuple<int, int?>, List<File>>, IFileMapper
    {
        public FileMapper(IContext context) : base(context)
        {
        }

        protected override string Table => "[File]";

        protected override string SelectAllCommandText => $"select id, articleId, file, insertionDate from {this.Table}";

        protected override string SelectCommandText => $"{this.SelectAllCommandText} where id = @id AND articleId = @articleId";

        protected override string UpdateCommandText => "Update dbo.[File] set [file]=@file , insertionDate=@insertionDate where id = @id AND articleId = @articleId";

        protected override string DeleteCommandText => $"delete from {this.Table} where id = @id AND articleId = @articleId";

        protected override string InsertCommandText => "InsertFile";

        protected override CommandType InsertCommandType => CommandType.StoredProcedure;

        protected override void DeleteParameters(IDbCommand command, File entity)
        {
            SqlParameter p1 = new SqlParameter("@id", entity.Id);
            SqlParameter p2 = new SqlParameter("@articleId", entity.ArticleId);
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                p1, p2
            };
            command.Parameters.AddRange(parameters);
        }

        protected override void InsertParameters(IDbCommand command, File entity)
        {
            var articleId = new SqlParameter("@articleId", entity.ArticleId);
            var file = new SqlParameter("@file", entity.SubmittedFile);

            command.Parameters.AddRange(new List<SqlParameter> { articleId, file });
        }
        protected override File Map(IDataRecord record) => throw new NotImplementedException();
        protected override void SelectParameters(IDbCommand command, Tuple<int, int?> id) => throw new NotImplementedException();
        protected override File UpdateEntityId(IDbCommand command, File entity) => throw new NotImplementedException();
        protected override void UpdateParameters(IDbCommand command, File entity) => throw new NotImplementedException();
    }
}
