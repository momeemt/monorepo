using OpenCvSharp;
using System;
using static MovieEdit.Effects.Blur;

namespace MovieEdit.Effects
{
    public static class Filter
    {
        public static Blur BLUR(BlurType type) => new Blur(type);
        public static Mosaic MOSAIC(double rx, double ry) => new Mosaic(rx, ry);
        public static Mosaic MOSAIC(Size size) => new Mosaic(size);
    }

    public abstract class FilterBase : Base
    {
        protected private FilterBase(string name, string explain, params object[] value)
            : base(name, explain, value, BaseType.Filter) { }

        public abstract Mat Filtering(Mat source, Point point, Size size);

        public Mat Filtering(Mat source)
        {
            if (source == null) throw new ArgumentNullException(nameof(source));
            return Filtering(source, new Point(0, 0), source.Size());
        }
    }
    public abstract class FilterBase<A> : FilterBase
    {
        protected private A Value1
        {
            get => (A)Values[0];
            set => Values[0] = value;
        }

        public FilterBase(string name, string explain, A value1)
            : base(name, explain, value1) { }
    }
    public abstract class FilterBase<A, B> : FilterBase
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

        public FilterBase(string name, string explain, A value1, B value2)
            : base(name, explain, value1, value2) { }
    }
    public abstract class FilterBase<A, B, C> : FilterBase
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

        public FilterBase(string name, string explain, A value1, B value2, C value3)
            : base(name, explain, value1, value2, value3) { }
    }

    public class Blur : FilterBase<BlurType>
    {
        public enum BlurType
        {
            Smooth3x3, Smooth5x5, Gaussian3x3, Gaussian5x5, Mediun3x3, Mediun5x5
        }

        internal Blur(BlurType type) : base("Blur", "", type) { }

        public override Mat Filtering(Mat source, Point point, Size size)
        {
            Mat res = new Mat();
            var mat = PrintEffect.RECT(point, size).Processing(source);
            switch (Value1)
            {
                case BlurType.Smooth3x3:
                    Cv2.Blur(mat, res, new Size(3, 3));
                    break;
                case BlurType.Smooth5x5:
                    Cv2.Blur(mat, res, new Size(5, 5));
                    break;
                case BlurType.Gaussian3x3:
                    Cv2.GaussianBlur(mat, res, new Size(3, 3), 0);
                    break;
                case BlurType.Gaussian5x5:
                    Cv2.GaussianBlur(mat, res, new Size(5, 5), 0);
                    break;
                case BlurType.Mediun3x3:
                    Cv2.MedianBlur(mat, res, 3);
                    break;
                case BlurType.Mediun5x5:
                    Cv2.MedianBlur(mat, res, 5);
                    break;
            }
            return res;
        }
    }

    public class Mosaic : FilterBase<double, double, Size?>
    {
        internal Mosaic(double ratio_x, double ratio_y) : base("Mosaic", "", ratio_x, ratio_y, null) { }
        internal Mosaic(double ratio) : this(ratio, ratio) { }
        internal Mosaic(Size pixel) : base("Mosaic", "", -1, -1, pixel) { }

        public override Mat Filtering(Mat source, Point point, Size size)
        {
            if (source == null) throw new ArgumentNullException(nameof(source));
            Mat res = new Mat();
            if (Value3 != null)
            {
                Size pixel = (Size)Value3;
                Value1 = (double)pixel.Width / size.Width;
                Value2 = (double)pixel.Height / size.Height;
            }
            var mat = new Mat();
            Cv2.Resize(source, mat, new Size(), Value1, Value2, InterpolationFlags.Nearest);
            Cv2.Resize(mat, res, source.Size(), interpolation: InterpolationFlags.Nearest);
            return res;
        }
    }
}