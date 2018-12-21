using SI2App.Concrete.Mappers;
using SI2App.Dal;
using SI2App.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SI2App.Mapper.Proxy
{
    class ConferenceProxy : Conference
    {
        private IContext context;
        public ConferenceProxy(Conference c, IContext context) :base()
        {
            base.Acronym = c.Acronym;
            base.Grade = c.Grade;
            base.Id = c.Id;
            base.Name = c.Name;
            base.SubmissionDate = c.SubmissionDate;
            base.Year = c.Year;
            base.Attendees = null;
            this.context = context;
        }

        public override List<Attendee> Attendees {
            get
            {
                if(base.Attendees == null)
                {
                    ConferenceMapper cm = new ConferenceMapper(context);
                    base.Attendees = cm.LoadAttendees(this);
                }
                return base.Attendees;
            }

            set => base.Attendees = value;
        }
    }
}
