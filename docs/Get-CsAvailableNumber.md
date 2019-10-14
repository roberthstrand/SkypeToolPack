# Get-CSAvailableNumber

## Syntax

```powershell
Get-CsAvailableNumber [-StartNumber] <int> [-EndNumber] <int> [-ShowAll] [<CommonParameters>]
```

## Example, showing the next available number

```powershell
Get-CsAvailableNumber -StartNumber 77600000 -EndNumber 77699999
```

## Example, showing all available number

```powershell
Get-CsAvailableNumber -StartNumber 77600000 -EndNumber 77699999 -ShowAll
```
