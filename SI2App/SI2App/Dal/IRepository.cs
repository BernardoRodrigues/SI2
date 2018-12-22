namespace SI2App.Dal
{
    using System.Collections.Generic;

    public interface IRepository<T>
    {

        IEnumerable<T> FindAll();
<<<<<<< HEAD
        IEnumerable<T> Find(Clauses clauses);
        T Delete(T entity);
        T Update(T entity);
        T Create(T entity);
=======
        IEnumerable<T> Find(Func<T, bool> criteria);
        void Update(T entity);
>>>>>>> 990cce7b3d8687393f96f26cd9e0ae0af57235e0

    }
}
