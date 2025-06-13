# Contributing to Revent

## Writing Code

Do read: [Dart](https://dart.dev/effective-dart/style) 'Effect Dart: Style' styling

## Folder/Project Structure

- Keep similar files together
- Don't dump everything into one folder, create subfolder if possible

Example:

`/services/notification_service.dart`
`/models/comment_filter.dart`

## Naming

**File** - Must be same with class name & lowercase with underscore for whitespace replacement, for example if class is called `MyClass` then the file must be `my_class.type`

**Class** - Must be UpperCamelCase. Must clarifies it's purpose and not misleading, for example: `UserDataGetter` (OK) `GetStuffForUser` (BAD).

**Function** - Must be lowerCamelCase. Must specify it's sole purpose, for example `getPostName` (OK) `getStuffFromPost` (BAD).

**Variable** - Must be lowerCamelCase. For top-class private variable use `_` prefix before the name, for example: `_myVar`. If variable is within a function then private prefix is not needed.

## Indentation

- Use 2 spaces per indentation level.

Example:

```void func() {
  print("Hello");
}```

- Opening braces go on the same line, nested block must be indented by one level.

Example:

```// OK
if (isActive) {
  doSomething();
} else {
  doSomethingElse();
}

// BAD
if (isActive)
{
doSomething();
}
```

However if the `if` statement has multiples lines within the braces then do add one extra line after it and before the condition is finish, for example:

```// OK
if (condition) {

    //
    //
    //

}

// BAD
if (condition) {
    //
    //
    //
}```

- Align parameters with line if there's multiples of them (More than 1)

Example:

```// OK
void ({
    required String name, 
    required String email
}) {

}

// BAD
void ({required String name, required String email}) {

}```

## Commenting