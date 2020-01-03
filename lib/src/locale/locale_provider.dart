import 'dart:io';
import 'dart:convert';

import 'package:clockwork/src/locale/en.locale.dart';
import 'package:clockwork/src/locale/locale.dart';
import 'package:clockwork/src/utils/exception.dart';

/// Provides locale data for the package.
abstract class LocaleProvider {
    /// Load data for [localeName] into memory.
    void load(String localeName);
    /// Get the data for [localeName]. If such data isn't loaded, an exception is thrown.
    Locale call(String localeName);
    /// Get the data for [localeName]. If such data isn't loaded, [null] is returned.
    Locale operator [](String localeName);
}

class DefaultLocaleProvider implements LocaleProvider {
    static final DefaultLocaleProvider _singleton = DefaultLocaleProvider._internal();
    factory DefaultLocaleProvider() => _singleton;
    DefaultLocaleProvider._internal();

    final Map<String, Locale> data = {'en': en};

    String? _dataPath;

    /// Set the path of data on disk. Without having called this function, all operations inside this class will fail.
    void setDataPath(String dataPath) {
        _dataPath = dataPath;
    }

    void load(String localeName) async {
        if (data.containsKey(localeName)) return;
        else if (_dataPath == null) throw GeneralException("You haven't indicated a path from which we can load data. Use setDataPath()");

        late final parsedObj;

        try {
            final fp = File("${_dataPath}/$localeName.json");
            parsedObj = json.decode(await fp.readAsString());
        } catch (e) {
            if (e is FileSystemException) throw InvalidArgumentException('localeName');
            else if (e is FormatException) throw GeneralException("Data source is not valid JSON file.");
        }

        data[localeName] = Locale.fromJson(parsedObj);
    }

    Locale call(String localeName) => data.containsKey(localeName) ? data[localeName] : throw DataNotLoadedException('Locale Data');
    Locale operator [](String localeName) => data.containsKey(localeName) ? data[localeName] : null;
}