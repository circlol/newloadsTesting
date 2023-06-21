Function Get-DisplayResolution {
    $screen = Get-WmiObject -Class Win32_VideoController | Select-Object CurrentHorizontalResolution, CurrentVerticalResolution
    $width = $screen.CurrentHorizontalResolution
    $height = $screen.CurrentVerticalResolution
    $ratio = "{0}:{1}" -f $width, $height

    $aspectRatios = @{
        '3840:2560' = '16:9 (UHD)'
        '3840:2160' = '16:9 (UHD)'
        '2560:1600' = '16:10 (WQXGA)'
        '2560:1440' = '16:9 (WQHD)'
        '2048:1152' = '16:9 (QWXGA)'
        '1920:1200' = '16:10 (WUXGA)'
        '1920:1080' = '16:9 (FHD)'
        '1680:1050' = '16:10 (WSXGA+)'
        '1600:900'  = '16:9 (HD+)'
        '1440:900'  = '16:10 (WXGA+)'
        '1366:768'  = '16:9 (WXGA)'
        '1280:800'  = '16:10 (WXGA)'
        '1280:720'  = '16:9 (HD)'
        '1024:768'  = '4:3 (XGA)'
        '2880:1800' = '8:5 (Retina)'
        '2256:1504' = '3:2'
        '2160:1440' = '3:2 (2160p)'
        '1920:1280' = '3:2 (Surface Pro 3)'
        '1440:960'  = '3:2 (Surface Laptop 3)'
        '2736:1824' = '3:2 (Surface Pro 4)'
    }

    if ($aspectRatios.ContainsKey($ratio)) {
        $aspectRatio = $aspectRatios[$ratio]
    }
    else {
        $aspectRatio = $ratio
    }

    return @{
        Resolution = "$width x $height"
        AspectRatio = $aspectRatio
    }
}
