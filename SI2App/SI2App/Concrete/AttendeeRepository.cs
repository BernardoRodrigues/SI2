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
    class AttendeeRepository : IAttendeeRepository
    {
        private AttendeeMapper _mapper;

        public AttendeeRepository(IContext context)
        {
            _mapper = new AttendeeMapper(context);
        }
        public IEnumerable<Attendee> Find(Func<Attendee, bool> criteria)
        {
            return this.FindAll().Where(criteria);
        }

        public IEnumerable<Attendee> FindAll()
        {
            return _mapper.ReadAll();
        }

        public void Update(Attendee entity)
        {
            throw new NotImplementedException();
        }

        public void GiveRole(Attendee user, int role)
        {
            _mapper.GiveRoleToUser(user, role);
        }
    }
}
