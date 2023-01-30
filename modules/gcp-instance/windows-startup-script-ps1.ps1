### INSTALL CLOUDFLARE WARP

Start-Service -Name "WLAN AutoConfig"
md -Path $env:temp\warp -erroraction SilentlyContinue | Out-Null
$Download = join-path $env:temp\warp Cloudflare_WARP_Release-x64.msi
#URL needs to be updated on new release
Invoke-WebRequest 'https://1111-releases.cloudflareclient.com/windows/Cloudflare_WARP_Release-x64.msi' -OutFile $Download
Invoke-Expression "$Download /quiet ORGANIZATION=`"mike-demo`" ONBOARDING=false"

### CONFIGURE CLOUDFLARED TUNNEL

Invoke-Expression "cloudflared.exe service install ${tunnel_token}"