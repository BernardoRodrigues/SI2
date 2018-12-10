namespace SI2App.Concrete
{
    using SI2App.Dal;
    using System.Data;
    using System.Data.SqlClient;
    using System.Transactions;

    public class Context : IContext
    {
        private string ConnectionString { get; set; }
        private SqlConnection Connection { get; set; }

        public Context(string cs)
        {
            this.ConnectionString = cs;
        }

        public SqlCommand CreateCommand()
        {
            this.Open();
            return this.Connection.CreateCommand();
        }

        public void Dispose()
        {
            if (this.Connection != null)
            {
                this.Connection.Dispose();
                this.Connection = null;
            }
        }

        public void EnlistTransaction()
        {
            if (this.Connection != null)
            {
                this.Connection.EnlistTransaction(Transaction.Current);
            }
        }

        public void Open()
        {
            if (this.Connection == null)
            {
                this.Connection = new SqlConnection(this.ConnectionString);
            }
            if (this.Connection.State != ConnectionState.Open)
            {
                this.Connection.Open();
            }
        }
    }
}
