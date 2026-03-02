# Configuración de DankGreeter (Dank Material Shell)

Guía para configurar el greeter de Dank Material Shell en CachyOS/Arch.

## 1. Instalación (CachyOS/Arch)

```bash
# Con paru o yay (AUR)
paru -S greetd-dms-greeter-git
# o
yay -S greetd-dms-greeter-git
```

Si ya tienes DMS y el repo de DankLinux:

```bash
dms greeter install
```

⚠️ Esto reemplaza tu gestor de sesión actual (GDM, SDDM, etc.).

## 2. Completar la configuración (si instalaste el paquete manualmente)

```bash
# Habilitar greetd y desactivar otros DMs
dms greeter enable

# Sincronizar tema, wallpaper y colores con tu usuario
dms greeter sync
```

Después de `dms greeter sync` **cierra sesión y vuelve a entrar** para que el grupo `greeter` se aplique.

## 3. Comprobar estado

```bash
dms greeter status
```

Comprueba grupo `greeter`, enlaces de configuración y directorio de caché.

## 4. Configuración del compositor

El comando por defecto en `/etc/greetd/config.toml` depende del compositor.

### Niri (por defecto)

```toml
command = "dms-greeter --command niri"
```

Con config custom:

```bash
sudo tee /etc/greetd/niri.kdl > /dev/null << 'EOF'
hotkey-overlay { skip-at-startup }
environment { DMS_RUN_GREETER "1" }
gestures { hot-corners { off } }
layout { background-color "#000000" }
EOF
```

```toml
command = "dms-greeter --command niri -C /etc/greetd/niri.kdl"
```

### Hyprland

```bash
sudo tee /etc/greetd/hypr.conf > /dev/null << 'EOF'
env = DMS_RUN_GREETER,1
misc { disable_hyprland_logo = true }
EOF
```

```toml
command = "dms-greeter --command hyprland -C /etc/greetd/hypr.conf"
```

### Sway

```toml
command = "dms-greeter --command sway -C /etc/greetd/sway"
```

## 5. Archivos de configuración del greeter

En `/var/cache/dms-greeter/` (o `DMS_GREET_CFG_DIR` si lo defines):

| Archivo       | Uso                          |
|---------------|------------------------------|
| `settings.json` | Reloj, tiempo, tema, fuentes, weather |
| `session.json`  | Wallpaper y modo de relleno   |
| `colors.json`   | Esquema de colores (matugen) |

Si usas `dms greeter sync`, estos se enlazan desde tu usuario y no hace falta editarlos a mano.

### Ejemplo `settings.json`

```json
{
  "use24HourClock": true,
  "showSeconds": false,
  "currentThemeName": "blue",
  "fontFamily": "Inter Variable",
  "fontScale": 1.0,
  "cornerRadius": 12,
  "weatherEnabled": true,
  "weatherLocation": "Tu Ciudad",
  "useFahrenheit": false
}
```

### Ejemplo `session.json` (wallpaper)

```json
{
  "wallpaperPath": "/ruta/a/tu/wallpaper.jpg",
  "wallpaperFillMode": "PreserveAspectCrop"
}
```

## 6. Iniciar greetd sin reiniciar

```bash
sudo systemctl start greetd
```

## Referencias

- [DankGreeter – Documentación](https://danklinux.com/docs/dankgreeter/)
- [Configuración](https://danklinux.com/docs/dankgreeter/configuration)
- [Instalación](https://danklinux.com/docs/dankgreeter/installation)
