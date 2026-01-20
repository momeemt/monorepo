using System;
using System.ComponentModel;
using System.IO;
using MovieEdit.IO;
using static MovieEdit.MESystem;

namespace MovieEdit
{
    public static class Start
    {
        private static FileWatcher watcher;

        public static void Main(string[] args)
        {
            if (args == null) args = Array.Empty<string>();
            Starting(args);
            CUI.Input();
            Ending();
        }

        private static void Starting(string[] args)
        {
            for (int i = 0;i < args.Length;i++)
            {
                var arg = args[i];
                if(arg == "--debug")
                {
                    ConsoleInfo = true;
                    Log.Warn("Debugging Mode Start...");
                    //Program.DebugStart();
                    //Debugging.CreateSettingFile.ExtentionData();
                }
                else if (arg == "--outinfo") ConsoleInfo = true;
            }

            //Language.Load();

            //Setting.InitLoad();
            watcher = new FileWatcher(JsonWatchPath);
            watcher.StartWatching();
        }

        private static void Ending(int code = 0)
        {
            watcher.EndWatching();
            Log.Info("プログラム終了");
            Environment.Exit(code);
        }
    }
}
