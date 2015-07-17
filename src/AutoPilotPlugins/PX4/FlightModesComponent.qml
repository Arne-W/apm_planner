/*=====================================================================

 QGroundControl Open Source Ground Control Station

 (c) 2009 - 2015 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>

 This file is part of the QGROUNDCONTROL project

 QGROUNDCONTROL is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 QGROUNDCONTROL is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with QGROUNDCONTROL. If not, see <http://www.gnu.org/licenses/>.

 ======================================================================*/

import QtQuick                  2.2
import QtQuick.Controls         1.2
import QtQuick.Controls.Styles  1.2
import QtQuick.Dialogs          1.2
import QtQuick.Layouts          1.1

import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.Controllers   1.0
import QGroundControl.ScreenTools   1.0

QGCView {
    id:         rootQGCView
    viewPanel:  panel

    readonly property int monitorThresholdCharWidth: 8  // Character width of Monitor and Threshold labels

    // User visible strings

    readonly property string topHelpText:               "Assign Flight Modes to radio control channels and adjust the thresholds for triggering them. " +
                                                        "You can assign multiple flight modes to a single channel. " +
                                                        "Turn your radio control on to test switch settings."


    readonly property string fwManualModeName:          "Manual/Main"
    readonly property string mrManualModeName:          "Stabilized/Main"
    readonly property string fwManualModeDescription:   "The pilot has full control of the aircraft, no assistance is provided. " +
                                                        "The Main mode switch must always be assigned to a channel in order to fly"
    readonly property string mrManualModeDescription:   "Centering roll/pitch stick will return the multirotor to a level attitude, but it will continue drifting in the direction it was previously sent. " +
                                                        "Altitude is controlled fully by pilot using the Throttle stick. " +
                                                        "The Main mode switch must always be assigned to a channel in order to fly"

    readonly property string assistModeName:            "Assist"
    readonly property string assistModeDescription:     "If Position Control is placed on a seperate channel from the Main mode channel, an additional 'Assist' mode is added to the Main switch. " +
                                                        "In order for the Attitude Control/Position Control switch to be active, the Main switch must be in Assist mode."

    readonly property string autoModeName:              "Auto"
    readonly property string autoModeDescription:       "If Loiter is placed on a seperate channel from the Main mode channel, an additional 'Auto' mode is added to the Main switch. " +
                                                        "In order for the Mission/Loiter switch to be active, the Main switch must be in Auto mode."

    readonly property string fwAcroModeName:            "Stabilized"
    readonly property string mrAcroModeName:            "Acro"
    readonly property string fwAcroModeDescription:     "Need Stablized description"
    readonly property string mrAcroModeDescription:     "Need Acro mode description"

    readonly property string fwAltCtlModeName:          "Attitude Control"
    readonly property string mrAltCtlModeName:          "Altitude Control"
    readonly property string fwAltCtlModeDescription:   "Aileron and Elevator sticks affect roll and pitch according to the Attitude Control settings. " +
                                                        "Altitude is not maintained automatically. " +
                                                        "Rudder is controlled fully by the pilot."
    readonly property string mrAltCtlModeDescription:   "Same as Stablized mode except that Throttle controls climb/sink rate. Centered throttle holds altitude steady."

    readonly property string posCtlModeName:            "Position Control"
    readonly property string fwPosCtlModeDescription:   "Throttle controls speed, pitch controls climb/sink rate, roll controls yaw rate. " +
                                                        "Roll and Pitch centered gives level, straight-line flight. " +
                                                        "Position Control and Attitude Control must always be on the same channel."
    readonly property string mrPosCtlModeDescription:   "Roll and Pitch control left-right and front-back speed over ground respectively. " +
                                                        "When roll and pitch are centered, the multirotor will hold position. " +
                                                        "Yaw controls yaw rate as in Stablized mode. " +
                                                        "Throttle controls climb/sink rate. Centered throttle holds altitude steady. " +
                                                        "Position Control and Attitude Control must always be on the same channel."

    readonly property string missionModeName:           "Mission"
    readonly property string missionModeDescription:    "The aircraft obeys the programmed mission sent by QGroundControl. " +
                                                        "If no mission was sent, aircraft will loiter at current position instead."

    readonly property string loiterModeName:            "Loiter"
    readonly property string fwLoiterModeDescription:   "The aircraft flies in a circle around the current position at the current altitude. " +
                                                        "Loiter and Mission must always be on the same channel."
    readonly property string mrLoiterModeDescription:   "The multirotor hovers in a fixed position at the current position and altitude. " +
                                                        "Loiter and Mission must always be on the same channel."

    readonly property string returnModeName:            "Return"
    readonly property string fwReturnModeDescription:   "The aircraft returns to the home position and loiters above it." +
                                                        "The settings which control this sequence can be found under Setup - Safety."
    readonly property string mrReturnModeDescription:   "The multirotor returns to the home position, loiters and then lands. " +
                                                        "The settings which control this sequence can be found under Setup - Safety."

    readonly property string offboardModeName:          "Offboard"
    readonly property string offboardModeDescription:   "Offboard description"

    readonly property real modeSpacing: ScreenTools.defaultFontPixelHeight / 3

    QGCPalette { id: qgcPal; colorGroupEnabled: panel.enabled }

    FlightModesComponentController {
        id:         controller
        factPanel:  panel

        onModeRowsChanged: recalcModePositions()
    }

    Timer {
        interval:   200
        running:    true

        onTriggered: recalcModePositions()
    }

    function recalcModePositions() {
        var spacing = ScreenTools.defaultFontPixelHeight / 2
        var nextY = manualMode.y + manualMode.height + spacing

        for (var index = 0; index < 9; index++) {
            if (controller.assistModeRow == index) {
                if (controller.assistModeVisible) {
                    assistMode.y = nextY
                    assistMode.z = 9 - index
                    nextY += assistMode.height + spacing
                }
            } else if (controller.autoModeRow == index) {
                if (controller.autoModeVisible) {
                    autoMode.y = nextY
                    autoMode.z = 9 - index
                    nextY += autoMode.height  + spacing
                }
            } else if (controller.acroModeRow == index) {
                acroMode.y = nextY
                acroMode.z = 9 - index
                nextY += acroMode.height + spacing
            } else if (controller.altCtlModeRow == index) {
                altCtlMode.y = nextY
                altCtlMode.z = 9 - index
                nextY += altCtlMode.height + spacing
            } else if (controller.posCtlModeRow == index) {
                posCtlMode.y = nextY
                posCtlMode.z = 9 - index
                nextY += posCtlMode.height + spacing
            } else if (controller.loiterModeRow == index) {
                loiterMode.y = nextY
                loiterMode.z = 9 - index
                nextY += loiterMode.height + spacing
            } else if (controller.missionModeRow == index) {
                missionMode.y = nextY
                missionMode.z = 9 - index
                nextY += missionMode.height + spacing
            } else if (controller.returnModeRow == index) {
                returnMode.y = nextY
                returnMode.z = 9 - index
                nextY += returnMode.height + spacing
            } else if (controller.offboardModeRow == index) {
                offboardMode.y = nextY
                offboardMode.z = 9 - index
                nextY += offboardMode.height + spacing
            }
        }

        scrollItem.height = nextY
    }

    QGCViewPanel {
        id:             panel
        anchors.fill:   parent

        ScrollView {
            id:                         scroll
            anchors.fill:               parent
            horizontalScrollBarPolicy:  Qt.ScrollBarAlwaysOff

            Item {
                id:     scrollItem
                width:  scroll.viewport.width

                QGCLabel {
                    id:             header
                    width:          parent.width
                    font.pixelSize: ScreenTools.largeFontPixelSize
                    text:           "FLIGHT MODES CONFIG"
                }

                Item {
                    id:             headingSpacer
                    anchors.top:    header.bottom
                    height:         20
                    width:          20
                }

                QGCLabel {
                    anchors.top:            headingSpacer.bottom
                    anchors.left:           parent.left
                    anchors.rightMargin:    ScreenTools.defaultFontPixelWidth
                    anchors.right:          applyButton.left
                    text:                   topHelpText
                    wrapMode:               Text.WordWrap
                }

                QGCButton {
                    id:                     applyButton
                    anchors.top:            headingSpacer.bottom
                    anchors.rightMargin:    ScreenTools.defaultFontPixelWidth
                    anchors.right:          parent.right
                    text:                   "Generate Thresholds"

                    onClicked: controller.generateThresholds()
                }

                Item {
                    id:             lastSpacer
                    anchors.top:    applyButton.bottom
                    height:         20
                    width:          10
                }

                ModeSwitchDisplay {
                    id:                     manualMode
                    anchors.top:            lastSpacer.bottom
                    flightModeName:         controller.fixedWing ? fwManualModeName : mrManualModeName
                    flightModeDescription:  controller.fixedWing ? fwManualModeDescription : mrManualModeDescription
                    rcValue:                controller.manualModeRcValue
                    modeChannelIndex:       controller.manualModeChannelIndex
                    modeChannelEnabled:     true
                    modeSelected:           controller.manualModeSelected
                    thresholdValue:         controller.manualModeThreshold
                    thresholdDragEnabled:   false

                    onModeChannelIndexChanged: controller.manualModeChannelIndex = modeChannelIndex
                }

                ModeSwitchDisplay {
                    id:                     assistMode
                    visible:                controller.assistModeVisible
                    flightModeName:         assistModeName
                    flightModeDescription:  assistModeDescription
                    rcValue:                controller.assistModeRcValue
                    modeChannelIndex:       controller.assistModeChannelIndex
                    modeChannelEnabled:     false
                    modeSelected:           controller.assistModeSelected
                    thresholdValue:         controller.assistModeThreshold
                    thresholdDragEnabled:   true

                    onThresholdValueChanged: controller.assistModeThreshold = thresholdValue

                    Behavior on y { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 1000 } }
                }

                ModeSwitchDisplay {
                    id:                     autoMode
                    visible:                controller.autoModeVisible
                    flightModeName:         autoModeName
                    flightModeDescription:  autoModeDescription
                    rcValue:                controller.autoModeRcValue
                    modeChannelIndex:       controller.autoModeChannelIndex
                    modeChannelEnabled:     false
                    modeSelected:           controller.autoModeSelected
                    thresholdValue:         controller.autoModeThreshold
                    thresholdDragEnabled:   true

                    onThresholdValueChanged: controller.autoModeThreshold = thresholdValue

                    Behavior on y { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 1000 } }
                }

                ModeSwitchDisplay {
                    id:                     acroMode
                    flightModeName:         controller.fixedWing ? fwAcroModeName : mrAcroModeName
                    flightModeDescription:  controller.fixedWing ? fwAcroModeDescription : mrAcroModeDescription
                    rcValue:                controller.acroModeRcValue
                    modeChannelIndex:       controller.acroModeChannelIndex
                    modeChannelEnabled:     true
                    modeSelected:           controller.acroModeSelected
                    thresholdValue:         controller.acroModeThreshold
                    thresholdDragEnabled:   true

                    onModeChannelIndexChanged:  controller.acroModeChannelIndex = modeChannelIndex
                    onThresholdValueChanged:    controller.acroModeThreshold = thresholdValue

                    Behavior on y { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 1000 } }
                }

                ModeSwitchDisplay {
                    id:                     altCtlMode
                    flightModeName:         controller.fixedWing ? fwAltCtlModeName : mrAltCtlModeName
                    flightModeDescription:  controller.fixedWing ? fwAltCtlModeDescription : mrAltCtlModeDescription
                    rcValue:                controller.altCtlModeRcValue
                    modeChannelIndex:       controller.altCtlModeChannelIndex
                    modeChannelEnabled:     false
                    modeSelected:           controller.altCtlModeSelected
                    thresholdValue:         controller.altCtlModeThreshold
                    thresholdDragEnabled:   !controller.assistModeVisible

                    onThresholdValueChanged:    controller.altCtlModeThreshold = thresholdValue

                    Behavior on y { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 1000 } }
                }

                ModeSwitchDisplay {
                    id:                     posCtlMode
                    flightModeName:         posCtlModeName
                    flightModeDescription:  controller.fixedWing ? fwPosCtlModeDescription : mrPosCtlModeDescription
                    rcValue:                controller.posCtlModeRcValue
                    modeChannelIndex:       controller.posCtlModeChannelIndex
                    modeChannelEnabled:     true
                    modeSelected:           controller.posCtlModeSelected
                    thresholdValue:         controller.posCtlModeThreshold
                    thresholdDragEnabled:   true

                    onModeChannelIndexChanged:  controller.posCtlModeChannelIndex = modeChannelIndex
                    onThresholdValueChanged:    controller.posCtlModeThreshold = thresholdValue

                    Behavior on y { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 1000 } }
                }

                ModeSwitchDisplay {
                    id:                     missionMode
                    flightModeName:         missionModeName
                    flightModeDescription:  missionModeDescription
                    rcValue:                controller.missionModeRcValue
                    modeChannelIndex:       controller.missionModeChannelIndex
                    modeChannelEnabled:     false
                    modeSelected:           controller.missionModeSelected
                    thresholdValue:         controller.missionModeThreshold
                    thresholdDragEnabled:   !controller.autoModeVisible

                    onThresholdValueChanged: controller.missionModeThreshold = thresholdValue

                    Behavior on y { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 1000 } }
                }

                ModeSwitchDisplay {
                    id:                     loiterMode
                    flightModeName:         loiterModeName
                    flightModeDescription:  controller.fixedWing ? fwLoiterModeDescription : mrLoiterModeDescription
                    rcValue:                controller.loiterModeRcValue
                    modeChannelIndex:       controller.loiterModeChannelIndex
                    modeChannelEnabled:     true
                    modeSelected:           controller.loiterModeSelected
                    thresholdValue:         controller.loiterModeThreshold
                    thresholdDragEnabled:   true

                    onModeChannelIndexChanged:  controller.loiterModeChannelIndex = modeChannelIndex
                    onThresholdValueChanged:    controller.loiterModeThreshold = thresholdValue

                    Behavior on y { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 1000 } }
                }

                ModeSwitchDisplay {
                    id:                     returnMode
                    flightModeName:         returnModeName
                    flightModeDescription:  controller.fixedWing ? fwReturnModeDescription : mrReturnModeDescription
                    rcValue:                controller.returnModeRcValue
                    modeChannelIndex:       controller.returnModeChannelIndex
                    modeChannelEnabled:     true
                    modeSelected:           controller.returnModeSelected
                    thresholdValue:         controller.returnModeThreshold
                    thresholdDragEnabled:   true

                    onModeChannelIndexChanged:  controller.returnModeChannelIndex = modeChannelIndex
                    onThresholdValueChanged:    controller.returnModeThreshold = thresholdValue

                    Behavior on y { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 1000 } }
                }

                ModeSwitchDisplay {
                    id:                     offboardMode
                    flightModeName:         offboardModeName
                    flightModeDescription:  offboardModeDescription
                    rcValue:                controller.offboardModeRcValue
                    modeChannelIndex:       controller.offboardModeChannelIndex
                    modeChannelEnabled:     true
                    modeSelected:           controller.offboardModeSelected
                    thresholdValue:         controller.offboardModeThreshold
                    thresholdDragEnabled:   true

                    onModeChannelIndexChanged:  controller.offboardModeChannelIndex = modeChannelIndex
                    onThresholdValueChanged:    controller.offboardModeThreshold = thresholdValue

                    Behavior on y { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 1000 } }
                }
            } // Item
        } // Scroll View
    } // QGCViewPanel
} // QGCView