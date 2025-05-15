import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Placeholder blue header for travel plan image
        Stack(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue[800],
              ),
            ),
            const Positioned(
              top: 40,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back, color: Colors.white),
                  Row(
                    children: [
                      Icon(Icons.share, color: Colors.white),
                      const SizedBox(width: 16),
                      Icon(Icons.settings, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
            const Positioned(
              left: 24,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Everest Trek',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'May 5 - June 5, 2025',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(  // Placeholder shared with friends icons 
                    children: [
                      CircleAvatar(radius: 12, backgroundColor: Colors.white),
                      const SizedBox(width: 4),
                      CircleAvatar(radius: 12, backgroundColor: Colors.white),
                      const SizedBox(width: 4),
                      CircleAvatar(radius: 12, backgroundColor: Colors.white),
                      const SizedBox(width: 4),
                      CircleAvatar(radius: 12, backgroundColor: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        // Tabs
        TabBar( 
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.black,
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(text: 'Itinerary'),
            Tab(text: 'Notes'),
            Tab(text: 'Flights'),
            Tab(text: 'Accommodations'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Itinerary tab
              _ItineraryTab(),
              // Notes Tab
              Center(child: Text('Notes')), 
              // Flights Tab
              Center(child: Text('Flights')), 
              // Accommodations Tab
              Center(child: Text('Accommodations')), 
            ],
          ),
        ),
      ],
    );
  }
}

class _ItineraryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Add activity bar
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Icon(Icons.add_circle_outline, color: Theme.of(context).colorScheme.primary),
            title: Text('Add an activity...'),
            trailing: Icon(Icons.more_vert),
            onTap: () {},
          ),
        ),
        const SizedBox(height: 16),
        // Date section
        Text(
          'May 5, 2025',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        // Itinerary Timeline
        _ItineraryTimeline(),
      ],
    );
  }
}

class _ItineraryTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder itinerary data
    final items = [
      {
        'time': '7:15 AM to 8:15 AM',
        'title': 'Mount Everest Basecamp',
        'desc': 'Quick camping and breakfast at basecamp',
      },
      {
        'time': '8:15 AM to 10:00 AM',
        'title': 'Mount Everest Camp IV',
        'desc': 'Go towards Camp IV then prepare to summit',
      },
      {
        'time': '10:00 AM to 7:00 PM',
        'title': 'Mount Everest Summit',
        'desc': 'Ideal push for summit, then bivouac',
      },
      {
        'time': '7:00 PM to 6:00 AM',
        'title': 'Mount Everest Summit',
        'desc': 'Sleep',
      },
    ];
    return Column(
      children: List.generate(items.length, (i) {
        final item = items[i];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['time'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['title'] as String,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['desc'] as String,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
