namespace SI2App.Model
{
    using System.Collections.Generic;

    public class Reviewer : Attendee
    {
        public List<int> ArticlesIds { get; set; }

        public Reviewer() : base()
        {
            this.ArticlesIds = new List<int>();
        }
    }
}
