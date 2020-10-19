---
title: An each_with_index for SwiftUI
date: 2020-10-18 19:52 PDT
tags: SwiftUI
---

Lately I've been learning SwiftUI, which is pretty neat.  I've noticed that when it comes to displaying a list of items: you often want access to the index value as part of your swift|`ForEach`| or swift|`List`| in order to reference a swift|`@Binding`| of the larger collection.

Forums like [Stackoverflow](https://stackoverflow.com) are littered with questions around this issue:  how to cleanly iterate over an Array to use its elements in subviews while maintaining a swift|`Binding`| so any addition or removal from the collection is reflected in the UI.  There's essentially two types of answers:

- Use the swift|`.indices`| attribute of the Array, or use a Range that looks something like swift|`0..<items.count`|.  Then once you're in the loop, create a temporary variable using the index value to hold a reference to the item itself.

- Use the swift|`.enumerated()`| attribute of the Array class to create tuples of the value and index and then enumerate over those tuples.

Both of these are kind of ugly and cumbersome.  I come from a background of loving and using Ruby, where this problem is solved with ruby|`.each_with_index`|, passing both an index and the value into the included closure.

## EnumForEach (and EnumList)

As an exercise to learn about Generics and Closures in Swift, I decided to create a function similar to ruby|`.each_with_index`| to complement swift|`ForEach`| and swift|`List`|.  If we had this rather cumbersome code using swift|`.enumerated()`|:

```swift
ForEach(Array(array.enumerated()), id: \.element) { index, element in
    ...
}
```

With my library function, this can become:

```swift
EnumForEach(array) { index, element in
    ...
}
```

Note that in both of these examples, your elements must implement the protocol swift|`Identifiable`|.  The same transformation can be done with swift|`List`|, by swapping for swift|`EnumList`|.

You can see the code for these functions [here](https://gist.github.com/jubishop/d99715f71f1d44175dc1c9a68986a30b).  I hope others find them useful.  If you have other/better ways of achieving this, please let me know!
