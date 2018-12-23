namespace SI2App.Concrete.Mappers
{
    using SI2App.Dal;
    using SI2App.Mapper;
    using SI2App.Model;
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.SqlClient;
    using System.Transactions;

    public class AttendeeMapper : AbstractMapper<Attendee, int?, List<Attendee>>, IUserMapper
    {
        public AttendeeMapper(IContext context) : base(context)
        {
        }

        #region LOADER METHODS  
        internal List<Conference> LoadConferences(Attendee attendee)
        {
            var conferences = new List<Conference>();
            var mapper = new ConferenceMapper(this.context);
            var parameters = new List<IDataParameter>
            {
                new SqlParameter("@id", attendee.Id)
            };

            using (var reader = this.ExecuteReader("select userId from ConferenceUser where userId = @id", parameters))
            {
                while (reader.Read()) conferences.Add(mapper.Read(reader.GetInt32(0)));
            }

            return conferences;
        }



        internal Institution LoadInstitution(Attendee a)
        {
            Institution institution = null;
            var im = new InstitutionMapper(context);
            var parameters = new List<IDataParameter>();
            parameters.Add(new SqlParameter("@id", a.Id));
            var query = "Select institutionId from [User] where id=@id";
            using (var rd = ExecuteReader(query, parameters))
            {
                while (rd.Read())
                {
                    var key = rd.GetInt32(0);
                    institution = im.Read(key);
                }
            }

            return institution;
        }

        #endregion

        public override Attendee Delete(Attendee entity)
        {
            CheckEntityForNull(entity, typeof(Attendee));

            using(var ts = new TransactionScope(TransactionScopeOption.Required))
            {
                EnsureContext();
                context.EnlistTransaction();
                var conferences = entity.Conferences;
                if(conferences != null && conferences.Count > 0)
                {
                    var p = new SqlParameter("@userId", entity.Id);
                    var parameters = new List<IDataParameter>();
                    parameters.Add(p);
                    ExecuteNonQuery("delete from dbo.ConferenceUser where userId=@userId", parameters);
                }
                var del = base.Delete(entity);
                ts.Complete();
                return del;
            }
        }

        public void GiveRoleToUser(Attendee user, int role)
        {
            CheckEntityForNull(user, typeof(Attendee));
            using (IDbCommand command = context.CreateCommand())
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandText = "GiveRoleToUser";
                var parameters = new List<SqlParameter>
                {
                    new SqlParameter("@userId", user.Id),
                    new SqlParameter("@role", role)
                };
                command.Parameters.AddRange(parameters);
                command.ExecuteNonQuery();
            }
            
        }
        protected override string Table => "[User]";

        protected override string SelectAllCommandText => $"select id, name, email, institutionId from {this.Table}";

        protected override string SelectCommandText => $"{this.SelectAllCommandText} where id = @id";

        protected override string UpdateCommandText => "UpdateUser";

        protected override CommandType UpdateCommandType => CommandType.StoredProcedure;

        protected override string DeleteCommandText => "DeleteUser";

        protected override CommandType DeleteCommandType => CommandType.StoredProcedure;

        protected override string InsertCommandText => $"InsertUser";

        protected override CommandType InsertCommandType => CommandType.StoredProcedure;

        protected override void DeleteParameters(IDbCommand command, Attendee entity) => command.Parameters.Add(new SqlParameter("@id", entity.Id));

        protected override void InsertParameters(IDbCommand command, Attendee entity)
        {
            var email = new SqlParameter("@email", entity.Email);
            var institutionId = new SqlParameter("@institutionId", entity.Institution == null ? null : entity.Institution.Id);
            var name = new SqlParameter("@name", entity.Name);
            var conferenceId = new SqlParameter("@conferenceId", entity.Conferences[0]);
            var id = new SqlParameter("@id", DbType.Int32)
            {
                Direction = ParameterDirection.InputOutput
            };
            var parameters = new List<SqlParameter>
            {
                email, institutionId, name, id
            };

            if (entity.Id != null)
            {
                id.Value = entity.Id;
            }
            else
            {
                id.Value = DBNull.Value;
            }
            command.Parameters.AddRange(parameters);
        }

        protected override Attendee Map(IDataRecord record)
        {
            var a = new Attendee
            {
                Id = record.GetInt32(0),
                Email = record.GetString(2),
                Name = record.GetString(1)
            };
            return new AttendeeProxy(a, context);
        }

        protected override void SelectParameters(IDbCommand command, int? id) => command.Parameters.Add(new SqlParameter("@id", id));

        protected override Attendee UpdateEntityId(IDbCommand command, Attendee entity)
        {
            var parameter = command.Parameters["@id"] as SqlParameter;
            entity.Id = int.Parse(parameter.Value.ToString());
            return entity;
        }

        protected override void UpdateParameters(IDbCommand command, Attendee entity) => this.InsertParameters(command, entity);
    }
}
