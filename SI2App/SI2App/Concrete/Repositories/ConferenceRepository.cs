namespace SI2App.Concrete.Repositories
{
    using System.Collections.Generic;
    using SI2App.Concrete.Mappers;
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

        public IEnumerable<Conference> Find(Clauses clauses) => this.Mapper.ReadWhere(clauses); 

        public IEnumerable<Conference> FindAll() => this.Mapper.ReadAll();
    }
}
