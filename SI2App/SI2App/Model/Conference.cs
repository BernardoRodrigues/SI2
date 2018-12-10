namespace SI2App.Model
{
    using System;
    using System.Collections.Generic;

    public class Conference
    {

        public int? Id { get; set; }

        public string Name { get; set; }

        public int Year { get; set; }

        public string Acronym { get; set; }

        public int? Grade { get; set; }

        public DateTime? SubmissionDate { get; set; }

        public List<int> AttendeesIds { get; set; }

        public Conference()
        {
            this.AttendeesIds = new List<int>();
        }

    }
}
