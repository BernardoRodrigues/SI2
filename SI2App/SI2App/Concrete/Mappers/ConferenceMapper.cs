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

        internal List<Attendee> LoadAttendees(Conference conference)
        {
            var attendees = new List<Attendee>();
            var mapper = new AttendeeMapper(this.context);

            var parameters = new List<IDataParameter>
            {
                new SqlParameter("@id", conference.Id)
            };

            using (var reader = this.ExecuteReader("select userId from ConferenceUser where conferenceId = @id", parameters))
            {
                while (reader.Read()) attendees.Add(mapper.Read(reader.GetInt32(0)));
            }
            return attendees;
        }

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
        public List<Article> LoadArticles(Conference c)
        {
            List<Article> res = new List<Article>();
            ArticleMapper am = new ArticleMapper(context);
            List<IDataParameter> parameters = new List<IDataParameter>();
            parameters.Add(new SqlParameter("@id", c.Id));
            var query = "Select id from Article where conferenceId=@id";
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
        public float PercentageOfAcceptedArticles(int conference)
        {
            using (IDbCommand command = context.CreateCommand())
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandText = "GetPercentageOfAcceptedArticles";
                var percentage = new SqlParameter("@percentage", -1);
                var id = new SqlParameter("@conferenceId", conference);
                percentage.Direction = ParameterDirection.InputOutput;
                command.Parameters.Add(percentage);
                command.Parameters.Add(id);
                command.ExecuteNonQuery();
                var res = float.Parse(percentage.Value.ToString());
                return res;
            }
        }
        protected override string Table => "Conference";

        protected override string SelectCommandText => $"{this.SelectAllCommandText} where id=@id";

        protected override string UpdateCommandText => "UpdateConference";

        protected override CommandType UpdateCommandType => CommandType.StoredProcedure;

        protected override string DeleteCommandText => $"delete from {this.Table} where id = @id";

        protected override string InsertCommandText =>
            $@"insert into {this.Table}(name, year, acronym) values (@name, @year, @acronym); 
            select @id = scope_identity()";

        protected override string SelectAllCommandText => $"select id, name, year, acronym, grade, submissionDate from {this.Table}";

        protected override void DeleteParameters(IDbCommand command, Conference entity)
        {
            var parameter = new SqlParameter("@id", entity.Id);
            command.Parameters.Add(parameter);
        }

        protected override void InsertParameters(IDbCommand command, Conference entity)
        {
            var id = new SqlParameter("@conferenceId", SqlDbType.Int)
            {
                Direction = ParameterDirection.InputOutput
            };
            var name = new SqlParameter("@name", entity.Name);
            var year = new SqlParameter("@year", entity.Year);
            var acronym = new SqlParameter("@acronym", entity.Acronym);
            SqlParameter grade;
            if (entity.Grade.HasValue)
                grade = new SqlParameter("@grade", entity.Grade);
            else
                grade = new SqlParameter("@grade", DBNull.Value);

            SqlParameter submissionDate;
            if (entity.Grade.HasValue)
                submissionDate = new SqlParameter("@submissionDate", entity.SubmissionDate);
            else
                submissionDate = new SqlParameter("@submissionDate", DBNull.Value);
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

<<<<<<< HEAD
        protected override Conference Map(IDataRecord record) =>  new ConferenceProxy (
                                                                            record.GetInt32(0),
                                                                            record.GetString(1),
                                                                            record.GetInt32(2),
                                                                            record.GetString(3),
                                                                            record.IsDBNull(4)? null : (float?)record.GetValue(4),
                                                                            record.IsDBNull(4) ? null: (DateTime?)record.GetValue(5),
                                                                            this.context
        );
=======
        protected override Conference Map(IDataRecord record)
        {
            int? grade = null ;
            if (!record.IsDBNull(4)) {
                grade = record.GetInt32(4);
            }
           
           Conference c =  new Conference
                            {
                                Id = record.GetInt32(0),
                                Name = record.GetString(1),
                                Year = record.GetInt32(2),
                                Acronym = record.GetString(3),
                                Grade = grade,
                                SubmissionDate = record.GetDateTime(5)
                            };
            return new ConferenceProxy(c, context);
        }
>>>>>>> 990cce7b3d8687393f96f26cd9e0ae0af57235e0
        

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

        protected override void UpdateParameters(IDbCommand command, Conference entity) {
            this.InsertParameters(command, entity);
        }

            
    }
}
