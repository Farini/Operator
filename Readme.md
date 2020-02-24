#  Operator

This is an app that shows the progress of simulated operations run by a javascript file source.

## Single View

One View Controller **SJSController** is the single view controller and manages a stack of views that represent each operation.

## Messages

Each message captured is displayed in **MessageView**, using the **Message** model both to initialize and update the view.

## Logic

As described in the url provided for this exercise:

> "The app should download the javascript file, evaluate it, and call startOperation multiple times. This should happen such that multiple operations are "running" at the same time."

1. From **ViewDidLoad** I get the source code, evaluate it, load an html file in the **WKWebView** as a sample webpage and start calling **startOperations()**
2. Every time the jsscript posts a message, I use a loop to check if each operation has started (and therefore create a new **MessageView**), or if it is under progress, in which case I use a **UIProgressView** to display the progress, and finally, when the operation is completed, I add an emoji.

        ✅ means the operation has completed with a 'success' message
        
        ⚠️ means the operation has completed with an 'error' message
    

This is where I call the **startOperation(id)** method

```
    for i in 1...12 {
        let id = "A\(i)"
        jsWebView.evaluateJavaScript("startOperation('\(id)')", completionHandler: nil)
    }
```
    
I chose 12 as the number of concurrent operations, but it can be changed. If creating too many more operations, one would have to embed the vertical **UIStackView** in a **UIScrollView**, in order to see more views.
