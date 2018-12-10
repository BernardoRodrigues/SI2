using SI2App.Dal;
using SI2App.Model;

namespace SI2App.Mapper
{
    public class AttendeeProxy : Attendee
    {
        private IContext Context { get; set; }
        private int? ConferenceId { get; set; }

        public AttendeeProxy(Attendee attendee, int? conferenceId, IContext context) : base()
        {
            this.Id = attendee.Id;
            this.Name = attendee.Name;
            this.Email = attendee.Email;
            this.InstitutionId = attendee.InstitutionId;
            this.ConferenceId = conferenceId;
            this.Context = context;
        }

        
    }
}
