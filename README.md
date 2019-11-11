# MarsRoverGallery

## Installation

First, go to this [link](https://api.nasa.gov/) to generate your own NASA API key. Then, create a new swift file in your project named and the following code to it:

```swift
struct Secrets {
	static let apiKey = "YOUR_API_KEY_HERE"
}
```

## Screenshots

<div align="center">
    <img src="Screenshots/gallery_ipad.png?raw=true" alt="Gallery IPad"> 
    <img src="Screenshots/search_settings_ipad.png?raw=true" alt="Search Settings IPad"> 
    <p align="center">
        <img src="Screenshots/gallery_iphone.png?raw=true" alt="Gallery IPhone" width="250"> 
        <img src="Screenshots/search_settings_iphone.png?raw=true" alt="Search Settings IPhone" width="250">  
    </p>
    <img src="Screenshots/full_screen_landscape_iphone.png?raw=true" alt="Full Screen IPhone"> 
</div>

## App Architecture

For anyone who may be trying to understand the code, it may be helpful to know the basic structure:

The important models are:

- `Photo`: An combination of a rover image + image details. I use "photo" when referring to the image plus image datails and "image" when referring to images on their own
- `Rover`: Details about the rover that took the image.
- `Manifest`: Details how many photos the rover took on each day of its mission.

The central hub is `MainCoordinator.swift`. It controls the navigation to and from the three components:

- Main Gallery: `WaterfallCollectionViewController` configured by `PhotosCollectionViewModel`
- Full Screen Photo: `FullScreenPhotoViewController` configured by `FullScreenPhotoViewModel`
- Search Settings: `SearchSettingsCollectionViewController` configured by `SearchSettingsCollectionViewModel`

`MainCoordinator.swift` injects the three aforementioned components with the following networking dependencies:

- `PaginatedPhotosController`: Mangages the paginated photos query
- `ImageStore`: Stores and fetches photo images
- `ManifestStore`: Stores and fetches rover mission manifests
