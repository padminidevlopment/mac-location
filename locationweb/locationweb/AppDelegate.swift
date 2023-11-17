//
//  AppDelegate.swift
//  locationweb
//
//  Created by Raghav Naphade on 13/11/23.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let locationManager = LocationManager()


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        locationManager.startUpdatingLocation()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

