using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Resources;
using System.Runtime.CompilerServices;
using System.Text;
using static MovieEdit.MESystem;
using static MovieEdit.Language;
using static System.StringComparison;

namespace MovieEdit
{
    public static class Language
    {
        public static LanguageText Text { get; private set; }
        public static CultureInfo SystemLang { get; private set; }
        public static IReadOnlyList<CultureInfo> SupportedLang { get; private set; }
        private static Dictionary<CultureInfo, List<string>> TextSettingFile { get; set; }

        public static void Load(string filter = null)
        {
            var dic = new Dictionary<CultureInfo, Dictionary<string, string>>();
            var list = new List<CultureInfo>();
            TextSettingFile = new Dictionary<CultureInfo, List<string>>();
            foreach (var file in Directory.GetFiles($"{AppLocation}lang"))
            {
                var f = Path.GetFullPath(file);
                if (Path.GetExtension(f) != ".resx") continue;
                if (filter != null && !f.Contains(filter, CurrentCulture)) continue;
                var ss = Path.GetFileNameWithoutExtension(f).Split('_');
                string id;
                if (ss.Length == 1) continue;
                else if (ss.Length == 2) id = ss[0];
                else id = string.Join('.', ss).Replace($".{ss[^1]}", "", CurrentCulture);
                var lang = new CultureInfo(ss[^1]);
                if (!list.Contains(lang))
                {
                    list.Add(lang);
                    dic.Add(lang, new Dictionary<string, string>());
                    TextSettingFile.Add(lang, new List<string>());
                }
                TextSettingFile[lang].Add(f);
                var rs = new ResourceSet(f);
                foreach (DictionaryEntry entry in rs)
                {
                    Console.WriteLine((string)entry.Key);
                    Console.WriteLine((string)entry.Value);
                    dic[lang].Add((string)entry.Key, (string)entry.Value);
                }
                rs.Dispose();
            }
            Text = new LanguageText(dic);
            SystemLang = CultureInfo.CurrentUICulture;
            SupportedLang = list;
        }
        public static void AddText(ResourceManager res)
        {

        }
        public static bool Change(CultureInfo lang)
        {
            if (IsSupported(lang)) SystemLang = lang;
            else SystemLang = new CultureInfo("en-US");
            return SystemLang == lang;
        }
        public static bool IsSupported(CultureInfo lang)
            => new List<CultureInfo>(SupportedLang).Contains(lang);
    }

    public class LanguageText
    {
        private Dictionary<CultureInfo, Dictionary<string, string>> AllLangText { get; }
        public string this[string key, CultureInfo lang = null]
        {
            get => GetText(key, lang);
        }

        internal LanguageText(Dictionary<CultureInfo, Dictionary<string, string>> text)
        {
            AllLangText = text;
        }

        public string GetText(string key, CultureInfo lang = null)
        {
            return GetText(key, lang);
        }
        public void TryGetText(string key, out string value, CultureInfo lang = null)
        {
            value = GetText(key, lang, false);
        }
        private string GetText(string key, CultureInfo lang, bool error = true)
        {
            var eng = new CultureInfo("en-US");
            if (lang == null) lang = SystemLang;
            else if (!AllLangText.ContainsKey(lang)) lang = eng;
            AllLangText[lang].TryGetValue(key, out var value);
            if (lang != eng && value == null) AllLangText[eng].TryGetValue(key, out value);
            if (error && value == null) throw new KeyNotFoundException();
            return value;
        }
    }
}
