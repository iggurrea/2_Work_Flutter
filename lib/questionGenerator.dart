import 'dart:math';

class Question {
  final String questionText;
  final String correctAnswer;

  Question({required this.questionText, required this.correctAnswer});
}

class QuestionGenerator {
  static final Random _random = Random();

  static Question generate(int level) {
    switch (level) {
      case 1:
        return _generateLevel1();
      case 2:
        return _generateLevel2();
      case 3:
        return _generateLevel3();
      default:
        throw Exception("Invalid difficulty level.");
    }
  }

  static Question _generateLevel1() {
    final cidrOptions = [8, 16, 24];
    final cidr = cidrOptions[_random.nextInt(cidrOptions.length)];
    final ip = _randomIP();
    final questionType = _random.nextInt(3);

    switch (questionType) {
      case 0:
        final netId = _networkID(ip, cidr);
        return Question(
          questionText: "What is the Network ID of $ip/$cidr?",
          correctAnswer: netId,
        );
      case 1:
        final broadcast = _broadcast(ip, cidr);
        return Question(
          questionText: "What is the Broadcast address of $ip/$cidr?",
          correctAnswer: broadcast,
        );
      case 2:
        final ip2 = _randomIP();
        final sameNetwork = _sameNetwork(ip, ip2, cidr);
        return Question(
          questionText: "Are $ip and $ip2 on the same network with /$cidr?",
          correctAnswer: sameNetwork ? "Yes" : "No",
        );
      default:
        throw Exception("Invalid question type");
    }
  }

  static Question _generateLevel2() {
    final subnets = [26, 27, 28, 29];
    final cidr = subnets[_random.nextInt(subnets.length)];
    final ip = _randomIP();
    final choice = _random.nextInt(3);

    if (choice == 0) {
      return Question(
        questionText: "What is the Network ID of $ip with /$cidr?",
        correctAnswer: _networkID(ip, cidr),
      );
    } else if (choice == 1) {
      return Question(
        questionText: "What is the Broadcast address of $ip with /$cidr?",
        correctAnswer: _broadcast(ip, cidr),
      );
    } else {
      final ip2 = _randomIP();
      return Question(
        questionText: "Are $ip and $ip2 on the same network with /$cidr?",
        correctAnswer: _sameNetwork(ip, ip2, cidr) ? "Yes" : "No",
      );
    }
  }

  static Question _generateLevel3() {
    final cidrs = [21, 20, 19];
    final cidr = cidrs[_random.nextInt(cidrs.length)];
    final ip = _randomIP();
    final type = _random.nextInt(3);

    if (type == 0) {
      return Question(
        questionText: "What is the Network ID of $ip with /$cidr?",
        correctAnswer: _networkID(ip, cidr),
      );
    } else if (type == 1) {
      return Question(
        questionText: "What is the Broadcast address of $ip with /$cidr?",
        correctAnswer: _broadcast(ip, cidr),
      );
    } else {
      final ip2 = _randomIP();
      return Question(
        questionText: "Are $ip and $ip2 on the same network with /$cidr?",
        correctAnswer: _sameNetwork(ip, ip2, cidr) ? "Yes" : "No",
      );
    }
  }

  static String _randomIP() {
    return "${_random.nextInt(223)}.${_random.nextInt(256)}.${_random.nextInt(256)}.${_random.nextInt(256)}";
  }

  static List<int> _ipToIntList(String ip) => ip.split('.').map(int.parse).toList();

  static int _cidrToMask(int cidr) => 0xFFFFFFFF << (32 - cidr);

  static String _networkID(String ip, int cidr) {
    int ipNum = _ipToInt(_ipToIntList(ip));
    int mask = _cidrToMask(cidr);
    int netID = ipNum & mask;
    return _intToIP(netID);
  }

  static String _broadcast(String ip, int cidr) {
    int ipNum = _ipToInt(_ipToIntList(ip));
    int mask = _cidrToMask(cidr);
    int broadcast = ipNum | (~mask & 0xFFFFFFFF);
    return _intToIP(broadcast);
  }

  static bool _sameNetwork(String ip1, String ip2, int cidr) {
    int mask = _cidrToMask(cidr);
    return (_ipToInt(_ipToIntList(ip1)) & mask) == (_ipToInt(_ipToIntList(ip2)) & mask);
  }

  static int _ipToInt(List<int> bytes) {
    return (bytes[0] << 24) | (bytes[1] << 16) | (bytes[2] << 8) | bytes[3];
  }

  static String _intToIP(int num) {
    return "${(num >> 24) & 0xFF}.${(num >> 16) & 0xFF}.${(num >> 8) & 0xFF}.${num & 0xFF}";
  }
}