namespace SI2App.Mapper
{
    using System.Collections.Generic;
    using SI2App.Concrete.Mappers;
    using SI2App.Dal;
    using SI2App.Model;

    public class AttendeeProxy : Attendee
    {
        private IContext Context { get; set; }

        public AttendeeProxy(Attendee attendee, int? conferenceId, IContext context) : base()
        {
            this.Id = attendee.Id;
            this.Name = attendee.Name;
            this.Email = attendee.Email;
            this.InstitutionId = attendee.InstitutionId;
            this.Context = context;
        }

        public override List<Conference> Conferences
        {
            get
            {
                if (base.Conferences == null)
                {
                    var mapper = new AttendeeMapper(this.Context);
                    base.Conferences = mapper.LoadConferences(this);
                }
                return base.Conferences;
            }
            set => base.Conferences = value;
        }


    }
}
