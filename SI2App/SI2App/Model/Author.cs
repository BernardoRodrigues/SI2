namespace SI2App.Model
{
    using System.Collections.Generic;

    public class Author : Attendee
    {
<<<<<<< HEAD
        public virtual List<Article> ArticlesIds { get; set; }

        public Author() : base()
        {
            this.ArticlesIds = new List<Article>();
=======
        public virtual List<Article> Articles { get; set; }

        public Author() : base()
        {
            this.Articles = new List<Article>();
>>>>>>> 990cce7b3d8687393f96f26cd9e0ae0af57235e0
        }

    }
}
