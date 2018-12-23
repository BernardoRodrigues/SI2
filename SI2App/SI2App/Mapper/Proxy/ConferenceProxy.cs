using SI2App.Concrete.Mappers;
using SI2App.Dal;
using SI2App.Model;
using System.Collections.Generic;

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
            base.Articles = null;
            this.context = context;
        }

        public override List<Attendee> Attendees {
            get
            {
                if(base.Attendees == null)
                {
                    var cm = new ConferenceMapper(context);
                    base.Attendees = cm.LoadAttendees(this);
                }
                return base.Attendees;
            }

            set => base.Attendees = value;
        }

        public override List<Article> Articles {
            get
            {
                if(base.Articles == null)
                {
                    var cm = new ConferenceMapper(context);
                    base.Articles = cm.LoadArticles(this);
                }
                return base.Attendees
            }
            set => base.Articles = value;
        }
    }
}
