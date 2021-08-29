# NvTooling

An assortment of useful classes used for development at NonVanilla.

## SuccessOrFailure
`SuccessOrFailure` is a way to get rid of your exceptions and force yourself to handle the error case whenever you want to access the date inside this class. Especially when making API calls it is very easy to forget to handle certain exceptions. This class won't let you do that.

There are two methods that return `SuccessOrFailure`. `successOf` and `failureOf` which create a `SuccessOrFailure` instance with either a `Success` or `Failure` object.


It then also provides an `access(...)` method which takes two callbacks for both scenarios (`Success` and `Failure`). 

The additional `map(...)` method allows mutating the `SuccessOrFailure` class easily without having to handle both scenarios.

```
// The types are quite long this way so creating typedefs can make them more readable
typedef AsyncObjectOrFreezedFailure = Future<SuccessOrFailure<SomeObject, FreezedErrorUnion>>;

// Let's pretend we are doing some remote work here
AsyncObjectOrFreezedFailure getObjectFromServer() async => successOf(SomeObject());

final SuccessOrFailure<SomeObject, FreezedErrorUnion> myObjects = await getObjectFromServer successOf(true);

// Notice that this changes the type
final newMyObjects = myObjects.map(failure: (failure) => 'Something went wrong'); 

// And the finally inside your widget, access your data (and handle the error case).
Text(
    newMyObjects.access(
        (myObject) => myObject.toString(), 
        (failure) => failure,
    );
)
```

## Selection/OptionalSelection

This type keeps all the options as well as the selected option in one place. If you have a list of Strings and want your user to select one it is sometimes the case, that you need to know both the selected option as well as all the available ones. 

`OptionalSelection` allows for the selection to be null while `Selection` makes sure there is always one item selected.

```
final selection = Selection(
    options: ['Hello', 'my', 'friend'], 
    selected: 'my',
);
```

## Iterable extensions
### mapGrouped
Groups elements together according to the `groupBy` callback and then applies the `groupBuilder`method to each individual group.

```
final names = ['Alex', 'Anna', 'Bill', 'Benny'];
final namesGrouped = Map.fromEntries(
    names.mapGrouped(
        groupBy: (name) => name[0], 
        groupBuilder: (key, values) => MapEntry(key, values),
    ),
);

print(namesGrouped);

// Output: 
// { 'A': ['Alex', 'Anna'], 'B': ['Bill', 'Benny'] }
```

### mapIndexed
Gives you access to the index of the element while mapping.

```
final names = ['Alex', 'Anna', 'Bill', 'Benny'];
final namesWithIndex = names.mapIndexed(
    (index, element) => '$index: $element',      
);

print(namesWithIndex);

// Output: 
// ['0: Alex', '1: Anna', '2: Bill', '3: Benny']
```

### separatedBy 
`separatedBy` inserts the supplied element in between every two elements in the iterable.


```
final names = ['Alex', 'Anna', 'Bill''];
final namesWithJolo = names.separatedBy('Jolo');

print(namesWithJolo);

// Output: 
// ['Alex', 'Jolo', 'Anna', 'Jolo', 'Bill']
```

