# SkypeToolPack

When I started working with Skype for Business, I quickly started to write scripts to check the services on some of the Enterprise frontend pools I helped manage. When people started asking for these scripts I figured it would be easier if I made it into a module and published it online.

## Installation

You can install the module manually but when I'm done with a new feature or bug fix I quickly upload the module to [PowerShellGallery](https://www.powershellgallery.com/packages/SkypeToolPack/). You can easily install the module with the following:

```powershell
Install-Module -Name SkypeToolPack
```

For the majority of the cmdlets, you need to have the Skype for Business administration tools installed on the machine but some cmdlets require the *ActiveDirectory* module.

[Documentation](docs/index.md)