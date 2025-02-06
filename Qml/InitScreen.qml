import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    width: parent.width
    height: parent.height

    // Define a signal for the click event
    signal clicked()

    Button {
        text: "Continue"
        anchors.centerIn: parent
        onClicked: root.clicked()
    }

    Text{

    }
}
