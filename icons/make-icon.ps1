param(
  [int]$Size = 192,
  [string]$Out = "icon-192.png"
)
Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap($Size, $Size)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = 'AntiAlias'

# Theme colors — match the app's pale-orange / accent-orange theme
$bgColor      = [System.Drawing.Color]::FromArgb(0xfd, 0xe4, 0xcf)  # #fde4cf  pale orange
$accentColor  = [System.Drawing.Color]::FromArgb(0xe8, 0x59, 0x0c)  # #e8590c  saturated orange

# Solid background — full bleed so the icon also works as a maskable
$bg = New-Object System.Drawing.SolidBrush $bgColor
$g.FillRectangle($bg, 0, 0, $Size, $Size)

# --- Front-view speaker (Deezer-style audio output icon) -------------------------
# Layout:
#   [ rounded rectangular cabinet ]
#       small circle (tweeter) up top
#       larger circle (woofer)  below, with a small dot at its center
# Sized to sit inside the maskable safe zone (~70% of the icon).

$cx = $Size / 2.0
$cy = $Size / 2.0

$cabW = $Size * 0.50    # cabinet width
$cabH = $Size * 0.72    # cabinet height (taller than wide — speaker proportions)
$cabR = $Size * 0.10    # corner radius
$cabL = $cx - $cabW / 2
$cabT = $cy - $cabH / 2
$cabB = $cy + $cabH / 2

$accent = New-Object System.Drawing.SolidBrush $accentColor
$thinPen = New-Object System.Drawing.Pen $bgColor, ([single]($Size * 0.018))

# Build a rounded-rectangle path for the cabinet
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$d = [single](2 * $cabR)
$path.AddArc([single]$cabL,                 [single]$cabT,                 $d, $d, [single]180, [single]90)
$path.AddArc([single]($cabL + $cabW - $d),  [single]$cabT,                 $d, $d, [single]270, [single]90)
$path.AddArc([single]($cabL + $cabW - $d),  [single]($cabT + $cabH - $d),  $d, $d, [single]0,   [single]90)
$path.AddArc([single]$cabL,                 [single]($cabT + $cabH - $d),  $d, $d, [single]90,  [single]90)
$path.CloseFigure()
$g.FillPath($accent, $path)

# Tweeter — small circle near the top of the cabinet (cut into the cabinet by
# drawing in the background color)
$tweeterR = $Size * 0.055
$tweeterCY = $cabT + $cabH * 0.18
$tweeterRect = New-Object System.Drawing.RectangleF (
  [single]($cx - $tweeterR),
  [single]($tweeterCY - $tweeterR),
  [single](2 * $tweeterR),
  [single](2 * $tweeterR)
)
$bgBrush = New-Object System.Drawing.SolidBrush $bgColor
$g.FillEllipse($bgBrush, $tweeterRect)

# Woofer — large circle below center, with a thin pale ring (drawn as fill in
# bg color to "punch out" the speaker face) and a small accent dot in the middle
$wooferR = $Size * 0.155
$wooferCY = $cabT + $cabH * 0.62
$wooferRect = New-Object System.Drawing.RectangleF (
  [single]($cx - $wooferR),
  [single]($wooferCY - $wooferR),
  [single](2 * $wooferR),
  [single](2 * $wooferR)
)
$g.FillEllipse($bgBrush, $wooferRect)

# Inner ring — a thinner accent ring inside the woofer cone for depth
$ringInner = $wooferR - $Size * 0.035
$ringRect = New-Object System.Drawing.RectangleF (
  [single]($cx - $ringInner),
  [single]($wooferCY - $ringInner),
  [single](2 * $ringInner),
  [single](2 * $ringInner)
)
$g.FillEllipse($accent, $ringRect)

# Dust cap (center dot) in bg color
$dotR = $Size * 0.045
$dotRect = New-Object System.Drawing.RectangleF (
  [single]($cx - $dotR),
  [single]($wooferCY - $dotR),
  [single](2 * $dotR),
  [single](2 * $dotR)
)
$g.FillEllipse($bgBrush, $dotRect)

$path.Dispose()
$thinPen.Dispose()
$g.Dispose()
$bmp.Save($Out, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "Wrote $Out ($Size x $Size)"
