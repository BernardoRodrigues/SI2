namespace SI2App.Model
{
    using System.Collections.Generic;

    public class Attendee
    {
        public int? Id { get; set; }

        public string Name { get; set; }

        public string Email { get; set; }

        public int InstitutionId { get; set; }

        public List<int> ConferencesIds { get; set; }

        public Attendee()
        {
            this.ConferencesIds = new List<int>();
        }
    }
}
