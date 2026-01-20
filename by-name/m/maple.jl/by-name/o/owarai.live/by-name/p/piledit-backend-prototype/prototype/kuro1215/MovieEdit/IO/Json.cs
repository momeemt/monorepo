using System;
using System.IO;
using System.Text.Json;

namespace MovieEdit.IO
{
    public static class EditJson
    {
        public static T ReadJson<T>(string json)
        {
            return JsonSerializer.Deserialize<T>(json);
        }
        public static T ReadJsonFile<T>(string path)
        {
            using var reader = new StreamReader(path);
            return ReadJson<T>(reader.ReadToEnd());
        }
        public static string OutJson(object obj)
        {
            return JsonSerializer.Serialize(obj);
        }
        public static DateTime? WriteJsonFile(string type, object obj, bool result = false)
        {
            var (date, file) = FileName.GeneratePath(type, ".json", result);
            if (date == null)
            {
                Log.Error("");
                return null;
            }
            using var writer = new StreamWriter(file);
            writer.Write(OutJson(obj));
            return date;
        }
    }
}
