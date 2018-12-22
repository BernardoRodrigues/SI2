namespace SI2App.Model
{
    using System.Collections.Generic;

    public class Attendee
    {
        public int? Id { get; set; }

        public string Name { get; set; }

        public string Email { get; set; }

        public virtual Institution Institution { get; set; }

        public virtual List<Conference> Conferences { get; set; }

        public Attendee()
        {
<<<<<<< HEAD
            this.Conferences = new List<Conference>();
=======
            Conferences = new List<Conference>();
>>>>>>> 990cce7b3d8687393f96f26cd9e0ae0af57235e0
        }
    }
}
