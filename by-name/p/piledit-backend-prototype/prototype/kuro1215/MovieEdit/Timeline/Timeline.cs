using OpenCvSharp;
using System;
using System.Collections.Generic;
using System.Linq;

namespace MovieEdit.TL
{
    public class Timeline
    {
        public TimelineObject this[ushort layer, uint frame]
        {
            get => GetObject(layer, frame);
        }
        public TimelineObject this[ushort layer, FrameInfo frame]
        {
            get => GetObject(layer, frame);
        }
        private IReadOnlyDictionary<FrameInfo, TimelineObject>[] Objects;
        public int LayerCount { get => Objects.Length; }

        public Timeline()
        {
            Objects = Array.Empty<Dictionary<FrameInfo, TimelineObject>>();
        }

        public void AddObject(ushort layer, FrameInfo frame, TimelineObject obj)
        {
            var objs = Objects;
            if (LayerCount < layer) Array.Resize(ref objs, LayerCount);
            else if (objs[layer].ContainsKey(frame)) return;
            objs[layer] = new Dictionary<FrameInfo, TimelineObject>(objs[layer]) { { frame, obj } };
            Objects = objs;
        }
        public TimelineObject GetObject(ushort layer, uint frame)
        {
            return GetObject(layer, (FrameInfo)frame);
        }
        public TimelineObject GetObject(ushort layer, FrameInfo frame)
        {
            var dic = Objects[layer];
            return dic.ContainsKey(frame) ? dic[layer] : null;
        }

        public Mat GetMat(uint frame)
        {
            Mat mat = null;
            for(int i = 0;i < LayerCount; i++)
            {
                var obj = GetObject((ushort)i, frame);
                if (obj == null || !(obj is TimelinePrintObject)) continue;
                var tpo = obj as TimelinePrintObject;
                var fi = Objects[i].FirstOrDefault(c => c.Value == obj).Key;
                if(mat == null)
                {
                    mat = tpo.GetMat(frame - fi.Begin);
                    continue;
                }
                var src = tpo.GetMat(frame - fi.Begin);
                Mat gray = new Mat(), mask = new Mat(), res = new Mat(), nm = new Mat();
                Cv2.CvtColor(src, gray, ColorConversionCodes.BGR2GRAY);
                Cv2.BitwiseNot(gray, mask);
                Cv2.BitwiseOr(src, src, res, mask);
                Cv2.BitwiseOr(mat, res, nm);
                mat = nm;
            }
            return mat;
        }
        public Mat GetMat(ushort layer, uint frame)
        {
            Mat mat = null;
            var obj = GetObject(layer, frame);
            if (obj != null && obj is TimelinePrintObject)
            {
                var tpo = obj as TimelinePrintObject;
                var fi = Objects[layer].FirstOrDefault(c => c.Value == obj).Key;
                mat = tpo.GetMat(frame - fi.Begin);
            }
            return mat;
        }
    }
}
