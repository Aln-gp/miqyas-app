using System;
using Sys = Cosmos.System;
using Cosmos.System.Graphics;
using System.Drawing;

namespace NajdOS.Drivers
{
    public static class MouseDriver
    {
        public static void UpdateMouse(Canvas canvas)
        {
            // قراءة موقع الماوس الحالي من النظام
            int x = (int)Sys.MouseManager.X;
            int y = (int)Sys.MouseManager.Y;

            // رسم مؤشر الماوس (مربع صغير أبيض)
            canvas.DrawFilledRectangle(Color.White, x, y, 8, 8);
        }
    }
}
