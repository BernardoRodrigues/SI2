namespace SI2App.Model
{
    using System.Collections.Generic;

    public class Author : Attendee
    {
        public List<int> ArticlesIds { get; set; }

        public Author() : base()
        {
            this.ArticlesIds = new List<int>();
        }

    }
}
