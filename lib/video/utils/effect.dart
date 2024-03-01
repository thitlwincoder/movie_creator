class Effect {
  Effect(this.type, {this.time, this.delay});

  static Effect zoomIn = Effect("zoompan=z='min(zoom+0.002,1.5)'");

  static Effect shake = Effect(
      "zoompan=z='if(lte(mod(t,2),1),1.5+zoom/1.5,max(1.5-zoom/1.5,1.5))");

  final String type;
  final int? time;
  final int? delay;
}
