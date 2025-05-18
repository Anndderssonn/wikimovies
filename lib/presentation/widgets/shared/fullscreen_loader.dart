import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages() {
    final messages = <String>[
      'Popcorn? Check. Patience? Working on it...',
      'Loading the plot twist... please wait!',
      'Your movie magic is almost ready. Cue the dramatic music!',
      'Staring contest with the loading bar: you are losing.',
      'Staring contest with the loading bar: you are losing.',
      'Buffering like it is 1999...',
      'Almost there... just bribing the movie stars.',
      'Casting actors... and spells.',
      'Adding extra butter to your movie experience...',
      'Just like a sequel, it is taking longer than expected.',
      'Loading faster than a slow-motion explosion.',
    ];
    return Stream.periodic(const Duration(milliseconds: 1200), (step) {
      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Wating... Please.'),
          const SizedBox(height: 10),
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 10),
          StreamBuilder(
            stream: getLoadingMessages(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text('Loading...');
              }
              return Text(snapshot.data!);
            },
          ),
        ],
      ),
    );
  }
}
