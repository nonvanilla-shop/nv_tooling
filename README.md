# NvTooling

An assortment of useful classes used for development at NonVanilla.

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
final names = ['Alex', 'Anna', 'Bill'];
final namesWithJolo = names.separatedBy('Jolo');

print(namesWithJolo);

// Output: 
// ['Alex', 'Jolo', 'Anna', 'Jolo', 'Bill']
```

