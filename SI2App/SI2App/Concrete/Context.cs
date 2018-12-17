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

        private ConferenceRepository _conferenceRepository;

        public Context(string cs)
        {
            connectionString = cs;
            _conferenceRepository = new ConferenceRepository(this);
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

        public ConferenceRepository Conferences
        {
            get
            {
                return _conferenceRepository;
            }
        }
    }
}
