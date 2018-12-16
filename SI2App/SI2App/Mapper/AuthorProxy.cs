namespace SI2App.Mapper
{
    using System.Collections.Generic;
    using SI2App.Concrete.Mappers;
    using SI2App.Dal;
    using SI2App.Model;

    public class AuthorProxy : Author
    {
        private IContext Context { get; set; }

        public AuthorProxy(int id, string email, string name, int institutionId, IContext context) : base()
        {
            this.Id = id;
            this.Email = email;
            this.Name = name;
            this.InstitutionId = institutionId;
            this.Context = context;
        }

        public override List<Article> ArticlesIds
        {
            get
            {   if (base.ArticlesIds == null)
                {
                    var mapper = new AuthorMapper(this.Context);
                    base.ArticlesIds = mapper.LoadArticles(this);
                }
                return base.ArticlesIds;
            }
            set => base.ArticlesIds = value;
        }

    }
}
