using SI2App.Concrete.Mappers;
using SI2App.Dal;
using SI2App.Model;
using System.Collections.Generic;

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
                    var am = new AuthorMapper(context);
                    base.Articles = am.LoadArticles(this);
                }
                return base.Articles;
            }

            set => base.Articles = value;
        }
    }
}
