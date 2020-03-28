import 'dart:convert';
import 'dart:io';

import '../utils/exception.dart';
import 'en.locale.dart';
import 'locale.dart';

/// Provides locale data for the package.
abstract class LocaleProvider {
    /// Load data for [localeName] into memory.
    void load(String localeName);
    /// Get the data for [localeName]. If such data isn't loaded, an exception is thrown.
    Locale call(String localeName);
    /// Get the data for [localeName]. If such data isn't loaded, null is returned.
    Locale? operator [](String localeName);

    /// The currently registered locale provider list. When calling [LocaleProvider.loadAll], the function will
    /// go through this list and loads data of the locale one by one.
    static final Set<LocaleProvider> providerList = {DefaultLocaleProvider()};

    /// Register a locale provider to the list of providers.
    static void register(LocaleProvider provider) {
        providerList.add(provider);
    }

    /// Load locale info for [localeName] from all providers.
    static void loadAll(String localeName) async {
        return await Future.forEach<LocaleProvider>(providerList, (provider) async => await provider.load(localeName));
    }

    /// All [LocaleProvider] are assumed to be singletons. This equality relation ensures that only unique [LocaleProvider]s are registered.
    @override operator ==(covariant LocaleProvider other) => this.runtimeType == other.runtimeType;
}

/// This is the default locale provider for all generic and Gregorian-calendar based data.
class DefaultLocaleProvider implements LocaleProvider {
    static final DefaultLocaleProvider _singleton = DefaultLocaleProvider._internal();
    factory DefaultLocaleProvider() => _singleton;
    DefaultLocaleProvider._internal();

    String? _dataPath;

    final Map<String, Locale> data = {'en': en};

    /// Set the path of data on disk. Without having called this function, all operations inside this class will fail.
    void setDataPath(String dataPath) {
        _dataPath = dataPath;
    }

    @override
    void load(String localeName) async {
        if (data.containsKey(localeName)) return;
        else if (_dataPath == null) throw GeneralException("You haven't indicated a path from which we can load data. Use setDataPath()");

        late final parsedObj;

        try {
            final fp = File("$_dataPath/$localeName.json");
            parsedObj = json.decode(await fp.readAsString());
        } catch (e) {
            if (e is FileSystemException) throw InvalidArgumentException('localeName');
            else if (e is FormatException) throw GeneralException("Data source is not valid JSON file.");
        }

        data[localeName] = Locale.fromJson(parsedObj);
    }

    @override Locale call(String localeName) => data.containsKey(localeName) ? data[localeName] : throw DataNotLoadedException('Locale Data');
    @override Locale? operator [](String localeName) => data.containsKey(localeName) ? data[localeName] : null;
}