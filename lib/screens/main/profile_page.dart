import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/screens/auth/sign_out_page.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final double coverHeight = 150;
  final double profileHeight = 200;

  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(
       padding: EdgeInsets.zero, 
       children: <Widget>[
        buildTop(),
        buildContent(),
       ],
      )
    );
  }

  Widget buildTop(){
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;
    
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
        ),
        Positioned(
          top: top,
          child: buildProfileImage(),
        )
      ], 
    );
  }

  Widget buildCoverImage() => Container(
    color: Theme.of(context).colorScheme.primaryContainer,
    width: double.infinity,
    height: coverHeight,
    // fit: BoxFit.cover,
  );

  Widget buildProfileImage() { 
    final innerRadius = (profileHeight / 2) - 8.0;
    final outerSize = profileHeight; 

    return Container(
      width: outerSize,
      height: outerSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle, 
        border: Border.all(
          color: Theme.of(context).scaffoldBackgroundColor, 
          width: 8.0, 
        ),
      ),
      child: CircleAvatar(
        radius: innerRadius, 
        backgroundColor: Colors.grey.shade600, 
      ),
    );
  }

  Widget buildContent() {
    final authState = ref.watch(authNotifierProvider);
    return Column(
        children: [
          const SizedBox(height: 8),
          Text(
            "${authState.user!.firstName} ${authState.user!.lastName}",
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              fontWeight: FontWeight.bold
            )
          ),
          const SizedBox(height: 8),
          Text(
            "@${authState.user!.username}",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Theme.of(context).colorScheme.outline
            )

          ),

          const SizedBox(height: 8),
          const SizedBox(height: 8),
          buildAbout(),
        ], 
    );
  }



  Widget buildAbout() {
    final authState = ref.watch(authNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildTile("Biography","I am steve."), 
        buildTile("Interests",authState.user != null ? (authState.user!.interests)!.map((item) => (item as dynamic).title.toString()).join(", ") : "No interests to show!"), 
        buildTile("Travel Styles",authState.user != null ? (authState.user!.travelStyles)!.map((item) => (item as dynamic).title.toString()).join(", ") : "No particular travel styles"), 
        Row(
          children: [
            Expanded( child: buildTile("Email", authState.user!.email)),
            Expanded( child: buildTile("Phone Number", "---")),
          ],
        ),
        // const SignOutPage() // TODO: fix this
      ],
    ); 
  }
  
   

  Widget buildTile(String title, String content) => Card(
    elevation: 1.0, 
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    color: Theme.of(context).colorScheme.primaryContainer,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ),
  );
}
