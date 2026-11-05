# iylomilo macOS VST3

This workflow builds the **VST3 plug-in only** as a universal macOS bundle for Apple Silicon and Intel Macs. It supports macOS 11 or newer and does not create a `.pkg` installer.

## Download the plug-in

1. Open the repository's **Actions** tab and select **Build iylomilo macOS VST3**.
2. Click **Run workflow**. When the run finishes successfully, download the `iylomilo-macOS-universal-VST3` artifact.
3. Extract the downloaded artifact ZIP. Inside it, extract `iylomilo-1.0-macOS-universal-VST3.zip` to get the `iylomilo.vst3` plug-in bundle.

## Install

1. Quit your DAW.
2. In Finder, choose **Go → Go to Folder…** and enter:

   ```text
   ~/Library/Audio/Plug-Ins/VST3
   ```

   If the `VST3` folder does not exist, create it.
3. Copy the whole `iylomilo.vst3` bundle into that folder.
4. Reopen your DAW and rescan its plug-ins if iylomilo does not appear.

The plug-in is currently unsigned and not notarized by Apple. Some macOS systems or DAWs may show a security warning or block it.
