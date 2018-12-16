namespace SI2App.Concrete.Repositories
{
    using SI2App.Concrete.Mappers;
    using SI2App.Dal;
    using SI2App.Model;
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class AttendeeRepository : IAttendeeRepository
    {
        private IContext Context { get; set; }
        private AttendeeMapper Mapper { get; set; }

        public AttendeeRepository(IContext context)
        {
            this.Context = context;
            this.Mapper = new AttendeeMapper(context);
        }

        public IEnumerable<Attendee> Find(Func<Attendee, bool> criteria) => this.FindAll().Where(criteria);

        public IEnumerable<Attendee> FindAll() => this.Mapper.ReadAll();
        public IEnumerable<Attendee> Find(Clauses clauses) => this.Mapper.ReadWhere(clauses);
    }
}
