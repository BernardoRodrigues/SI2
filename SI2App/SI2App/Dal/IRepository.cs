namespace SI2App.Dal
{
    using SI2App.Concrete;
    using System.Collections.Generic;

    public interface IRepository<T>
    {

        IEnumerable<T> FindAll();
        IEnumerable<T> Find(Clauses clauses);

    }
}
