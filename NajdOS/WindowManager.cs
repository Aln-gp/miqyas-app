using System;
using Cosmos.System.Graphics;
using System.Drawing;

namespace NajdOS.GUI
{
    public static class WindowManager
    {
        private static Canvas canvas;

        public static void Initialize(Canvas c)
        {
            canvas = c;
        }

        public static void DrawWindow(int x, int y, int width, int height, string title)
        {
            // 1. رسم حدود النافذة
            canvas.DrawFilledRectangle(Color.LightGray, x, y, width, height);
            
            // 2. رسم شريط العنوان
            canvas.DrawFilledRectangle(Color.DarkBlue, x, y, width, 25);
            
            // 3. (مستقبلاً) رسم نص العنوان والأزرار
            Console.WriteLine("[GUI] Rendering window: " + title);
        }
    }
}
