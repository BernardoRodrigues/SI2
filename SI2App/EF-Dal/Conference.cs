//------------------------------------------------------------------------------
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
    using System.Collections.Generic;
    
    public partial class Conference
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Conference()
        {
            this.Articles = new HashSet<Article>();
            this.ConferenceUsers = new HashSet<ConferenceUser>();
        }
    
        public int id { get; set; }
        public string name { get; set; }
        public int year { get; set; }
        public string acronym { get; set; }
        public Nullable<int> grade { get; set; }
        public System.DateTime submissionDate { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Article> Articles { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ConferenceUser> ConferenceUsers { get; set; }
    }
}
