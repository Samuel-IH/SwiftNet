# SwiftNet

A small library to help you embed asynchronous content beutifully in SwiftUI.


## Use
SNet is currently focused around one View:
`SNetContent`
This is used to wrap any remote content calls on the background thread and give your starting content a default value.

For example:
```swift
SNetContent(initialView: {
                Image("loading")
            }, request: {
                 sleep(3)
                 return UIImage(systemName: "tortoise")!
            }) { img in
                 Image(uiImage: img!)
            }
```

The SNetContent initializer has three properties:

- **The initial view**, what is rendered _before_ the remote content is loaded.
- **The request**, the async code to be ran on appear (is automatically run on the background thread).
- **The 'final' view**, what is rendered _after_ the remote call completes.

SNet also provides the `SNetMicroContent` class, which wraps the existing `SNetContent` but provides an input value that conforms to the _generic type_ of the request's output:

```swift
SNetMicroContent(initialValue: UIImage(systemName: "pencil.and.outline")!, request: {
    sleep(3)
    return UIImage(systemName: "tortoise")!
}) { img in
    Image(uiImage: img)
}
```

Finally, SNet also provides `SNetImage` and `SNetActivityIndicator`. They both work, but aren't too customizable (_yet_) :

```swift
SNetImage(url: URL.init(string: "https://www.locationOfMyImage.com/image.png")!)
    .scaledToFit()
    .frame(width: 300)
    .animation(.easeIn)
```

```swift
ActivityIndicator(isAnimating: .constant(true), style: .large)
```


## Animation
All SNet async views can be animated, simply add the animation modifier:
```swift
.animation(.easeIn)
```
