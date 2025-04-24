import 'package:flutter/material.dart';
import 'package:skilltopia/Kuesioner/Kuesioner.dart';
import 'package:skilltopia/Materi/ListSubModul.dart';
import 'package:skilltopia/models.dart'; // Import model
import 'package:skilltopia/repository.dart'; // Import repository

class ListModul extends StatefulWidget {
  final String uuid;
  final String accessToken;
  final String gayaBelajar;
  final String username;

  const ListModul({
    Key? key,
    required this.uuid,
    required this.accessToken,
    required this.gayaBelajar,
    required this.username,
  }) : super(key: key);

  @override
  State<ListModul> createState() => _ListModulState();
}

class _ListModulState extends State<ListModul> {
  final ModulRepository _modulRepository = ModulRepository();
  List<ModulModel> modules = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (widget.gayaBelajar == null || widget.gayaBelajar.isEmpty) {
      // Use Future.microtask to schedule the dialog after the current build cycle
      Future.microtask(() => _showIfGayaBelajarNull());
    } else {
      _fetchModules();
    }
  }

  Future<void> _fetchModules() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final fetchedModules = await _modulRepository.getModul(
        widget.accessToken,
      );
      setState(() {
        modules = fetchedModules;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load modules: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _showIfGayaBelajarNull() {
    setState(() {
      isLoading = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF27DEBF)),
              SizedBox(width: 10),
              Text('Pemberitahuan'),
            ],
          ),
          content: Text(
            'Gaya Belajar Anda belum dibuat. Silakan isi kuesioner untuk melanjutkan.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('KEMBALI', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF27DEBF),
              ),
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to Kuesioner
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => Kuesioner(
                          uuid: widget.uuid,
                          accessToken: widget.accessToken,
                          username: widget.username,
                        ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter modules based on search query
    List<ModulModel> filteredModules = modules;
    if (_searchQuery.isNotEmpty) {
      filteredModules =
          modules
              .where(
                (module) =>
                    (module.judul?.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ??
                        false) ||
                    (module.deskripsi?.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ??
                        false) ||
                    (module.pelajaran?.pelajaran?.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ??
                        false),
              )
              .toList();
    }

    if (widget.gayaBelajar.isNotEmpty) {
      filteredModules =
          filteredModules
              .where(
                (module) =>
                    module.type?.toLowerCase() ==
                    widget.gayaBelajar.toLowerCase(),
              )
              .toList();
    }

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
          'Daftar Materi',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF27DEBF),
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: Color(0xFF27DEBF)),
            onPressed: () {
              _showSearchDialog();
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list_rounded, color: Color(0xFF27DEBF)),
            onPressed: () {
              _showFilterDialog();
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

          // Header section with total modules
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  children: [
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.close, size: 14, color: Colors.red),
                              SizedBox(width: 6),
                              Text(
                                'Clear Search',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Main content - module list
              Expanded(
                child:
                    _isLoading
                        ? Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF27DEBF),
                          ),
                        )
                        : _errorMessage.isNotEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 60,
                                color: Colors.red[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                _errorMessage,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red[600],
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 24),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF27DEBF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: _fetchModules,
                                child: Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        )
                        : filteredModules.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Tidak ada materi yang ditemukan',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: filteredModules.length,
                          itemBuilder: (context, index) {
                            final module = filteredModules[index];

                            // Determine the color and icon based on type
                            Color typeColor;
                            IconData typeIcon;

                            switch (module.type?.toLowerCase() ?? '') {
                              case 'visual':
                                typeColor = Color(0xFF5C7AEA);
                                typeIcon = Icons.visibility_outlined;
                                break;
                              case 'kinestetik':
                                typeColor = Color(0xFFE94560);
                                typeIcon = Icons.accessibility_new_rounded;
                                break;
                              case 'auditori':
                                typeColor = Color(0xFF4E9F3D);
                                typeIcon = Icons.hearing_outlined;
                                break;
                              default:
                                typeColor = Color(0xFF5C7AEA);
                                typeIcon = Icons.book_outlined;
                            }

                            // Helper function to get subject icon
                            IconData getSubjectIcon(String subject) {
                              switch (subject) {
                                case 'Matematika':
                                  return Icons.calculate_rounded;
                                case 'Fisika':
                                  return Icons.science_rounded;
                                case 'B.Inggris':
                                  return Icons.language_rounded;
                                case 'B. Indonesia':
                                  return Icons.menu_book_rounded;
                                default:
                                  return Icons.book_rounded;
                              }
                            }

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ListSubModul(
                                          modulId: module.id,
                                          accessToken: widget.accessToken,
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 0,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Color(0xFF27DEBF).withOpacity(0.15),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Module header with type indicator
                                    Container(
                                      padding: EdgeInsets.fromLTRB(
                                        16,
                                        16,
                                        16,
                                        12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Type indicator and bookmark button
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: typeColor.withOpacity(
                                                    0.1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: typeColor
                                                        .withOpacity(0.3),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      typeIcon,
                                                      size: 16,
                                                      color: typeColor,
                                                    ),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      module.type ?? 'Unknown',
                                                      style: TextStyle(
                                                        color: typeColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 12),

                                          // Module title
                                          Text(
                                            module.judul ?? 'No Title',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              letterSpacing: 0.3,
                                            ),
                                          ),

                                          SizedBox(height: 8),

                                          // Module description
                                          Text(
                                            module.deskripsi ??
                                                'No Description',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                              height: 1.5,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Divider
                                    Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Colors.grey.withOpacity(0.1),
                                    ),

                                    // Module metadata section
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.02),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          // Subject indicator
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Color(
                                                0xFF27DEBF,
                                              ).withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              getSubjectIcon(
                                                module.pelajaran?.pelajaran ??
                                                    '',
                                              ),
                                              size: 18,
                                              color: Color(0xFF27DEBF),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            module.pelajaran?.pelajaran ??
                                                'Unknown Subject',
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),

                                          Spacer(),

                                          // Duration indicator
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time_rounded,
                                                  size: 14,
                                                  color: Colors.grey[700],
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  module.durasi != null
                                                      ? '${module.durasi} Jam'
                                                      : 'N/A',
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          SizedBox(width: 8),

                                          // Grade level indicator
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.school_rounded,
                                                  size: 14,
                                                  color: Colors.grey[700],
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  module.kelas?.kelas != null
                                                      ? 'Kelas ${module.kelas?.kelas}'
                                                      : 'N/A',
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Cari Materi'),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Masukkan kata kunci',
                prefixIcon: Icon(Icons.search, color: Color(0xFF27DEBF)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF27DEBF)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF27DEBF), width: 2),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            actions: [
              TextButton(
                child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF27DEBF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Cari'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Filter Materi'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kelas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildFilterChip('Kelas 10', Color(0xFF27DEBF)),
                    _buildFilterChip('Kelas 11', Color(0xFF27DEBF)),
                    _buildFilterChip('Kelas 12', Color(0xFF27DEBF)),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Reset', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF27DEBF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Terapkan'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  Widget _buildFilterChip(String label, Color color) {
    return FilterChip(
      label: Text(label, style: TextStyle(fontSize: 12, color: Colors.white)),
      backgroundColor: color.withOpacity(0.7),
      selectedColor: color,
      selected: false,
      onSelected: (selected) {
        // Handle filter selection
      },
    );
  }
}
