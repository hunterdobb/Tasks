//
//  EditProjectView.swift
//  Tasks
//
//  Created by Hunter Dobbelmann on 11/21/20.
//

import CloudKit
import CoreHaptics
import SwiftUI

struct EditProjectView: View {
    @ObservedObject var project: Project

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var detail: String
    @State private var color: String

    @State private var showingDeleteConfirm = false
	@State private var showingNotificationsErrors = false

	@State private var remindMe: Bool
	@State private var reminderTime: Date

	@State private var engine = try? CHHapticEngine()

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(project: Project) {
        self.project = project

        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)

		if let projectReminderTime = project.reminderTime {
			_reminderTime = State(wrappedValue: projectReminderTime)
			_remindMe = State(wrappedValue: true)
		} else {
			_reminderTime = State(wrappedValue: Date())
			_remindMe = State(wrappedValue: false)
		}
    }

    var body: some View {
        Form {
            Section(header: Text("Basic Settings")) {
                TextField("Project Name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
            }

            Section(header: Text("Custom Project Color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            }

			Section(header: Text("Project Reminder")) {
				Toggle("Show reminders", isOn: $remindMe.animation().onChange(update))
					.alert(isPresented: $showingNotificationsErrors) {
						Alert(
							title: Text("Oops!"),
							message: Text("There was a problem. Please check you have notifications enabled."),
							primaryButton: .default(Text("Open Settings"), action: showAppSettings),
							secondaryButton: .cancel()
						)
					}

				if remindMe {
					DatePicker(
						"Reminder time",
						selection: $reminderTime.onChange(update),
						displayedComponents: .hourAndMinute
					)
				}
			}

			// swiftlint:disable:next line_length
            Section(footer: Text("Closing a project moves it from the Open tab to the Closed tab. Deleting a project removes it entirely.")) {
				Button(project.closed ? "Reopen This Project" : "Close This Project", action: toggleClosed)

                Button("Delete This Project") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
        }
        .navigationTitle("Edit Project")
		.toolbar {
			Button {
				let records = project.prepareCloudRecords()
				let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
				operation.savePolicy = .allKeys

				operation.modifyRecordsCompletionBlock = { _, _, error in
					if let error = error {
						print("Error: \(error.localizedDescription)")
					}
				}

				CKContainer.default().publicCloudDatabase.add(operation)
			} label: {
				Label("Upload to iCloud", systemImage: "icloud.and.arrow.up")
			}
		}
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(
				title: Text("Delete Project?"),
				message: Text("Are you sure you want to delete this project? You will also delete all the items it contains."), // swiftlint:disable:this line_length
				primaryButton: .destructive(Text("Delete"), action: delete),
				secondaryButton: .cancel())
        }
    }

    func update() {
        project.title = title
        project.detail = detail
        project.color = color

		if remindMe {
			project.reminderTime = reminderTime

			dataController.addReminders(for: project) { success in
				if success == false {
					project.reminderTime = nil
					remindMe = false

					showingNotificationsErrors = true
				}
			}
		} else {
			project.reminderTime = nil
			dataController.removeReminders(for: project)
		}
    }

    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }

	func toggleClosed() {
		project.closed.toggle()

		if project.closed {
			do {
				try engine?.start()

				let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
				let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)

				let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
				let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)

				let parameter = CHHapticParameterCurve(
					parameterID: .hapticIntensityControl,
					controlPoints: [start, end],
					relativeTime: 0
				)

				let event1 = CHHapticEvent(
					eventType: .hapticTransient,
					parameters: [intensity, sharpness],
					relativeTime: 0
				)

				let event2 = CHHapticEvent(
					eventType: .hapticContinuous,
					parameters: [sharpness, intensity],
					relativeTime: 0.125,
					duration: 1
				)

				let pattern = try CHHapticPattern(events: [event1, event2], parameterCurves: [parameter])

				let player = try engine?.makePlayer(with: pattern)
				try player?.start(atTime: 0)
			} catch {
				// haptics didn't work
			}
		}
	}

    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color
                ? [.isButton, .isSelected]
                : .isButton
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }

	func showAppSettings() {
		guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
			return
		}

		if UIApplication.shared.canOpenURL(settingsURL) {
			UIApplication.shared.open(settingsURL)
		}
	}
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
//            .previewDevice("iPhone 12")
    }
}
