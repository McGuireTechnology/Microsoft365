# Office Deployment Tool setup

This folder contains a Microsoft Office Deployment Tool bootstrapper and a
32-bit Microsoft 365 Apps configuration file.

## Files

| File | Purpose |
| --- | --- |
| `OfficeSetup.exe` | Office Deployment Tool executable. |
| `configuration-32bit.xml` | Installs 32-bit Microsoft 365 Apps in English from the Current Channel. |
| `OfficeSetup-help.txt` | Captured help text for the setup executable. |

## Quick start: install 32-bit Office

Open PowerShell in this folder:

```powershell
cd C:\Users\nmcguire\Documents\GitHub\Microsoft365\Office
```

Run the 32-bit install:

```powershell
.\OfficeSetup.exe /configure .\configuration-32bit.xml
```

If setup does not display help directly in PowerShell, pipe the output:

```powershell
.\OfficeSetup.exe /? 2>&1 | Out-String
```

## Setup modes

| Command | Use |
| --- | --- |
| `.\OfficeSetup.exe /download .\configuration.xml` | Download Office installation files for the products and languages in the XML. |
| `.\OfficeSetup.exe /configure .\configuration.xml` | Install, remove, or configure Office using the XML. |
| `.\OfficeSetup.exe /customize .\configuration.xml` | Apply Office application preferences only. |
| `.\OfficeSetup.exe /? 2>&1 \| Out-String` | Show help when PowerShell does not render it directly. |

## Current 32-bit configuration

```xml
<Configuration>
  <Add OfficeClientEdition="32" Channel="Current">
    <Product ID="O365ProPlusRetail">
      <Language ID="en-us" />
    </Product>
  </Add>

  <Display Level="Full" AcceptEULA="TRUE" />
</Configuration>
```

The key 32-bit setting is:

```xml
OfficeClientEdition="32"
```

Important: Office does not support mixed 32-bit and 64-bit Click-to-Run
installations on the same machine. If Microsoft 365 Apps is already installed,
the configured architecture must match the existing architecture unless you use
`MigrateArch="TRUE"`.

## Common configuration options

### Add

Defines what Office should download or install.

Common attributes:

| Attribute | Example | Notes |
| --- | --- | --- |
| `OfficeClientEdition` | `OfficeClientEdition="32"` | Use `32` or `64`. If omitted on a clean machine, ODT generally chooses 64-bit unless Windows is 32-bit or RAM is below 4 GB. |
| `Channel` | `Channel="Current"` | Update channel to install from. Common values include `Current`, `MonthlyEnterprise`, and `SemiAnnual`. |
| `SourcePath` | `SourcePath="\\server\share"` | Local or network source path for Office installation files. |
| `DownloadPath` | `DownloadPath="\\server\source"` | Alternate download source. When used, Microsoft requires a `Version`. |
| `Version` | `Version="16.0.12345.67890"` | Specific Office build, or values such as `MatchInstalled` for some scenarios. |
| `MigrateArch` | `MigrateArch="TRUE"` | Switch an existing Office install between 32-bit and 64-bit. |
| `OfficeMgmtCOM` | `OfficeMgmtCOM="TRUE"` | Enables Configuration Manager management of Office updates. |

Example:

```xml
<Add OfficeClientEdition="32" Channel="Current">
  <Product ID="O365ProPlusRetail">
    <Language ID="en-us" />
  </Product>
</Add>
```

### Product

Defines the Office product to install.

Common product IDs:

| Product ID | Use |
| --- | --- |
| `O365ProPlusRetail` | Microsoft 365 Apps for enterprise |
| `O365BusinessRetail` | Microsoft 365 Apps for business |
| `VisioProRetail` | Visio desktop app |
| `ProjectProRetail` | Project desktop app |

Example:

```xml
<Product ID="O365ProPlusRetail">
  <Language ID="en-us" />
</Product>
```

For the full product list, use Microsoft's supported product ID reference.

### Language

Defines the Office language packages.

Example:

```xml
<Language ID="en-us" />
<Language ID="es-es" />
```

### ExcludeApp

Prevents selected apps from being installed.

Common IDs include `Access`, `Excel`, `Groove`, `Lync`, `OneDrive`, `OneNote`,
`Outlook`, `OutlookForWindows`, `PowerPoint`, `Publisher`, `Teams`, and `Word`.

Notes:

- For legacy OneDrive exclusion, Microsoft documents `Groove`.
- For Skype for Business, use `Lync`.
- `OutlookForWindows` refers to the new Outlook app.

Example:

```xml
<Product ID="O365ProPlusRetail">
  <Language ID="en-us" />
  <ExcludeApp ID="Access" />
  <ExcludeApp ID="Publisher" />
  <ExcludeApp ID="Teams" />
</Product>
```

