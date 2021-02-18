/*
 * Copyright (C) 2019 Open Mobile Platform LLC
 * Copyright (C) 2013-2014 Jolla Ltd.
 * Contact: Robin Burchell <robin.burchell@jolla.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; version 2 only.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

import "../python"
import "../components"
import "../components/MimeTypeSwitcher.js" as MimeTypeIconSwitcher
import "../components/GeneralUseFunctions.js" as Functions

// This is mostly from Sailfish-office aka Documents...cheers Jolla!
Page {
    id: listPage
    allowedOrientations: Orientation.All
    focus: true

    property var fetchCount
    property var fetchParam
    property var fetchHeader
    property var dirPush
    property var iconSetParse
    property var setIcon

    property bool searchEnabled
    property bool refreshAfterIconSet
    property bool loaded: false

    Component.onCompleted: {
        if (dirPush) {
            console.log("opening dir")
            pageHeader.title = fetchHeader
            py.getCustomSearch(fetchCount, fetchParam)
        } else {
            console.log("loading main page")
            py.getData(25)
        }
    }

    onSearchEnabledChanged: {
        if (pageStack.currentPage.status === PageStatus.Active) {
            if (searchEnabled) {
                searchField.forceActiveFocus()
            } else {
                searchField.focus = false
            }
        }
        if (!searchEnabled) {
            searchField.text = ""
        }
    }

    function iconSet(model) {

        var useThisIconSet = ""

        switch (setIcon) {
        case "googleDriveIconSet":
            useThisIconSet = Functions.retinaIconLink(model.iconLink,
                                                      '/16/', '/64/')
            break
        case "silicaIconSet":
            useThisIconSet = Functions.dir(
                        model.mimeType) ? "image://theme/icon-m-file-folder" : MimeTypeIconSwitcher.mimeTypeIcon(
                                              model.mimeType, Theme.colorScheme)
            break
        }

        return useThisIconSet
    }

    SilicaListView {
        id: list
        currentIndex: -1
        anchors.fill: parent
        model: ListModel {
            id: listModel
        }

        visible: true
        header: Item {
            width: list.width
            height: headerContent.height
        }

        Column {
            id: headerContent
            parent: list.headerItem
            width: parent.width
            height: pageHeader.height + (searchEnabled ? searchField.height : 0)
            Behavior on height {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }
            PageHeader {
                id: pageHeader
                title: qsTrId("Cargo!")
            }
            SearchField {
                id: searchField
                width: parent.width
                opacity: listPage.searchEnabled ? 1.0 : 0.0
                visible: opacity > 0
                placeholderText: qsTrId("Search Drive!")
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false

                Behavior on opacity {
                    FadeAnimation {
                        duration: 150
                    }
                }

                onTextChanged: {
                    if (text.length > 3) {
                        Functions.refreshAfterSearch(
                                    25,
                                    "name contains '" + searchField.text + "'",
                                    "Cargo!")
                    } else if (text.length === 0) {
                        listModel.clear()
                        focus = true
                        py.getData(25)
                    }
                }
            }
        }

        Connections {
            target: searchField.activeFocus ? list : null
            ignoreUnknownSignals: true
            onContentYChanged: {
                if (list.contentY > (Screen.height / 2)) {
                    searchField.focus = false
                }
            }
        }
        PullDownMenu {
            id: menu
            property bool _searchEnabled
            onActiveChanged: {
                if (active) {
                    _searchEnabled = listPage.searchEnabled
                }
            }

            MenuItem {
                text: qsTr('About')
                onClicked: {
                    pageStack.push('About.qml')
                }
            }

            MenuItem {
                text: qsTr('Settings')
                onClicked: {
                    pageStack.push('SettingsPage.qml', {
                                       "currentIconSet": iconSetParse
                                   })
                }
            }

            MenuItem {
                text: !menu._searchEnabled ? qsTrId("Show Search") : qsTrId(
                                                 "Hide Search")
                onClicked: listPage.searchEnabled = !listPage.searchEnabled
            }

            MenuItem {
                id: _refresh
                text: qsTr('Refresh')
                onClicked: {
                    loaded = false
                    menu._resetPosition()
                    Functions.refresh()
                }
            }
        }

        delegate: ListItem {
            id: listItem
            contentHeight: Math.max(Theme.itemSizeMedium,
                                    labels.height + 2 * Theme.paddingMedium)

            Image {
                id: icon
                cache: true
                asynchronous: true
                anchors {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    verticalCenter: parent.verticalCenter
                }
                source: iconSet(model)
                onSourceChanged: {
                    if (source) {
                        loaded = true
                    }
                }
            }

            Column {
                id: labels
                anchors {
                    left: icon.right
                    leftMargin: Theme.paddingMedium
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                    verticalCenter: parent.verticalCenter
                }
                Label {

                    text: name
                    width: parent.width
                    color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                    font.pixelSize: Theme.fontSizeMedium
                    truncationMode: TruncationMode.Fade
                }
                Item {
                    width: parent.width
                    height: sizeLabel.height
                    Label {
                        id: sizeLabel
                        text: Format.formatFileSize(model.size)
                        font.pixelSize: Theme.fontSizeExtraSmall
                        color: listItem.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    }
                    Label {
                        anchors.right: parent.right
                        text: Format.formatDate(model.modifiedTime,
                                                Format.Timepoint)
                        font.pixelSize: Theme.fontSizeExtraSmall
                        color: listItem.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    }
                }
            }


            onClicked: {
                var filePath =  '/home/nemo/Downloads/Cargo/' + id + "." + name.split(".")[1]
                Functions.dir(
                           model.mimeType) ? Functions.pushPageDir(150,
                                                                   "'" + model.id + "' in parents", model.name) : Functions.pushPageFile(
                                                 model.id, model.name,
                                                 model.description, model.size,
                                                 model.modifiedTime, model.mimeType,
                                                 model.createdTime, model.webViewLink,
                                                 model.iconLink, model.hasThumbnail,
                                                 model.thumbnailLink,
                                                 model.shared,
                                                 model.sharedWithMeTime,
                                                 model.ownedByMe,
                                                 model.md5Checksum,
                                                 filePath)
            }

            menu: ContextMenu {

                MenuItem {
                    text: qsTr('Download')
                    onClicked: {
                        py.download(id, md5Checksum, false)
                    }
                }

                MenuItem {
                    text: qsTr('Download as PDF')
                    onClicked: {
                        py.download(id, md5Checksum, true)
                    }
                }

            }
        }

        AppNotification {
            id: imageNotification
        }

        LoadingIndicator {
            id: loading
            visible: !loaded
            Behavior on opacity {
                NumberAnimation {
                }
            }
            opacity: loaded ? 0 : 1
            height: parent.height
            width: parent.width
        }
        //STOPPED HERE,
        //Added Loading indicatior Component to fix refresh glitch 10/18/2020.
        //Need to add visual item here
    }

    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../python'))
            setHandler('download_status', function (res) {
                if (res === 100) {
                    imageNotification.show(qsTr("Download Complete!"));
                }
                else if (res === 110) {
                    imageNotification.show(qsTr("File Already Exists"));
                }
                else {
                    imageNotification.show(qsTr("Download Failed!"));
                }
            })

            setHandler('iconParseSetting', function (option) {
                    iconSetParse = option
            })

            setHandler('setIcon', function (option) {
                    setIcon = option
            })
            importModule('main', function () {})
        }

        function getData(count) {
            call('main.api.listFileService', [count], function (result) {
                for (var i=0; i<result.length; i++) {
                    listModel.append(result[i])
                }
            })
        }

        function getCustomSearch(count, term) {
            call('main.api.searchListFileService', [count, term], function (result) {
                for (var i=0; i<result.length; i++) {
                    listModel.append(result[i])
                }
            })
        }

        function download(id, md5Checksum, asPdf) {
            call('main.api.download', [id, md5Checksum, asPdf], function () {})
        }

        function configParser(configName) {
            call('main.api.configParser', [configName], function () {})
        }
    }
}
