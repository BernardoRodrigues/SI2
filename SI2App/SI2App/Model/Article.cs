namespace SI2App.Model
{
    using System;
    using System.Collections.Generic;

    public class Article
    {

        public int? Id { get; set; }

        public ArticleState? State { get; set; }

        public string Summary { get; set; }

        public bool? Accepted { get; set; }

        public DateTime SubmissionDate { get; set; }

<<<<<<< HEAD
        public virtual List<Author> Authors { get; set; }

        public virtual List<Reviewer> Reviewers { get; set; } 

=======
        public virtual Conference Conference { get; set; }

        public virtual List<Author> Authors { get; set; }

        public virtual List<Reviewer> Reviewers { get; set; } 

>>>>>>> 990cce7b3d8687393f96f26cd9e0ae0af57235e0
        public virtual List<File> Files { get; set; }

        public Article()
        {
            this.Authors = new List<Author>();
            this.Reviewers = new List<Reviewer>();
            this.Files = new List<File>();
        }

    }
}
