namespace SI2App.Mapper
{
    using System.Collections.Generic;
    using SI2App.Concrete.Mappers;
    using SI2App.Dal;
    using SI2App.Model;

    public class ConferenceProxy : Conference
    {
        private IContext Context { get; set; }

        public ConferenceProxy(int id, string name, int year, string acronym, IContext context) : base()
        {
            this.Id = id;
            this.Name = name;
            this.Year = year;
            this.Acronym = acronym;
            this.Context = context;
        }

        public override List<Attendee> Attendees
        {
            get
            {
                if (base.Attendees == null)
                {
                    var mapper = new ConferenceMapper(this.Context);
                    base.Attendees = mapper.LoadAttendees(this);
                }
                return base.Attendees;
            }
            set => base.Attendees = value;
        }

    }
}
