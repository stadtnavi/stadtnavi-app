import 'pattern.dart';
import 'stoptime.dart';

class StoptimesInPattern {
  final PatternOtp? pattern;
  final List<StoptimeOtp>? stoptimes;

  const StoptimesInPattern({
    this.pattern,
    this.stoptimes,
  });

  factory StoptimesInPattern.fromJson(Map<String, dynamic> json) =>
      StoptimesInPattern(
        pattern: json['pattern'] != null
            ? PatternOtp.fromJson(json['pattern'] as Map<String, dynamic>)
            : null,
        stoptimes: json['stoptimes'] != null
            ? List<StoptimeOtp>.from((json["stoptimes"] as List<dynamic>).map(
                (x) => StoptimeOtp.fromJson(x as Map<String, dynamic>),
              ))
            : null,
      );

  // Map<String, dynamic> toJson() => {
  //       'pattern': pattern?.toJson(),
  //       'stoptimes': List.generate(
  //           stoptimes?.length ?? 0, (index) => stoptimes[index].toJson()),
  //     };
}
