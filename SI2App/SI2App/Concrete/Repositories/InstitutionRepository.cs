namespace SI2App.Concrete.Repositories
{
    using SI2App.Concrete.Mappers;
    using SI2App.Dal;
    using SI2App.Model;
    using System.Collections.Generic;

    public class InstitutionRepository : IInstitutionRepository
    {
        private IContext Context { get; set; }
        private IntitutionMapper Mapper { get; set;}

        public InstitutionRepository(IContext context)
        {
            this.Context = context;
            this.Mapper = new IntitutionMapper(context);
        }

        public IEnumerable<Institution> Find(Clauses clauses) => this.Mapper.ReadWhere(clauses);

        public IEnumerable<Institution> FindAll() => this.Mapper.ReadAll();
    }
}
