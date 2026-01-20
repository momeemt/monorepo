using MovieEdit.Effects;
using MovieEdit.TL;
using OpenCvSharp;
using System;
using System.Collections.Generic;
using static OpenCvSharp.VideoCaptureProperties;
using static System.StringComparison;

namespace MovieEdit.IO
{
    public class Movie
    {
        public static void OutputMovie(string path, string extention, FourCC cc,
            VideoCapture cap = null, Dictionary<FrameInfo, PrintEffectBase> effect = null)
        {
            if (path == null) throw new ArgumentNullException(nameof(path));
            if (extention == null) throw new ArgumentNullException(nameof(extention));

            if (extention[0] != '.') extention = "." + extention;
            if (!path.EndsWith(extention, CurrentCulture)) path += extention;
            Size size = new Size(cap.Get(FrameWidth), cap.Get(FrameHeight));
            double fps = cap.Get(Fps);
            VideoWriter vw = new VideoWriter(path, cc, fps, size);
            Mat frame;
            cap.Set(PosFrames, 0);
            do
            {
                frame = cap.RetrieveMat();
                var f = (uint)cap.Get(PosFrames);
                foreach (var eff in effect)
                {
                    if (eff.Key.Begin <= f && f <= eff.Key.End) frame = eff.Value.Processing(frame);
                }
                vw.Write(frame);
                Log.Progress("Outputing Movie", f / cap.Get(FrameCount) * 100);
            }
            while (!frame.Empty());
            vw.Dispose();
        }

        public static void OutputMovie(string path, ExtentionBase extention,
            VideoCapture cap = null, Dictionary<FrameInfo, PrintEffectBase> effect = null)
        {
            if (extention.CC is FourCC cc) OutputMovie(path, extention.Name, cc, cap, effect);
            else Log.Error("対応していないコーデックです");
        }

        private void OutputMovie(FourCC cc, string extention)
        {

        }
        public static void FrameMat(uint frame, VideoCapture cap = null)
        {
            if(cap != null)
            {
                
            }
        }
    }
}
