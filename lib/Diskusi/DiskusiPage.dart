import 'package:flutter/material.dart';
import 'package:skilltopia/Diskusi/AddDiskusi.dart';
import 'package:skilltopia/Diskusi/EditDiskusi.dart';
import 'package:skilltopia/constants.dart';
import 'package:intl/intl.dart';
import 'package:skilltopia/models.dart';
import 'package:skilltopia/repository.dart';

String getFileNameFromUrl(String url) {
  Uri uri = Uri.parse(url);
  String fileName = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
  return fileName;
}

class DiskusiPage extends StatefulWidget {
  final int siswaId;
  final String uuid;
  final String username;
  final String accessToken;
  final String judulContent;

  const DiskusiPage({
    Key? key,
    required this.siswaId,
    required this.uuid,
    required this.username,
    required this.accessToken,
    required this.judulContent,
  }) : super(key: key);

  @override
  _DiskusiPageState createState() => _DiskusiPageState();
}

class _DiskusiPageState extends State<DiskusiPage> {
  final List<String> _filters = ['Semua', 'Belum Dijawab', 'Pertanyaan Saya'];
  String _selectedFilter = 'Semua';
  final Color _primaryColor = Color(0xFF27DEBF);
  bool _isLoading = true;
  List<DiskusiModel> _diskusiList = [];
  List<KomentarModel> _commentsList = [];
  Map<int, bool> _showComments = {};
  Map<int, bool> _showCommentForm = {};

  final Map<int, TextEditingController> _commentControllers = {};
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  // Add repositories
  final DiskusiRepository _diskusiRepository = DiskusiRepository();
  final KomentarRepository _komentarRepository = KomentarRepository();

