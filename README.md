# BiteBuddy

## Goal
BiteBuddy is a shopping list app focused on helping families coordinate their shopping lists. The secondary goal for BiteBuddy is to help improve consumption habits by offering healthier and lower carbon footprint alternatives.

## Architecture
BiteBuddy runs on Flutter & uses Firebase Realtime Database as its database. State management is done by Bloc.  
One of the goals for BiteBuddy is to follow best practices and clean architecture as much as reasonably possible.

## Guides  
### Tests
Generate mocks by running the command:
```
flutter pub run build_runner build
```

Run test from the command line with
```
flutter test
```


## Notes
### Scope
- Offline usage not supported
- Authentication not implemented
- Limited widget testing
- 1 integration test only 
- Unit testing could be more thorough
### Weak spots/areas to look for errors
- Handling of streams in bloc & testing them