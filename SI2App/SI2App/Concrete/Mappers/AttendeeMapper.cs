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
        internal List<Conference> LoadConferences(Attendee a)
        {
            List<Conference> res = new List<Conference>();
            ConferenceMapper cm = new ConferenceMapper(context);
            List<IDataParameter> parameters = new List<IDataParameter>();
            parameters.Add(new SqlParameter("@id", a.Id));
            var query = "Select conferenceId from dbo.ConferenceUser where userId=@id";
            using (IDataReader reader = ExecuteReader(query, parameters))
            {
                while (reader.Read())
                {
                    int key = reader.GetInt32(0);
                    res.Add(cm.Read(key));
                }
            }
            return res;
        }

        internal Institution LoadInstitution(Attendee a)
        {
            Institution institution = null;
            InstitutionMapper im = new InstitutionMapper(context);
            List<IDataParameter> parameters = new List<IDataParameter>();
            parameters.Add(new SqlParameter("@id", a.Id));
            var query = "Select institutionId from [User] where id=@id";
            using (IDataReader rd = ExecuteReader(query, parameters))
            {
                while (rd.Read())
                {
                    int key = rd.GetInt32(0);
                    institution = im.Read(key);
                }
            }

            return institution;
        }

        #endregion

        public override Attendee Delete(Attendee entity)
        {
            CheckEntityForNull(entity, typeof(Attendee));

            using(TransactionScope ts = new TransactionScope(TransactionScopeOption.Required))
            {
                EnsureContext();
                context.EnlistTransaction();
                var conferences = entity.Conferences;
                if(conferences != null && conferences.Count > 0)
                {
                    SqlParameter p = new SqlParameter("@userId", entity.Id);
                    List<IDataParameter> parameters = new List<IDataParameter>();
                    parameters.Add(p);
                    ExecuteNonQuery("delete from dbo.ConferenceUser where userId=@userId", parameters);
                }
                Attendee del = base.Delete(entity);
                ts.Complete();
                return del;
            }
        }
        protected override string Table => "User";

        protected override string SelectAllCommandText => $"select id, name, email, institutionId from {this.Table}";

        protected override string SelectCommandText => $"{this.SelectAllCommandText} where id = @id";

        protected override string UpdateCommandText => "UpdateUser";

        protected override CommandType UpdateCommandType => CommandType.StoredProcedure;

        protected override string DeleteCommandText => "DeleteUser";

        protected override CommandType DeleteCommandType => CommandType.StoredProcedure;

        protected override string InsertCommandText => $"InsertUser";

        protected override CommandType InsertCommandType => CommandType.StoredProcedure;

        protected override void DeleteParameters(IDbCommand command, Attendee entity) => command.Parameters.Add(new SqlParameter("@id", entity.Id));
        
        #pragma warning disable IDE0009 // Member access should be qualified.
        protected override void InsertParameters(IDbCommand command, Attendee entity)
        {
            var email = new SqlParameter("@email", entity.Email);
            var institutionId = new SqlParameter("@institutionId", entity.Institution == null ? null : entity.Institution.Id);
            var name = new SqlParameter("@name", entity.Name);
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
#pragma warning restore IDE0009 // Member access should be qualified.

        protected override Attendee Map(IDataRecord record) {
            Attendee a = new Attendee
            {
                Id = record.GetInt32(0),
                Email = record.GetString(2),
                Name = record.GetString(4),
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
