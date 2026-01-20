using System;
using System.IO;
using static System.StringComparison;

namespace MovieEdit.IO
{
    public static class FileName
    {
        public static (DateTime?, string) GeneratePath(string type, string extention, bool result = false)
        {
            if (!IsExsitType(type)) return (null, null);
            string s = result ? "_result" : "";
            var date = DateTime.Now;
            string file = $@"{MESystem.JsonWatchPath}\{type}\{type}{date:HHmmssf}{s}.{extention}";
            return (date, file);
        }
        public static string GetDate(string path)
        {
            if (path == null || !path.Contains(MESystem.JsonWatchPath, CurrentCulture)) return null;
            string name = Path.GetFileNameWithoutExtension(path).Replace("_result", "", CurrentCulture);
            return name.Substring(name.Length - 8);
        }
        public static string GetType(string path)
        {
            if (path == null || !path.Contains(MESystem.JsonWatchPath, CurrentCulture)) return null;
            return Path.GetDirectoryName(path).Replace($@"{MESystem.JsonWatchPath}\", "", CurrentCulture);
        }
        public static bool IsExsitType(string type)
            => Directory.Exists($@"{MESystem.JsonWatchPath}\{type}");
        public static bool IsResultFile(string path)
            => Path.GetFileNameWithoutExtension(path).EndsWith("_result", CurrentCulture);
    }
}
