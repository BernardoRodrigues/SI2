﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace EF_Dal
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class cs : DbContext
    {
        public cs()
            : base("name=cs")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<Article> Articles { get; set; }
        public virtual DbSet<ArticleAuthor> ArticleAuthors { get; set; }
        public virtual DbSet<ArticleReviewer> ArticleReviewers { get; set; }
        public virtual DbSet<ArticleState> ArticleStates { get; set; }
        public virtual DbSet<Author> Authors { get; set; }
        public virtual DbSet<Conference> Conferences { get; set; }
        public virtual DbSet<ConferenceUser> ConferenceUsers { get; set; }
        public virtual DbSet<File> Files { get; set; }
        public virtual DbSet<Institution> Institutions { get; set; }
        public virtual DbSet<Reviewer> Reviewers { get; set; }
        public virtual DbSet<User> Users { get; set; }
    
        public virtual ObjectResult<User> GetCompatibleReviewersForArticle(Nullable<int> articleId)
        {
            var articleIdParameter = articleId.HasValue ?
                new ObjectParameter("articleId", articleId) :
                new ObjectParameter("articleId", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<User>("GetCompatibleReviewersForArticle", articleIdParameter);
        }
    
        public virtual ObjectResult<User> GetCompatibleReviewersForArticle(Nullable<int> articleId, MergeOption mergeOption)
        {
            var articleIdParameter = articleId.HasValue ?
                new ObjectParameter("articleId", articleId) :
                new ObjectParameter("articleId", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<User>("GetCompatibleReviewersForArticle", mergeOption, articleIdParameter);
        }
    }
}
