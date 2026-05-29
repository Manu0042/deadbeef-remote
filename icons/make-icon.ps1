param(
  [int]$Size = 192,
  [string]$Out = "icon-192.png"
)
Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap($Size, $Size)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = 'AntiAlias'
$g.TextRenderingHint = 'AntiAlias'

# Background — dark rounded square (maskable safe zone)
$bg = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(26,26,26))
$g.FillRectangle($bg, 0, 0, $Size, $Size)

# Inner accent disc
$pad = [int]($Size * 0.18)
$disc = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(214,40,40))
$g.FillEllipse($disc, $pad, $pad, $Size - 2*$pad, $Size - 2*$pad)

# Note glyph
$font = New-Object System.Drawing.Font("Segoe UI Symbol", [single]($Size * 0.46), [System.Drawing.FontStyle]::Bold)
$txtBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
$sf = New-Object System.Drawing.StringFormat
$sf.Alignment = 'Center'
$sf.LineAlignment = 'Center'
$rect = New-Object System.Drawing.RectangleF(0, [single]($Size * -0.02), $Size, $Size)
$g.DrawString([char]0x266B, $font, $txtBrush, $rect, $sf)

$g.Dispose()
$bmp.Save($Out, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "Wrote $Out ($Size x $Size)"
