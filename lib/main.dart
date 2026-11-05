import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const SurvivalGameApp());
}

class SurvivalGameApp extends StatelessWidget {
  const SurvivalGameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Survival Game - BOABCA AZEDDIN',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF111111),
        primaryColor: Colors.redAccent,
      ),
      home: const GameRulesScreen(),
    );
  }
}

class Player {
  String name;
  int losses;
  int score;
  bool active;
  int currentChoice;
  bool isHidden;

  Player({
    required this.name,
    this.losses = 0,
    this.score = 5, // نقاط الحماية والدرع البدئي
    this.active = true,
    this.currentChoice = 0,
    this.isHidden = true,
  });
}

// ==========================================
// شاشة عرض القواعد الأساسية
// ==========================================
class GameRulesScreen extends StatelessWidget {
  const GameRulesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("قواعد التحدي المتدرج - BOABCA AZEDDIN"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "📜 دستور اللعبة ونظام القواعد المتدرجة:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber),
            ),
            const SizedBox(height: 10),
            const Text(
              "1. النظام التدريجي: تبدأ اللعبة بالقاعدة الأولى فقط، وكلما تم إقصاء لاعب، تفتح قاعدة جديدة ويظهر لك تنبيه فوري بها!\n\n"
              "• القاعدة 1 (البداية): الاقتراب من الناتج المستهدف يمنح نقطة أخضر 🟢.\n"
              "• القاعدة 2 (تفتح بعد 1 إقصاء): عقوبة تطابق الأرقام (-1 أحمر 🔴).\n"
              "• القاعدة 3 (تفتح بعد 2 إقصاء): مفارقة 0 و 100 (+1 أخضر و -1 أحمر).\n"
              "• القاعدة 4 (تفتح بعد 3 إقصاء): تطابق الأصفار المتعددة (حسب عدد الأصفار).\n"
              "• القاعدة 5 (تفتح بعد 4 إقصاء): الاقتراب العميق بأقل من 1.5 (+3 نقاط زرقاء 🔵).\n\n"
              "2. نظام النقاط: تبدأ بـ 5 نقاط درع. من تنفذ نقاطه يتم إقصاؤه نهائياً.",
              style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SetupPlayersScreen()),
                );
              },
              child: const Text(
                "التالي: إعداد أسماء المشاركين",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// شاشة إعداد اللاعبين (من 2 إلى 30)
// ==========================================
class SetupPlayersScreen extends StatefulWidget {
  const SetupPlayersScreen({Key? key}) : super(key: key);

  @override
  _SetupPlayersScreenState createState() => _SetupPlayersScreenState();
}

class _SetupPlayersScreenState extends State<SetupPlayersScreen> {
  final List<TextEditingController> _controllers = [
    TextEditingController(text: "أحمد (أنا)"),
    TextEditingController(text: "Shunsui"),
    TextEditingController(text: "Dustin"),
    TextEditingController(text: "Ayanokoji"),
  ];

  void addPlayer() {
    if (_controllers.length < 30) {
      setState(() {
        _controllers.add(TextEditingController(text: "عضو ${_controllers.length + 1}"));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الحد الأقصى هو 30 عضواً!")),
      );
    }
  }

  void removePlayer(int index) {
    if (_controllers.length > 2) {
      setState(() {
        _controllers.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الحد الأدنى هو عضوين!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تخصيص الأعضاء (من 2 إلى 30)"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _controllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        Text("${index + 1}.", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _controllers[index],
                            decoration: InputDecoration(
                              labelText: "اسم العضو",
                              filled: true,
                              fillColor: Colors.grey[900],
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => removePlayer(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, padding: const EdgeInsets.all(14)),
                    onPressed: addPlayer,
                    child: const Text("إضافة عضو +"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, padding: const EdgeInsets.all(14)),
                    onPressed: () {
                      List<Player> initializedPlayers = _controllers
                          .map((c) => Player(name: c.text.isEmpty ? "مجهول" : c.text))
                          .toList();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameDashboardScreen(playersList: initializedPlayers),
                        ),
                      );
                    },
                    child: const Text("ابدأ المعركة 🚀", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// لوحة اللعب والقواعد المتدرجة مع تنبيهات القواعد الجديدة
// ==========================================
class GameDashboardScreen extends StatefulWidget {
  final List<Player> playersList;
  const GameDashboardScreen({Key? key, required this.playersList}) : super(key: key);

  @override
  _GameDashboardScreenState createState() => _GameDashboardScreenState();
}

class _GameDashboardScreenState extends State<GameDashboardScreen> {
  int currentRound = 1;
  late List<Player> players;
  int unlockedRulesCount = 1; // تبدأ بقاعدة واحدة

  @override
  void initState() {
    super.initState();
    players = widget.playersList;
  }

  void openNumberSelector(Player player) {
    int selectedNum = player.currentChoice;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text("اختر رقماً لـ ${player.name}"),
          content: SizedBox(
            width: 300,
            height: 350,
            child: Column(
              children: [
                Text(
                  "الرقم: ${player.isHidden ? '****' : selectedNum}",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("إخفاء الرقم سراً: "),
                    Checkbox(
                      value: player.isHidden,
                      onChanged: (val) {
                        setDialogState(() {
                          player.isHidden = val ?? true;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: 101,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: selectedNum == index ? Colors.redAccent : Colors.grey[800],
                        ),
                        onPressed: () {
                          setDialogState(() {
                            selectedNum = index;
                          });
                        },
                        child: Text("$index", style: const TextStyle(fontSize: 12, color: Colors.white)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  player.currentChoice = selectedNum;
                });
                Navigator.pop(context);
              },
              child: const Text("تأكيد وحفظ"),
            ),
          ],
        ),
      ),
    );
  }

  void processRound() {
    List<Player> activePlayers = players.where((p) => p.active).toList();

    if (activePlayers.length <= 1) {
      String winner = activePlayers.isNotEmpty ? activePlayers[0].name : "لا يوجد";
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("انتهت المعركة"),
          content: Text("الفائز الأوحد بالعرش هو: $winner\nالمبرمج: BOABCA AZEDDIN"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إغلاق"),
            ),
          ],
        ),
      );
      return;
    }

    Map<String, int> choices = {for (var p in activePlayers) p.name: p.currentChoice};
    int totalSum = choices.values.reduce((a, b) => a + b);
    double avg = totalSum / activePlayers.length;
    double target = avg * 0.8;

    String roundLog = choices.entries.map((e) => "👤 ${e.key} : [${e.value}]").join("\n");
    roundLog += "\n\nالمجموع: $totalSum | المتوسط: ${avg.toStringAsFixed(2)}\nالناتج المستهدف (×0.8): ${target.toStringAsFixed(2)}\n\n";
    roundLog += "📌 القواعد النشطة حالياً: $unlockedRulesCount من 5\n\n";

    List<String> penalizedPlayers = [];
    if (unlockedRulesCount >= 2) {
      Map<int, List<String>> numGroups = {};
      choices.forEach((name, num) {
        numGroups.putIfAbsent(num, () => []).add(name);
      });

      numGroups.forEach((num, names) {
        if (names.length > 1) {
          roundLog += "⚠️ تطابق في الرقم ($num) للعضو/الأعضاء: ${names.join(', ')} (-1 نقطة حمراء 🔴)\n";
          for (var name in names) {
            penalizedPlayers.add(name);
            players.firstWhere((p) => p.name == name).score -= 1;
          }
        }
      });
    }

    Map<String, int> activeChoicesForTarget = Map.from(choices);
    for (var name in penalizedPlayers) {
      activeChoicesForTarget.remove(name);
    }

    bool specialRuleApplied = false;

    // القاعدة 3: مفارقة 0 و 100
    if (unlockedRulesCount >= 3 && activeChoicesForTarget.containsValue(0) && activeChoicesForTarget.containsValue(100)) {
      specialRuleApplied = true;
      roundLog += "⚡ تطبيق القاعدة 3 (مفارقة 0 و 100)!\n";
      for (var entry in activeChoicesForTarget.entries) {
        if (entry.value == 100) {
          players.firstWhere((p) => p.name == entry.key).score += 1;
          roundLog += "🟢 ${entry.key} اخترق بـ 100 وفاز بنقطة (+1 أخضر)\n";
        } else {
          players.firstWhere((p) => p.name == entry.key).score -= 1;
          roundLog += "🔴 ${entry.key} خسر نقطة (-1 أحمر)\n";
        }
      }
    }

    // القاعدة 4: تطابق الأصفار
    List<String> zeroHolders = activeChoicesForTarget.entries.where((e) => e.value == 0).map((e) => e.key).toList();
    if (!specialRuleApplied && unlockedRulesCount >= 4 && zeroHolders.length >= 2 && !activeChoicesForTarget.containsValue(100)) {
      specialRuleApplied = true;
      int zerosCount = zeroHolders.length;
      roundLog += "🔥 تطبيق القاعدة 4 (تطابق $zerosCount أصفار): يفوز كل منهم بـ (+$zerosCount نقاط زرقاء 🔵)!\n";
      for (var name in zeroHolders) {
        players.firstWhere((p) => p.name == name).score += zerosCount;
      }
      for (var entry in activeChoicesForTarget.entries) {
        if (!zeroHolders.contains(entry.key)) {
          players.firstWhere((p) => p.name == entry.key).score -= 1;
        }
      }
    }

    // الاقتراب العادي / القاعدة 5
    if (!specialRuleApplied && activeChoicesForTarget.isNotEmpty) {
      String closestName = "";
      double minDiff = 999.0;
      activeChoicesForTarget.forEach((name, num) {
        double diff = (num - target).abs();
        if (diff < minDiff) {
          minDiff = diff;
          closestName = name;
        }
      });

      if (unlockedRulesCount >= 5 && minDiff <= 1.5) {
        roundLog += "🎯 $closestName اقترب بعمق بفرق ${minDiff.toStringAsFixed(2)} وحصل على (+3 نقاط زرقاء 🔵)!\n";
        players.firstWhere((p) => p.name == closestName).score += 3;
        for (var entry in activeChoicesForTarget.entries) {
          if (entry.key != closestName) {
            players.firstWhere((p) => p.name == entry.key).score -= 1;
          }
        }
      } else {
        roundLog += "👑 $closestName كان الأقرب وحصل على (+1 نقطة خضراء 🟢)!\n";
        players.firstWhere((p) => p.name == closestName).score += 1;
        for (var entry in activeChoicesForTarget.entries) {
          if (entry.key != closestName) {
            players.firstWhere((p) => p.name == entry.key).score -= 1;
          }
        }
      }
    }

    // فحص الإقصاء ومعرفة عدد من تم إقصاؤهم في هذه الجولة
    int newlyEliminated = 0;
    List<String> eliminatedNames = [];
    for (var p in players) {
      if (p.score <= 0 && p.active) {
        p.active = false;
        newlyEliminated++;
        eliminatedNames.add(p.name);
        roundLog += "\n💀 تم إقصاء اللاعب ${p.name} لتنفاذ نقاطه بالكامل!\n";
      }
    }

    // عرض نتائج الجولة أولاً
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("نتيجة الجولة ${currentRound}"),
        content: SingleChildScrollView(child: Text(roundLog)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              // إذا تم إقصاء لاعبين، نظهر نافذة منبثقة مستقلة وخاصة لتنبيه الجميع بالقاعدة الجديدة!
              if (newlyEliminated > 0 && unlockedRulesCount < 5) {
                setState(() {
                  unlockedRulesCount += newlyEliminated;
                  if (unlockedRulesCount > 5) unlockedRulesCount = 5;
                });

                String ruleTitle = "";
                String ruleDesc = "";
                if (unlockedRulesCount == 2) {
                  ruleTitle = "قاعدة جديدة أُضيفت: عقوبة التطابق!";
                  ruleDesc = "تم إقصاء عضو، وتم تفعيل [القاعدة 2]: إذا تطابق رقمان أو أكثر، يُعاقب أصحابهما بسالب نقطة (-1) ويتم استبعادهم من المنافسة على الناتج في هذه الجولة!";
                } else if (unlockedRulesCount == 3) {
                  ruleTitle = "قاعدة جديدة أُضيفت: مفارقة 0 و 100!";
                  ruleDesc = "تم تفعيل [القاعدة 3]: إذا اختار شخص 0 وآخر 100، يفوز صاحب الـ 100 بنقطة ويخسر الباقون!";
                } else if (unlockedRulesCount == 4) {
                  ruleTitle = "قاعدة جديدة أُضيفت: تطابق الأصفار المتعددة!";
                  ruleDesc = "تم تفعيل [القاعدة 4]: إذا اختار عدة أشخاص الرقم 0، يفوز كل منهم بنقاط مساوية لعدد الأصفار المختارة!";
                } else if (unlockedRulesCount == 5) {
                  ruleTitle = "قاعدة جديدة أُضيفت: الاقتراب العميق (3 نقاط)!";
                  ruleDesc = "تم تفعيل [القاعدة الخيرة 5]: من يقترب من الناتج بفارق أقل من 1.5 يحصل على 3 نقاط زرقاء كاملة!";
                }

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.indigo[900],
                    title: Text(ruleTitle, style: const TextStyle(color: Colors.amber, fontSize: 18)),
                    content: Text(
                      "💀 تم إقصاء: ${eliminatedNames.join(', ')}\n\n$ruleDesc",
                      style: const TextStyle(fontSize: 15, color: Colors.white, height: 1.4),
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("حسناً، فهمت القاعدة الجديدة 🔥", style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text("التالي"),
          ),
        ],
      ),
    );

    setState(() {
      currentRound++;
      for (var p in players) {
        p.isHidden = true;
        p.currentChoice = 0;
      }
    });
  }

  @override
  Widget_build(BuildContext context) => build(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الجولة $currentRound (قواعد نشطة: $unlockedRulesCount/5)"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text(
              "المبرمج: BOABCA AZEDDIN",
              style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  var p = players[index];
                  Color scoreColor = p.score > 5 ? Colors.blueAccent : (p.score < 5 ? Colors.redAccent : Colors.greenAccent);
                  if (p.score <= 0) scoreColor = Colors.red;

                  return Card(
                    color: p.active ? const Color(0xFF1E1E1E) : Colors.red.withOpacity(0.2),
                    child: ListTile(
                      title: Text(p.name, style: TextStyle(fontWeight: FontWeight.bold, c