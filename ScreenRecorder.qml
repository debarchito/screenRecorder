import QtQuick
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root
    layerNamespacePlugin: "screen-recorder"

    property bool isRecording: pluginData.isRecording || false
    property string captureSource: pluginData.captureSource || "portal"
    property string outputDir: pluginData.outputDir || "/tmp"
    property int replaySeconds: pluginData.replaySeconds ?? 0
    property string replayOutputDir: pluginData.replayOutputDir || "/tmp"
    property int fps: pluginData.fps ?? 60
    property string quality: pluginData.quality || "high"
    property string container: pluginData.container || "mp4"

    function buildOutputPath() {
        var dir = outputDir.replace(/\/$/, "")
        var ts = new Date().toISOString().replace(/[:.]/g, "-").slice(0, 19)
        return dir + "/recording_" + ts + "." + container
    }

    function startRecording() {
        if (root.isRecording) return
        var outPath = buildOutputPath()
        var args = ["gpu-screen-recorder", "-w", captureSource, "-o", outPath, "-f", String(fps), "-q", quality, "-c", container]
        if (replaySeconds > 0) {
            args.push("-r")
            args.push(String(replaySeconds))
            args.push("-ro")
            args.push(replayOutputDir.replace(/\/$/, ""))
        }
        var ok = Quickshell.execDetached(args)
        if (ok) {
            root.isRecording = true
            if (pluginService) {
                pluginService.savePluginData(pluginId, "isRecording", true)
            }
            ToastService.showInfo("Screen Recorder", replaySeconds > 0 ? "Replay buffer activo" : "Grabación iniciada")
        } else {
            ToastService.showError("Screen Recorder", "No se pudo iniciar gpu-screen-recorder")
        }
    }

    function stopRecording() {
        if (!root.isRecording) return
        var ok = Quickshell.execDetached(["pkill", "-SIGUSR1", "-f", "gpu-screen-recorder"])
        if (ok !== false) {
            root.isRecording = false
            if (pluginService) {
                pluginService.savePluginData(pluginId, "isRecording", false)
            }
            ToastService.showInfo("Screen Recorder", "Grabación guardada")
        } else {
            ToastService.showError("Screen Recorder", "No se pudo detener la grabación")
        }
    }

    function toggleRecording() {
        if (root.isRecording) stopRecording()
        else startRecording()
    }

    ccWidgetIcon: root.isRecording ? "stop_circle" : "videocam"
    ccWidgetPrimaryText: root.isRecording ? "Grabando" : "Screen Recorder"
    ccWidgetSecondaryText: root.isRecording ? "Pulsa para guardar y detener" : "Pulsa para iniciar grabación"
    ccWidgetIsActive: root.isRecording
    onCcWidgetToggled: toggleRecording()

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingS
            DankIcon {
                name: root.isRecording ? "stop_circle" : "videocam"
                size: Theme.iconSize
                color: root.isRecording ? Theme.error : Theme.primary
                anchors.verticalCenter: parent.verticalCenter
            }
            StyledText {
                text: root.isRecording ? "Grabando" : "Grabar"
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.surfaceText
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
    verticalBarPill: Component {
        Column {
            spacing: Theme.spacingXS
            DankIcon {
                name: root.isRecording ? "stop_circle" : "videocam"
                size: Theme.iconSize
                color: root.isRecording ? Theme.error : Theme.primary
                anchors.horizontalCenter: parent.horizontalCenter
            }
            StyledText {
                text: root.isRecording ? "Grabando" : "Grabar"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceText
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    popoutContent: Component {
        PopoutComponent {
            id: popout
            headerText: "Screen Recorder"
            detailsText: root.isRecording ? "Replay buffer o grabación en curso" : "gpu-screen-recorder (Wayland)"
            showCloseButton: true
            Column {
                width: parent.width - Theme.spacingL * 2
                spacing: Theme.spacingM
                StyledRect {
                    width: parent.width - Theme.spacingL
                    height: 48
                    radius: Theme.cornerRadius
                    color: root.isRecording ? Theme.errorContainer : Theme.primaryContainer
                    StyledText {
                        anchors.centerIn: parent
                        text: root.isRecording ? "Detener y guardar" : "Iniciar grabación"
                        font.pixelSize: Theme.fontSizeMedium
                        color: root.isRecording ? Theme.onErrorContainer : Theme.onPrimaryContainer
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.toggleRecording()
                            popout.closePopout()
                        }
                    }
                }
                StyledText {
                    width: parent.width
                    text: "Origen: " + root.captureSource + " · " + root.fps + " fps · " + root.quality
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.surfaceVariantText
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
    popoutWidth: 320
    popoutHeight: 220
}
