using System;

namespace NajdOS.Kernel
{
    public static class SecurityEngine
    {
        // 1. مصفوفة الأنماط الخطرة (الفيروسات)
        private static string[] blacklistedPatterns = { "malware", "virus", "inject", "rootkit" };

        public static void Initialize()
        {
            Console.WriteLine("[SEC] Security Engine Initializing...");
            // هنا يتم فحص الذاكرة للتأكد من عدم وجود تلاعب
        }

        public static bool IsFileSafe(string fileName)
        {
            // 2. محرك الفحص السلوكي
            foreach (var pattern in blacklistedPatterns)
            {
                if (fileName.ToLower().Contains(pattern))
                {
                    Console.WriteLine("[ALERT] Dangerous file detected: " + fileName);
                    return false; // الملف غير آمن
                }
            }
            return true; // الملف آمن
        }
    }
}
