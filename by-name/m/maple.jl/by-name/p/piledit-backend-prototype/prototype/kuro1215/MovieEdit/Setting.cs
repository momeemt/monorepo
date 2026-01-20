using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;

namespace MovieEdit
{
    public static class Setting
    {
        public static void InitLoad()
        {
            Path.GetFullPath(@".\CarResources.resx");
            string path = Path.GetFullPath(@".\");

            Language.Load(path);

            var t = typeof(SettingContents);
            var list = new List<SettingContent>();
            foreach (var f in t.GetFields(BindingFlags.Static | BindingFlags.NonPublic | BindingFlags.Public))
                if (f.FieldType.Name == "SettingContent`1") list.Add((SettingContent)f.GetValue(t));
            SettingContents.SettingList = list;
            LoadAll();
        }
        public static void Load(params SettingContent[] setting)
        {
            foreach (var s in setting) s.Load();
        }
        public static void LoadAll()
        {
            Load(new List<SettingContent>(SettingContents.SettingList).ToArray());
        }
    }

    public static class SettingContents
    {
        public static IReadOnlyList<SettingContent> SettingList { get; set; }

        internal static SettingContent Extentions
            = new SettingContent("MovieEdit.MESystem", "Extentions", ".extention");

        public static void AddSetting(SettingContent content)
        {
            var list = new List<SettingContent>(SettingList) { content };
            SettingList = list;
        }
    }

    public class SettingContent
    {
        protected private string FileName { get; }
        protected private FieldInfo Field { get; set; }
        internal SettingContent(string classname, string fieldname, string filename)
        {
            FileName = filename;
            var t = Type.GetType(classname);
            var flag = BindingFlags.NonPublic | BindingFlags.Static | BindingFlags.Public;
            Field = t.GetField($"<{fieldname}>k__BackingField", flag);
            Load();
        }

        internal void Load()
        {
            using var stream = new FileStream($@"{MESystem.DataPath}\{FileName}", FileMode.Open, FileAccess.Read);
            BinaryFormatter bf = new BinaryFormatter();
            Field.SetValue(Field.FieldType, bf.Deserialize(stream));
        }
        internal void Save()
        {
            using var stream = new FileStream($@"{MESystem.DataPath}\{FileName}", FileMode.OpenOrCreate, FileAccess.Write);
            BinaryFormatter bf = new BinaryFormatter();
            bf.Serialize(stream, Field.GetValue(Field.FieldType));
        }
    }
}
