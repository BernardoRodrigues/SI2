using SI2App.Concrete.Mappers;
using SI2App.Dal;
using SI2App.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SI2App.Concrete
{
    class ArticleRepository : IArticleRepository
    {
        private ArticleMapper _mapper;

        public ArticleRepository(IContext context)
        {
            _mapper = new ArticleMapper(context);
        }

        public void AttributeRevision(int article, int reviewer)
        {
            _mapper.AttributeRevision(article, reviewer);
        }

        public IEnumerable<Article> Find(Func<Article, bool> criteria)
        {
            return this.FindAll().Where(criteria);
        }

        public IEnumerable<Article> FindAll()
        {
            return _mapper.ReadAll();
        }

        public IEnumerable<Reviewer> GetCompatibleReviewers(int article)
        {
            return _mapper.GetCompatibleReviewers(article);
        }

        public void Update(Article entity)
        {
            throw new NotImplementedException();
        }
    }
}
