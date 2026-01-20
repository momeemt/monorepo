using MovieEdit.TL;
using OpenCvSharp;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

namespace MovieEdit
{
    public class Project
    {
        public Size OutputSize { get; private set; }
        public string ProjectPath { get; }
        public IReadOnlyList<string> ObjectsPath { get; }
        public Timeline Timeline { get; }

        private Project(string path, Size size, Timeline timeline)
        {
            OutputSize = size;
            ProjectPath = path;
            Timeline = timeline;
        }

        public void ChangeSize(int width, int heigth)
        {
            OutputSize = new Size(width, heigth);
        }

        public Project Create(string path, Size size)
        {
            return new Project(path, size, new Timeline());
        }

        public static Project Load(string path)
        {
            return Load(path);
        }

        public void Save()
        {
            SaveNewFile(ProjectPath, FileMode.Open);
        }

        public void SaveNewFile(string file, FileMode mode = FileMode.CreateNew)
        {
            using var stream = new FileStream(file, mode, FileAccess.Write);
            BinaryFormatter bf = new BinaryFormatter();
            bf.Serialize(stream, this);
        }
    }
}