### Display

Controls the user interface during installation.

| Attribute | Values | Notes |
| --- | --- | --- |
| `Level` | `Full`, `None` | `Full` shows the normal install UI. `None` is silent. |
| `AcceptEULA` | `TRUE`, `FALSE` | `TRUE` accepts the license prompt. |

Interactive:

```xml
<Display Level="Full" AcceptEULA="TRUE" />
```

Silent:

```xml
<Display Level="None" AcceptEULA="TRUE" />
```

### Updates

Controls Office update behavior after installation.

Common attributes:

| Attribute | Example | Notes |
| --- | --- | --- |
| `Enabled` | `Enabled="TRUE"` | Enables or disables Office update checks. |
| `UpdatePath` | `UpdatePath="\\server\share"` | Uses a local, network, or HTTP path for updates. |
| `Channel` | `Channel="Current"` | Update channel to use after install. |

Example:

```xml
<Updates Enabled="TRUE" Channel="Current" />
```

### RemoveMSI

Removes older MSI-based Office, Visio, or Project installations before
installing Microsoft 365 Apps.

Example:

```xml
<RemoveMSI />
```

You can preserve specific MSI products with `IgnoreProduct`:

```xml
<RemoveMSI>
  <IgnoreProduct ID="VisPro" />
</RemoveMSI>
```

### Remove

Removes Click-to-Run Office products or languages.

Remove everything:

```xml
<Configuration>
  <Remove All="TRUE" />
  <Display Level="Full" AcceptEULA="TRUE" />
</Configuration>
```

Remove a specific language from a product:

```xml
<Configuration>
  <Remove All="FALSE">
    <Product ID="O365ProPlusRetail">
      <Language ID="es-es" />
    </Product>
  </Remove>
</Configuration>
```

### AppSettings

Applies Office application preferences. Microsoft recommends using the Office
Customization Tool to generate these settings because the registry-backed
preference IDs are verbose and easy to mistype.

Example shape:

```xml
<AppSettings>
  <User Key="software\microsoft\office\16.0\excel\security"
        Name="vbawarnings"
        Value="3"
        Type="REG_DWORD"
        App="excel16"
        Id="L_VBAWarningsPolicy" />
</AppSettings>
```

## Example configurations

### 32-bit, English, interactive install

```xml
<Configuration>
  <Add OfficeClientEdition="32" Channel="Current">
    <Product ID="O365ProPlusRetail">
      <Language ID="en-us" />
    </Product>
  </Add>

  <Display Level="Full" AcceptEULA="TRUE" />
</Configuration>
```

### 32-bit, English, silent install, remove older MSI Office

```xml
<Configuration>
  <Add OfficeClientEdition="32" Channel="Current">
    <Product ID="O365ProPlusRetail">
      <Language ID="en-us" />
      <ExcludeApp ID="Access" />
      <ExcludeApp ID="Publisher" />
    </Product>
  </Add>

  <RemoveMSI />
  <Display Level="None" AcceptEULA="TRUE" />
  <Updates Enabled="TRUE" Channel="Current" />
</Configuration>
```

### Migrate an existing 64-bit install to 32-bit

```xml
<Configuration>
  <Add OfficeClientEdition="32" MigrateArch="TRUE" />
  <Display Level="Full" AcceptEULA="TRUE" />
</Configuration>
```

## Logs

If setup fails, check recent log files in your temp directory:

```powershell
Get-ChildItem $env:TEMP -Filter "*.log" |
  Sort-Object LastWriteTime -Descending |
  Select-Object -First 10 FullName, LastWriteTime
```

## Troubleshooting notes

### Setup stays at bootstrapping

On this machine, the Office installer did not move past the bootstrapping stage
while both Microsoft Access Database Engine 2010 and Microsoft Access Database
Engine 2007 were installed.

If setup appears stuck before the Office installation UI or progress begins,
check installed apps for those Access Database Engine components and remove the
old/conflicting versions before running `OfficeSetup.exe` again.

## References

- Microsoft Learn: Office Deployment Tool overview
  https://learn.microsoft.com/deployoffice/overview-office-deployment-tool
- Microsoft Learn: Configuration options for the Office Deployment Tool
  https://learn.microsoft.com/en-us/microsoft-365-apps/deploy/office-deployment-tool-configuration-options
- Microsoft Learn: Product IDs supported by the Office Deployment Tool
  https://learn.microsoft.com/en-us/troubleshoot/microsoft-365-apps/office-suite-issues/product-ids-supported-office-deployment-click-to-run
- Microsoft Learn: Change Microsoft 365 Apps between 32-bit and 64-bit
  https://learn.microsoft.com/en-us/microsoft-365-apps/deploy/change-bitness
