import QtQuick 2.0
import Sailfish.Silica 1.0



CoverBackground {

    Image {
            id: cargoCover
            anchors.fill: parent
            source: "../../res/images/harbour-cargo-cover.png"
            fillMode: Image.PreserveAspectFit
            clip: true
            opacity: 0.8
        }

}
