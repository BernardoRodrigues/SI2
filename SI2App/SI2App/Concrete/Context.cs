namespace SI2App.Concrete
{
    using SI2App.Dal;
    using System.Data;
    using System.Data.SqlClient;
    using System.Transactions;

    public class Context : IContext
    {
        private string connectionString;
        private SqlConnection con = null;

        private IConferenceRepository _conferenceRepository;
        private IAttendeeRepository _attendeeRepository;
        private IArticleRepository _articleRepository;
        private IReviewerRepository _reviewerRepository;

        public Context(string cs)
        {
            connectionString = cs;
            _conferenceRepository = new ConferenceRepository(this);
            _attendeeRepository = new AttendeeRepository(this);
            _articleRepository = new ArticleRepository(this);
            _reviewerRepository = new ReviewerRepository(this);
        }

        public SqlCommand CreateCommand()
        {
            this.Open();
            return con.CreateCommand();
        }

        public void Dispose()
        {
            if (con != null)
            {
                con.Dispose();
                con = null;
            }
        }

        public void EnlistTransaction()
        {
            if (con != null)
            {
                con.EnlistTransaction(Transaction.Current);
            }
        }

        public void Open()
        {
            if (con == null)
            {
                con = new SqlConnection(connectionString);
            }
            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
        }

        public IConferenceRepository Conferences
        {
            get
            {
                return _conferenceRepository;
            }
        }

        public IAttendeeRepository Users
        {
            get => _attendeeRepository;
        }

        public IArticleRepository Articles
        {
            get => _articleRepository;
        }

        public IReviewerRepository Reviewers
        {
            get => _reviewerRepository;
        }
    }
}
