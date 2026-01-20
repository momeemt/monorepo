using OpenCvSharp;
using System;
using System.Collections.Generic;
using System.Text;

namespace MovieEdit.IO
{
    public class Camera : IDisposable
    {
        public VideoCapture OpeningCamera { get; private set; }
        public bool IsShow { get; private set; } = false;

        public Camera() { }
        public Camera(int id) { Open(id); }

        public void Open(int id = 0)
        {
            OpeningCamera = new VideoCapture(id);
        }
        public void Show()
        {
            if (!IsCamera()) return;
            Mat frame = new Mat();
            IsShow = true;
            while (Cv2.WaitKey(1) == -1 && IsShow)
            {
                OpeningCamera.Read(frame);
                Cv2.ImShow("Camera", frame);
            }
            Cv2.DestroyWindow("Camera");
            frame.Dispose();
            IsShow = false;
        }
        public void Close(bool dispose = true)
        {
            if (!IsCamera(false)) return;
            IsShow = false;
            if (dispose) Dispose();
        }
        private bool IsCamera(bool msg = true)
        {
            if (OpeningCamera == null)
            {
                if (msg) Log.Error("指定されたCameraは解放済みのため、再定義して使用してください");
                return false;
            }
            else return true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        protected virtual void Dispose(bool disposing)
        {
            if (IsCamera(false)) return;
            if (disposing)
            {
                OpeningCamera.Dispose();
                OpeningCamera = null;
            }
        }
        ~Camera()
        {
            Dispose(false);
        }
    }
}
