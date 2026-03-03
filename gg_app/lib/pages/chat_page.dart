import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  // بيانات تجريبية لقائمة المحادثات
  List<_ChatThread> get threads => [
        _ChatThread(name: "Khalid", lastMessage: "Are you joining today?", time: "3:45 PM", unread: 2),
        _ChatThread(name: "Faisal", lastMessage: "Location is updated ✅", time: "11:20 AM", unread: 0),
        _ChatThread(name: "Evening Running Group", lastMessage: "New member joined", time: "Yesterday", unread: 1),
        _ChatThread(name: "Padel Friday", lastMessage: "See you at 8!", time: "Mon", unread: 0),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      appBar: AppBar(
        title: const Text("Chat"),
      ),

      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: threads.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final t = threads[i];
          return _ThreadTile(
            thread: t,
            onTap: () {
              // نفتح صفحة المحادثة (details)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatDetailsPage(threadName: t.name),
                ),
              );
            },
          );
        },
      ),

      // ✅ Bottom Navigation (شكل فقط) — ما يسوي تنقل
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // اختاري 0 أو أي رقم (بس للعرض)
        onTap: (_) {}, // شكل فقط
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF10B981),
        unselectedItemColor: const Color(0xFF9CA3AF),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), label: "Groups"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: "Create"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

// ===== صفحة تفاصيل المحادثة (Message bubbles + input + send) =====
class ChatDetailsPage extends StatefulWidget {
  final String threadName;
  const ChatDetailsPage({super.key, required this.threadName});

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  final TextEditingController _controller = TextEditingController();

  // رسائل تجريبية (local state)
  final List<_Message> _messages = [
    _Message(text: "Hi! Are you joining today?", isMe: false, time: "3:41 PM"),
    _Message(text: "Yes, I will be there 👍", isMe: true, time: "3:42 PM"),
    _Message(text: "Great! See you.", isMe: false, time: "3:43 PM"),
  ];

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_Message(text: text, isMe: true, time: _nowTime()));
    });
    _controller.clear();
  }

  String _nowTime() {
    final now = TimeOfDay.now();
    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final min = now.minute.toString().padLeft(2, "0");
    final period = now.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$min $period";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      appBar: AppBar(
        title: Text(widget.threadName),
      ),
      body: Column(
        children: [
          // ===== قائمة الرسائل =====
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                return _Bubble(message: m);
              },
            ),
          ),

          // ===== شريط الكتابة + زر إرسال =====
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        filled: true,
                        fillColor: const Color(0xFFF3F4F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: _send,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== Bubble UI =====
class _Bubble extends StatelessWidget {
  final _Message message;
  const _Bubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF10B981) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: isMe ? Colors.white : const Color(0xFF111827),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message.time,
              style: TextStyle(
                color: isMe ? Colors.white70 : const Color(0xFF9CA3AF),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Tile للمحادثات =====
class _ThreadTile extends StatelessWidget {
  final _ChatThread thread;
  final VoidCallback onTap;

  const _ThreadTile({required this.thread, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE5E7EB),
          child: Text(thread.name.isNotEmpty ? thread.name[0].toUpperCase() : "C"),
        ),
        title: Text(thread.name, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(thread.lastMessage),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(thread.time, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
            const SizedBox(height: 6),
            if (thread.unread > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${thread.unread}",
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ===== Models =====
class _ChatThread {
  final String name;
  final String lastMessage;
  final String time;
  final int unread;

  _ChatThread({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
  });
}

class _Message {
  final String text;
  final bool isMe;
  final String time;

  _Message({
    required this.text,
    required this.isMe,
    required this.time,
  });
}
