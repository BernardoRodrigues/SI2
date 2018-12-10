namespace SI2App.Model
{
    using System;
    using System.Collections.Generic;

    public class Article
    {

        public int? Id { get; set; }

        public ArticleState? StateId { get; set; }

        public int ConferenceId { get; set; }

        public string Summary { get; set; }

        public bool? Accepted { get; set; }

        public DateTime SubmissionDate { get; set; }

        public List<int> AuthorsIds { get; set; }

        public List<int> ReviewersIds { get; set; } 

        public Article()
        {
            this.AuthorsIds = new List<int>();
            this.ReviewersIds = new List<int>();
        }

    }
}
