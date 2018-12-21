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
    class ReviewerRepository : IReviewerRepository
    {
        private ReviewerMapper _mapper;
        public ReviewerRepository(IContext ctx)
        {
            _mapper = new ReviewerMapper(ctx);
        }
        public IEnumerable<Reviewer> Find(Func<Reviewer, bool> criteria)
        {
            return FindAll().Where(criteria);
        }

        public IEnumerable<Reviewer> FindAll()
        {
            return _mapper.ReadAll();
        }

        public void Update(Reviewer entity)
        {
            throw new NotImplementedException();
        }

    }
}
