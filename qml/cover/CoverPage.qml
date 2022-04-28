import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

CoverBackground {

    Image {
            id: cargoCover
            anchors.fill: parent
            source: "../../res/images/harbour-cargo-cover" +  ( Theme.colorScheme ? "-light" : "-dark" ) + ".png"
            fillMode: Image.PreserveAspectFit
            clip: true
            opacity: 0.7
        }
}
