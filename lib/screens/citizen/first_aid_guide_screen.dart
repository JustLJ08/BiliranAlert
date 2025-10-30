import 'package:flutter/material.dart';

class FirstAidGuideScreen extends StatelessWidget {
  const FirstAidGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> firstAidGuides = [
      {
        'title': 'CPR (Cardiopulmonary Resuscitation)',
        'icon': Icons.favorite,
        'color': Colors.redAccent,
        'image': 'lib/assets/images/cpr.png', // optional local asset
        'steps': '''
1. Check responsiveness and breathing.
2. Call emergency services immediately.
3. Place the heel of your hand on the center of the chest.
4. Push hard and fast (100–120 compressions per minute).
5. If trained, give 2 rescue breaths after every 30 compressions.
6. Continue until help arrives or the person starts breathing.
        '''
      },
      {
        'title': 'Bleeding',
        'icon': Icons.water_drop,
        'color': Colors.deepOrange,
        'image': 'lib/assets/images/bleeding.png',
        'steps': '''
1. Apply direct pressure to the wound using a clean cloth.
2. Do not remove the cloth if soaked — add another on top.
3. Elevate the injured area if possible.
4. If bleeding doesn't stop, seek medical help immediately.
        '''
      },
      {
        'title': 'Burns',
        'icon': Icons.local_fire_department,
        'color': Colors.orangeAccent,
        'image': 'lib/assets/images/burns.png',
        'steps': '''
1. Cool the burn with clean running water for at least 10 minutes.
2. Do not use ice or ointments.
3. Cover with a clean, non-stick cloth.
4. Seek medical attention for severe or large burns.
        '''
      },
      {
        'title': 'Fractures (Broken Bones)',
        'icon': Icons.accessibility_new,
        'color': Colors.green,
        'image': 'lib/assets/images/fracture.png',
        'steps': '''
1. Do not move the injured person unnecessarily.
2. Immobilize the affected area using a splint or sling.
3. Apply a cold pack to reduce swelling.
4. Seek professional medical help immediately.
        '''
      },
      {
        'title': 'Choking',
        'icon': Icons.mood_bad,
        'color': Colors.purpleAccent,
        'image': 'lib/assets/images/choking.png',
        'steps': '''
1. Encourage coughing if the person can breathe.
2. If not breathing, perform the Heimlich maneuver:
   - Stand behind the person.
   - Wrap your arms around their waist.
   - Make a fist and place it just above the navel.
   - Thrust inward and upward quickly.
3. Repeat until the object is expelled or the person becomes unconscious.
4. If unconscious, start CPR.
        '''
      },
      {
        'title': 'Heat Stroke',
        'icon': Icons.wb_sunny,
        'color': Colors.amber,
        'image': 'lib/assets/images/heatstroke.png',
        'steps': '''
1. Move the person to a cool place immediately.
2. Loosen or remove excess clothing.
3. Cool the body using water, fans, or wet towels.
4. Give small sips of water if the person is conscious.
5. Seek medical help right away.
        '''
      },
      {
        'title': 'Poisoning',
        'icon': Icons.warning_amber,
        'color': Colors.teal,
        'image': 'lib/assets/images/poison.png',
        'steps': '''
1. Identify the poison if possible.
2. Do not induce vomiting unless advised by a professional.
3. Call emergency services or poison control immediately.
4. Keep the poison container or label for reference.
        '''
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('First Aid Guide'),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent, Colors.orangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: firstAidGuides.length,
          itemBuilder: (context, index) {
            final item = firstAidGuides[index];
            return Card(
              color: Colors.white.withOpacity(0.95),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.only(bottom: 16),
              child: ExpansionTile(
                iconColor: item['color'],
                collapsedIconColor: item['color'],
                leading: CircleAvatar(
                  backgroundColor: item['color'].withOpacity(0.2),
                  child: Icon(item['icon'], color: item['color']),
                ),
                title: Text(
                  item['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: item['color'],
                  ),
                ),
                children: [
                  if (item['image'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        item['image'],
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const SizedBox(),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      item['steps'],
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
