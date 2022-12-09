### INSTALL WINDOWS FEATURES

# Prerequisite for WARP-Client
install-WindowsFeature Wireless-Networking
# Simple Services to test policies
install-WindowsFeature Simple-TCPIP
# Client to access Simple-TCPIP-Services
install-WindowsFeature telnet-client

### INSTALL GOOGLE CHROME

# Create a temporary directory to store Google Chrome.
md -Path $env:temp\chromeinstall -erroraction SilentlyContinue | Out-Null
$Download = join-path $env:temp\chromeinstall chrome_installer.exe

# Download the Google Chrome installer.
Invoke-WebRequest 'https://dl.google.com/chrome/install/latest/chrome_installer.exe'  -OutFile $Download

# Perform a silent installation of Google Chrome.
Invoke-Expression "$Download /silent /install"
 
### INSTALL CLOUDFLARE ROOT-CERT

md -Path $env:temp\cfcert -erroraction SilentlyContinue | Out-Null
$Download = join-path $env:temp\cfcert Cloudflare_CA.crt
Invoke-WebRequest 'https://developers.cloudflare.com/cloudflare-one/static/documentation/connections/Cloudflare_CA.crt'  -OutFile $Download
Import-Certificate -FilePath $Download -CertStoreLocation Cert:\LocalMachine\Root

### INSTALL CLOUDFLARED

md -Path $env:temp\cloudflared -erroraction SilentlyContinue | Out-Null
$Download = join-path $env:temp\cloudflared cloudflared-windows-amd64.msi
Invoke-WebRequest 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.msi'  -OutFile $Download
Invoke-Expression "$Download /quiet"

### INSTALL CLOUDFLARE WARP

Start-Service -Name "WLAN AutoConfig"
md -Path $env:temp\warp -erroraction SilentlyContinue | Out-Null
$Download = join-path $env:temp\warp Cloudflare_WARP_Release-x64.msi
#URL needs to be updated on new release
Invoke-WebRequest 'https://1111-releases.cloudflareclient.com/windows/Cloudflare_WARP_Release-x64.msi' -OutFile $Download
Invoke-Expression "$Download /quiet ORGANIZATION=`"mike-demo`" ONBOARDING=false"

### Reboot VM to start Service "nativewifip" (Prerequisite)

Restart-Computer