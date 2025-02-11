import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import QtQuick.Layouts
import QtCore // For persistent settings

Rectangle {
    id: root
    width: 400
    height: 600
    color: "#f0f0f0"
    radius: 16
    visible: false // Hidden by default, controlled by parent

    signal profileSaved()
    property string filePath;


    // Show this screen only if profile is not completed
    function showIfNeeded() {
        if (!user.done) {
            root.visible = true;
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 25
        width: parent.width * 0.8

        // Avatar Preview
        Rectangle {
            id: avatarFrame
            Layout.alignment: Qt.AlignCenter
            width: 150
            height: 150
            radius: 75
            color: "#ffffff"
            border.color: "#cccccc"
            clip: true

            Image {
                id: avatarImage
                anchors.fill: parent
                anchors.margins: 5
                source: user.avatarPath
                fillMode: Image.PreserveAspectCrop

                layer.enabled: true
            }
        }

        // Change Avatar Button
        Button {
            Layout.alignment: Qt.AlignCenter
            text: "Choose Avatar"
            onClicked: avatarDialog.open()

            background: Rectangle {
                radius: 8
                color: parent.down ? "#e0e0e0" : "#f5f5f5"
            }
        }

        // Username Input
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            Label {
                text: "Username:"
                font.bold: true
                color: "#333"
            }

            TextField {
                id: usernameField
                Layout.fillWidth: true
                text: user.username
                maximumLength: 20
                validator: RegularExpressionValidator {
                    regularExpression: /^[a-zA-Z0-9_\- ]{3,20}$/
                }

                background: Rectangle {
                    radius: 8
                    border.color: "#ccc"
                    color: "#fff"
                }

                onTextChanged: {
                    submitButton.enabled = text.trim() !== user.username
                }
            }
        }

        // Submit Button
        Button {
            id: submitButton
            Layout.fillWidth: true
            text: "Save Profile"
            enabled: false
            onClicked: {
                user.setAvatarPath(filePath)
                user.setUsername(usernameField.text.trim())
                toast.show("Profile updated successfully!")
                root.profileSaved() // Notify parent

                user.setDone()
            }
        }

        // Next Button
        Button {
            Layout.fillWidth: true
            text: "Next"
            onClicked: {
                root.profileSaved() // Notify parent
            }
            background: Rectangle {
                radius: 8
                color: parent.down ? "#d0d0d0" : "#e0e0e0"
            }
        }
    }

    // Image Selection Dialog
    FileDialog {
        id: avatarDialog
        title: "Select Profile Picture"
        nameFilters: ["Image files (*.png *.jpg *.jpeg)"]
        onAccepted: {
            let rawPath = avatarDialog.selectedFile.toString()
             filePath = rawPath
             // user.setAvatarPath(filePath)
            console.log("Selected avatar path:", filePath)

            submitButton.enabled = avatarImage.source !== user.avatarPath
        }
    }

    // Toast Notification System
    Popup {
        id: toast
        width: 200
        height: 40
        x: (parent.width - width) / 2
        y: parent.height - height - 20
        modal: false
        closePolicy: Popup.NoAutoClose

        function show(message, duration = 2000) {
            toastLabel.text = message
            open()
            timer.interval = duration
            timer.start()
        }

        Timer {
            id: timer
            onTriggered: toast.close()
        }

        Label {
            id: toastLabel
            anchors.centerIn: parent
            color: "white"
        }

        background: Rectangle {
            color: "#4CAF50"
            radius: 20
        }
    }
}
