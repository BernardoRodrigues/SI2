namespace SI2App.Concrete.Mappers
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.SqlClient;
    using System.Transactions;
    using SI2App.Dal;
    using SI2App.Mapper;
    using SI2App.Mapper.Proxy;
    using SI2App.Model;

    public class ConferenceMapper : AbstractMapper<Conference, int?, List<Conference>>, IConferenceMapper
    {

        public ConferenceMapper(IContext context) : base(context)
        {
        }

        #region LOADER METHODS
        public List<Attendee> LoadAttendees(Conference c)
        {
            List<Attendee> res = new List<Attendee>();
            AttendeeMapper am = new AttendeeMapper(context);
            List<IDataParameter> parameters = new List<IDataParameter>();
            parameters.Add(new SqlParameter("@id", c.Id));
            var query = "Select userId from dbo.ConferenceUser where conferenceId=@id";
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

        public override Conference Delete(Conference conf)
        {
            CheckEntityForNull(conf, typeof(Conference));

            using (TransactionScope ts = new TransactionScope(TransactionScopeOption.Required))
            {
                EnsureContext();
                context.EnlistTransaction();
                var attendees = conf.Attendees;
                if(attendees != null && attendees.Count > 0)
                {
                    SqlParameter p = new SqlParameter("@confId", conf.Id);
                    List<IDataParameter> parameters = new List<IDataParameter>();
                    parameters.Add(p);
                    ExecuteNonQuery("delete from dbo.ConferenceUser where conferenceId=@confId", parameters);
                }
                Conference del = base.Delete(conf);
                ts.Complete();
                return del;
            }
        }

        protected override string Table => "Conference";

        protected override string SelectCommandText => $"{this.SelectAllCommandText} where id=@id";

        protected override string UpdateCommandText => "UpdateConference";

        protected override string DeleteCommandText => $"delete from {this.Table} where id = @id";

        protected override string InsertCommandText =>
            $@"insert into {this.Table}(name, year, acronym, grade, submissionDate) values (@name, @year, @acronym, @grade, @submissionDate); 
            select @id = scope_identity()";

        protected override string SelectAllCommandText => $"select id, name, year, acrony, grade, submissionDate from {this.Table}";

        protected override void DeleteParameters(IDbCommand command, Conference entity)
        {
            var parameter = new SqlParameter("@id", entity.Id);
            command.Parameters.Add(parameter);
        }

        protected override void InsertParameters(IDbCommand command, Conference entity)
        {
            var id = new SqlParameter("@id", SqlDbType.Int)
            {
                Direction = ParameterDirection.InputOutput
            };
            var name = new SqlParameter("@name", entity.Name);
            var year = new SqlParameter("@year", entity.Year);
            var acronym = new SqlParameter("@acronym", entity.Acronym);
            var grade = new SqlParameter("@grade", entity.Grade);
            var submissionDate = new SqlParameter("@submissionDate", entity.SubmissionDate);
            var parameters = new List<SqlParameter>()
            {
#pragma warning disable IDE0009 // Member access should be qualified.
                id, name, year, acronym, grade,
                submissionDate
#pragma warning restore IDE0009 // Member access should be qualified.
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

        protected override Conference Map(IDataRecord record)
        {
           Conference c =  new Conference
                            {
                                Id = record.GetInt32(0),
                                Name = record.GetString(1),
                                Year = record.GetInt32(2),
                                Acronym = record.GetString(3),
                                Grade = record.GetInt32(4),
                                SubmissionDate = record.GetDateTime(5)
                            };
            return new ConferenceProxy(c, context);
        }
        

        protected override void SelectParameters(IDbCommand command, int? id)
        {
            var parameter = new SqlParameter("@id", id);
            command.Parameters.Add(parameter);
        }

        protected override Conference UpdateEntityId(IDbCommand command, Conference entity)
        {
            var parameter = command.Parameters["@id"] as SqlParameter;
            entity.Id = int.Parse(parameter.Value.ToString());
            return entity;
        }

        protected override void UpdateParameters(IDbCommand command, Conference entity) => this.InsertParameters(command, entity);
    }
}
