namespace SI2App.Mapper
{
    using SI2App.Concrete.Mappers;
    using SI2App.Dal;
    using SI2App.Model;
    using System.Collections.Generic;

    public class ReviewerProxy : Reviewer
    {
        private IContext Context { get; set; }

        public ReviewerProxy(int id, string email, string name, int institutionId, IContext context) : base()
        {
            this.Id = id;
            this.Email = email;
            this.Name = name;
            this.InstitutionId = institutionId;
            this.Context = context;
        }

        public override List<Article> Articles
        {
            get
            {
                if (base.Articles == null)
                {
                    var mapper = new ReviewerMapper(this.Context);
                    base.Articles = mapper.LoadArticles(this);
                }
                return base.Articles;
            }
            set => base.Articles = value;
        }

    }
}
