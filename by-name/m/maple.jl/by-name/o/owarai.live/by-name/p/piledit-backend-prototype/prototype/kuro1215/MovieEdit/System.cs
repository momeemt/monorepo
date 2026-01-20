using OpenCvSharp;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.Json.Serialization;

namespace MovieEdit
{
    public static class MESystem
    {
        internal enum FileType
        {
            Movie, Picture, Audio
        }
        private static IReadOnlyDictionary<FileType, List<ExtentionBase>> Extentions { get; set; }
        public static List<ExtentionBase> MovieExtentions { get => Extentions [FileType.Movie]; }
        public static List<ExtentionBase> PictureExtentions { get => Extentions [FileType.Picture]; }
        public static List<ExtentionBase> AudioExtentions { get => Extentions [FileType.Audio]; }
        public static string AppLocation { get; } = Path.GetFullPath(@".\");
        public static string JsonWatchPath { get; } = $@"{AppLocation}assets\watch";
        public static string DataPath { get; } = $@"{AppLocation}data";
        public static Project OpeningProject { get; }
        internal static bool ConsoleInfo { get; set; } = false;

        public static bool AddMovieExtention(string extention, string filetype = "")
            => AddExtention(FileType.Movie, extention, filetype);
        public static bool AddPictureExtention(string extention, string filetype = "")
            => AddExtention(FileType.Picture, extention, filetype);
        public static bool AddAudioExtention(string extention, string filetype = "")
            => AddExtention(FileType.Audio, extention, filetype);
        private static bool AddExtention(FileType type, string extention, string filetype)
        {
            var list = Extentions[type];
            if (!list.Contains(extention))
            {
                list.Add(new ExtentionBase(filetype, extention));
                var dic = new Dictionary<FileType, List<ExtentionBase>>(Extentions) { [type] = list };
                Extentions = dic;
                return true;
            }
            return false;
        }
        public static bool IsMovie(string file)
            => MovieExtentions.Contains(Path.GetExtension(file));
        public static bool IsPicture(string file)
            => PictureExtentions.Contains(Path.GetExtension(file));
        public static bool IsAudio(string file)
            => AudioExtentions.Contains(Path.GetExtension(file));
    }

    [Serializable()]
    public struct ExtentionBase : IEquatable<ExtentionBase>
    {
        public string Type { get; private set; }
        [JsonPropertyName("Extention")]
        public string Name { get; private set; }
        [JsonIgnore]
        public FourCC? CC {
            get
            {
                if (CCstring == null) return null;
                else return VideoWriter.FourCC(CCstring);
            }
        }
        [JsonPropertyName("CC")]
        public string CCstring { get; }
        [JsonIgnore]
        public bool IsOutput { get; }

        public ExtentionBase(string type, string extention)
            : this(type, extention, null) { }
        public ExtentionBase(string type, string extention, string cc)
        {
            if (extention == null) throw new ArgumentNullException(nameof(extention));
            Type = type;
            if (extention[0] != '.') extention = "." + extention;
            Name = extention;
            if (cc == null)
            {
                CCstring = "";
                IsOutput = false;
            }
            else
            {
                CCstring = cc;
                IsOutput = false;
            }

        }

        public static bool operator ==(ExtentionBase left, ExtentionBase right)
            => left.Equals(right);
        public static bool operator !=(ExtentionBase left, ExtentionBase right)
            => !(left == right);
        public static implicit operator string(ExtentionBase ext)
            => ext.Name;
        public static implicit operator ExtentionBase(string ext)
            => ToExtentionBase(ext);
        public static ExtentionBase ToExtentionBase(string ext)
            => new ExtentionBase("StringExtention", ext);

        public override bool Equals(object obj)
        {
            if (obj is string) return Name == (string)obj;
            else if (obj is ExtentionBase ext) return Equals(ext);
            else return false;
        }
        public bool Equals(ExtentionBase ext)
        {
            if (ext.Type == "StringExtention") return Name == ext.Name;
            else return base.Equals(ext);
        }
        public override int GetHashCode() => HashCode.Combine(Name);
        public override string ToString() => Name;
    }
}
