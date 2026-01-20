using System;
using System.IO;
using System.Collections.Generic;
using MovieEdit.TL;
using static MovieEdit.MESystem;
using static System.StringComparison;

namespace MovieEdit.IO
{
    public class FileWatcher : IDisposable
    {
        private FileSystemWatcher watcher = null;
        public string WatchingPath { get; }
        public IReadOnlyDictionary<string, Action<string>> CreatedEvents { get; private set; }

        public FileWatcher(string path, string filter = "")
        {
            if (!Directory.Exists(path)) throw new DirectoryNotFoundException();
            WatchingPath = path;
            watcher = new FileSystemWatcher
            {
                Path = WatchingPath,
                NotifyFilter = NotifyFilters.LastAccess | NotifyFilters.LastWrite,
                IncludeSubdirectories = true,
                Filter = filter,
            };
            watcher.Created += new FileSystemEventHandler(CreatedEvent);
            var dic = new Dictionary<string, Action<string>>
            {
                { "Command", CommandEvent }, { "MsgBox", MsgBoxEvent }, { "Task", TaskEvent }
            };
        }

        public void StartWatching()
        {
            if (!IsWatcher()) return;
            watcher.EnableRaisingEvents = true;
            Log.Warn($"フォルダ\"{ WatchingPath }\"のファイル監視を開始", "FileWatcher");
        }
        public void EndWatching(bool dispose = true)
        {
            if (!IsWatcher()) return;
            watcher.EnableRaisingEvents = false;
            Log.Warn($"フォルダ\"{ WatchingPath }\"のファイル監視を終了", "FileWatcher");
            if (dispose) Dispose();
        }
        public string WaitResult()
        {
            if (!IsWatcher() || watcher.EnableRaisingEvents) return null;
            var result = watcher.WaitForChanged(WatcherChangeTypes.Created);
            if (result.TimedOut)
            {
                Log.Error("ファイル監視がタイムアウトしました");
                return null;
            }
            else return result.Name;
        }
        private bool IsWatcher()
        {
            bool b = watcher == null;
            if (b) Log.Error("指定されたFileWatcherは解放済みのため、再定義して使用してください");
            return b;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        protected virtual void Dispose(bool disposing)
        {
            if (!IsWatcher()) return;
            if (disposing)
            {
                watcher.Dispose();
                watcher = null;
            }
        }
        ~FileWatcher()
        {
            Dispose(false);
        }

        public bool AddEvent(string trigger, Action<string> action)
        {
            var dic = new Dictionary<string, Action<string>>(CreatedEvents);
            if (!dic.ContainsKey(trigger)) dic.Add(trigger, action);
            else return false;
            return true;
        }
        private void CreatedEvent(object source, FileSystemEventArgs e)
        {
            string path = e.FullPath;
            string current = path.Replace($@"{JsonWatchPath}\", "", CurrentCulture);
            if(CreatedEvents.TryGetValue(current, out var evt)) evt(path);
        }
        private void CommandEvent(string path)
        {
            var reader = new StreamReader(path);
            string cmd = reader.ReadToEnd();
            Command.RunCommand(cmd);
            reader.Dispose();
            
        }
        private void MsgBoxEvent(string path)
        {
            if (FileName.IsResultFile(path))
            {
                Dialog.Result = int.Parse(EditText.ReadFile(path), Language.SystemLang) == 0;
                Dialog.Waiting = false;
            }
        }
        private void TaskEvent(string path)
        {
            var reader = new StreamReader(path);
            string json = reader.ReadToEnd();
            var tl = EditJson.ReadJsonFile<TLInfo<TimelineObject>>(json);
            OpeningProject.Timeline.AddObject(tl.Layer, tl.Frame, tl.TLObject);
            reader.Dispose();
        }
    }
}
