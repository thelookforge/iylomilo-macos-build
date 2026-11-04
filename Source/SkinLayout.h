// Coordinates for the supplied iylomilo design, scaled to 1024 x 1080.
#pragma once

namespace SkinLayout
{
inline constexpr float width = 1024.0f, height = 1080.0f;

// Knob centres, visual radii and live-pointer dimensions in artwork pixels.
struct Knob { float cx, cy, radius, pointerIn, pointerOut, pointerWidth; };
inline constexpr Knob input  { 280.0f, 120.0f, 21.5f, 3.0f, 17.5f, 3.4f };
inline constexpr Knob gate   { 366.0f, 120.0f, 21.5f, 3.0f, 17.5f, 3.4f };
inline constexpr Knob blend  { 665.0f, 120.0f, 21.5f, 3.0f, 17.5f, 3.4f };
inline constexpr Knob output { 748.0f, 120.0f, 21.5f, 3.0f, 17.5f, 3.4f };
inline constexpr Knob chill  { 512.0f, 455.0f, 64.0f, 3.0f, 38.0f, 2.6f };
inline constexpr Knob order  { 324.0f, 577.0f, 66.0f, 2.2f, 39.0f, 2.2f };
inline constexpr Knob sloth  { 701.0f, 577.0f, 66.0f, 2.2f, 39.0f, 2.2f };
inline constexpr Knob rise   { 512.0f, 582.0f, 39.0f, 1.6f, 23.0f, 1.7f };

struct Circle { float cx, cy, radius; };
inline constexpr Circle prevButton { 420.0f, 180.0f, 20.0f };
inline constexpr Circle nextButton { 603.0f, 180.0f, 20.0f };
inline constexpr Circle led { 512.0f, 936.0f, 9.0f };
inline constexpr Circle upSwitch { 292.0f, 916.0f, 36.0f };
inline constexpr Circle wayUpSwitch { 732.0f, 916.0f, 36.0f };
inline constexpr float upSwitchAxis = 292.0f, wayUpSwitchAxis = 732.0f;

struct Rect { float x0, y0, x1, y1; };
inline constexpr Rect presetWindow { 425.0f, 165.0f, 599.0f, 197.0f };
inline constexpr bool presetWindowIsDark = true;
inline constexpr Rect toggle { 488.0f, 211.0f, 536.0f, 237.0f };
inline constexpr float toggleMirrorX = 512.0f;

inline constexpr int meterLamps = 7;
inline constexpr float meterLampY[meterLamps] { 96.0f, 111.0f, 126.0f, 141.0f, 156.0f, 171.0f, 186.0f };
inline constexpr Rect meterLeft { 203.0f, 96.0f, 227.0f, 186.0f };
inline constexpr Rect meterRight { 797.0f, 96.0f, 821.0f, 186.0f };
} // namespace SkinLayout
