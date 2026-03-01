import QtQuick
import qs.Common
import qs.Modules.Plugins
import qs.Widgets

PluginSettings {
    id: root
    pluginId: "screenRecorder"

    StyledText {
        width: parent.width
        text: "Screen Recorder (gpu-screen-recorder)"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }
    StyledText {
        width: parent.width
        text: "Inicia, detiene y configura grabaciones de pantalla en Wayland (niri, Hyprland, etc.). Requiere gpu-screen-recorder instalado."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    SelectionSetting {
        settingKey: "captureSource"
        label: "Origen de captura"
        description: "portal = selector de ventana/pantalla (Wayland); screen = primera pantalla"
        options: [
            { label: "Portal (elegir en pantalla)", value: "portal" },
            { label: "Pantalla completa", value: "screen" }
        ]
        defaultValue: "portal"
    }

    StringSetting {
        settingKey: "outputDir"
        label: "Carpeta de grabaciones"
        description: "Directorio donde se guardan los vídeos (ruta completa, ej. /home/tu/Videos)"
        placeholder: "/home/tu/Videos"
        defaultValue: ""
    }

    SliderSetting {
        settingKey: "replaySeconds"
        label: "Buffer de replay (segundos)"
        description: "0 = grabación continua; >0 = grabar los últimos N segundos (estilo ShadowPlay)"
        defaultValue: 0
        minimum: 0
        maximum: 120
        unit: "s"
    }

    StringSetting {
        settingKey: "replayOutputDir"
        label: "Carpeta para replays"
        description: "Solo si buffer de replay > 0. Donde se guardan los clips al pulsar \"Detener\""
        placeholder: "/home/tu/Videos"
        defaultValue: ""
    }

    SliderSetting {
        settingKey: "fps"
        label: "FPS"
        description: "Fotogramas por segundo"
        defaultValue: 60
        minimum: 24
        maximum: 120
        unit: ""
    }

    SelectionSetting {
        settingKey: "quality"
        label: "Calidad"
        description: "Preset de codificación GPU"
        options: [
            { label: "Ultra", value: "ultra" },
            { label: "Alta", value: "high" },
            { label: "Media", value: "medium" },
            { label: "Baja", value: "low" }
        ]
        defaultValue: "high"
    }

    SelectionSetting {
        settingKey: "container"
        label: "Formato de archivo"
        description: "Contenedor del vídeo"
        options: [
            { label: "MP4", value: "mp4" },
            { label: "MKV", value: "mkv" },
            { label: "FLV", value: "flv" }
        ]
        defaultValue: "mp4"
    }
}
