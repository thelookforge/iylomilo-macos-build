# iylomilo macOS installer build

This project creates a universal macOS installer for **iylomilo by thefadlyma**. The installer offers three selectable formats:

- **AU** for Logic Pro, GarageBand, and other Audio Unit hosts
- **VST3** for Ableton Live, Cubase, REAPER, and other VST3 hosts
- **CLAP** for DAWs that support CLAP

The plug-ins are built for Apple Silicon and Intel Macs, with macOS 11 or newer as the deployment target.

## Build the installer on a Mac

1. Install Xcode Command Line Tools by opening Terminal and running `xcode-select --install`.
2. Install CMake. If Homebrew is already installed, run `brew install cmake`.
3. Unzip this project on the Mac and open Terminal in the unzipped `iylomilo-source` folder.
4. Run:

   ```sh
   chmod +x tools/make_installer_mac.sh
   ./tools/make_installer_mac.sh
   ```

The completed package will be created in `dist/iylomilo-1.0-macOS-universal.pkg`. The installer lets the user choose AU, VST3, CLAP, or any combination. Plug-ins install in the standard system audio plug-in folders.

## Signing note

The package produced by this script is unsigned and not notarized by Apple. macOS may show a security warning when it is opened. A Developer ID Installer certificate and Apple notarization are required for a signed, notarized release.
