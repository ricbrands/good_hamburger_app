/// Base exception class for all app-specific exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Exception thrown when storage operations fail
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code = 'STORAGE_ERROR',
    super.originalError,
  });

  factory StorageException.readFailed({dynamic originalError}) =>
      StorageException(
        message: 'Failed to read data from storage',
        code: 'STORAGE_READ_ERROR',
        originalError: originalError,
      );

  factory StorageException.writeFailed({dynamic originalError}) =>
      StorageException(
        message: 'Failed to write data to storage',
        code: 'STORAGE_WRITE_ERROR',
        originalError: originalError,
      );

  factory StorageException.deleteFailed({dynamic originalError}) =>
      StorageException(
        message: 'Failed to delete data from storage',
        code: 'STORAGE_DELETE_ERROR',
        originalError: originalError,
      );
}

/// Exception thrown when order operations fail
class OrderException extends AppException {
  const OrderException({
    required super.message,
    super.code = 'ORDER_ERROR',
    super.originalError,
  });

  factory OrderException.placementFailed({dynamic originalError}) =>
      OrderException(
        message: 'Failed to place order',
        code: 'ORDER_PLACEMENT_ERROR',
        originalError: originalError,
      );

  factory OrderException.loadFailed({dynamic originalError}) =>
      OrderException(
        message: 'Failed to load orders',
        code: 'ORDER_LOAD_ERROR',
        originalError: originalError,
      );

  factory OrderException.emptyCart() =>
      const OrderException(
        message: 'Cannot place order with empty cart',
        code: 'ORDER_EMPTY_CART',
      );

  factory OrderException.invalidData({String? details}) =>
      OrderException(
        message: 'Invalid order data${details != null ? ': $details' : ''}',
        code: 'ORDER_INVALID_DATA',
      );
}

/// Exception thrown when cart operations fail
class CartException extends AppException {
  const CartException({
    required super.message,
    super.code = 'CART_ERROR',
    super.originalError,
  });

  factory CartException.itemNotFound(String itemId) =>
      CartException(
        message: 'Item not found in cart: $itemId',
        code: 'CART_ITEM_NOT_FOUND',
      );

  factory CartException.invalidQuantity() =>
      const CartException(
        message: 'Invalid quantity specified',
        code: 'CART_INVALID_QUANTITY',
      );
}

/// Result type for operations that can fail
class Result<T> {
  final T? data;
  final AppException? error;

  const Result._({this.data, this.error});

  factory Result.success(T data) => Result._(data: data);
  factory Result.failure(AppException error) => Result._(error: error);

  bool get isSuccess => error == null;
  bool get isFailure => error != null;

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppException error) onFailure,
  }) {
    if (isSuccess) {
      return onSuccess(data as T);
    } else {
      return onFailure(error!);
    }
  }
}
