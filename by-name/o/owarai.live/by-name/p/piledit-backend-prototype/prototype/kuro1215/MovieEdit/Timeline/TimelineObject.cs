using MovieEdit.Effects;
using OpenCvSharp;
using OpenCvSharp.Extensions;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text.Json.Serialization;
using static MovieEdit.MESystem;
using static MovieEdit.Effects.Base.BaseType;
using Point = OpenCvSharp.Point;
using System.Diagnostics.CodeAnalysis;

namespace MovieEdit.TL
{
    public class TimelineMovie : TimelinePrintObject, IDisposable
    {
        public string FilePath { get; }
        private VideoCapture mov = null;
        [JsonIgnore]
        public VideoCapture Movie
        {
            get => mov ?? (mov = new VideoCapture(FilePath));
            set => mov = value;
        }
        public double Speed { get; set; }
        public FrameInfo Frame { get; private set; }

        public TimelineMovie(PositionInfo pos, string path, FrameInfo? frame = null, double speed = 1.0)
            : base(TimelineObjectType.Movie, pos)
        {
            if (File.Exists(path) && IsMovie(path))
            {
                FilePath = path;
                mov = new VideoCapture(FilePath);
                Speed = speed;
                if (frame == null) frame = new FrameInfo(0, (uint)mov.Get(VideoCaptureProperties.FrameCount));
                Frame = (FrameInfo)frame;
            }
            else
            {
                throw new FileNotFoundException("", path);
            }
        }

        public override Mat GetMat(uint frame)
        {
            var mov = Movie;
            mov.Set(VideoCaptureProperties.PosFrames, Frame.Begin + frame);
            var mat = mov.RetrieveMat();
            foreach (var eff in Effects) mat = eff.Processing(mat);
            return mat;
        }
        public override EditTask[] ToTasks()
        {
            throw new NotImplementedException();
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        protected virtual void Dispose(bool disposing)
        {
            if (mov == null) return;
            if (disposing)
            {
                mov.Dispose();
                mov = null;
            }
        }
        ~TimelineMovie()
        {
            Dispose(false);
        }
    }

    public class TimelinePicture : TimelinePrintObject, IDisposable
    {
        public string FilePath { get; }
        private Mat pic = null;
        [JsonIgnore]
        public Mat Picture
        {
            get
            {
                if (pic == null) pic = new Mat(FilePath);
                return pic;
            }
            set { pic = value; }
        }

        public TimelinePicture(PositionInfo pos, string path)
            : base(TimelineObjectType.Picture, pos)
        {
            if(File.Exists(path) && IsPicture(path))
            {
                FilePath = path;
                Picture = new Mat(path);
            }
            else
            {
                throw new FileNotFoundException("", path);
            }
        }

        public override Mat GetMat(uint frame)
        {
            return Picture;
        }
        public override EditTask[] ToTasks()
        {
            throw new NotImplementedException();
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        protected virtual void Dispose(bool disposing)
        {
            if (pic == null) return;
            if (disposing)
            {
                pic.Dispose();
                pic = null;
            }
        }
        ~TimelinePicture()
        {
            Dispose(false);
        }
    }

    public class TimelineAudio : TimelineObject
    {
        public string FilePath { get; }
        public double Speed { get; set; }
        public new IReadOnlyList<AudioEffectBase> Effects { get; private set; }
        public FrameInfo Frame { get; private set; }

        public TimelineAudio(PositionInfo pos, string path, FrameInfo? frame, double speed = 1.0)
            : base(TimelineObjectType.Audio, pos)
        {
            if (File.Exists(path) && IsAudio(path))
            {
                FilePath = path;
                Speed = speed;
                if (frame == null) frame = new FrameInfo(0, 1);
                Frame = (FrameInfo)frame;
            }
            else
            {
                throw new FileNotFoundException("", path);
            }
        }

