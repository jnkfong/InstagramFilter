# Instagram Filter
Image and video instagram filter

<img src="https://github.com/jnkfong/InstagramFilter/blob/master/img/a.jpg" width="20%"> <img src="https://github.com/jnkfong/InstagramFilter/blob/master/img/b.jpg" width="20%"> <img src="https://github.com/jnkfong/InstagramFilter/blob/master/img/c.jpg" width="20%"> <img src="https://github.com/jnkfong/InstagramFilter/blob/master/img/d.jpg" width="20%">

## Description
Instagram filter is a practice project to simulate the instagram filter for both videos and images using the inspired [Sharaku](https://github.com/makomori/Sharaku) project and self research on video editing. Feel free to contact me for any additional modifications. There is currently no pod for this project but you can copy the five files under the Filter folder to add into your own project. Any video changes can be modified in the EditVideoUtility swift class.

## Requirements
- Swift4
- iOS 9.0+

## Usage
### How to present image filter viewController
``` Swift
let image = UIImage(image: exampleImage)
let imgViewController = FilterImageViewController(image:image)
imgViewController.delegate = self
self.present(imgViewController, animated: false, completion: nil)

```

### FilterImageViewControllerDelegate methods
``` Swift
extension ViewController: FilterImageViewControllerDelegate {
    func filterImageViewControllerImageDidFilter(image: UIImage) {
      // Filtered image will be returned here.
    }

    func filterImageViewControllerDidCancel() {
      // This will be called when you cancel filtering the image.
    }
}
```
### How to present video filter viewController
``` Swift
let image = UIImage(image: exampleImage)
  let imgViewController = FilterImageViewController(image:image)
  imgViewController.delegate = self
  self.present(imgViewController, animated: false, completion: nil)

```

### FilterVideoViewControllerDelegate methods
``` Swift
extension ViewController: FilterVideoViewControllerDelegate {
    func filterVideoViewControllerVideoDidFilter(video: AVURLAsset) {
      // Filtered video will be returned here.
    }

    func filterVideoViewControllerDidCancel() {
      // This will be called when you cancel filtering the video.
    }
}
```

## License

Instragram Filter is available under the MIT license. See the LICENSE file for more info.
