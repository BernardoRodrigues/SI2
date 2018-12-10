namespace SI2App.Dal
{
    using System;
    using System.Collections.Generic;

    public interface IRepository<T>
    {

        IEnumerable<T> FindAll();
        IEnumerable<T> Find(Func<T, bool> criteria);

    }
}
