import 'package:flutter/material.dart';

class Notifikasi extends StatefulWidget {
  final String uuid;
  final String accessToken;

  const Notifikasi({
    Key? key, 
    required this.uuid,
    required this.accessToken,
  }) : super(key: key);

  @override
  State<Notifikasi> createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
  final Color primaryColor = Color(0xFF27DEBF);
  // Sample data for notifications
  final List<Map<String, dynamic>> notifications = [
    {
      'name': 'John Doe',
      'action': 'mengomentari postingan anda',
      'time': '2 jam yang lalu',
      'isRead': false,
      'avatarUrl': 'https://randomuser.me/api/portraits/men/1.jpg',
    },
    {
      'name': 'Jane Smith',
      'action': 'menyukai postingan anda',
      'time': '3 jam yang lalu',
      'isRead': true,
      'avatarUrl': 'https://randomuser.me/api/portraits/women/2.jpg',
    },
    {
      'name': 'Robert Johnson',
      'action': 'mengomentari postingan anda',
      'time': '5 jam yang lalu',
      'isRead': false,
      'avatarUrl': 'https://randomuser.me/api/portraits/men/3.jpg',
    },
    {
      'name': 'Emily Davis',
      'action': 'mulai mengikuti anda',
      'time': '1 hari yang lalu',
      'isRead': true,
      'avatarUrl': 'https://randomuser.me/api/portraits/women/4.jpg',
    },
    {
      'name': 'Michael Brown',
      'action': 'mengirim pesan kepada anda',
      'time': '2 hari yang lalu',
      'isRead': false,
      'avatarUrl': 'https://randomuser.me/api/portraits/men/5.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF27DEBF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifikasi',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF27DEBF),
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep_outlined, color: Color(0xFF27DEBF)),
            onPressed: () {
              _showClearAllDialog();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background curved shapes
          Positioned(
            top: -120,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Color(0xFF27DEBF).withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -180,
            left: -120,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                color: Color(0xFF27DEBF).withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main content - notification list
          notifications.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: notification['isRead']
                            ? Colors.white
                            : Color(0xFFF0FFFC),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: primaryColor.withOpacity(
                              notification['isRead'] ? 0.1 : 0.2),
                          width: 1,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Mark as read when tapped
                          setState(() {
                            notifications[index]['isRead'] = true;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Unread indicator
                              if (!notification['isRead'])
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: EdgeInsets.only(top: 6, right: 8),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              // Profile picture
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.grey[200],
                                backgroundImage:
                                    NetworkImage(notification['avatarUrl']),
                              ),
                              SizedBox(width: 12),
                              // Notification content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          height: 1.4,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: notification['name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' ${notification['action']}',
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Klik disini untuk lihat',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      notification['time'],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Delete button
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                          Icons.delete_outline,
                                          size: 18,
                                          color: Colors.red[400]),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        setState(() {
                                          notifications.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  // Mark as read button
                                  if (!notification['isRead'])
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.check,
                                          size: 18,
                                          color: primaryColor,
                                        ),
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          setState(() {
                                            notifications[index]['isRead'] =
                                                true;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 70,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Tidak ada notifikasi',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Anda akan menerima notifikasi ketika ada aktivitas baru',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Semua Notifikasi'),
        content: Text('Apakah Anda yakin ingin menghapus semua notifikasi?'),
        actions: [
          TextButton(
            child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Hapus'),
            onPressed: () {
              setState(() {
                notifications.clear();
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}