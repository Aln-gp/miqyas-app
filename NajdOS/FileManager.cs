using System;
using System.IO;

namespace NajdOS.System
{
    public static class FileManager
    {
        // مسار افتراضي لحفظ ملفات النظام السيادي
        private static string rootPath = @"0:\NajdData\";

        public static void Initialize()
        {
            // إنشاء مجلد النظام إذا لم يكن موجوداً
            if (!Directory.Exists(rootPath))
            {
                Directory.CreateDirectory(rootPath);
                Console.WriteLine("[FS] Najd File System Initialized.");
            }
        }

        public static void SaveFile(string fileName, string content)
        {
            File.WriteAllText(rootPath + fileName, content);
            Console.WriteLine("[FS] File Saved: " + fileName);
        }

        public static string ReadFile(string fileName)
        {
            if (File.Exists(rootPath + fileName))
            {
                return File.ReadAllText(rootPath + fileName);
            }
            return "File Not Found!";
        }
    }
}
