namespace SI2App.Mapper
{
    using System;
    using System.Collections.Generic;
    using SI2App.Concrete.Mappers;
    using SI2App.Dal;
    using SI2App.Model;

    public class ArticleProxy : Article
    {
        private IContext Context { get; set; }
        private ArticleMapper Mapper { get; set; }

        public ArticleProxy(int id, ArticleState state, int conferenceId, string summary, bool accepted, DateTime submissionDate, IContext context) : base()
        {
            this.Id = id;
            this.StateId = state;
            this.ConferenceId = conferenceId;
            this.Accepted = accepted;
            this.SubmissionDate = submissionDate;
            this.Context = context;
            this.Mapper = new ArticleMapper(context);
        }

        public override List<File> Files
        {
            get
            {
                if (base.Files == null)
                {
                    var mapper = new ArticleMapper(this.Context);
                    base.Files = mapper.LoadFiles(this);
                }
                return base.Files;
            }
            set => base.Files = value;
        }

        public override List<Author> Authors
        {
            get
            {
                if (base.Authors == null)
                {
                    var mapper = new ArticleMapper(this.Context);
                    base.Authors = mapper.LoadAuthors(this);
                }
                return base.Authors;
            }
            set => base.Authors = value;
        }

        public override List<Reviewer> Reviewers
        {
            get
            {
                if (base.Reviewers == null)
                {
                    var mapper = new ArticleMapper(this.Context);
                    base.Reviewers = mapper.LoadReviewers(this);
                }
                return base.Reviewers;
            }
            set => base.Reviewers = value;
        }
    }
}
