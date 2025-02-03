import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 500
    height: 500
    title: "Random Quote Generator"

    property bool darkMode: false
    color: darkMode ? "#2e2e2e" : "#f0f0f0"

    Text {
        anchors.fill: parent
        color: darkMode ? "#e0e0e0" : "#2e2e2e"
        text: darkMode ? "Dark Mode" : "Light Mode"
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 10
        font.pixelSize: 16
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignTop
        MouseArea {
            anchors.fill: parent
            onClicked: darkMode = !darkMode
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 20
        width: parent.width * 0.9

        Text {
            id: quoteText
            width: parent.width
            color: darkMode ? "#d34c4c" : "#3553e8"
            text: "Click the button for a quote!"
            font.pixelSize: 18
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
        }

        Button {
            text: "Generate Quote"
            width: parent.width * 0.6
            height: 50
            font.pixelSize: 16
            anchors.horizontalCenter: parent.horizontalCenter
            background: Rectangle {
                color: darkMode ? "#d34c4c" : "#4CAF50"
                radius: 10
                border.color: darkMode ? "#ffffff" : "#2e2e2e"
            }
            onClicked: {
                // Implement quote generation logic here
                quoteText.text = quotesLoader.randomQuote;
            }
        }

        Slider {
            width: parent.width * 0.8
            anchors.horizontalCenter: parent.horizontalCenter
            from: 12
            to: 36
            value: 18
            onValueChanged: quoteText.font.pixelSize = value
        }
    }
}
