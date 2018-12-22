﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using SI2App.Concrete;

namespace SI2App
{
    enum Option
    {
        Unknown,
        Exit,
        UpdateConference,
        GiveRoleToUser,
        ListCompatibleReviewers,
        GiveRevisionToReviewer,
        RegisterRevision,
        PercentageOfAcceptedSubmissions,
    }

    delegate void IWorker();
    class App
    { 
        private static Dictionary<Option, IWorker> methods = new Dictionary<Option, IWorker>();
        private static string connectionString = ConfigurationManager.ConnectionStrings["cs"].ConnectionString;
        private static void init()
        {
            methods.Add(Option.Exit, () => Console.WriteLine("Goodbye! Press any key..."));
            methods.Add(Option.UpdateConference, UpdateConference);
            methods.Add(Option.GiveRoleToUser, GiveRoleToUser);
            methods.Add(Option.ListCompatibleReviewers, ListCompatibleReviewers);
            methods.Add(Option.GiveRevisionToReviewer, GiveRevision);
            methods.Add(Option.RegisterRevision, RegisterRevision);
            methods.Add(Option.PercentageOfAcceptedSubmissions, AcceptedSubmissionsInPercentage);
        }

        private static void UpdateConference()
        {
           
            using (Context ctx = new Context(connectionString))
            {
                var repo = ctx.Conferences;
                var first = repo.FindAll().First();
                var id = first.Id;
                first.Grade = 45;
                repo.Update(first);
                Console.WriteLine($"Conference {first.Name} updated with success!");
                Console.ReadKey();
            }
        }

        private static void GiveRoleToUser()
        {
           
            using (Context ctx = new Context(connectionString))
            {

                var repo = ctx.Users;
                var user = repo.Find(u => u.Email.Equals("0000@isel.ipl.pt")).First();
                repo.GiveRole(user, 0);
                Console.WriteLine($"{user.Name} is now a Reviewer");
                Console.ReadKey();
            }
            
           
        }

        private static void ListCompatibleReviewers()
        {
            using (Context ctx = new Context(connectionString))
            {

                var repo = ctx.Articles;
                var first = repo.FindAll().First();
                var reviewers = repo.GetCompatibleReviewers(first.Id.Value);
                foreach(var r in reviewers)
                {
                    Console.WriteLine($"Name : {r.Name}");
                }
                Console.ReadKey();
            }
        }

        private static void GiveRevision()
        {
            using (Context ctx = new Context(connectionString))
            {
                var articles = ctx.Articles;
                var reviewers = ctx.Reviewers;
                var article = articles.FindAll().First();
                var reviewer = articles.GetCompatibleReviewers(article.Id.Value).First();
                articles.AttributeRevision(article.Id.Value, reviewer.Id.Value);
                Console.WriteLine("Success!");
                Console.ReadKey();
            }
        }
        private static void RegisterRevision()
        {
            using (Context ctx = new Context(connectionString))
            {
                var articles = ctx.Articles;
                articles.RegisterRevision(1, "Success", 100);
                Console.WriteLine("Success!");
                Console.ReadKey();
            }
        }
        private static void AcceptedSubmissionsInPercentage()
        {
            using(Context ctx = new Context(connectionString))
            {
                var conferences = ctx.Conferences;
                var first = conferences.FindAll().First();
                var res = conferences.PercentageOfAcceptedArticles(first);
                Console.WriteLine($"Percentage : {res}");
                Console.ReadKey();
            }
        }

        private static void clearConsole()
        {
            for (int y = 0; y < 25; y++) //console is 80 columns and 25 lines
                Console.WriteLine("\n");
        }

        private static Option showMenu()
        {
            Option userInput = Option.Unknown;

            Console.WriteLine("1. Sair");
            Console.WriteLine("2. Actualizar uma conferência");
            Console.WriteLine("3. Atribuir um papel a um utilizador");
            Console.WriteLine("4. Listar os revisores compatíveis com uma revisão");
            Console.WriteLine("5. Atribuir um revisor a uma revisão");
            Console.WriteLine("6. Registar uma revisão");
            Console.WriteLine("7. Percentagem de submissões aceites de uma conferência");
            Console.Write("> ");
            var input = int.Parse(Console.ReadLine());
            userInput = (Option)(Enum.GetValues(typeof(Option)).GetValue(input));
            return userInput;
        }
        public static void Main(string[] args)
        {
            init();

            Option userInput = Option.Unknown;
            do
            {
                try
                {
                    userInput = showMenu();
                    methods[userInput]();
                    clearConsole();
                }catch(Exception e)
                {
                    Console.WriteLine($"Error : {e.Message}");
                    Console.ReadKey();
                }
            } while (userInput != Option.Exit);
        }
    }
}
