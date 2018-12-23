using SI2App.Concrete.Mappers;
using SI2App.Dal;
using SI2App.Model;
using System.Collections.Generic;

namespace SI2App.Mapper
{
    class ArticleProxy : Article
    {
        private IContext context;

        public ArticleProxy(Article a , IContext context) : base()
        {
            base.Id = a.Id;
            base.State = a.State;
            base.Summary = a.Summary;
            base.SubmissionDate = a.SubmissionDate;
            base.Accepted = a.Accepted;
            base.Conference = null;
            base.Authors = null;
            base.Reviewers = null;
            this.context = context;
        }

        public override Conference Conference {
            get
            {
                if(base.Conference == null)
                {
                    var am = new ArticleMapper(context);
                    base.Conference = am.LoadConference(this);
                }
                return base.Conference;
            }

            set => base.Conference = value;
        }

        public override List<Author> Authors {
            get
            {
                if(base.Authors == null)
                {
                    var am = new ArticleMapper(context);
                    base.Authors = am.LoadAuthors(this);
                }
                return base.Authors;
            }

            set => base.Authors = value;
        }

        public override List<Reviewer> Reviewers
        {
            get
            {
                if(base.Reviewers == null)
                {
                    var am = new ArticleMapper(context);
                    base.Reviewers = am.LoadReviewers(this);
                }
                return base.Reviewers;
            }

            set => base.Reviewers = value;
        }

        public override List<File> Files
        {
            get
            {
                if(base.Files == null)
                {
                    var am = new ArticleMapper(context);
                    base.Files = am.LoadFiles(this);
                }
                return base.Files;
            }

            set => base.Files = value;
        }
    }
}
