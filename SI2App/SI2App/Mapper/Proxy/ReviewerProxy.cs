using SI2App.Concrete.Mappers;
using SI2App.Dal;
using SI2App.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SI2App.Mapper.Proxy
{
    class ReviewerProxy : Reviewer
    {
        private IContext context;
        public ReviewerProxy(Reviewer r, IContext context): base()
        {
            base.Articles = r.Articles;
            base.Email = r.Email;
            base.Id = r.Id;
            base.Institution = r.Institution;
            base.Name = r.Name;
            this.context = context;
        }

        public override List<Article> Articles {
            get
            {
                if(base.Articles == null)
                {
                    ReviewerMapper rm = new ReviewerMapper(context);
                    base.Articles = rm.LoadArticles(this);
                }
                return base.Articles;
            }

            set => base.Articles = value;
        }
    }
}
