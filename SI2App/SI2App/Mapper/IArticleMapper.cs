namespace SI2App.Mapper
{
    using SI2App.Model;
    using System.Collections.Generic;

    public interface IArticleMapper : IMapper<Article, int?, List<Article>>
    {
    }
}
