import QtQuick
import QtQuick.Controls 2.15

ApplicationWindow {
    id: mainwindow
    width: 600
    height: 500
    visible: true
    title: qsTr("QuoteGenerator")

    InitScreen {
        id: initview
        anchors.fill: parent
        onProfileSaved: {
            initview.visible = false
            quoteview.visible = true
        }

        Component.onCompleted: {
            initview.showIfNeeded() // Show only if profile is not completed
        }
    }

    QuoteView {
        id: quoteview
        anchors.fill: parent
        visible: !initview.visible // Show only if initview is hidden
        // Button to show profile setup again (for testing/demo purposes)
        Button {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Show Profile Setup"
            onClicked: {
                initview.visible = true
                quoteview.visible = false
            }
        }
    }


}
