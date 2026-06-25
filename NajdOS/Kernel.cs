using System;
using Sys = Cosmos.System;
using Cosmos.System.Graphics;
using System.Drawing;
using NajdOS.Kernel;
using NajdOS.GUI;
using NajdOS.Drivers;
using NajdOS.System;

namespace NajdOS
{
    public class Kernel : Sys.Kernel
    {
        private Canvas canvas;

        protected override void BeforeRun()
        {
            // 1. تهيئة الشاشة (800x600)
            canvas = FullScreenCanvas.GetFullScreenCanvas(new Mode(800, 600, ColorDepth.ColorDepth32));
            
            // 2. إطلاق محرك الحماية فوراً
            SecurityEngine.Initialize();
            
            // 3. تهيئة نظام الملفات
            FileManager.Initialize();

            // 4. شاشة الإقلاع (الترحيب)
            canvas.Clear(Color.FromArgb(6, 10, 26)); // اللون الملكي
            Console.WriteLine("========================================");
            Console.WriteLine("      Welcome to Najd OS - نجد OS       ");
            Console.WriteLine("    The Sovereign Security System      ");
            Console.WriteLine("========================================");
            Console.WriteLine("System Status: Initializing Kernel...");
            Console.WriteLine("User: Yazan | Integrity: Verified");
            
            // 5. تهيئة الواجهة
            WindowManager.Initialize(canvas);
        }

        protected override void Run()
        {
            // رسم خلفية النظام في كل دورة (Frame)
            canvas.Clear(Color.FromArgb(6, 10, 26));

            // رسم النافذة الرئيسية للواجهة
            WindowManager.DrawWindow(100, 100, 600, 400, "Najd OS Desktop");

            // تشغيل الماوس
            MouseDriver.UpdateMouse(canvas);

            // تحديث الشاشة
            canvas.Display();
        }
    }
}
