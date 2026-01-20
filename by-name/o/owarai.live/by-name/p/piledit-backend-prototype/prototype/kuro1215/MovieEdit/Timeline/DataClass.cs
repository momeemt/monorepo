using System;
using System.Globalization;
using System.Text.Json.Serialization;
using static MovieEdit.Language;

namespace MovieEdit.TL
{
    public class TLInfo<T> where T : TimelineObject
    {
        public ushort Layer { get; internal set; }
        public FrameInfo Frame { get; internal set; }
        public T TLObject { get; }

        public TLInfo(ushort layer, FrameInfo frame, T obj)
        {
            Layer = layer;
            Frame = frame;
            TLObject = obj;
        }
    }

    public struct FrameInfo : IEquatable<FrameInfo>
    {
        public uint Begin { get; private set; }
        public uint End { get; private set; }
        [JsonIgnore]
        public uint Length { get => (uint)Math.Abs(End - Begin); }

        public static implicit operator FrameInfo(uint frame) => ToFrameInfo(frame);
        public static FrameInfo ToFrameInfo(uint frame) => new FrameInfo(frame, frame);
        public static bool operator ==(FrameInfo left, FrameInfo right)
            => left.Equals(right);
        public static bool operator !=(FrameInfo left, FrameInfo right)
            => !(left == right);

        public FrameInfo(uint begin, uint end)
        {
            Begin = begin; End = end;
        }

        public void Change(uint begin, uint end)
        {
            Begin = begin; End = end;
        }

        public override bool Equals(object obj)
        {
            if (obj is FrameInfo frame) return Equals(frame);
            else return false;
        }
        public bool Equals(FrameInfo frame)
        {
            if (frame.Length == 0) return Begin <= frame.Begin && frame.Begin <= End;
            else return Begin == frame.Begin && End == frame.End;
        }
        public override int GetHashCode()
        {
            return HashCode.Combine(Begin, End);
        }
    }
    public struct PositionInfo : IEquatable<PositionInfo>
    {
        public enum ReferencePosition
        {
            LeftUp, MiddleUp, RightUp, LeftMid, Center, RightMid, LeftDown, MiddleDown, RightDown
        }
        public double X { get; private set; }
        public double Y { get; private set; }
        public ReferencePosition Reference { get; private set; }

        public PositionInfo(double posX, double posY, ReferencePosition reference = ReferencePosition.Center)
        {
            X = posX;
            Y = posY;
            Reference = reference;
        }
        
        public static bool operator ==(PositionInfo left, PositionInfo right)
            => left.Equals(right);
        public static bool operator !=(PositionInfo left, PositionInfo right)
            => !(left == right);

        internal void Change(double posX, double posY)
        {
            X = posX;
            Y = posY;
        }
        internal void Change(ReferencePosition reference)
        {
            Reference = reference;
        }

        public override bool Equals(object obj)
        {
            if (obj is PositionInfo pos) return Equals(pos);
            else return false;
        }
        public bool Equals(PositionInfo other)
        {
            return base.Equals(other);
        }
        public override int GetHashCode()
        {
            return HashCode.Combine(this);
        }
    }

    public struct Color : IEquatable<Color>
    {
        public byte Red { get; set; }
        public byte Green { get; set; }
        public byte Blue { get; set; }
        [JsonIgnore]
        public string ColorCode
        {
            get => "#" + string.Format(SystemLang, "{0:X6}", Red * 10000 + Green * 100 + Blue);
        }

        public Color(byte r, byte g, byte b)
        {
            Red = r;
            Green = g;
            Blue = b;
        }
        public Color(string code)
        {
            if (code == null) throw new ArgumentNullException(nameof(code));
            if (code[0] == '#') code = code.Substring(1);
            Red = (byte)int.Parse(code.Substring(0, 2), NumberStyles.HexNumber, SystemLang);
            Green = (byte)int.Parse(code.Substring(3, 2), NumberStyles.HexNumber, SystemLang);
            Blue = (byte)int.Parse(code.Substring(5, 2), NumberStyles.HexNumber, SystemLang);
        }

        public static bool operator ==(Color left, Color right)
            => left.Equals(right);
        public static bool operator !=(Color left, Color right)
            => !(left == right);

        public override bool Equals(object obj)
        {
            if (obj is Color color) return Equals(color);
            else return false;
        }
        public bool Equals(Color other)
        {
            return base.Equals(other);
        }
        public override int GetHashCode()
        {
            return HashCode.Combine(this);
        }
        public override string ToString()
        {
            return ColorCode;
        }
    }
}
