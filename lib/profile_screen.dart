import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _showContactCard = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _launchLinkedIn() async {
    final Uri url =
        Uri.parse('https://www.linkedin.com/in/anushka-singh-634213252');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void _launchEmail() async {
    final Uri email = Uri.parse('mailto:anushka.wwork@gmail.com');
    if (!await launchUrl(email)) {
      throw 'Could not launch $email';
    }
  }

  void _launchPhone() async {
    final Uri phone = Uri.parse('tel:+919076002975');
    if (!await launchUrl(phone)) {
      throw 'Could not launch $phone';
    }
  }

  void _launchGitHub() async {
    final Uri github = Uri.parse('https://github.com/anushkawork');
    if (!await launchUrl(github, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $github';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _showContactCard = !_showContactCard;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              final themeNotifier =
                  Provider.of<ThemeNotifier>(context, listen: false);
              themeNotifier.toggleTheme(!themeNotifier.isDarkMode);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                height: 150,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://source.unsplash.com/random/900x300"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Positioned(
                left: 20,
                bottom: -30,
                child: AnimatedScale(
                  scale: 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: const CircleAvatar(
                      radius: 42,
                      backgroundImage: NetworkImage(
                        'https://avatars.githubusercontent.com/u/9919?s=280&v=4',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          FadeTransition(
            opacity: _fadeAnimation,
            child: const Column(
              children: [
                Text(
                  'Anushka Singh',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Flutter Developer',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 600),
            firstChild: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('anushka.wwork@gmail.com'),
                      onTap: _launchEmail,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: 0),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text('+91 9076002975'),
                      onTap: _launchPhone,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: 0),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.web),
                      title: const Text('LinkedIn Profile'),
                      onTap: _launchLinkedIn,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: 0),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.github,
                        size: 24,
                        color: Colors.black,
                      ),
                      title: const Text('GitHub'),
                      onTap: _launchGitHub,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: 0),
                    ),
                  ],
                ),
              ),
            ),
            secondChild: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Profile editing is currently disabled."),
            ),
            crossFadeState: _showContactCard
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
          ),
        ],
      ),
    );
  }
}
