/*
    Copyright (C) 2018 Michał Szczepaniak
    This file is part of Morsender.
    Morsender is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Morsender is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with Morsender.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: aboutPage

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent

        contentHeight: column.height + header.height + Theme.paddingLarge

        PageHeader {
            id: header
            title: qsTr("About")
        }

        Column {
            id: column
            spacing: Theme.paddingLarge
            anchors.top: parent.top
            anchors.topMargin: header.height
            width: parent.width

            Image {
                source: "../../res/images/harbour-cargo-big.png"
                width: 1 / 3 * parent.width
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: "Cargo 1.1-5"
                font.pixelSize: Theme.fontSizeExtraLarge
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
            }

            Label {
                text: qsTr("Assembled by A. Madani (m4d_d3v)")
                font.pixelSize: Theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                width: parent.width - Theme.paddingLarge * 2
                horizontalAlignment: Text.AlignHCenter
            }

            Label {
                text: qsTr("Uses components from nanofile, Fernweh, Sailfish-Office, File-Browser")
                font.pixelSize: Theme.fontSizeExtraSmall
                width: parent.width - (2 * Theme.horizontalPageMargin)
                wrapMode: Text.Wrap
                textFormat: Text.StyledText
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            SectionHeader {
                text: qsTr("Contributors")
            }

            Label {
                text: qsTr("Attah")
                font.pixelSize: Theme.fontSizeExtraSmall
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                width: parent.width - Theme.paddingLarge * 2
                horizontalAlignment: Text.AlignHCenter
            }

            SectionHeader {
                text: qsTr("Links")
            }

            Label {
                text: "Github: <a href=\"https://github.com/Logic-gate/harbour-cargo\">github.com/Logic-gate/harbour-cargo</a>"
                textFormat: Text.StyledText
                font.pixelSize: Theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment: Text.AlignHCenter
                linkColor: Theme.highlightColor
                onLinkActivated: Qt.openUrlExternally(link)
            }

            SectionHeader {
                text: qsTr("Credits")
            }

            Label {
                text: qsTr("Jolla (Sailfish-office) main ui")
                font.pixelSize: Theme.fontSizeExtraSmall
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                width: parent.width - Theme.paddingLarge * 2
                horizontalAlignment: Text.AlignHCenter
            }

            Label {
                text: qsTr("Kari Pihkala (File-browser) for file info ui")
                font.pixelSize: Theme.fontSizeExtraSmall
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                width: parent.width - Theme.paddingLarge * 2
                horizontalAlignment: Text.AlignHCenter
            }

            Label {
                text: qsTr("Michał Szczepaniak (nanofile) for this page, mimetype switcher, and various elements")
                font.pixelSize: Theme.fontSizeExtraSmall
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                width: parent.width - Theme.paddingLarge * 2
                horizontalAlignment: Text.AlignHCenter
            }

            Label {
                text: qsTr("Sebastian J. Wolf (fernweh) for notifications/loading, welcome page, and various elements")
                font.pixelSize: Theme.fontSizeExtraSmall
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                width: parent.width - Theme.paddingLarge * 2
                horizontalAlignment: Text.AlignHCenter
            }

            Label {
                text: qsTr("Icon made from <a href='http://www.onlinewebfonts.com/icon'>Online Web Fonts</a> is licensed by CC BY 3.0")
                font.pixelSize: Theme.fontSizeExtraSmall
                width: parent.width - (2 * Theme.horizontalPageMargin)
                wrapMode: Text.Wrap
                textFormat: Text.StyledText
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                linkColor: Theme.highlightColor
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Label {
                text: qsTr("This project was assembeled--line for line--from various open source projects.")
                font.pixelSize: Theme.fontSizeExtraSmall
                width: parent.width - (2 * Theme.horizontalPageMargin)
                color: Theme.highlightColor
                wrapMode: Text.Wrap
                textFormat: Text.StyledText
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }
        VerticalScrollDecorator {
        }
    }
}
