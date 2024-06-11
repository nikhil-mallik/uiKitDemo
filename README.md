# UIKit Demo Project for Learning Purposes

## Overview
This project is a UIKit demo application designed to provide learners with a practical understanding of various UIKit components and architectural patterns. The application covers essential concepts such as user authentication, data fetching, UI updates, and navigation within an iOS app. The app is built using the Model-View-ViewModel (MVVM) architecture to clearly separate concerns and facilitate efficient data binding and user interaction.

## Key Features

1. **User Authentication**
   - **Login**: Users can log in using their credentials. The app includes error handling for invalid login attempts.
   - **Registration**: New users can register by providing their details. The registration process includes validation and error handling.

2. **Data Display**
   - **Browse Data**: Users can browse a list of items (e.g., products). Each item is displayed with its image, title, category, price, and rating.
   - **Item Details**: Users can view detailed information about an item, including a larger image, description, and like/unlike functionality.

3. **User Profile**
   - **Profile Management**: Users can view and manage their profile information, including their name and authentication token.

4. **Logout**
   - **Logout Functionality**: Users can log out to clear their session and redirect them to the login screen.

## Technical Details

- **Architecture**: Model-View-ViewModel (MVVM)
  - **Model**: Represents the data and business logic (e.g., `LoginModel`, `LoginResponseModel`, `RegisterModel`, `UserListModel`, `ProductListModel`).
  - **ViewModel**: Manages the data for the view and handles business logic (e.g., `LoginViewModel`, `RegisterViewModel`, `UserListViewModel`, `ProductListViewModel`, `CollectionViewModel`).
  - **View**: The user interface components (e.g., `LoginViewController`, `RegisterViewController`, `ProductListViewController` etc).

- **Networking**
  - **API Manager**: A singleton class that handles API requests and responses using URLSession. It includes methods for making GET and POST requests and handles common headers and error responses.
  - **Endpoints**: Defined in the `APIEndPoint` enum, which conforms to the `EndPointType` protocol. This includes paths, base URLs, methods, and request bodies for various API calls (e.g., login, register, fetch items, fetch users).

- **UI Components**
  - **Custom Views**: Includes styled text fields and buttons, managed by the `Utility` class for consistent UI styling.
  - **Collection View**: Displays a grid of items with custom sizing and layout.
  - **Table View**: Used for displaying user lists.

- **Data Binding**
  - **Event Handling**: The ViewModels use closures to handle events such as loading, data loaded, errors, and navigation. This allows for reactive updates to the UI based on the state of the data.

## Screens

1. **Login Screen**: Users can enter their email and password to log in.
2. **Registration Screen**: Enables new users to sign up with their details.
3. **Dashboard**: A welcome screen showing the user’s name and options to navigate to item lists or user lists.
4. **Item List Screen**: Displays a list of items with images and basic details.
5. **Item Detail Screen**: Shows detailed information about a selected item, including description and rating.
6. **User List Screen**: Displays a list of users, for administrative purposes.

## Navigation

- **Storyboard-Based**: The app uses storyboards to define UI and screen navigation. Each view controller is instantiated from the storyboard using a shared instance method.

## Error Handling

- **DataError Enum**: Defines various error types that can occur during network operations, such as invalid response, invalid URL, network errors, and decoding errors.

## Extensions

- **UIViewController Extensions**: Provides methods for creating shared instances of view controllers from the storyboard.
- **UICollectionView and UITableView Extensions**: Implements delegate and data source methods for managing collection and table views.

This UIKit demo project aims to deliver a comprehensive learning tool for understanding the essential concepts and best practices in iOS development. Through hands-on implementation, learners will gain valuable experience in building and managing a UIKit-based application.
