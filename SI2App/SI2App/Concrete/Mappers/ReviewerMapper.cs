namespace SI2App.Concrete.Mappers
{
    using SI2App.Dal;
    using SI2App.Mapper;
    using SI2App.Model;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.SqlClient;

    public class ReviewerMapper : AbstractMapper<Reviewer, int?, List<Reviewer>>, IReviewerMapper
    {
        public ReviewerMapper(IContext context) : base(context)
        {
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

        protected override Reviewer Map(IDataRecord record) => 
            new Reviewer
            {
                Id = record.GetInt32(0),
                Name = record.GetString(1),
                Email = record.GetString(2),
                InstitutionId = record.GetInt32(3)
            };

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
            var institutionId = new SqlParameter("@institutionId", entity.InstitutionId);
            var parameters = new List<SqlParameter>
            {
                id, name, email, institutionId
            };

            command.Parameters.AddRange(parameters);
        }
    }
}
