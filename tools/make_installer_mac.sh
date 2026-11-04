#!/bin/zsh
# Build an unsigned universal macOS installer for AU, VST3, and CLAP.
# Run this script on a Mac with Xcode Command Line Tools and CMake installed.
set -euo pipefail

ROOT=${0:A:h:h}
cd "$ROOT"

if [[ "$(uname -s)" != "Darwin" ]]; then
    print -u2 "This installer must be built on macOS; this computer is not running Darwin."
    exit 1
fi

for tool in cmake pkgbuild productbuild plutil ditto xcrun; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        print -u2 "Required tool is missing: $tool"
        print -u2 "Install Xcode Command Line Tools, then install CMake (for example: brew install cmake)."
        exit 1
    fi
done

if ! xcrun --sdk macosx --show-sdk-path >/dev/null 2>&1; then
    print -u2 "The macOS SDK was not found. Install Xcode Command Line Tools and try again."
    exit 1
fi

VERSION=$(sed -n 's/^project(iylomilo VERSION \([0-9.]*\).*/\1/p' CMakeLists.txt)
[[ -n $VERSION ]] || { print -u2 "Could not read the version from CMakeLists.txt."; exit 1; }

BUILD="$ROOT/build/macos"
WORK="$ROOT/build/macos-installer"
OUT="$ROOT/dist/iylomilo-$VERSION-macOS-universal.pkg"
JOBS=$(sysctl -n hw.ncpu 2>/dev/null || print 4)

print "Configuring universal Apple Silicon + Intel build..."
cmake -S "$ROOT" -B "$BUILD" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64" \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=11.0 \
    -DIYLOMILO_COPY_AFTER_BUILD=OFF

print "Building AU, VST3, and CLAP plug-ins..."
cmake --build "$BUILD" --config Release --parallel "$JOBS" \
    --target TheCalm_AU TheCalm_VST3 TheCalm_CLAP

ARTEFACTS="$BUILD/TheCalm_artefacts/Release"
[[ -d "$ARTEFACTS/AU/iylomilo.component" ]] || { print -u2 "AU build output was not found."; exit 1; }
[[ -d "$ARTEFACTS/VST3/iylomilo.vst3" ]] || { print -u2 "VST3 build output was not found."; exit 1; }
[[ -d "$ARTEFACTS/CLAP/iylomilo.clap" ]] || { print -u2 "CLAP build output was not found."; exit 1; }

rm -rf "$WORK"
mkdir -p "$WORK/packages" "$ROOT/dist"

# format | bundle path | standard macOS install location
COMPONENTS=(
    "au|AU/iylomilo.component|/Library/Audio/Plug-Ins/Components"
    "vst3|VST3/iylomilo.vst3|/Library/Audio/Plug-Ins/VST3"
    "clap|CLAP/iylomilo.clap|/Library/Audio/Plug-Ins/CLAP"
)

for entry in $COMPONENTS; do
    IFS='|' read -r id artefact location <<< "$entry"
    stage="$WORK/stage/$id"
    mkdir -p "$stage"
    ditto "$ARTEFACTS/$artefact" "$stage/${artefact:t}"

    # Prevent Installer from relocating a bundle to an unrelated existing copy.
    pkgbuild --analyze --root "$stage" "$WORK/$id.plist" >/dev/null
    plutil -replace 0.BundleIsRelocatable -bool NO "$WORK/$id.plist"
    pkgbuild --root "$stage" --component-plist "$WORK/$id.plist" \
        --identifier "com.thefadlyma.iylomilo.$id" --version "$VERSION" \
        --install-location "$location" "$WORK/packages/$id.pkg" >/dev/null
done

cat > "$WORK/distribution.xml" <<EOF
<?xml version="1.0" encoding="utf-8"?>
<installer-gui-script minSpecVersion="2">
    <title>iylomilo $VERSION</title>
    <organization>com.thefadlyma</organization>
    <domains enable_localSystem="true"/>
    <options customize="always" require-scripts="false" hostArchitectures="arm64,x86_64"/>
    <welcome file="welcome.txt" mime-type="text/plain"/>
    <license file="license.txt" mime-type="text/plain"/>
    <choices-outline>
        <line choice="au"/>
        <line choice="vst3"/>
        <line choice="clap"/>
    </choices-outline>
    <choice id="au" title="AU" description="Audio Units, including Logic Pro and GarageBand." start_selected="true">
        <pkg-ref id="com.thefadlyma.iylomilo.au"/>
    </choice>
    <choice id="vst3" title="VST3" description="VST3 plug-in for Ableton Live, Cubase, REAPER, and other hosts." start_selected="true">
        <pkg-ref id="com.thefadlyma.iylomilo.vst3"/>
    </choice>
    <choice id="clap" title="CLAP" description="CLAP plug-in for compatible audio workstations." start_selected="true">
        <pkg-ref id="com.thefadlyma.iylomilo.clap"/>
    </choice>
    <pkg-ref id="com.thefadlyma.iylomilo.au" version="$VERSION">au.pkg</pkg-ref>
    <pkg-ref id="com.thefadlyma.iylomilo.vst3" version="$VERSION">vst3.pkg</pkg-ref>
    <pkg-ref id="com.thefadlyma.iylomilo.clap" version="$VERSION">clap.pkg</pkg-ref>
</installer-gui-script>
EOF

mkdir -p "$WORK/resources"
cat > "$WORK/resources/welcome.txt" <<EOF
iylomilo $VERSION by thefadlyma

A playful pitch-shifting effect for your Mac DAW.

Choose Customize during installation to select AU, VST3, CLAP, or any combination.
After installation, restart your DAW and rescan plug-ins if iylomilo does not appear.

This package is not signed or notarized by Apple. macOS may show a security warning
when opening it. A Developer ID Installer certificate and Apple notarization are
needed for a signed, notarized release.
EOF
cp "$ROOT/LICENSE" "$WORK/resources/license.txt"

print "Packaging the macOS installer..."
productbuild --distribution "$WORK/distribution.xml" \
    --package-path "$WORK/packages" \
    --resources "$WORK/resources" "$OUT" >/dev/null

print "Created: $OUT"
