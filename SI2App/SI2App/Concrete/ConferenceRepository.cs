using SI2App.Concrete.Mappers;

namespace SI2App.Concrete
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SI2App.Dal;
    using SI2App.Model;

    public class ConferenceRepository : IConferenceRepository
    {
        private IContext Context { get; set; }
        private ConferenceMapper Mapper { get; set; }

        public ConferenceRepository(IContext context)
        {
            this.Context = context;
            this.Mapper = new ConferenceMapper(context);
        }

        public IEnumerable<Conference> Find(Func<Conference, bool> criteria) => this.FindAll().Where(criteria);

        public IEnumerable<Conference> FindAll() => this.Mapper.ReadAll();

        public void Update(Conference entity) => this.Mapper.Update(entity);
    }
}
