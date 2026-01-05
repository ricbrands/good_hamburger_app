import 'package:get_it/get_it.dart';
import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/orders/orders_bloc.dart';
import '../../repositories/order_repository.dart';
import '../../repositories/order_repository_impl.dart';

/// Global service locator instance
final GetIt sl = GetIt.instance;

/// Initializes all dependencies
Future<void> initDependencies() async {
  // Repositories
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(),
  );

  // BLoCs
  sl.registerFactory<CartBloc>(
    () => CartBloc(),
  );

  sl.registerFactory<OrdersBloc>(
    () => OrdersBloc(orderRepository: sl<OrderRepository>()),
  );
}

/// Resets all registered dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
}
