namespace SI2App.Concrete.Repositories
{
    using SI2App.Concrete.Mappers;
    using SI2App.Dal;
    using SI2App.Model;
    using System.Collections.Generic;

    public class ArticleRepository : IArticleRepository
    {
        private IContext Context { get; set; }
        private ArticleMapper Mapper { get; set; }

        public ArticleRepository(IContext context)
        {
            this.Context = context;
            this.Mapper = new ArticleMapper(context);
        }

        public IEnumerable<Article> FindAll() => this.Mapper.ReadAll();
        public IEnumerable<Article> Find(Clauses clauses) => this.Mapper.ReadWhere(clauses);
    }
}
