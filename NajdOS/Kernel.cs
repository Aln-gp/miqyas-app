using System;
using System.IO;
using Cosmos.System.FileSystem;
using Cosmos.System.FileSystem.VFS;
using Cosmos.System.Graphics;
using Cosmos.System.Graphics.Fonts;
using System.Drawing;
using Sys = Cosmos.System;

namespace NajdOS
{
    public class Kernel : Sys.Kernel
    {
        // تعريف نظام الملفات والشاشة والماوس
        private CosmosVFS myFileSystem;
        private Canvas myCanvas;
        private uint screenWidth = 800;
        private uint screenHeight = 600;

        protected override void BeforeRun()
        {
            try
            {
                // 1. تهيئة نظام الملفات وتفعيله لقراءة الـ .najd والـ exe
                myFileSystem = new CosmosVFS();
                VFSManager.RegisterVFS(myFileSystem);
                Console.WriteLine("System File Manager initialized successfully.");

                // 2. تهيئة تفاعل الماوس داخل النظام
                Sys.MouseManager.ScreenWidth = screenWidth;
                Sys.MouseManager.ScreenHeight = screenHeight;

                // 3. تشغيل الوضع الرسومي (الواجهة) بدقة 800x600
                myCanvas = FullScreenCanvas.GetFullScreenCanvas(new Mode(screenWidth, screenHeight, ColorDepth.ColorDepth32));
                
                // تنظيف الشاشة بلون خلفية أساسي للنظام (أزرق غامق ملكي مثلاً)
                myCanvas.Clear(Color.FromArgb(10, 25, 47)); 
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error during initialization: {ex.Message}");
            }
        }

        protected override void Run()
        {
            try
            {
                // تحديث الشاشة في كل لفة (Loop)
                DrawInterface();
                
                // التعامل مع مدخلات الماوس والكيبورد
                HandleInputs();

                // تحديث العرض على الشاشة
                myCanvas.Display();
                
                // تأخير بسيط لمنع الضغط العالي على المعالج
                Sys.Power.Wait(10); 
            }
            catch (Exception ex)
            {
                // إذا حدث خطأ يطبع تفاصيله في الواجهة
                myCanvas.DrawString($"Kernel Run Error: {ex.Message}", PCScreenFont.Default, Color.Red, 10, 10);
                myCanvas.Display();
            }
        }

        // دالة رسم الواجهة الرسومية (GUI)
        private void DrawInterface()
        {
            // خلفية النظام
            myCanvas.Clear(Color.FromArgb(10, 25, 47));

            // رسم شريط المهام (Taskbar) بالأسفل
            myCanvas.DrawFilledRectangle(Color.FromArgb(23, 42, 69), 0, (int)(screenHeight - 40), (int)screenWidth, 40);

            // رسم زر "ابدأ" أو شعار "نجd" في شريط المهام
            myCanvas.DrawFilledRectangle(Color.FromArgb(100, 255, 218), 10, (int)(screenHeight - 35), 60, 30);
            myCanvas.DrawString("NAJD", PCScreenFont.Default, Color.Black, 22, (int)(screenHeight - 27));

            // رسم أيقونة افتراضية لملفات .najd على سطح المكتب
            DrawIcon("System.najd", 40, 40);

            // رسم الماوس على الشاشة بناءً على حركته الحالية
            int mouseX = (int)Sys.MouseManager.X;
            int mouseY = (int)Sys.MouseManager.Y;
            DrawMouseCursor(mouseX, mouseY);
        }

        // دالة مخصصة لرسم الأيقونات على سطح المكتب
        private void DrawIcon(string name, int x, int y)
        {
            // رسم مربع الأيقونة
            myCanvas.DrawFilledRectangle(Color.FromArgb(23, 42, 69), x, y, 50, 50);
            // رسم حواف الأيقونة
            myCanvas.DrawRectangle(Color.FromArgb(100, 255, 218), x, y, 50, 50);
            // كتابة اسم الملف تحتها
            myCanvas.DrawString(name, PCScreenFont.Default, Color.White, x - 10, y + 55);
        }

        // دالة مخصصة لرسم مؤشر الماوس
        private void DrawMouseCursor(int x, int y)
        {
            // رسم مثلث بسيط ليمثل مؤشر الماوس
            myCanvas.DrawFilledTriangle(
                Color.White,
                x, y,
                x + 10, y + 10,
                x, y + 15
            );
        }

        // دالة التعامل مع النقرات وتشغيل الملفات والتطبيقات
        private void HandleInputs()
        {
            int mouseX = (int)Sys.MouseManager.X;
            int mouseY = (int)Sys.MouseManager.Y;

            if (Sys.MouseManager.MouseState == Sys.MouseState.Left)
            {
                // إذا تم النقر على إحداثيات الأيقونة (System.najd)
                if (mouseX >= 40 && mouseX <= 90 && mouseY >= 40 && mouseY <= 90)
                {
                    ExecuteNajdFile("0:\\System.najd");
                }
            }
        }

        // دالة لتشغيل وقراءة ملفات نظام الـ .najd المخصصة
        private void ExecuteNajdFile(string path)
        {
            if (File.Exists(path))
            {
                string fileContent = File.ReadAllText(path);
                // هنا تضع المفسر (Interpreter) الخاص بك لقراءة وتنفيذ الأوامر داخل ملفك
            }
        }
    }
}
