class Petal {
  final String image;
  double top;
  double left;
  final double size;
  final double speed;
  final double rotationSpeed;
  double rotation = 0;
  final double horizontalSway;

  Petal({
    required this.image,
    required this.top,
    required this.left,
    required this.size,
    required this.speed,
    required this.rotationSpeed,
    required this.horizontalSway,
  });
}