        public void AddEffect(AudioEffectBase effect)
        {
            Effects = new List<AudioEffectBase>(Effects) { effect };
        }
        public override void AddEffect(Base effect)
        {
            if (effect is AudioEffectBase aeb) AddEffect(aeb);
            else throw new InvalidCastException();
        }
        public override bool CanEffect(Base effect)
            => effect is AudioEffectBase;

        public override EditTask[] ToTasks()
        {
            throw new NotImplementedException();
        }
    }

    public class TimelineSquare : TimelinePrintObject
    {
        public Color Color { get; private set; }
        public int Thickness { get; private set; }
        public IReadOnlyList<Vertex> Vertexes { get; private set; }
        public int Polygon { get => Vertexes.Count; }

        public TimelineSquare(PositionInfo pos, int thick, params Vertex[] vert)
            : base(TimelineObjectType.Square, pos)
        {
            var list = new List<Vertex>();
            for(int i = 0; i < vert.Length; i++)
            {
                int back = i - 1, next = i + 1;
                if (i == 0) back = vert.Length - 1;
                else if (i == vert.Length - 1) next = 0;
                list.Add(new Vertex(vert[i].Position, vert));
            }
            Vertexes = list;
            Thickness = thick;
        }

        public void AddVertex(Point pos, params Vertex[] connect)
        {
            var list = new List<Vertex>(Vertexes);
            foreach(var v in list)
            {
                if (v != pos) continue;
                Log.Error("This position's vertex is exsisted.");
                return;
            }
            var vert = new Vertex(pos, connect);
            foreach (var v in connect)
            {
                if (!list.Contains(v)) continue;
                list[list.IndexOf(v)].AddConnection(vert);
            }
            list.Add(vert);
            Vertexes = list;
            ChangeAction();
        }
        public void AddConnection(Vertex vert1, Vertex vert2)
        {
            var list = new List<Vertex>(Vertexes);
            if (list.Contains(vert1) && list.Contains(vert2))
            {
                list[list.IndexOf(vert1)].AddConnection(vert2);
                list[list.IndexOf(vert2)].AddConnection(vert1);
            }
        }
        public void ChangeColor(Color color)
        {
            Color = color;
            ChangeAction();
        }
        public void ChangeThickness(int thick)
        {
            Thickness = thick;
            ChangeAction();
        }
        public void ChangeVertexPos(Vertex vert, Point pos)
        {
            var list = new List<Vertex>(Vertexes);
            if (list.Contains(vert))
            {
                list[list.IndexOf(vert)].ChangePos(pos);
                ChangeAction();
            }
        }
        public Vertex GetVertex(Point point)
        {
            foreach(var vert in Vertexes)
            {
                if (vert == point) return vert;
            }
            return null;
        }
        public bool TryGetVertex(Point point, ref Vertex vertex)
        {
            foreach (var vert in Vertexes)
            {
                if (vert != point) continue;
                vertex = vert;
                return true;
            }
            return false;
        }
        public bool RemoveVertex(Vertex vert)
        {
            var list = new List<Vertex>(Vertexes);
            if (!list.Contains(vert)) return false;
            var arr = list[list.IndexOf(vert)].Connection.ToArray();
            foreach (var con in arr)
            {
                list[list.IndexOf(vert)].RemoveConnection(con);
                con.GetOtherPoint(vert).RemoveConnection(con);
            }
            list.Remove(vert);
            Vertexes = list;
            ChangeAction();
            return true;
        }

        public override Mat GetMat(uint frame)
        {
            var mat = new Mat();
            foreach(var vert in Vertexes)
                foreach (var con in vert.Connection)
                    Cv2.Line(mat, con.Point1.Position, con.Point2.Position, new Scalar(Color.Red, Color.Green, Color.Blue), Thickness);
            return mat;
        }
        public override EditTask[] ToTasks()
        {
            throw new NotImplementedException();
        }
    }
    public class Vertex : IEquatable<Vertex>, IEquatable<Point>
    {
        public IReadOnlyList<VertexConnection> Connection { get; private set; }
        public Point Position { get; private set; }

