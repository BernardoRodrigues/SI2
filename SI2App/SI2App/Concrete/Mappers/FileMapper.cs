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

<<<<<<< HEAD
        protected override string UpdateCommandText => throw new InvalidOperationException("File does not need updates");
=======
        protected override string UpdateCommandText => "Update dbo.[File] set [file]=@file , insertionDate=@insertionDate where id = @id AND articleId = @articleId";
>>>>>>> 990cce7b3d8687393f96f26cd9e0ae0af57235e0

        protected override string DeleteCommandText => "DeleteFile";

        protected override CommandType DeleteCommandType => CommandType.StoredProcedure;

        protected override string InsertCommandText => "InsertFile";

        protected override CommandType InsertCommandType => CommandType.StoredProcedure;

<<<<<<< HEAD
        protected override void DeleteParameters(IDbCommand command, File entity) => command.Parameters.Add(new SqlParameter("@articleId", entity.ArticleId));
=======
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

>>>>>>> 990cce7b3d8687393f96f26cd9e0ae0af57235e0
        protected override void InsertParameters(IDbCommand command, File entity)
        {
            var articleId = new SqlParameter("@articleId", entity.ArticleId);
            var file = new SqlParameter("@file", entity.SubmittedFile);
            var id = new SqlParameter("@id", SqlDbType.Int)
            {
                Direction = ParameterDirection.Output
            };

            command.Parameters.AddRange(new List<SqlParameter> { articleId, file, id });
        }
        protected override File Map(IDataRecord record) => new File
        {
            Id = record.GetInt32(0),
            ArticleId = record.GetInt32(1),
            SubmittedFile = (byte[])record.GetValue(2),
            InsertionDate = record.GetDateTime(3)
        };
        protected override void SelectParameters(IDbCommand command, Tuple<int, int?> id) => throw new NotImplementedException();
        protected override File UpdateEntityId(IDbCommand command, File entity) => throw new NotImplementedException();
        protected override void UpdateParameters(IDbCommand command, File entity) => throw new NotImplementedException();
    }
}
