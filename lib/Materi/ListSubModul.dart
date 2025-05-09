import 'package:flutter/material.dart';
import 'package:skilltopia/Materi/ViewContent.dart';
import 'package:skilltopia/models.dart';
import 'package:skilltopia/repository.dart';

class ListSubModul extends StatefulWidget {
  final int modulId;
  final String judul;
  final String accessToken;

  const ListSubModul({
    Key? key,
    required this.modulId,
    required this.judul,
    required this.accessToken,
  }) : super(key: key);

  @override
  State<ListSubModul> createState() => _ListSubModulState();
}

class _ListSubModulState extends State<ListSubModul> {
  final SubModulRepository _subModulRepository = SubModulRepository();
  List<SubModulModel> subModules = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchSubModules();
  }

  Future<void> _fetchSubModules() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final fetchedSubModules = await _subModulRepository.getSubModul(
        widget.accessToken,
        widget.modulId,
      );
      setState(() {
        subModules = fetchedSubModules;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load sub modules: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF27DEBF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.judul,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF27DEBF),
            letterSpacing: 0.5,
          ),
        ),
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

          // Main content
          _isLoading
              ? Center(
                child: CircularProgressIndicator(color: Color(0xFF27DEBF)),
              )
              : _errorMessage.isNotEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        _errorMessage,
                        style: TextStyle(fontSize: 16, color: Colors.red[700]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _fetchSubModules,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF27DEBF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: Text('Coba Lagi'),
                    ),
                  ],
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sub Module Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.format_list_bulleted_rounded,
                          color: Color(0xFF27DEBF),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Daftar Sub Modul',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Empty state if no sub modules
                  subModules.isEmpty
                      ? Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.article_outlined,
                                size: 64,
                                color: Color(0xFF27DEBF).withOpacity(0.7),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Belum ada modul yang tersedia', // Changed the text here
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: subModules.length,
                          itemBuilder: (context, index) {
                            final subModule = subModules[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: Color(0xFF27DEBF).withOpacity(0.15),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Content
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            subModule.subJudul ?? '',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                            maxLines:
                                                2, // Allow up to 2 lines for the title
                                            overflow: TextOverflow.ellipsis,
                                          ),

                                          SizedBox(height: 6),

                                          Text(
                                            subModule.subDeskripsi ?? '',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13,
                                              height: 1.4,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(width: 12),

                                    // Learn button
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => ViewContent(
                                                  subJudul: subModule.subJudul,
                                                  content: subModule.content,
                                                  audio: subModule.audio,
                                                  video: subModule.video
                                                ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF27DEBF),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                      ),
                                      child: Text(
                                        'Pelajari',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                ],
              ),
        ],
      ),
    );
  }
}
