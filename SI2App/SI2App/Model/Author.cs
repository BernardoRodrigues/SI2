namespace SI2App.Model
{
    using System.Collections.Generic;

    public class Author : Attendee
    {
        public virtual List<Article> ArticlesIds { get; set; }

        public Author() : base()
        {
            this.ArticlesIds = new List<Article>();
        }

    }
}
