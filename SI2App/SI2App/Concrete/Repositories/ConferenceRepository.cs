<<<<<<< HEAD:SI2App/SI2App/Concrete/Repositories/ConferenceRepository.cs
﻿namespace SI2App.Concrete.Repositories
=======
﻿using SI2App.Concrete.Mappers;

namespace SI2App.Concrete
>>>>>>> 990cce7b3d8687393f96f26cd9e0ae0af57235e0:SI2App/SI2App/Concrete/ConferenceRepository.cs
{
    using System.Collections.Generic;
    using SI2App.Concrete.Mappers;
    using SI2App.Dal;
    using SI2App.Model;

    public class ConferenceRepository : IConferenceRepository
    {
        private IContext Context { get; set; }
        private ConferenceMapper Mapper { get; set; }

        public ConferenceRepository(IContext context)
        {
            this.Context = context;
            this.Mapper = new ConferenceMapper(context);
        }

        public IEnumerable<Conference> Find(Clauses clauses) => this.Mapper.ReadWhere(clauses); 

        public IEnumerable<Conference> FindAll() => this.Mapper.ReadAll();

<<<<<<< HEAD:SI2App/SI2App/Concrete/Repositories/ConferenceRepository.cs
        public Conference Delete(Conference entity) => this.Mapper.Delete(entity);

        public Conference Update(Conference entity) => this.Mapper.Update(entity);

        public Conference Create(Conference entity) => this.Mapper.Create(entity);
=======
        public void Update(Conference entity) => this.Mapper.Update(entity);

        public float PercentageOfAcceptedArticles(Conference c)
        {
            return Mapper.PercentageOfAcceptedArticles(c.Id.Value);
        }

>>>>>>> 990cce7b3d8687393f96f26cd9e0ae0af57235e0:SI2App/SI2App/Concrete/ConferenceRepository.cs
    }
}
