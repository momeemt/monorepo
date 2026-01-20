using System;
using System.Collections.Generic;
using OpenCvSharp;
using static MovieEdit.TL.TimelineObject;
using static MovieEdit.TL.TimelineObject.TimelineObjectType;

namespace MovieEdit.Effects
{
    public static class PrintEffect
    {
        public static ColorConvart COLORCONVERT(ColorConversionCodes code)
            => new ColorConvart(code);
        public static Flip FLIP(FlipMode mode) => new Flip(mode);
        [Obsolete("Can't change")]
        public static Opacity OPACITTY(byte value) => new Opacity(value);
        public static Rect RECT(Point point, Size size) => new Rect(point, size);
        public static Resize RESIZE(double scale) => new Resize(scale);
        public static Rotate ROTATE(double value, double scale) => new Rotate(value, scale);
        public static Threshold THRESHOLD(int threst, ThresholdTypes thType, MorphTypes moType)
            => new Threshold(threst, thType, moType);
    }

    public abstract class PrintEffectBase : Base
    {
        private readonly List<TimelineObjectType> Types;

        protected private PrintEffectBase(string name, string explain, object[] value, params TimelineObjectType[] types)
            : base(name, explain, value, BaseType.Effect) { Types = new List<TimelineObjectType>(types); }

        public abstract Mat Processing(Mat source);

        public bool CanEffect(TimelineObjectType type) => Types.Contains(type);
    }
    public abstract class PrintEffectBase<A> : PrintEffectBase
    {
        protected private A Value1
        {
            get => (A)Values[0];
            set => Values[0] = value;
        }

        public PrintEffectBase(string name, string explain, A value1, params TimelineObjectType[] types)
            : base(name, explain, new object[] { value1 }, types) { }
    }
    public abstract class PrintEffectBase<A, B> : PrintEffectBase
    {
        protected private A Value1
        {
            get => (A)Values[0];
            set => Values[0] = value;
        }
        protected private B Value2
        {
            get => (B)Values[1];
            set => Values[1] = value;
        }

        public PrintEffectBase(string name, string explain, A value1, B value2, params TimelineObjectType[] types)
            : base(name, explain, new object[] { value1, value2 }, types) { }
    }
    public abstract class PrintEffectBase<A, B, C> : PrintEffectBase
    {
        protected private A Value1
        {
            get => (A)Values[0];
            set => Values[0] = value;
        }
        protected private B Value2
        {
            get => (B)Values[1];
            set => Values[1] = value;
        }
        protected private C Value3
        {
            get => (C)Values[2];
            set => Values[2] = value;
        }

        public PrintEffectBase(string name, string explain, A value1, B value2, C value3, params TimelineObjectType[] types)
            : base(name, explain, new object[] { value1, value2, value3 }, types) { }
    }
    public interface IPrintPrintEffect
    {
        protected private List<TimelineObjectType> Types { get; }

    }
    public interface IAudioPrintEffect
    {
        List<TimelineObjectType> Types { get; }

    }

    public class Chromakey : PrintEffectBase<string>
    {
        internal Chromakey() : base("", "", "", Movie, Picture) { }

        public override Mat Processing(Mat mat)
        {
            throw new NotImplementedException();
        }
    }

    public class Flip : PrintEffectBase<FlipMode>
    {
        internal Flip(FlipMode mode) : base("", "", mode, Movie, Picture) { }

        public override Mat Processing(Mat source)
        {
            var res = new Mat();
            Cv2.Flip(source, res, Value1);
            return res;
        }
    }

    public class ColorConvart : PrintEffectBase<ColorConversionCodes>
    {
        internal ColorConvart(ColorConversionCodes code) : base("", "", code, Movie, Picture) { }

        public override Mat Processing(Mat source)
        {
            var res = new Mat();
            Cv2.CvtColor(source, res, Value1);
            return res;
        }
    }

    [Obsolete("Can't change")]
    public class Opacity : PrintEffectBase<byte>
    {
        internal Opacity(byte value) : base("", "", value, Movie, Picture) { }

        public override Mat Processing(Mat mat)
        {
            if (mat == null) throw new ArgumentNullException(nameof(mat));
            Mat alpha = new Mat(mat.Size(), MatType.CV_8UC3);
            Cv2.CvtColor(mat, alpha, ColorConversionCodes.BGR2RGBA);
            for (int y = 0; y < alpha.Height; y++)
            {
                for (int x = 0; x < alpha.Width; x++)
                {
                    var px = alpha.At<Vec4b>(y, x);
                    px[3] = Value1;
                    alpha.Set(y, x, px);
                }
            }
            return alpha;
        }
    }

    public class Rect : PrintEffectBase<Point, Size>
    {
        internal Rect(Point point, Size size) : base("", "", point, size, Movie, Picture) { }

        public override Mat Processing(Mat source)
        {
            if (source == null) throw new ArgumentNullException(nameof(source));
            return source.Clone(new OpenCvSharp.Rect(Value1, Value2));
        }
    }

    public class Resize : PrintEffectBase<double>
    {
        internal Resize(double scale) : base("", "", scale, Movie, Picture) { }

        public override Mat Processing(Mat source)
        {
            if (source == null) throw new ArgumentNullException(nameof(source));
            var res = new Mat();
            if (Value1 != 1) Cv2.Resize(source, res, new Size(source.Width * Value1, source.Height * Value1));
            else res = source;
            return res;
        }
    }

    public class Rotate : PrintEffectBase<double, double>
    {
        internal Rotate(double value, double scale = 1.0) : base("", "", value, scale, Movie, Picture){ }

        public override Mat Processing(Mat source)
        {
            if (source == null) throw new ArgumentNullException(nameof(source));
            if (Value1 / 360 >= 1) Value1 %= 360;
            if (Value1 == 0) return source;
            if (Value1 % 90 == 0)
            {
                return (Value1 / 90) switch
                {
                    1 => Rotation(source, RotateFlags.Rotate90Clockwise, Value2),
                    2 => Rotation(source, RotateFlags.Rotate180, Value2),
                    3 => Rotation(source, RotateFlags.Rotate90Counterclockwise, Value2),
                    _ => throw new Exception(),
                };
            }
            else
            {
                var res = new Mat();
                var mat = Cv2.GetRotationMatrix2D(new Point2f(source.Width / 2, source.Height / 2), Value1, Value2);
                double w = 1 / Math.Cos(Value1 * Math.PI / 180) * (source.Width + source.Height);
                double h = 1 / Math.Cos((360 - Value1) * Math.PI / 180) * (source.Width + source.Height);
                Cv2.WarpAffine(source, res, mat, new Size(w, h));
                return res;
            }
        }
        private Mat Rotation(Mat source, RotateFlags flag, double scale)
        {
            Mat mat = new Mat();
            Cv2.Rotate(source, mat, flag);
            return new Resize(scale).Processing(mat);
        }
    }

    public class Threshold : PrintEffectBase<int, ThresholdTypes, MorphTypes?>
    {
        internal Threshold(int threst, ThresholdTypes thType, MorphTypes? moType = null)
            : base("", "", threst, thType, moType, Movie, Picture) { }

        public override Mat Processing(Mat source)
        {
            if (source == null) throw new ArgumentNullException(nameof(source));
            var res = new Mat();
            Cv2.Threshold(source, res, Value1, 255, Value2);
            if(Value3 != null)
            {
                var type = (MorphTypes)Value3;
                var mat = new Mat();
                Cv2.MorphologyEx(res, mat, type, null);
                res = mat;
            }
            return res;
        }
    }
}