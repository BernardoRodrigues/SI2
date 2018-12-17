using SI2App.Concrete.Mappers;
using SI2App.Dal;
using SI2App.Model;
using System.Collections.Generic;

namespace SI2App.Mapper
{
    public class AttendeeProxy : Attendee
    {
        private IContext context;
       
        public AttendeeProxy(Attendee attendee, IContext context) : base()
        {
            base.Id = attendee.Id;
            base.Name = attendee.Name;
            base.Email = attendee.Email;
            base.Conferences = null;
            base.Institution = null;
            this.context = context;
            
        }

        public override Institution Institution {
            get {
                if(base.Institution == null)
                {
                    AttendeeMapper mapper = new AttendeeMapper(context);
                    base.Institution = mapper.LoadInstitution(this);
                }
                return base.Institution;
            }
            set => base.Institution = value;
        }

        public override List<Conference> Conferences
        {
            get
            {
                if(base.Institution == null)
                {
                    AttendeeMapper mapper = new AttendeeMapper(context);
                    base.Conferences = mapper.LoadConferences(this);
                }
                return base.Conferences;
            }
            set
            {
                base.Conferences = value;
            }
        }

        
    }
}
