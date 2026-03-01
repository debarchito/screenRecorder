# Screen Recorder — Plugin Dank Material Shell

Plugin para **Dank Material Shell** que permite iniciar, detener y configurar grabaciones de pantalla con **gpu-screen-recorder** en Wayland (niri, Hyprland, GNOME, etc.).

## Requisitos

- [Dank Material Shell](https://github.com/AvengeMedia/DankMaterialShell) (DMS) en tu compositor
- [gpu-screen-recorder](https://git.dec05eba.com/gpu-screen-recorder/) instalado y en el `PATH`

### Instalar gpu-screen-recorder

- **Arch:** `pacman -S gpu-screen-recorder`
- **Otros:** compilar desde [fuente](https://git.dec05eba.com/gpu-screen-recorder/) o usar el paquete de tu distro.

## Instalación del plugin

1. Clona o copia este repositorio.
2. Enlaza la carpeta al directorio de plugins de DMS:

```bash
ln -sf /ruta/a/dms-screen-recorder ~/.config/DankMaterialShell/plugins/screenRecorder
```

3. Recarga los plugins (o reinicia el shell):

```bash
dms ipc call plugins reload screenRecorder
```

4. En **DMS Settings → Plugins** activa el widget en la barra y/o en el Control Center.

## Uso

- **Barra (DankBar):** icono de cámara / "Grabar". Clic para abrir el popout con **Iniciar** / **Detener y guardar**.
- **Control Center:** toggle "Screen Recorder". Encendido = grabando; apagado = detenido y guardado.

### Replay buffer (estilo ShadowPlay)

En **Configuración del plugin** pon **Buffer de replay** > 0 (por ejemplo 30 s). La grabación mantiene en memoria los últimos N segundos. Al pulsar **Detener**, se guarda solo ese clip en la carpeta de replays.

## Configuración

En **DMS Settings → Plugins → Screen Recorder**:

| Opción | Descripción |
|--------|-------------|
| **Origen de captura** | `portal` = eliges ventana/pantalla al iniciar; `screen` = primera pantalla |
| **Carpeta de grabaciones** | Dónde se guardan los vídeos (ruta completa; por defecto /tmp si está vacío) |
| **Buffer de replay** | 0 = grabación continua; >0 = últimos N segundos |
| **Carpeta para replays** | Dónde se guardan los clips al detener (si replay > 0) |
| **FPS** | 24–120 |
| **Calidad** | ultra / high / medium / low |
| **Formato** | mp4, mkv, flv |

## Detener la grabación

El plugin detiene **gpu-screen-recorder** enviando `SIGUSR1`, para que guarde el archivo correctamente. No uses `pkill -KILL` salvo que quieras descartar la grabación.

## Desarrollo

Enlace simbólico para probar cambios sin reinstalar:

```bash
ln -sf "$(pwd)" ~/.config/DankMaterialShell/plugins/screenRecorder
dms ipc call plugins reload screenRecorder
```

Listar plugins y estado:

```bash
dms ipc call plugins list
```

## Licencia

Puedes usar y modificar este plugin bajo los mismos términos que aceptes para DMS y gpu-screen-recorder.
