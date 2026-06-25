// Program.cs - المحرك الرئيسي الذي يربط كل الملفات
using NajdOS.Kernel;
using NajdOS.GUI;

namespace NajdOS
{
    public class SystemLoader
    {
        public static void Main()
        {
            // 1. تشغيل الحماية أولاً
            SecurityEngine.Initialize();
            
            // 2. تشغيل التعريفات
            DisplayDriver.Start();
            
            // 3. تشغيل الواجهة
            WindowManager.LoadDesktop();
        }
    }
}
