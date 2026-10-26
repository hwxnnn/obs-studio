# OBS Webcam for macOS

This fork is based on OBS Studio 33.0.0. Its macOS camera device is named
**Logitech C920 HD Pro Webcam**. The provider manufacturer is `Logitech`, the model
has the same camera name, and the idle feed is black. These are software-supplied
names; this fork is an OBS virtual camera, not a Logitech product.

The app is `OBS Webcam.app` (`com.hwxnnn.obs-webcam`) and its extension is
`com.hwxnnn.obs-webcam.camera-extension`. The `macos-webcam` CMake preset uses
separate, stable device and stream UUIDs. Official OBS and this extension can
coexist. OBS's upstream automatic updater is disabled in the preset so an update
does not replace the fork.

## USB identity and websites

The requested `USB\VID_046D&PID_082D` is a Windows Plug and Play hardware ID.
Renaming a CoreMediaIO camera extension on macOS does not create a USB device,
assign USB vendor/product descriptors, or make this identifier available through
WebUSB. The extension retains its virtual transport type. No physical USB
identity or website acceptance is claimed.

Websites using `getUserMedia()` / `enumerateDevices()` can see the camera label
once camera permission allows it. WebRTC device IDs are browser-managed and
origin-scoped. A site can still reject virtual cameras or inspect capabilities;
this fork does not change the browser, bypass permissions, or emulate the C920's
hardware controls or its complete supported format list.

## Build

Use an Apple Silicon Mac, Xcode, CMake 3.28 or newer, and an Apple Developer team
with camera/system-extension signing capabilities. The preset fetches upstream
OBS dependencies with their pinned SHA-256 hashes and enables browser sources.

```sh
CODESIGN_TEAM=YOUR_TEAM_ID ./build-aux/build-webcam-macos.sh
```

Xcode automatic signing is used by default. `-allowProvisioningUpdates` lets Xcode
create or fetch signing assets for the fork's new identifiers using the account
already configured in Xcode. You must be signed into the corresponding team.
The host app and camera extension must be signed by the same team with valid
entitlements and provisioning profiles. An ad-hoc or unsigned build is useful
for compilation checks but cannot be assumed to activate the camera extension.

## Install and check

1. Copy the built `OBS Webcam.app` into `/Applications`.
2. Open it and select **Start Virtual Camera**.
3. Approve the camera extension in macOS System Settings when prompted. The exact
   location depends on the macOS version; OBS links its camera troubleshooting
   guide below. Restart the browser if it was open during activation.
4. Start the local diagnostic page:

   ```sh
   python3 -m http.server 8765 --bind 127.0.0.1 --directory docs/webcam
   ```

5. Open `http://localhost:8765/check.html`, click **Allow camera access**, then
   choose **Logitech C920 HD Pro Webcam** and click **Preview selected camera**.
   The page shows the actual label, settings and supported track capabilities.
6. Change the OBS scene and confirm the preview changes. Stop the virtual camera
   and confirm the idle feed becomes black. Repeat in the target website's own
   camera selector.

The diagnostic page serves no external resources and sends no video to a server.
Browser permission and extension activation require local user interaction.

## Upstream references

- [OBS macOS build instructions](https://github.com/obsproject/obs-studio/wiki/Build-Instructions-For-Mac)
- [OBS virtual camera troubleshooting](https://obsproject.com/kb/virtual-camera-troubleshooting)
- [Apple: Creating a camera extension](https://developer.apple.com/documentation/coremediaio/creating-a-camera-extension-with-core-media-i-o)
- [Microsoft: USB identifiers](https://learn.microsoft.com/en-us/windows-hardware/drivers/install/identifiers-for-usb-devices)
- [W3C: Media Capture and Streams](https://www.w3.org/TR/mediacapture-streams/)

OBS's GPL license, source notices, and attributions are retained in this fork.