        public Vertex(Point pos, params Vertex[] connect)
        {
            Position = pos;
            var list = new List<VertexConnection>();
            if (connect != null)
            {
                foreach(var p in connect)
                {
                    list.Add(new VertexConnection(this, p));
                }
            }
            Connection = list;
        }

        public static bool operator ==(Vertex left, Vertex right)
            => left.Equals(right);
        public static bool operator !=(Vertex left, Vertex right)
            => !(left == right);
        public static bool operator ==(Vertex left, Point right)
            => left.Equals(right);
        public static bool operator !=(Vertex left, Point right)
            => !(left == right);

        internal void AddConnection(Vertex vert)
        {
            Connection = new List<VertexConnection>(Connection) { new VertexConnection(this, vert) };
        }
        internal void AddConnection(VertexConnection connection)
        {
            Connection = new List<VertexConnection>(Connection) { connection };
        }
        internal void ChangePos(Point pos)
        {
            Position = pos;
        }
        internal void RemoveConnection(VertexConnection con)
        {
            if (!con.IsConnectionPoint(Position)) return;
            var list = new List<VertexConnection>(Connection);
            list.Remove(con);
            Connection = list;
        }
        internal void ReplaceConnection(Vertex before, Vertex after)
        {
            var list = new List<VertexConnection>(Connection);
            list.Remove(new VertexConnection(this, before));
            list.Add(new VertexConnection(this, after));
            Connection = list;
        }

        public Point ToPoint() => Position;
        public override bool Equals(object obj)
            => obj is Vertex vert ? Equals(vert) : false;
        public bool Equals(Vertex vert) => base.Equals(vert);
        public bool Equals([AllowNull] Point other) => Position == other;
        public override int GetHashCode() => HashCode.Combine(Position);
    }
    public class VertexConnection : IEquatable<VertexConnection>
    {
        public Vertex Point1 { get; private set; }
        public Vertex Point2 { get; private set; }
        private string NotPointMsg { get; }

        public VertexConnection(Vertex pos1, Vertex pos2)
        {
            Point1 = pos1;
            Point2 = pos2;
            NotPointMsg = "This point is not exsisted the connection.";
        }

        public static bool operator ==(VertexConnection left, VertexConnection right)
            => left.Equals(right);
        public static bool operator !=(VertexConnection left, VertexConnection right)
            => !(left == right);

        public Vertex GetOtherPoint(Point point)
            => Point1 == point ? Point2 : Point2 == point ? Point1
            : throw new ArgumentException(NotPointMsg, nameof(point));
        public Vertex GetOtherPoint(Vertex vert)
            => Point1 == vert ? Point2 : Point2 == vert ? Point1
            : throw new ArgumentException(NotPointMsg, nameof(vert));
        public bool TryGetOtherPoint(Point point, ref Vertex outv)
        {
            if (Point1 == point)
            {
                outv = Point2;
                return true;
            }
            else if (Point2 == point)
            {
                outv = Point1;
                return true;
            }
            else return false;
        }
        public bool TryGetOtherPoint(Vertex vert, ref Vertex outv)
        {
            if (Point1 == vert)
            {
                outv = Point2;
                return true;
            }
            else if (Point2 == vert)
            {
                outv = Point1;
                return true;
            }
            else return false;
        }
        public bool IsConnectionPoint(Point point) => Point1 == point || Point2 == point;

        public override bool Equals(object obj)
            => obj is VertexConnection vc ? Equals(vc) : false;
        public bool Equals(VertexConnection vc)
            => (Point1 == vc.Point1 && Point2 == vc.Point2) || (Point1 == vc.Point2 && Point2 == vc.Point1);
        public override int GetHashCode()
            => HashCode.Combine(this);
    }

    public class TimelineText : TimelinePrintObject
    {
        public string Text { get; private set; }
        public Font Font { get; private set; }
        public Brush Color { get; private set; }

