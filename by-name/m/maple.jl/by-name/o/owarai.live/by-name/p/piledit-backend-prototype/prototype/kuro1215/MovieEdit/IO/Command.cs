using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;

namespace MovieEdit.IO
{
    public class Command
    {
        public Command()
        {
            //var Get = new Cmd("get", "", new CmdArg("param", "", new CmdArg("argname", "", GetAction)));
        }

        public static void RunCommand(string cmd)
        {

        }

        private void GetAction()
        {

        }
    }

    public class Cmd
    {
        public string Name { get; }
        public string Explain { get; }
        public int ArgsCount { get; }

        public Cmd(string name, string explain, params CmdArg[] args)
        {

        }

        public static implicit operator string(Cmd cmd)
        {
            return cmd.Name;
        }

        public override bool Equals(object obj)
        {
            return obj switch
            {
                string s => s == Name,
                Cmd cmd => cmd.Name == Name,
                _ => false
            };
        }
        public override int GetHashCode()
        {
            return HashCode.Combine(Name);
        }
    }

    public class CmdArg
    {
        public string Name { get; }
        public string Explain { get; }

        public CmdArg(string name, string explain)
        {

        }
        public CmdArg(string name, string expain, Action action)
        {

        }
    }

    public class CmdArg<T> : CmdArg
    {
        public CmdArg(string name, string explain, Action action)
            : base (name, explain, action) { }

        public void AddArgument(CmdArg arg)
        {

        }

        public bool CanCast(object obj)
        {
            return obj is T;
        }
    }

    public class GetCommand : Cmd
    {
        public GetCommand() : base ("get", "")
        {
            var param = new CmdArg("param", "");
            //param.AddArgument
        }
    }

    public class LoadCommand : Cmd
    {
        public LoadCommand() : base("load", "")
        {
            var param = new CmdArg<string>("param", "", LoadMovie);
        }

        private void LoadMovie()
        {

        }
    }
}
