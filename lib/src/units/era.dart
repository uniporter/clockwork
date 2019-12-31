import 'package:clockwork/src/utils/exception.dart';

enum Era {
    AD, BC
}

extension EraExtension on Era {
    String toName() {
        switch (this) {
            case Era.AD: return "A.D.";
            case Era.BC: return 'B.C.';
            default: throw CriticalErrorException();
        }
    }
}