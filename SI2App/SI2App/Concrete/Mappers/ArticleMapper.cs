using System.Data.SqlClient;

namespace SI2App.Concrete.Mappers
{
    using SI2App.Dal;
    using SI2App.Mapper;
    using SI2App.Model;
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Transactions;

    public class ArticleMapper : AbstractMapper<Article, int?, List<Article>>, IArticleMapper
    {
        public ArticleMapper(IContext context) : base(context)
        {
        }

        #region LOADER METHODS
        internal Conference LoadConference(Article a)
        {
            Conference conference = null;
            ConferenceMapper cm = new ConferenceMapper(context);
            List<IDataParameter> parameters = new List<IDataParameter>();
            parameters.Add(new SqlParameter("@id", a.Id));
            var query = "Select conferenceId from dbo.Article where id=@id";
            using(IDataReader rd = ExecuteReader(query, parameters))
            {
                while (rd.Read())
                {
                    int key = rd.GetInt32(0);
                    conference = cm.Read(key);
                }
            }

            return conference;
        }
        internal List<Author> LoadAuthors(Article a)
        {
            List<Author> res = new List<Author>();
            AuthorMapper am = new AuthorMapper(context);
            List<IDataParameter> parameters = new List<IDataParameter>();
            parameters.Add(new SqlParameter("@id", a.Id));
            var query = "Select authorId from dbo.ArticleAuthor where articleId=@id";
            using(IDataReader rd = ExecuteReader(query, parameters))
            {
                while (rd.Read())
                {
                    res.Add(am.Read(rd.GetInt32(0)));
                }
            }
            return res;
        }
        internal List<Reviewer> LoadReviewers(Article a)
        {
            List<Reviewer> res = new List<Reviewer>();
            ReviewerMapper rm = new ReviewerMapper(context);
            List<IDataParameter> parameters = new List<IDataParameter>();
            parameters.Add(new SqlParameter("@id", a.Id));
            var query = "Select reviewerId from dbo.ArticleReviewer where articleId=@id";
            using (IDataReader rd = ExecuteReader(query, parameters))
            {
                while (rd.Read())
                {
                    res.Add(rm.Read(rd.GetInt32(0)));
                }
            }
            return res;
        }
        internal List<File> LoadFiles(Article a)
        {
            List<File> res = new List<File>();
            FileMapper fm = new FileMapper(context);
            List<IDataParameter> parameters = new List<IDataParameter>();
            parameters.Add(new SqlParameter("@id", a.Id));
            var query = "Select id from dbo.[File] where articleId=@id";
            using(IDataReader rd = ExecuteReader(query, parameters))
            {
                while (rd.Read())
                {
                    res.Add(fm.Read(new Tuple<int, int?>(rd.GetInt32(0), a.Id)));
                }
            }
            return res;
        }
        #endregion

        public override Article Delete(Article entity)
        {
            CheckEntityForNull(entity, typeof(Article));
            using (TransactionScope ts = new TransactionScope(TransactionScopeOption.Required))
            {
                EnsureContext();
                context.EnlistTransaction();
                var reviewers = entity.Reviewers;
                var authors = entity.Authors;

                if(authors != null && authors.Count > 0)
                {
                    SqlParameter p = new SqlParameter("@articleId", entity.Id);
                    List<IDataParameter> parameters = new List<IDataParameter>();
                    parameters.Add(p);
                    ExecuteNonQuery("delete from dbo.ArticleAuthor where articleId=@articleId", parameters);
                }
                if(reviewers != null && reviewers.Count > 0)
                {
                    SqlParameter p = new SqlParameter("@articleId", entity.Id);
                    List<IDataParameter> parameters = new List<IDataParameter>();
                    parameters.Add(p);
                    ExecuteNonQuery("delete from dbo.ArticleReviewer where articleId=@articleId", parameters);
                }
                Article del = base.Delete(entity);
                ts.Complete();
                return del;
            }
        }

        public IEnumerable<Reviewer> GetCompatibleReviewers(int article)
        {
            var res = new List<Reviewer>();
            using (IDbCommand command = context.CreateCommand())
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandText = "GetCompatibleReviewersForArticle";
                command.Parameters.Add(new SqlParameter("@articleId", article));
                using (IDataReader reader = command.ExecuteReader())
                {
                    ReviewerMapper rm = new ReviewerMapper(context);
                    while (reader.Read())
                    {
                        res.Add(rm.Read(reader.GetInt32(0)));
                    }
                }
            }
            return res;
        }
        public void AttributeRevision(int article, int reviewer)
        {
            using (IDbCommand command = context.CreateCommand())
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandText = "AttributeReviewerToRevision";
                var parameters = new List<SqlParameter>
                {
                    new SqlParameter("@articleId", article),
                    new SqlParameter("@reviewerId", reviewer)
                };
                command.Parameters.AddRange(parameters);
                command.ExecuteNonQuery();
            }
        }
        public void RegisterRevision(int article, string text, int grade)
        {
            using (IDbCommand command = context.CreateCommand())
            {
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandText = "RegisterRevision";
                var parameters = new List<SqlParameter>
                {
                    new SqlParameter("@articleId", article),
                    new SqlParameter("@revisionText", text),
                    new SqlParameter("@grade", grade)
                };
                command.Parameters.AddRange(parameters);
                command.ExecuteNonQuery();
            }
        }
        protected override string Table => "Article";

        protected override string SelectAllCommandText => $"select id, conferenceId, stateId, summary, accepted, submissionDate from {this.Table}";

        protected override string SelectCommandText => $"{this.SelectAllCommandText} where id = @id";

        protected override string UpdateCommandText => $"";

        protected override string DeleteCommandText => $"Delete from {this.Table} where articleId = @id";

        protected override string InsertCommandText => $"Insert into {this.Table}";

        protected override void DeleteParameters(IDbCommand command, Article entity) => throw new NotImplementedException();
        protected override void InsertParameters(IDbCommand command, Article entity) => throw new NotImplementedException();
        protected override Article Map(IDataRecord record) {
            bool? accepted = null;
            if (!record.IsDBNull(4))
                accepted = record.GetBoolean(4);
            Article a = new Article
            {
                Id = record.GetInt32(0),
                State = (ArticleState)record.GetInt32(1),
                Summary = record.GetString(3),
                Accepted = accepted,
                SubmissionDate = record.GetDateTime(5)
            };
            return new ArticleProxy(a, context);
        }
        protected override void SelectParameters(IDbCommand command, int? id) => 
            command.Parameters.Add(new SqlParameter("@id", id));
        
        protected override Article UpdateEntityId(IDbCommand command, Article entity) => 
            throw new NotImplementedException();
        protected override void UpdateParameters(IDbCommand command, Article entity) => throw new NotImplementedException();
    }
}
