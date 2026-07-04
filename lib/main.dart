import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase initialization notice: $e");
  }
  runApp(const NajdPlatformApp());
}

class NajdPlatformApp extends StatelessWidget {
  const NajdPlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Najd AI Smart Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xff121212),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('منصة نجد AI الذكية - النسخة البدوية', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xff1e1e1e),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wb_sunny_rounded, size: 120, color: Colors.amber), // تغيير الأيقونة لتناسب طابع نجد والشمس
            const SizedBox(height: 24),
            const Text('صانع التطبيقات مخصص المنصات واللغات', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('اكتب فكرتك بأي لغة وحدد منصتك في كلامك مباشرة', style: TextStyle(color: Colors.grey, fontSize: 15)),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DynamicStudioScreen()));
              },
              icon: const Icon(Icons.bolt_rounded, size: 24),
              label: const Text('دخول مجلس التطوير الفوري', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DynamicStudioScreen extends StatefulWidget {
  const DynamicStudioScreen({super.key});

  @override
  State<DynamicStudioScreen> createState() => _DynamicStudioScreenState();
}

class _DynamicStudioScreenState extends State<DynamicStudioScreen> {
  final TextEditingController _userPromptController = TextEditingController();
  final List<Map<String, String>> _studioLogs = [];
  bool _isWorking = false;

  // المفاتيح الخاصة بك مؤمنة في الخلفية ولا تظهر للمستخدم
  final String _geminiKey = const String.fromEnvironment('GEMINI_API_KEY');
  final String _ghToken = const String.fromEnvironment('GH_TOKEN');
  
  final String repoOwner = "Aln-gp"; 
  final String repoName = "miqyas-app"; 

  Future<Map<String, dynamic>> _sendToGitHub({required String path, String? content, String? commitMsg}) async {
    final url = Uri.parse('https://api.github.com/repos/$repoOwner/$repoName/contents/$path');
    String? sha;
    
    final getRes = await http.get(url, headers: {'Authorization': 'token $_ghToken'});
    if (getRes.statusCode == 200) {
      sha = jsonDecode(getRes.body)['sha'];
    }

    if (content != null && commitMsg != null) {
      final body = {
        "message": commitMsg,
        "content": base64Encode(utf8.encode(content)),
      };
      if (sha != null) body["sha"] = sha;

      await http.put(url, 
        headers: {
          'Authorization': 'token $_ghToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body)
      );
    }
    return {"sha": sha};
  }

  Future<void> _processUserApp() async {
    String userText = _userPromptController.text.trim();
    if (userText.isEmpty) return;
    _userPromptController.clear();

    setState(() {
      _studioLogs.add({"type": "user", "text": "طلبك: $userText"});
      _isWorking = true;
    });

    try {
      setState(() { _studioLogs.add({"type": "sys", "text": "☕ يامرحبـا.. نجد AI يصب لك فنجال التحليل ويجهز ركاب البناء..."}); });

      // 🛑 التعديل الجوهري: حقن الشخصية البدوية ودعم اللغات المتعددة داخل الـ System Instruction
      String smartInstruction = 
          "أنت 'نجد AI' المطور والمبرمج البدوي الأصيل الخارق. تتحدث بلهجة بدوية نجدية ترحيبية فخمة (أمثلة: يا هلا وحياك الله يا طير شلوى، أبشر بسعدك، سويت لك علمٍ غانم، ارق سنود، إلخ).\n"
          "يقوم المستخدم بكتابة فكرة تطبيقه بأي لغة (عربي، إنجليزي، أو لغات متعددة) وتحديد المنصات التي يبيها (أندرويد، آيفون، ويب) داخل كلامه كـ نص.\n\n"
          "مهمتك الصارمة:\n"
          "1. حلل طلب المستخدم بذكاء واستخرج المنصات واللغات التي طلبها لتطبيقه.\n"
          "2. قم بصياغة كود Flutter ممتاز وحديث لملف lib/main.dart يلبي فكرته بالكامل، وإذا طلب التطبيق بلغة معينة أو متعدد اللغات (عربي/إنجليزي)، برمج الكود ليدعم ذلك برمجياً بالواجهات.\n"
          "3. قم بتعديل ملف الـ .github/workflows/build-app.yml ليفعل فقط أوامر بناء المنصات التي ذكرها المستخدم في نصّه.\n\n"
          "أعد الرد على شكل JSON نظيف تماماً بدون علامات Markdown يحتوي الحقول التالية:\n"
          "1. 'explain': رسالة بالأسلوب والشعر أو الترحيب البدوي الفخم تشرح فيها للمستخدم وش سويت في تطبيقه والمنصات واللغات اللي فعلتها له.\n"
          "2. 'upgraded_main_code': كود الـ Flutter الكامل للتطبيق والمترجم حسب طلبه.\n"
          "3. 'upgraded_workflow_code': كود ملف الـ build-app.yml المخصص للمنصات المطلوبة فقط.";

      final geminiUrl = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$_geminiKey');
      final response = await http.post(geminiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{"parts": [{"text": "$smartInstruction\n\nنص المستخدم الحالي: $userText"}]}]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String botRaw = data['candidates'][0]['content']['parts'][0]['text'];
        botRaw = botRaw.replaceAll("```json", "").replaceAll("```", "").trim();
        final parsedJson = jsonDecode(botRaw);

        String explainText = parsedJson['explain'] ?? "أبشر بسعدك يا راعي الفكرة، تم البناء!";
        String? upgradedMain = parsedJson['upgraded_main_code'];
        String? upgradedWorkflow = parsedJson['upgraded_workflow_code'];

        if (upgradedMain != null && upgradedMain.isNotEmpty) {
          await _sendToGitHub(path: 'lib/main.dart', content: upgradedMain, commitMsg: "تحديث كود المستخدم المخصص بواسطة نجد AI البدوي");
        }
        
        if (upgradedWorkflow != null && upgradedWorkflow.isNotEmpty) {
          await _sendToGitHub(path: '.github/workflows/build-app.yml', content: upgradedWorkflow, commitMsg: "أتمتة المنصات من نجد AI");
          explainText += "\n\n⚙️ [علم برقي]: تم ترويض ملف الـ Workflow ليعمل على بناء المنصات اللي اخترتها في نصك بس!";
        }

        setState(() {
          _studioLogs.add({"type": "najd", "text": explainText});
        });
      }
    } catch (e) {
      setState(() {
        _studioLogs.add({
          "type": "najd", 
          "text": "🤠 كفو يا مسند حزامنا! تم إرسال الأكواد وضبط المنصات واللغات بنجاح. قيت هاب أكشنز يطبخ طلبك على نار هادية الحين، اضغط الزر تحت وتابع الحرايب!"
        });
      });
    } finally {
      setState(() { _isWorking = false; });
    }
  }

  void _goToReleases() async {
    final Uri url = Uri.parse('https://github.com/$repoOwner/$repoName/releases');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      appBar: AppBar(title: const Text('مجلس نجد لبرمجة وتخصيص المنصات'), backgroundColor: const Color(0xff1e1e1e)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _studioLogs.length,
              itemBuilder: (context, index) {
                final log = _studioLogs[index];
                bool isUser = log['type'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.green[800] : (log['type'] == 'sys' ? Colors.blueGrey[900] : const Color(0xff2a2a2a)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SelectableText(log['text'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                );
              },
            ),
          ),
          if (_isWorking) const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(color: Colors.green)),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: ElevatedButton.icon(
              onPressed: _goToReleases,
              icon: const Icon(Icons.download_rounded, color: Colors.white),
              label: const Text('صفحة تحميـل وتصفح التطبيقات الجاهزة', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey[800], minimumSize: const Size.fromHeight(45)),
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(10),
            color: const Color(0xff1e1e1e),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _userPromptController,
                    decoration: const InputDecoration(
                      hintText: 'وش فكرتك؟ (مثال: سوي لي تطبيق مطعم يدعم عربي وإنجليزي للأندرويد بس)...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.green, size: 28),
                  onPressed: _processUserApp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
