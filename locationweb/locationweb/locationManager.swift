//
//  locationManager.swift
//  locationweb
//
//  Created by Raghav Naphade on 13/11/23.
//
//
//  locationManager.swift
//  itplocation
//
//  Created by Raghav Naphade on 09/11/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager
    private var hasPrintedLocation = false
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.startUpdatingLocation()
        } else {
            print("Location services are disabled.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         if !hasPrintedLocation, let firstLocation = locations.first {
             let latitude = firstLocation.coordinate.latitude
             let longitude = firstLocation.coordinate.longitude
             print("Latitude: \(latitude), Longitude: \(longitude)")
             createLocationInfoFolder(latitude: Float(latitude), longitude: Float(longitude))
             saveLocationData(latitude: Double(latitude), longitude: Double(longitude))
             hasPrintedLocation = true
         }
     }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Location manager auth status changed to: ")
        switch status {
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedWhenInUse, .authorizedAlways:
            print("authorized")
        case .notDetermined:
            print("not yet determined")
        default:
            print("Unknown")
        }
    }
}
func getLibraryPath() -> String {
    let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
    let libraryPath = homeDirectory.appendingPathComponent("Library").path
    var newPath = libraryPath
    if let range = libraryPath.range(of: "/Containers") {
        let desiredPath = libraryPath[..<range.lowerBound]
        print(desiredPath)
        newPath = String(desiredPath)
    } else {
        print("The path does not contain '/Containers'")
        
    }
    return newPath
}
struct LocationData: Codable {
    var latitude: Double
    var longitude: Double
}
func saveLocationData(latitude: Double, longitude: Double) {
    let fileManager = FileManager.default

    do {
        // Get the app's Application Support directory
        let appSupportURL = try fileManager.url(for: .applicationSupportDirectory,
                                                in: .userDomainMask,
                                                appropriateFor: nil,
                                                create: true)

        // Append your folder name to the Application Support directory
        let folderName = "locationPoc" // Replace with your desired folder name
        let folderURL = appSupportURL.appendingPathComponent(folderName)

        // Check if the folder already exists
        if !fileManager.fileExists(atPath: folderURL.path) {
            // Create the folder if it doesn't exist
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            print("Folder created at: \(folderURL.path)")
        } else {
            print("Folder already exists at: \(folderURL.path)")
        }

        // Create file URL for the JSON file
        let jsonFileURL = folderURL.appendingPathComponent("locationPocData.json")

        var existingLocationData: LocationData?

        // Check if the JSON file already exists
        if fileManager.fileExists(atPath: jsonFileURL.path) {
            // Read existing JSON data
            let jsonData = try Data(contentsOf: jsonFileURL)
            existingLocationData = try JSONDecoder().decode(LocationData.self, from: jsonData)

            // Print existing data
            if let existingData = existingLocationData {
                print("Existing Location Data - Latitude: \(existingData.latitude), Longitude: \(existingData.longitude)")
            }
        }

        // Update or create location data
        let newLocationData: LocationData
        if let existingData = existingLocationData {
            // Update existing data with new latitude and longitude
            newLocationData = LocationData(latitude: latitude, longitude: longitude)
        } else {
            // Create new location data if no existing data
            newLocationData = LocationData(latitude: latitude, longitude: longitude)
        }

        // Encode location data to JSON
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(newLocationData)

        // Write JSON data to the file
        try jsonData.write(to: jsonFileURL)

        print("Location data saved to: \(jsonFileURL.path)")

    } catch {
        print("Error creating/saving location data: \(error.localizedDescription)")
    }
}
func createLocationInfoFolder(latitude: Float, longitude: Float) {
    do {
        let libraryPath = getLibraryPath()
        print("Library Path:", libraryPath);
        
        let baseFolderPath = "\(libraryPath)/Documents/"
        let newFolderName = "locationPoc"
        
        let newFolderPath = baseFolderPath + newFolderName
        print("newFolderPath:", newFolderPath);
        // Get the home directory for the current user
        
        
        // Specify the folder name
        
        
        // Create the full path for the folder inside the Documents directory
        let fileManager = FileManager.default
        
        // Check if the folder already exists
        if !fileManager.fileExists(atPath: newFolderPath) {
            do {
                try fileManager.createDirectory(atPath: newFolderPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating directory: \(error.localizedDescription)")
            }
        }
        
        // Create JSON data with parameters
        //        let jsonData: [String: Any] = [
        //            "latitude": latitude,
        //            "longitude": longitude
        //        ]
        //
        //        // Convert JSON data to Data
        //        let data = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
        //
        //        // Specify the file URL for the JSON file
        //        let jsonFileURL = folderURL.appendingPathComponent("dataLocation.json")
        //
        //        // Check if the file already exists
        //        if !FileManager.default.fileExists(atPath: jsonFileURL.path) {
        //            // Write the JSON data to the file
        //            try data.write(to: jsonFileURL)
        //            print("JSON file created successfully at path: \(jsonFileURL.path)")
        //        } else {
        //            try data.write(to: jsonFileURL)
        //            print("JSON file already exists at path: \(jsonFileURL.path)")
        //        }
        //    } catch {
        //        print("Error creating folder or JSON file: \(error.localizedDescription)")
        //    }
    }
}
