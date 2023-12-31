import 'package:get_it/get_it.dart';
import 'defensive.dart';
import 'package:meta/meta.dart';
import 'event_aggregator.dart';
import 'secure_storage.dart';

abstract class ServiceRegistry {
  void registerInstance<T extends Object>(T value);
  void registerSingleton<T extends Object>(T Function() factoryFunc);
  void registerTransient<T extends Object>(T Function() factoryFunc);
  void registerScoped<T extends Object>(T Function() factoryFunc);
}

abstract class _Registration<T extends Object> {
  final Type type = T;

  void register(GetIt getIt);
}

class _InstanceRegistration<T extends Object> extends _Registration<T> {
  final T value;

  _InstanceRegistration(this.value);

  @override
  void register(GetIt getIt) {
    // given(getIt, "getIt").ensureHasValue();
    getIt.registerSingleton<T>(this.value);
  }
}

class _SingletonRegistration<T extends Object> extends _Registration<T> {
  final T Function() factoryFunc;

  _SingletonRegistration(this.factoryFunc);

  @override
  void register(GetIt getIt) {
    // given(getIt, "getIt").ensureHasValue();
    getIt.registerLazySingleton<T>(this.factoryFunc);
  }
}

class _TransientRegistration<T extends Object> extends _Registration<T> {
  final T Function() factoryFunc;

  _TransientRegistration(this.factoryFunc);

  @override
  void register(GetIt getIt) {
    // given(getIt, "getIt").ensureHasValue();
    getIt.registerFactory<T>(this.factoryFunc);
  }
}

class _ScopedRegistration<T extends Object> extends _Registration<T> {
  final T Function() factoryFunc;

  _ScopedRegistration(this.factoryFunc);

  @override
  void register(GetIt getIt) {
    // given(getIt, "getIt").ensureHasValue();
    getIt.registerLazySingleton<T>(this.factoryFunc);
  }
}

class _Container implements ServiceRegistry {
  final instanceRegistrations = <_InstanceRegistration>[];
  final singletonRegistrations = <_SingletonRegistration>[];
  final transientRegistrations = <_TransientRegistration>[];
  final scopedRegistrations = <_ScopedRegistration>[];
  final _types = <Type>[];
  final GetIt _getIt = GetIt.instance;
  bool _isBootstrapped = false;

  @override
  void registerInstance<T extends Object>(T value) {
    // given(value, "value").ensureHasValue();
    given(this, "this")
        .ensure((t) => !t._types.contains(T), "Type $T is already registered")
        .ensure((t) => !t._isBootstrapped, "Already bootstrapped");
    this.instanceRegistrations.add(new _InstanceRegistration<T>(value));
    this._types.add(T);
  }

  @override
  void registerSingleton<T extends Object>(T Function() factoryFunc) {
    // given(factoryFunc, "factoryFunc").ensureHasValue();
    given(this, "this")
        .ensure((t) => !t._types.contains(T), "Type $T is already registered")
        .ensure((t) => !t._isBootstrapped, "Already bootstrapped");
    this.singletonRegistrations.add(new _SingletonRegistration<T>(factoryFunc));
    this._types.add(T);
  }

  @override
  void registerTransient<T extends Object>(T Function() factoryFunc) {
    // given(factoryFunc, "factoryFunc").ensureHasValue();
    given(this, "this")
        .ensure((t) => !t._types.contains(T), "Type $T is already registered")
        .ensure((t) => !t._isBootstrapped, "Already bootstrapped");
    this.transientRegistrations.add(new _TransientRegistration<T>(factoryFunc));
    this._types.add(T);
  }

  @override
  void registerScoped<T extends Object>(T Function() factoryFunc) {
    // given(factoryFunc, "factoryFunc").ensureHasValue();
    given(this, "this")
        .ensure((t) => !t._types.contains(T), "Type $T is already registered")
        .ensure((t) => !t._isBootstrapped, "Already bootstrapped");
    this.scopedRegistrations.add(new _ScopedRegistration<T>(factoryFunc));
    this._types.add(T);
  }

  void bootstrap() {
    given(this, "this")
        .ensure((t) => !t._isBootstrapped, "Already bootstrapped");

    if (!this._types.contains(EventAggregator))
      this.registerSingleton<EventAggregator>(() => FloaterEventAggregator());

    if (!this._types.contains(SecureStorageService))
      this.registerSingleton<SecureStorageService>(
          () => FloaterSecureStorageService());

    this
        .instanceRegistrations
        .forEach((element) => element.register(this._getIt));
    this
        .singletonRegistrations
        .forEach((element) => element.register(this._getIt));
    this
        .transientRegistrations
        .forEach((element) => element.register(this._getIt));
    // Deliberately not doing scoped registrations

    this._isBootstrapped = true;
  }

  _ChildScope createChildScope() {
    given(this, "this").ensure((t) => t._isBootstrapped, "Not bootstrapped");

    return new _ChildScope(this);
  }

  T resolve<T extends Object>() {
    given(this, "this").ensure((t) => t._isBootstrapped, "Not bootstrapped");

    return this._getIt.get();
  }
}

@sealed
class ServiceLocator {
  static final _instance = new ServiceLocator._private();

  static ServiceLocator get instance => _instance;

  ServiceLocator._private();

  T resolve<T extends Object>() {
    return ServiceManager.instance._resolve();
  }
}

abstract class Disposable {
  void dispose();
}

class _ChildScope implements ServiceLocator, Disposable {
  final _Container _parentScope;
  final GetIt _getIt = GetIt.asNewInstance();
  final _instances = <Disposable>[];
  var _isDisposed = false;

  _ChildScope(_Container parentScope) : this._parentScope = parentScope {
    this
        ._parentScope
        .scopedRegistrations
        .forEach((element) => element.register(this._getIt));
  }

  @override
  T resolve<T extends Object>() {
    if (this._isDisposed) throw new Exception("Object disposed");

    if (this
        ._parentScope
        .scopedRegistrations
        .any((element) => element.type == T)) {
      final instance = this._getIt.get<T>();
      if (instance is Disposable && !this._instances.contains(instance))
        this._instances.add(instance);
      return instance;
    } else
      return this._parentScope.resolve();
  }

  @override
  void dispose() {
    if (this._isDisposed) throw new Exception("Object disposed");
    this._getIt.reset();
    this._instances.forEach((instance) => instance.dispose());
    this._isDisposed = true;
  }
}

abstract class ServiceInstaller {
  void install(ServiceRegistry registry);
}

@sealed
class ServiceManager {
  static final _Container _container = new _Container();
  static final _instance = new ServiceManager._private();
  static var _isBootstrapped = false;

  static ServiceManager get instance => _instance;

  ServiceManager._private();

  void useInstaller(ServiceInstaller installer) {
    // given(installer, "installer").ensureHasValue();

    if (_isBootstrapped) throw new StateError("Already bootstrapped");

    installer.install(_container);
  }

  void bootstrap() {
    if (_isBootstrapped) throw new StateError("Already bootstrapped");

    _container.bootstrap();
    _isBootstrapped = true;
  }

  T _resolve<T extends Object>() {
    if (!_isBootstrapped) throw new StateError("Not bootstrapped");

    return _container.resolve();
  }

  ServiceLocator createScope() {
    if (!_isBootstrapped) throw new StateError("Not bootstrapped");

    return _container.createChildScope();
  }
}
