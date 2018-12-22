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
    class AuthorProxy : Author
    {
        private IContext context;
        public AuthorProxy(Author a, IContext context ) : base()
        {
            this.context = context;
        }

        public override List<Article> Articles {
            get
            {
                if(base.Articles == null)
                {
                    AuthorMapper am = new AuthorMapper(context);
                    base.Articles = am.LoadArticles(this);
                }
                return base.Articles;
            }

            set => base.Articles = value;
        }
    }
}
