using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;

namespace MovieEdit
{
    public static class Log
    {
        public enum LogType
        {
            Message, Info, Input, Warn, Error
        }

        public static void Message(object msg, string place = null)
        {
            if (msg == null) msg = "Null";
            OutLog(LogType.Message, place, msg);
        }
        public static void Info(object msg, string place = null)
        {
            if (msg == null) msg = "Null";
            OutLog(LogType.Info, place, msg);
        }
        public static void Input(object msg, string place = null)
        {
            if (msg == null) msg = "Null";
            OutLog(LogType.Info, place, msg);
        }
        public static void Warn(object msg, string place = null)
        {
            if (msg == null) msg = "Null";
            OutLog(LogType.Warn, place, msg);
        }
        public static void Error(object msg, string place = null)
        {
            if (msg == null) msg = "Null";
            OutLog(LogType.Error, place, msg);
        }
        private static void OutLog(LogType type, string place, object msg)
        {
            if (place == null) place = "MESystem";
            string date = DateTime.Now.ToString("HH:mm:ss.fff", Language.SystemLang);
            string[] msgs;
            if (msg.GetType().IsArray) msgs = (string[])msg;
            else if (msg.ToString().Contains("\n", StringComparison.CurrentCulture))
                msgs = msg.ToString().Split("\n");
            else msgs = new string[] { msg.ToString() };

            foreach (string s in msgs)
            {
                string output = $"[{type}@{place}] {s}";
                switch (type)
                {
                    case LogType.Message:
                        Console.WriteLine(s);
                        break;
                    case LogType.Warn:
                    case LogType.Error:
                        Console.WriteLine(output);
                        break;
                    case LogType.Info:
                        if (MESystem.ConsoleInfo) Console.WriteLine(output);
                        break;
                }
                Debug.WriteLine($"[{date}]{output}");
            }
        }
        public static void Progress(string msg, double percent, string place = null)
        {
            OutLog(LogType.Info, place, $"{msg}: {Math.Floor(percent * 1000) / 1000}%");
        }
    }
}
