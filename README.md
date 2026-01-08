# Good Hamburger App

An app for simulating orders, developed in Flutter.

# App features

This application has three main screens:
- Menu screen
The Menu screen displays a list of items, and you can select and add an iten to you cart by clicking on it. You can also filter items by category (Sandwiches or Extras);
- Cart screen
The Cart screen displays a list of selected items, with the subtotal amount, discounts and total amount. It also have a button to the Checkout screen. The Checkout screen have a input to place user name, the order summary and a button to place order;
- Orders screen
The Orders screen displays a list of all orders with the order id, user name, total amount, saved amount and timestamp. It also have a clear history buttom.
<img width="215" height="497" alt="Menu Screen" src="https://github.com/user-attachments/assets/f1e91a65-0190-48e8-a385-be5097f31f08" />
<img width="218" height="494" alt="Cart Screen" src="https://github.com/user-attachments/assets/32673ae1-633a-40e2-9d13-8e06397e039b" />
<img width="218" height="497" alt="Checkout Screen" src="https://github.com/user-attachments/assets/5e2c1013-85cf-4c41-912d-30d448df6af1" />
<img width="218" height="499" alt="Orders Screen" src="https://github.com/user-attachments/assets/a1cd238e-729e-4ddd-9ede-effa7e8336a5" />



# Technologies

This project was developed using Flutter 3.38.5 with Dart 3.10.4. It uses the following packages:
- cupertino_icons: default set of icon assets;
- flutter_bloc: for state management;
- equatable: simplify the process of comparing objects;
- google_fonts: package to use fonts from fonts.google.com;
- get: package for route management;
- get_it: used for service locator;
## State Management
This project uses Bloc library for state management. Bloc is a robust architectural approach and state management library that separates an application's business logic from its UI. It uses a predictable, unidirectional data flow with events as input and states as output, managed via Dart streams. 
There are two Blocs components, one for the Cart logic, and other for the Orders logic. You can find them in the /bloc folder.

# Get Set up

## Install dependencies
If you're new to Flutter the first thing you'll need is to follow the [setup instructions](https://flutter.dev/docs/get-started/install).
Once Flutter is setup, you can run `flutter pub get` to install dependencies listed in pubspec.yaml.
## Run
Use the command `flutter run` to run the application on a connected device, iOS simulator, Android simulator or some browser. For example, run `flutter run -d chrome` to run it on a Chrome browser (if you have one installed).
## Build
You can use the command flutter build <platform> to produce an application to deploy or publish in AppStore, PlaySore, or some other distribuition channels. 
## Test
To execute the unit tests, run the following command `flutter test` in your project's root directory. The command automatically finds and runs all files in the test/ folder.

## Limitations and Improvements
- Data source: since this is just a technical test project, all the items are stored in a JSON file locate at assets/menu_items.json. One suggestion for improvement would be to make a request to a web service that would provide this data dynamically.
- Order storage: Currently, orders are only being saved in memory, meaning that each time the app restarts, the data is lost. As an improvement, the data could be saved locally on the device or sent to be saved via a web service.
