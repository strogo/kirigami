/*
 *   Copyright 2015 Marco Martin <mart@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.1
import QtQuick.Controls 1.0 as Controls
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import org.kde.plasma.mobilecomponents 0.2

/**
 * A drawer specialization intended for the global actions of the application
 * valid regardless of the application state (think about the menubar
 * of a desktop application).
 *
 * Example usage:
 * @code
 * import org.kde.plasma.mobilecomponents 0.2 as MobileComponents
 *
 * MobileComponents.ApplicationWindow {
 *  [...]
 *     globalDrawer: MobileComponents.GlobalDrawer {
 *         actions: [
 *            MobileComponents.Action {
 *                text: "View"
 *                iconName: "view-list-icons"
 *                MobileComponents.Action {
 *                        text: "action 1"
 *                }
 *                MobileComponents.Action {
 *                        text: "action 2"
 *                }
 *                MobileComponents.Action {
 *                        text: "action 3"
 *                }
 *            },
 *            MobileComponents.Action {
 *                text: "Sync"
 *                iconName: "folder-sync"
 *            }
 *         ]
 *     }
 *  [...]
 * }
 * @endcode
 *
 * @inherit AbstractDrawer
 */
OverlayDrawer {
    id: root
    edge: Qt.LeftEdge

    /**
     * title: string
     * A title to be displayed on top of the drawer
     */
    property alias title: heading.text

    /**
     * icon: var
     * An icon to be displayed alongside the title.
     * It can be a QIcon, a fdo-compatible icon name, or any url understood by Image
     */
    property alias titleIcon: headingIcon.source

    /**
     * bannerImageSource: string
     * An image to be used as background for the title and icon for
     * a decorative purpose.
     * It accepts any url format supported by Image
     */
    property alias bannerImageSource: bannerImage.source

    /**
     * actions: list<Action>
     * The list of actions can be nested having a tree structure.
     * A tree depth bigger than 2 is discouraged.
     *
     * Example usage:
     * @code
     * import org.kde.plasma.mobilecomponents 0.2 as MobileComponents
     *
     * MobileComponents.ApplicationWindow {
     *  [...]
     *     globalDrawer: MobileComponents.GlobalDrawer {
     *         actions: [
     *            MobileComponents.Action {
     *                text: "View"
     *                iconName: "view-list-icons"
     *                MobileComponents.Action {
     *                        text: "action 1"
     *                }
     *                MobileComponents.Action {
     *                        text: "action 2"
     *                }
     *                MobileComponents.Action {
     *                        text: "action 3"
     *                }
     *            },
     *            MobileComponents.Action {
     *                text: "Sync"
     *                iconName: "folder-sync"
     *            }
     *         ]
     *     }
     *  [...]
     * }
     * @endcode
     */
    property list<Action> actions


    /**
     * content: list<Item> default property
     * Any random Item can be instantiated inside the drawer and
     * will be displayed underneath the actions list.
     *
     * Example usage:
     * @code
     * import org.kde.plasma.mobilecomponents 0.2 as MobileComponents
     *
     * MobileComponents.ApplicationWindow {
     *  [...]
     *     globalDrawer: MobileComponents.GlobalDrawer {
     *         actions: [...]
     *         Button {
     *             text: "Button"
     *             onClicked: //do stuff
     *         }
     *     }
     *  [...]
     * }
     * @endcode
     */
    default property alias content: mainContent.data

    contentItem: ColumnLayout {
        id: mainColumn
        anchors.fill: parent
        spacing: 0
        implicitWidth: Units.gridUnit * 12

        Image {
            id: bannerImage
            Layout.fillWidth: true

            Layout.preferredWidth: title.implicitWidth
            Layout.preferredHeight: bannerImageSource != "" ? Math.max(title.implicitHeight, Math.floor(width / (sourceSize.width/sourceSize.height))) : title.implicitHeight
            Layout.minimumHeight: Math.max(headingIcon.height, heading.height) + Units.smallSpacing * 2

            fillMode: Image.PreserveAspectCrop
            asynchronous: true

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            LinearGradient {
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                }
                visible: bannerImageSource != ""
                height: title.height * 1.3
                start: Qt.point(0, 0)
                end: Qt.point(0, height)
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: Qt.rgba(0, 0, 0, 0.8)
                    }
                    GradientStop {
                        position: 1.0
                        color: "transparent"
                    }
                }
            }

            RowLayout {
                id: title
                anchors {
                    left: parent.left
                    top: parent.top
                    margins: Units.smallSpacing * 2
                }
                Icon {
                    id: headingIcon
                    Layout.minimumWidth: Units.iconSizes.large
                    Layout.minimumHeight: width
                }
                Heading {
                    id: heading
                    level: 1
                    color: bannerImageSource != "" ? "white" : Theme.textColor
                }
                Item {
                    height: 1
                    Layout.minimumWidth: heading.height
                }
            }
        }

        Rectangle {
            color: Theme.textColor
            opacity: 0.2
            Layout.fillWidth: true
            Layout.minimumHeight: 1
        }

        Controls.StackView {
            id: stackView
            Layout.fillWidth: true
            Layout.fillHeight: true
            initialItem: menuComponent
        }

        ColumnLayout {
            id: mainContent
            Layout.alignment: Qt.AlignHCenter
            Layout.minimumWidth: parent.width - Units.smallSpacing*2
            Layout.maximumWidth: Layout.minimumWidth
            Layout.fillWidth: false
            Layout.fillHeight: true
            visible: children.length > 0
        }
        Item {
            Layout.minimumWidth: Units.smallSpacing
            Layout.minimumHeight: Units.smallSpacing
        }

        Component {
            id: menuComponent
            ListView {
                id: optionMenu
                clip: true

                model: actions
                property int level: 0

                interactive: contentHeight > height

                footer: BasicListItem {
                    visible: level > 0
                    supportsMouseEvents: true
                    icon: "go-previous"
                    label: typeof i18n !== "undefined" ? i18n("Back") : "Back"
                    onClicked: stackView.pop()
                }
                delegate: BasicListItem {
                    supportsMouseEvents: true
                    checked: modelData.checked
                    icon: modelData.iconName
                    label: modelData.text
                    visible: model ? model.visible : modelData.visible
                    enabled: model ? model.enabled : modelData.enabled
                    opacity: enabled ? 1.0 : 0.3

                    Icon {
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                            right: parent.right
                        }
                        width: height
                        source: "go-next"
                        visible: modelData.children.length > 0
                    }

                    onClicked: {
                        if (modelData.children.length > 0) {
                            stackView.push(menuComponent, {"model": modelData.children, "level": level + 1});
                        } else {
                            modelData.trigger();
                            stackView.pop(stackView.initialItem);
                            root.opened = false;
                        }
                    }
                }
            }
        }
    }
}

