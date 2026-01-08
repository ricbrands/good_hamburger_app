import 'package:get_it/get_it.dart';
import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/orders/orders_bloc.dart';
import '../../repositories/order_repository.dart';
import '../../repositories/order_repository_impl.dart';

/// Global service locator instance
final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(),
  );

  sl.registerFactory<CartBloc>(
    () => CartBloc(),
  );

  sl.registerFactory<OrdersBloc>(
    () => OrdersBloc(orderRepository: sl<OrderRepository>()),
  );
}

Future<void> resetDependencies() async {
  await sl.reset();
}