        public TimelineText(PositionInfo pos, string text, Font font, Brush color)
            : base(TimelineObjectType.Text, pos)
        {
            Text = text;
            Font = font;
            Color = color;
        }

        public void ChangeColor(Brush color)
        {
            Color = color;
            ChangeAction();
        }
        public void ChangeFont(Font font)
        {
            Font = font;
            ChangeAction();
        }
        public void ChangeText(string text)
        {
            Text = text;
            ChangeAction();
        }

        public override Mat GetMat(uint frame)
        {
            var size = OpeningProject.OutputSize;
            var bitmap = new Bitmap(size.Width, size.Height);
            Graphics g = Graphics.FromImage(bitmap);
            g.DrawString(Text, Font, Color, (float)Position.X, (float)Position.Y);
            g.Dispose();
            return BitmapConverter.ToMat(bitmap);
        }
        public override EditTask[] ToTasks()
        {
            throw new NotImplementedException();
        }
    }

    public class TimelineFilter : TimelinePrintObject
    {
        public FilterBase Filter { get; }

        public TimelineFilter(FilterBase filter, PositionInfo pos)
            : base(TimelineObjectType.Filter, pos)
        {
            Filter = filter;
        }

        public override Mat GetMat(uint frame)
        {
            throw new NotImplementedException();
        }
        public override EditTask[] ToTasks()
        {
            throw new NotImplementedException();
        }
    }

    public abstract class TimelineObject
    {
        public enum TimelineObjectType
        {
            Movie, Picture, Audio, Text, Square, Filter
        }

        public virtual IReadOnlyList<Base> Effects { get; private set; }
        public TimelineObjectType ObjectType { get; }
        public PositionInfo Position { get; }

        public virtual void AddEffect(Base effect)
        {
            if (effect == null) throw new ArgumentNullException(nameof(effect));
            if (effect.Type == Effect && CanEffect(effect))
                Effects = new List<Base>(Effects) { effect };
            else throw new InvalidCastException();
        }
        public abstract bool CanEffect(Base effect);

        public TimelineObject(TimelineObjectType type, PositionInfo pos)
        {
            ObjectType = type;
            Position = pos;
        }

        public abstract EditTask[] ToTasks();
    }

    public abstract class TimelinePrintObject : TimelineObject
    {
        public new IReadOnlyList<PrintEffectBase> Effects { get; private set; }
        //public List<FilterBase> Filter { get; private set; }

        public TimelinePrintObject(TimelineObjectType type, PositionInfo pos)
            : base(type, pos) { }

        public abstract Mat GetMat(uint frame);

        public void AddEffect(PrintEffectBase effect)
        {
            if (CanEffect(effect)) Effects = new List<PrintEffectBase>(Effects) { effect };
            else throw new InvalidCastException();
        }
        public override void AddEffect(Base effect)
        {
            if (effect is PrintEffectBase peb) AddEffect(peb);
            else throw new InvalidCastException();
        }
        public bool CanEffect(PrintEffectBase effect)
        {
            if (effect == null) throw new ArgumentNullException(nameof(effect));
            return effect.CanEffect(ObjectType);
        }
        public override bool CanEffect(Base effect)
        {
            if (effect == null) throw new ArgumentNullException(nameof(effect));
            if (effect is PrintEffectBase peb) return CanEffect(peb);
            else return false;
        }
        public void ChangePos(double posX, double posY)
        {
            Position.Change(posX, posY);
            ChangeAction();
        }
        public void ChangePosX(double posX)
        {
            ChangePos(posX, Position.Y);
        }
        public void ChangePosY(double posY)
        {
            ChangePos(Position.X, posY);
        }
        public void ChageReference(PositionInfo.ReferencePosition reference)
        {
            Position.Change(reference);
            ChangeAction();
        }
        protected void ChangeAction()
        {
            //Console.WriteLine("Action");
        }
    }
}
