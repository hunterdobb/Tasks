//
//  TasksApp.swift
//  Tasks
//
//  Created by Hunter Dobbelmann on 11/15/20.
//

import SwiftUI

@main
struct TasksApp: App {
    #if os(iOS)
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif

    @StateObject var dataController: DataController
	@StateObject var unlockManager: UnlockManager

    init() {
        let dataController = DataController()
		let unlockManager = UnlockManager(dataController: dataController)

        _dataController = StateObject(wrappedValue: dataController)
		_unlockManager = StateObject(wrappedValue: unlockManager)

		// Set a username in the simulator to prevent using SIWA (Sign in with Apple)
		#if targetEnvironment(simulator)
        // Force a specific username because Sign In With Apple doesn't work in the simulator.
		UserDefaults.standard.set("Hunter", forKey: "username")
		#endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
				.environmentObject(unlockManager)
                .onReceive(
					// Automatically save when we detect that we are no longer
					// the foreground app. Use this rather than the scene phase
					// API so we can port to macOS, where scene phase won't detect
					// our app losing focus as of macOS 11.1.
					NotificationCenter.default.publisher(
                        for: .willResignActive),
					perform: save
				)
				.onAppear(perform: dataController.appLaunched)
        }
    }

    func save(_ note: Notification) {
        dataController.save()
    }
}
