# Create UEFI ISO Hybris

## Sources
- [modGRUBShell.efi](https://github.com/datasone/grub-mod-setup_var/releases/)
- [ReBarUEFI](https://github.com/xCuri0/ReBarUEFI)

# Usage instruction

How to use `modGRUBShell.efi`, please, read ReBarUEFI instructions

## Lenovo M720Q BIOS
For Lenovo M720Q with BIOS/UEFI `M1UKT77A/1.0.0.119 25 Apr 2024`
Default Above 4GB MMIO BIOS assignment is `0x00`:
```commandline
SuppressIf 
    EqIdVal QuestionId: 0x2746, Value: 0xF
    OneOf Prompt: "Above 4GB MMIO BIOS assignment", Help: "Enable/Disable above 4GB MemoryMappedIO BIOS assignment

This is enabled automatically when Aperture Size is set to 2048MB.", QuestionFlags: 0x10, QuestionId: 0x54, VarStoreId: 0x1, VarOffset: 0xA49, Flags: 0x10, Size: 8, Min: 0x0, Max: 0x1, Step: 0x0
        OneOfOption Option: "Enabled" Value: 1
        OneOfOption Option: "Disabled" Value: 0, Default, MfgDefault
    End 
End 
```

**Enable ReBAR**: `setup_var 0xA49 0x1`

**Disable ReBAR**: `setup_var 0xA49 0x0`

### Additional info related to M720Q BIOS
```commandline
OneOf Prompt: "Max TOLUD", Help: "Maximum Value of TOLUD. Dynamic assignment would adjust TOLUD automatically based on largest MMIO length of installed graphic controller", QuestionFlags: 0x14, QuestionId: 0x2744, VarStoreId: 0x1, VarOffset: 0xA80, Flags: 0x10, Size: 8, Min: 0x0, Max: 0xB, Step: 0x0
    OneOfOption Option: "Dynamic" Value: 0, Default, MfgDefault
    OneOfOption Option: "1 GB" Value: 1
    OneOfOption Option: "1.25 GB" Value: 2
    OneOfOption Option: "1.5 GB" Value: 3
    OneOfOption Option: "1.75 GB" Value: 4
    OneOfOption Option: "2 GB" Value: 5
    OneOfOption Option: "2.25 GB" Value: 6
    OneOfOption Option: "2.5 GB" Value: 7
    OneOfOption Option: "2.75 GB" Value: 8
    OneOfOption Option: "3 GB" Value: 9
    OneOfOption Option: "3.25 GB" Value: 10
    OneOfOption Option: "3.5 GB" Value: 11
End 

SuppressIf 
    EqIdVal QuestionId: 0x2746, Value: 0xF
    OneOf Prompt: "Above 4GB MMIO BIOS assignment", Help: "Enable/Disable above 4GB MemoryMappedIO BIOS assignment

This is enabled automatically when Aperture Size is set to 2048MB.", QuestionFlags: 0x10, QuestionId: 0x54, VarStoreId: 0x1, VarOffset: 0xA49, Flags: 0x10, Size: 8, Min: 0x0, Max: 0x1, Step: 0x0
        OneOfOption Option: "Enabled" Value: 1
        OneOfOption Option: "Disabled" Value: 0, Default, MfgDefault
    End 
End 
        
OneOf Prompt: "Aperture Size", Help: "Select the Aperture Size

Note : Above 4GB MMIO BIOS assignment is automatically enabled when selecting 2048MB aperture. To use this feature, please disable CSM Support.", QuestionFlags: 0x14, QuestionId: 0x2746, VarStoreId: 0x1, VarOffset: 0x993, Flags: 0x10, Size: 8, Min: 0x0, Max: 0xF, Step: 0x0
    OneOfOption Option: "128MB" Value: 0
    OneOfOption Option: "256MB" Value: 1, Default, MfgDefault
    OneOfOption Option: "512MB" Value: 3
    OneOfOption Option: "1024MB" Value: 7
    OneOfOption Option: "2048MB" Value: 15
End   
```


## Project tree
```
├── content
│   ├── modGRUBShell.efi
│   └── v1.4
├── mk_hybrid_iso.sh
└── Readme.md
```

## Build Hybrid iso
Run:
```    
$ ./mk_hybrid_iso.sh
```
    




