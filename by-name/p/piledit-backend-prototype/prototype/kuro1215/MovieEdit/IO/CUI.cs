using MovieEdit.Effects;
using MovieEdit.TL;
using OpenCvSharp;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using static MovieEdit.Language;

namespace MovieEdit.IO
{
    public static class CUI
    {
        public static void Input()
        {
            VideoCapture cap = null;
            var dic = new Dictionary<FrameInfo, PrintEffectBase>();
            Camera cam = null;
            string msg = "Enter the command...";
            while (true)
            {
                string[] cmd = Inline(msg, true).Split(" ");
                msg = null;
                if (cmd[0] == "exit") break;
                else if (cmd[0] == "load")
                {
                    if (!File.Exists(cmd[1]))
                    {
                        Log.Error("The file is not found.");
                        continue;
                    }
                    cap = new VideoCapture(cmd[1]);
                    Log.Info("Loading OK.");
                }
                else if (cmd[0] == "unload")
                {
                    cap.Dispose();
                    Log.Info("Unloading completed.");
                }
                else if (cmd[0] == "effect")
                {
                    if (cmd[1] == "flip")
                    {
                        var fi = new FrameInfo(uint.Parse(cmd[3], SystemLang), uint.Parse(cmd[4], SystemLang));
                        if (cmd[2] == "X") dic.Add(fi, PrintEffect.FLIP(FlipMode.X));
                    }
                }
                else if (cmd[0] == "output")
                {
                    Movie.OutputMovie(cmd[1], ".avi", VideoWriter.FourCC('J', 'P', 'E', 'G'), cap, dic);
                }
                else if (cmd[0] == "cam")
                {
                    if (cam == null) cam = new Camera();
                    if (cmd[1] == "open") cam.Open();
                    else if (cmd[1] == "show" && !cam.IsShow) Task.Run(() => { cam.Show(); });
                    else if (cmd[1] == "close") cam.Close();
                    else continue;
                    Log.Info("Camera " + cmd[1]);
                }
                else if (cmd[0] == "show")
                {
                    if(cap != null) Task.Run(() => { Show(cap); });
                }
                else
                {
                    Log.Warn("Illegual command : " + cmd[0]);
                }
            }
            cap.Dispose();
            cam.Dispose();
        }

        public static string Inline(string msg, bool cmd = false)
        {
            if (msg != null) Log.Message(msg);
            string line = Console.ReadLine().Replace("\"", "", StringComparison.CurrentCulture);
            if (!cmd) Log.Input($"InputData:\"{line}\"");
            return line;
        }

        private static void Show(VideoCapture cap)
        {
            Mat frame;
            while (true)
            {
                frame = cap.RetrieveMat();
                if (frame.Empty()) break;
                Cv2.ImShow("preview", frame);
                int key = Cv2.WaitKey(33);
                double frame_position = cap.Get(VideoCaptureProperties.PosFrames);

                if (key == ' ') Cv2.WaitKey();
                else if (key == 'j') cap.Set(VideoCaptureProperties.PosFrames, frame_position - 20);
                else if (key == 'k') cap.Set(VideoCaptureProperties.PosFrames, frame_position + 20);
                else if (key == 0x1b) break;
            }
        }
    }
}
