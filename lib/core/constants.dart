// ignore_for_file: constant_identifier_names

/// URL to our database
String realtimeDatabaseUrl =
    'https://bitebuddy-55c4d-default-rtdb.europe-west1.firebasedatabase.app/items.json';

/// Message used when the user input is not suitable
const INVALID_INPUT_FAILURE_MESSAGE = "Name of the item should not be empty.";

/// Message used in case of server failures
const SERVER_FAILURE_MESSAGE = "Server failure.";

/// Message used when attempting to delete an item that is not found in the shopping list
const ITEM_NOT_FOUND_FAILURE_MESSAGE = "The item was not found in the list.";
