/*
 *   Copyright 2018 Marco Martin <mart@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
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

import QtQuick 2.5
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.4
import "../" as Private


AbstractPageHeader {
    id: root

    implicitWidth: titleTextMetrics.width/2 + buttonTextMetrics.collapsedButtonsWidth
    Layout.minimumWidth: ctxActionsButton.width*4

    MouseArea {
        anchors.fill: parent
        onClicked: page.forceActiveFocus()
    }
    RowLayout {
        id: titleLayout
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: actionsLayout.left
        }

        Heading {
            id: title
            level: 1
            Layout.fillWidth: true

            Layout.preferredWidth: implicitWidth
            Layout.minimumWidth: Math.min(titleTextMetrics.width, root.width - buttonTextMetrics.requiredWidth)
            leftPadding: Units.largeSpacing
            opacity: root.current ? 1 : 0.4
            maximumLineCount: 1
            color: Theme.textColor
            elide: Text.ElideRight
            text: page ? page.title : ""
        }
    }

    TextMetrics {
        id: titleTextMetrics
        text: page ? page.title : ""
        font: title.font
    }
    TextMetrics {
        id: buttonTextMetrics
        text: (page.actions.left ? page.actions.left.text : "") + (page.actions.main ? page.actions.main.text : "") + (page.actions.right ? page.actions.right.text : "")
        readonly property int collapsedButtonsWidth: ctxActionsButton.width + (page.actions.left ? ctxActionsButton.width + Units.gridUnit : 0) + (page.actions.main ? ctxActionsButton.width + Units.gridUnit : 0) + (page.actions.right ? ctxActionsButton.width + Units.gridUnit : 0)
        readonly property int requiredWidth: width + collapsedButtonsWidth
    }

    RowLayout {
        id: actionsLayout
        anchors {
            verticalCenter: parent.verticalCenter
            right: ctxActionsButton.visible ? ctxActionsButton.left : parent.right
        }

        readonly property bool toobig: root.width - root.leftPadding - root.rightPadding - titleTextMetrics.width - Units.gridUnit < buttonTextMetrics.requiredWidth

        Private.PrivateActionToolButton {
            Layout.alignment: Qt.AlignVCenter
            kirigamiAction: page && page.actions ? page.actions.left : null
            showText: !parent.toobig
        }
        Private.PrivateActionToolButton {
            Layout.alignment: Qt.AlignVCenter
            Layout.rightMargin: Units.smallSpacing
            kirigamiAction: page && page.actions ? page.actions.main : null
            showText: !parent.toobig
            flat: false
        }
        Private.PrivateActionToolButton {
            Layout.alignment: Qt.AlignVCenter
            kirigamiAction: page && page.actions ? page.actions.right : null
            showText: !parent.toobig
        }
    }

    Private.PrivateActionToolButton {
        id: ctxActionsButton
        showMenuArrow: page.actions.contextualActions.length == 1
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: Units.smallSpacing
        }
        Action {
            id: overflowAction
            icon.name: "overflow-menu"
            tooltip: qsTr("More Actions")
            visible: children.length > 0
            children: page && page.actions.contextualActions ? page.actions.contextualActions : null
        }

        kirigamiAction: page && page.actions.contextualActions.length === 1 ? page.actions.contextualActions[0] : overflowAction
    }
}