  void _showDiskusiOptionsBottomSheet(DiskusiModel diskusi) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Opsi Diskusi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.edit_outlined, color: Colors.blue),
                title: Text('Edit Diskusi'),
                onTap: () {
                  Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => EditDiskusi(
                                    uuid: widget.uuid,
                                    accessToken: widget.accessToken,
                                    postId: diskusi.id
                                  ),
                            ),
                          );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: Colors.red),
                title: Text('Hapus Diskusi'),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteDiskusiConfirmation(diskusi);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _fetchDataBasedOnFilter(String filter) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<DiskusiModel> diskusiList;
      switch (filter) {
        case 'Semua':
          diskusiList = await _diskusiRepository.getDiskusi(widget.accessToken);
          break;
        case 'Belum Dijawab':
          diskusiList = await _diskusiRepository.getAllDiskusiWithoutComment(
            widget.accessToken,
          );
          break;
        case 'Pertanyaan Saya':
          diskusiList = await _diskusiRepository.getMyDiskusi(
            widget.accessToken,
          );
          break;
        default:
          diskusiList = await _diskusiRepository.getDiskusi(widget.accessToken);
      }

      setState(() {
        _diskusiList = diskusiList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Gagal memuat data: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.judulContent;
    print( "nilai judul content: " + widget.judulContent);

    _fetchData().then((_) {
    if (widget.judulContent.isNotEmpty) {
      _filterDiskusiList(widget.judulContent);
    }
  });
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Using repositories instead of direct HTTP calls
      final diskusiList = await _diskusiRepository.getDiskusi(widget.accessToken);
      final commentsList = await _komentarRepository.getKomentar(widget.accessToken);

      setState(() {
        _diskusiList = diskusiList;
        _commentsList = commentsList;
        _isLoading = false; // Set loading to false once data is fetched
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Gagal memuat data: ${e.toString()}');
    }
  }

  void _showDeleteDiskusiConfirmation(DiskusiModel diskusi) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Hapus Diskusi'),
            content: Text('Apakah Anda yakin ingin menghapus diskusi ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  _deleteDiskusi(diskusi);
                },
                child: Text('Hapus'),
              ),
            ],
          ),
    );
  }

  Future<void> _deleteDiskusi(DiskusiModel diskusi) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Tambahkan method di DiskusiRepository untuk menghapus diskusi
      await _diskusiRepository.deleteDiskusi(
        accessToken: widget.accessToken,
        postId: diskusi.id,
      );

      // Refresh data setelah menghapus
      await _fetchDataBasedOnFilter(_selectedFilter);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Diskusi berhasil dihapus'),
          backgroundColor: _primaryColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus diskusi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  List<KomentarModel> _getCommentsForPost(int postId) {
    return _commentsList.where((comment) => comment.postId == postId).toList();
  }

  Future<void> _postComment(int postId, int siswaId, String content) async {
    if (content.trim().isEmpty) return;

    setState(() {
      _showCommentForm[postId] = false;
    });

    try {
      setState(() {
        _isDeletingComment[postId] = true;
      });

      final newComment = await _komentarRepository.postKomentar(
        accessToken: widget.accessToken,
        postId: postId,
        siswaId: siswaId,
        content: content,
      );

      // Fetch updated comments for this specific post
      final updatedComments = await _komentarRepository.getKomentarByPostId(
        widget.accessToken,
        postId,
      );

      setState(() {
        // Replace existing comments for this post with updated comments
        _commentsList =
            _commentsList.where((comment) => comment.postId != postId).toList();
        _commentsList.addAll(updatedComments);

        _commentControllers[postId]?.clear();
        _isDeletingComment.remove(postId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Balasan berhasil ditambahkan'),
          backgroundColor: _primaryColor,
        ),
      );
    } catch (e) {
      setState(() {
        _isDeletingComment.remove(postId);
      });

      _showErrorSnackBar('Gagal mengirim balasan: ${e.toString()}');
    }
  }

  void _toggleCommentForm(int postId) {
    setState(() {
      // Initialize controller if needed
      _commentControllers[postId] ??= TextEditingController();

      // Toggle comment form visibility
      _showCommentForm[postId] = !(_showCommentForm[postId] ?? false);

      // Hide comments section when showing form
      if (_showCommentForm[postId] == true) {
        _showComments[postId] = false;
      }
    });
  }

  void _toggleComments(int postId) {
    setState(() {
      _showComments[postId] = !(_showComments[postId] ?? false);

      // Hide comment form when showing comments
      if (_showComments[postId] == true) {
        _showCommentForm[postId] = false;
      }
    });
  }

  @override
  void dispose() {
    // Dispose all text controllers
    _commentControllers.forEach((_, controller) => controller.dispose());
    _commentController.dispose();
    super.dispose();
  }

  // Method to show edit comment dialog
  void _showEditCommentDialog(BuildContext context, KomentarModel comment) {
    TextEditingController editController = TextEditingController(
      text: comment.content,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit Komentar'),
            content: TextField(
              controller: editController,
              decoration: InputDecoration(
                hintText: 'Edit komentar...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF27DEBF),
                ),
                onPressed: () async {
                  if (editController.text.isNotEmpty) {
                    try {
                      // Set loading state for this specific comment
                      setState(() {
                        _isDeletingComment[comment.id] = true;
                      });

                      // Update the comment
                      await _komentarRepository.updateKomentar(
                        accessToken: widget.accessToken,
                        komentarId: comment.id,
                        content: editController.text,
                      );

                      // Fetch updated comments for this specific post
                      final updatedComments = await _komentarRepository
                          .getKomentarByPostId(
                            widget.accessToken,
                            comment.postId,
                          );

                      Navigator.pop(context);

                      // Update the comments list
                      setState(() {
                        // Remove existing comments for this post
                        _commentsList =
                            _commentsList
                                .where((c) => c.postId != comment.postId)
                                .toList();
                        // Add updated comments
                        _commentsList.addAll(updatedComments);

                        // Remove loading state
                        _isDeletingComment.remove(comment.id);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Komentar berhasil diperbarui'),
                          backgroundColor: _primaryColor,
                        ),
                      );
                    } catch (e) {
                      // Remove loading state on error
                      setState(() {
                        _isDeletingComment.remove(comment.id);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gagal memperbarui komentar: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Text('Simpan'),
              ),
            ],
          ),
    );
  }

  Map<int, bool> _isDeletingComment = {};

  // Method to show delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context, int commentId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Hapus Komentar'),
            content: Text('Apakah anda yakin ingin menghapus komentar ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Batal'),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () async {
                  try {
                    // Close the dialog first
                    Navigator.pop(context);

                    // Set the deleting state for this specific comment
                    setState(() {
                      _isDeletingComment[commentId] = true;
                    });

                    await _komentarRepository.deleteKomentar(
                      widget.accessToken,
                      commentId,
                    );

                    // Update the comments list by removing the deleted comment
                    setState(() {
                      _commentsList.removeWhere(
                        (comment) => comment.id == commentId,
                      );
                      _isDeletingComment.remove(
                        commentId,
                      ); // Remove the loading state
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Komentar berhasil dihapus')),
                    );
                  } catch (e) {
                    // Clear the loading state on error
                    setState(() {
                      _isDeletingComment[commentId] = false;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal menghapus komentar: $e')),
                    );
                  }
                },
                child: Text('Hapus'),
              ),
            ],
          ),
    );
  }

  String _formatTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  Widget _buildDiskusiOptionsButton(DiskusiModel diskusi) {
    return IconButton(
      icon: Icon(Icons.more_vert, color: Colors.grey, size: 20),
      constraints: BoxConstraints(), // Menghilangkan padding default
      padding: EdgeInsets.zero, // Menghilangkan padding default
      onPressed: () {
        // Hanya tampilkan opsi untuk diskusi milik pengguna
        if (diskusi.user.username == widget.username) {
          _showDiskusiOptionsBottomSheet(diskusi);
        }
      },
    );
  }

  void _filterDiskusiList(String query) {
  if (query.isEmpty) {
    // If the search query is empty, show all discussions
    _fetchDataBasedOnFilter(_selectedFilter);
  } else {
    // First fetch all discussions based on current filter if we don't have any
    if (_diskusiList.isEmpty) {
      _fetchDataBasedOnFilter(_selectedFilter).then((_) {
        // Then apply the filter
        _applySearchFilter(query);
      });
    } else {
      // Apply the filter directly if we already have discussions
      _applySearchFilter(query);
    }
  }
}

void _applySearchFilter(String query) {
  final filteredList = _diskusiList.where((diskusi) {
    return diskusi.judul.toLowerCase().contains(query.toLowerCase());
  }).toList();

  setState(() {
    _diskusiList = filteredList;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Forum Diskusi',
          style: TextStyle(
            color: _primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: _primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => AddDiskusi(
                        uuid: widget.uuid,
                        accessToken: widget.accessToken,
                        siswaId: widget.siswaId,
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator(color: _primaryColor))
              : Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari diskusi...',
                        prefixIcon: Icon(Icons.search, color: _primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _primaryColor.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (query) {
                        // Update the search filter based on judulContent and the query input
                        _filterDiskusiList(query);
                      },
                    ),
                  ),

                  // Filter Buttons
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children:
                            _filters.map((filter) {
                              bool isSelected = _selectedFilter == filter;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ChoiceChip(
                                  label: Text(filter),
                                  selected: isSelected,
                                  selectedColor: _primaryColor.withOpacity(0.2),
                                  backgroundColor: Colors.grey.shade100,
                                  labelStyle: TextStyle(
                                    color:
                                        isSelected
                                            ? _primaryColor
                                            : Colors.grey,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedFilter = filter;
                                      _fetchDataBasedOnFilter(filter);
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),

                  // Discussion List
                  Expanded(
                    child:
                        _diskusiList.isEmpty
                            ? Center(child: Text('Belum ada diskusi'))
                            : ListView.builder(
                              padding: EdgeInsets.all(16),
                              itemCount: _diskusiList.length,
                              itemBuilder: (context, index) {
                                final diskusi = _diskusiList[index];
                                final postId = diskusi.id;
                                final hasImages = diskusi.url.isNotEmpty;
                                final comments = _getCommentsForPost(postId);

                                // Ensure we have a controller for this post
                                _commentControllers[postId] ??=
                                    TextEditingController();

                                return Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Color Indicator
                                      Container(
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: _primaryColor,
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(12),
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Tags
                                            if (diskusi.kategori.isNotEmpty ||
                                                _selectedFilter ==
                                                    'Pertanyaan Saya')
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // Tags
                                                  Expanded(
                                                    child: Wrap(
                                                      spacing: 8,
                                                      children:
                                                          diskusi.kategori
                                                              .map(
                                                                (tag) =>
                                                                    _buildTag(
                                                                      tag,
                                                                    ),
                                                              )
                                                              .toList(),
                                                    ),
                                                  ),

                                                  // Options Button (Titik 3)
                                                  if (_selectedFilter ==
                                                      'Pertanyaan Saya')
                                                    _buildDiskusiOptionsButton(
                                                      diskusi,
                                                    ),
                                                ],
                                              ),

                                            SizedBox(height: 12),

                                            // Title
                                            Text(
                                              diskusi.judul,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            SizedBox(height: 8),

                                            // Description
                                            Text(
                                              diskusi.content,
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                              ),
                                            ),

                                            SizedBox(height: 16),

                                            // Images - Show only if available
                                            if (hasImages)
                                              Container(
                                                height: 200,
                                                child: _buildMultipleImages(
                                                  diskusi.url,
                                                ),
                                              ),

                                            if (hasImages) SizedBox(height: 16),

                                            // User Info
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage:
                                                      _getUserProfileImage(
                                                        diskusi,
                                                      ),
                                                  child:
                                                      _getUserProfileImage(
                                                                diskusi,
                                                              ) ==
                                                              null
                                                          ? Text(
                                                            _getUserInitial(
                                                              diskusi,
                                                            ),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )
                                                          : null,
                                                ),
                                                SizedBox(width: 12),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _getUserName(diskusi),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      diskusi.user.role ?? '-',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Text(
                                                  _formatDate(
                                                    diskusi.createdAt,
                                                  ),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 16),

                                            // Actions
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap:
                                                      () => _toggleCommentForm(
                                                        postId,
                                                      ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.comment_outlined,
                                                        color: _primaryColor,
                                                        size: 20,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        '${comments.length} Balasan',
                                                        style: TextStyle(
                                                          color: _primaryColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 16),
                                                if (comments.isNotEmpty)
                                                  InkWell(
                                                    onTap:
                                                        () => _toggleComments(
                                                          postId,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          _showComments[postId] ==
                                                                  true
                                                              ? Icons
                                                                  .visibility_off_outlined
                                                              : Icons
                                                                  .remove_red_eye_outlined,
                                                          color: _primaryColor,
                                                          size: 20,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          _showComments[postId] ==
                                                                  true
                                                              ? 'Sembunyikan Balasan'
                                                              : 'Lihat Balasan',
                                                          style: TextStyle(
                                                            color:
                                                                _primaryColor,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),

                                            // Comments Section
                                            if (_showComments[postId] == true)
                                              _buildCommentsSection(comments),

                                            // Comment Form
                                            if (_showCommentForm[postId] ==
                                                true)
                                              _buildCommentForm(postId),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }

  String _getUserName(DiskusiModel diskusi) {
    if (diskusi.siswa != null) {
      return diskusi.siswa!.nama ?? '';
    } else if (diskusi.guru != null) {
      return diskusi.guru!.nama ?? '';
    } else {
      return diskusi.user.username ?? '';
    }
  }

  String _getUserInitial(DiskusiModel diskusi) {
    String name = _getUserName(diskusi);
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  ImageProvider? _getUserProfileImage(DiskusiModel diskusi) {
    String? imageUrl;

    if (diskusi.siswa != null && diskusi.siswa!.url != null) {
      imageUrl =
          "${AppConstants.baseUrlImage}" +
          getFileNameFromUrl(diskusi.siswa!.url!);
    } else if (diskusi.guru != null && diskusi.guru!.url != null) {
      imageUrl =
          "${AppConstants.baseUrlImage}" +
          getFileNameFromUrl(diskusi.guru!.url!);
    }

    return imageUrl != null ? NetworkImage(imageUrl) : null;
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return '-';
    }
  }

  Widget _buildMultipleImages(List<String> imageUrls) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: imageUrls.length,
      itemBuilder: (context, imageIndex) {
        // Modified to use the proper image URL format
        final formattedImageUrl =
            "${AppConstants.baseUrlImage}" +
            getFileNameFromUrl(imageUrls[imageIndex]);

        return Padding(
          padding: EdgeInsets.only(
            right: imageIndex < imageUrls.length - 1 ? 8.0 : 0,
          ),
          child: InkWell(
            onTap: () {
              // Show full-screen image when tapped
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: Container(
                      color: Colors.black,
                      child: Center(
                        child: Image.network(
                          formattedImageUrl,
                          fit:
                              BoxFit
                                  .contain, // Ensure the image is fully contained and scales properly
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                formattedImageUrl,
                fit: BoxFit.cover,
                width: 330,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 200,
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(Icons.error, color: Colors.grey[400]),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 200,
                    child: Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                        color: _primaryColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // Fixed method to build comments section
  Widget _buildCommentsSection(List<KomentarModel> comments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            final bool isCurrentUser = comment.user.username == widget.username;
            final bool isDeleting = _isDeletingComment[comment.id] == true;

            // Show loading indicator while processing
            if (isDeleting) {
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: _primaryColor,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Memproses...",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Card(
              margin: EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User info and actions row
                    Row(
                      children: [
                        // User Avatar
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: _primaryColor.withOpacity(0.2),
                          backgroundImage: _getCommentUserProfileImage(comment),
                          child:
                              _getCommentUserProfileImage(comment) == null
                                  ? Text(
                                    _getCommentUserInitial(comment),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _primaryColor,
                                    ),
                                  )
                                  : null,
                        ),

                        SizedBox(width: 12),

                        // User info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getCommentUserName(comment),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                _formatTimestamp(comment.createdAt),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Action buttons for current user
                        if (isCurrentUser)
                          Row(
                            children: [
                              Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap:
                                      () => _showEditCommentDialog(
                                        context,
                                        comment,
                                      ),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap:
                                      () => _showDeleteConfirmation(
                                        context,
                                        comment.id,
                                      ),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),

                    // Comment content
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 12.0,
                        bottom: 4.0,
                        left: 4.0,
                      ),
                      child: Text(
                        comment.content,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // Add a "view more" button if there are many comments
        if (comments.length > 5)
          Center(
            child: TextButton.icon(
              onPressed: () {
                // TODO: Implement viewing all comments or pagination
              },
              icon: Icon(Icons.visibility, size: 16, color: _primaryColor),
              label: Text(
                'Lihat Semua Balasan',
                style: TextStyle(
                  color: _primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Method to handle posting comments from the bottom comment field
  void _handlePostComment(int postId) {
    if (_commentController.text.trim().isNotEmpty) {
      _postComment(postId, widget.siswaId, _commentController.text);
      _commentController.clear();
    }
  }

  String _getCommentUserName(KomentarModel comment) {
    if (comment.siswa != null) {
      return comment.siswa!.nama ?? '';
    } else if (comment.guru != null) {
      return comment.guru!.nama ?? '';
    } else {
      return comment.user.username ?? '';
    }
  }

  String _getCommentUserInitial(KomentarModel comment) {
    String name = _getCommentUserName(comment);
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  ImageProvider? _getCommentUserProfileImage(KomentarModel comment) {
    String? imageUrl;

    if (comment.siswa != null && comment.siswa!.url != null) {
      imageUrl =
          "${AppConstants.baseUrlImage}" +
          getFileNameFromUrl(comment.siswa!.url!);
    } else if (comment.guru != null && comment.guru!.url != null) {
      imageUrl =
          "${AppConstants.baseUrlImage}" +
          getFileNameFromUrl(comment.guru!.url!);
    }

    return imageUrl != null ? NetworkImage(imageUrl) : null;
  }

  Widget _buildCommentForm(int postId) {
    return Column(
      children: [
        Divider(height: 32),
        Text(
          'Tambahkan Balasan',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        TextField(
          controller: _commentControllers[postId],
          decoration: InputDecoration(
            hintText: 'Ketik balasan Anda di sini...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _primaryColor, width: 2),
            ),
          ),
          maxLines: 3,
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _showCommentForm[postId] = false;
                });
              },
              child: Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed:
                  () => _postComment(
                    postId,
                    widget.siswaId,
                    _commentControllers[postId]!.text,
                  ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Kirim Balasan'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTag(String label) {
    return Chip(
      label: Text(label, style: TextStyle(color: _primaryColor, fontSize: 12)),
      backgroundColor: _primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: _primaryColor.withOpacity(0.3)),
      ),
    );
  }
}
