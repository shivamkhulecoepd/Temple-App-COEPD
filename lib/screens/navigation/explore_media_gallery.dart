import 'package:flutter/material.dart';
import 'package:mslgd/widgets/common/snackbar_widget.dart';
import 'package:mslgd/widgets/translated_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/services/db_functions.dart';

class ExploreMediaGallery extends StatefulWidget {
  final String type; // 'images' or 'videos'
  const ExploreMediaGallery({required this.type, super.key});

  @override
  State<ExploreMediaGallery> createState() => _ExploreMediaGalleryState();
}

class _ExploreMediaGalleryState extends State<ExploreMediaGallery>
    with SingleTickerProviderStateMixin {
  final db = DBFunctions();
  String selectedCategory = ''; 
  late TabController _tabController;

  // Separate categories for images and videos
  final List<String> imageCategories = [
    'festivals',
    'seva',
    'temple_views',
    'devotees',
  ];

  final List<String> imageCategoryLabels = [
    'Festivals',
    'Seva',
    'Temple Views',
    'Devotees',
  ];

  final List<String> videoCategories = [
    'festivals_celebrations',
    'sevas_poojas',
    'temple_history_spiritual_discourses',
    'devotee_services_activities',
  ];

  final List<String> videoCategoryLabels = [
    'Festivals Celebrations',
    'Sevas/ Poojas',
    'Temple History/ Spiritual Discourses',
    'Devotee Services and Activities',
  ];

  List<String> get currentCategories => 
      widget.type == 'images' ? imageCategories : videoCategories;
  
  List<String> get currentCategoryLabels => 
      widget.type == 'images' ? imageCategoryLabels : videoCategoryLabels;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: currentCategories.length, vsync: this);
    selectedCategory = currentCategories.first;
    // Each tab now manages its own content independently
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



  void _onCategoryChanged(int index) {
    setState(() {
      selectedCategory = currentCategories[index];
    });
    // Each tab now manages its own content independently
  }

  @override
  Widget build(BuildContext context) {
    final isImages = widget.type == 'images';
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: TranslatedText(
          isImages ? 'Image Gallery' : 'Video Archive',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF043342), // primaryBlue
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: const Color(0xFF043342), // primaryBlue for both themes
            child: TabBar(
              controller: _tabController,
              onTap: _onCategoryChanged,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: EdgeInsets.zero,
              labelPadding: const EdgeInsets.symmetric(horizontal: 8),
              indicatorColor: const Color(0xFFFF5621), // primaryOrange
              indicatorWeight: 3,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 4),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              dividerColor: Colors.transparent,
              tabs: currentCategories.asMap().entries.map((entry) {
                final index = entry.key;
                final label = currentCategoryLabels[index];
                
                return Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: TranslatedText(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: currentCategories.map((category) {
          // Create a separate stateful widget for each tab content to handle its own media items
          return _buildMediaContentForCategory(category);
        }).toList(),
      ),
    );
  }

  Widget _buildMediaContentForCategory(String category) {
    return _MediaContentWidget(
      category: category,
      type: widget.type,
      db: db,
    );
  }
}

// Separate stateful widget to handle media content for each category
class _MediaContentWidget extends StatefulWidget {
  final String category;
  final String type; // 'images' or 'videos'
  final DBFunctions db;

  const _MediaContentWidget({
    required this.category,
    required this.type,
    required this.db,
  });

  @override
  State<_MediaContentWidget> createState() => _MediaContentWidgetState();
}

class _MediaContentWidgetState extends State<_MediaContentWidget> {
  List<dynamic> mediaItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedia();
  }

  Future<void> _loadMedia() async {
    setState(() => isLoading = true);
    try {
      List<dynamic> fetched;
      if (widget.type == 'images') {
        fetched = await widget.db.fetchGalleryImages(category: widget.category);
      } else {
        fetched = await widget.db.fetchArchiveVideosByCategory(category: widget.category);
      }
      
      setState(() {
        mediaItems = fetched;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        AppSnackbar.error(context, 'Failed to load ${widget.type}: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildMediaContent();
  }

  Widget _buildMediaContent() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            const Color(0xFFFF5621), // primaryOrange
          ),
        ),
      );
    }

    if (mediaItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.type == 'images' ? Icons.photo_library : Icons.video_library,
              size: 64,
              color: Colors.grey.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            TranslatedText(
              'No ${widget.type} found in this category',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return widget.type == 'images' ? _buildImageGrid() : _buildVideoList();
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: mediaItems.length,
      itemBuilder: (context, index) {
        final img = mediaItems[index];
        return _buildImageCard(img);
      },
    );
  }

  Widget _buildImageCard(dynamic img) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullScreenImageViewer(
              imageUrl: img['image_url'],
              title: img['title'] ?? 'Gallery Image',
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.network(
          img['image_url'],
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Colors.white,
              ),
            );
          },
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[100],
            child: Icon(
              Icons.broken_image,
              size: 60,
              color: Colors.grey.withValues(alpha: 0.4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mediaItems.length,
      itemBuilder: (context, index) {
        final video = mediaItems[index];
        return _buildVideoCard(video);
      },
    );
  }

  Widget _buildVideoCard(dynamic video) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              final url = video['embed_url'] ?? video['video_url'];
              if (url != null) {
                try {
                  await launchUrl(Uri.parse(url));
                } catch (e) {
                  if (mounted) {
                    AppSnackbar.error(context, 'Could not open video: $e');
                  }
                }
              }
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    video['thumbnail'] ?? '',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 200,
                          color: Colors.white,
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: Colors.grey[100],
                      child: const Center(
                        child: Icon(
                          Icons.video_library,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatedText(
                  video['title'] ?? 'Video',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF043342), // primaryBlue
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (video['description'] != null) ...[
                  const SizedBox(height: 8),
                  TranslatedText(
                    video['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF043342).withValues(alpha: 0.7), // primaryBlue with opacity
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final String title;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: TranslatedText(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 200,
                    height: 200,
                    color: Colors.white,
                  ),
                ),
              );
            },
            errorBuilder: (_, __, ___) => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image,
                    size: 80,
                    color: Colors.white54,
                  ),
                  SizedBox(height: 16),
                  TranslatedText(
                    'Failed to load image',
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}