# FUN_004dfed2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dfed2
# extent:       0x004dfed2-0x004dfff3 (289 code bytes)
# span:         0x004dfed2-0x004dfff3 (code 289, tables 0, padding 0)
# sha256:       a4ed95e5a6dca5f25dbe0662e7afc638c62a7636b1ba25f5dfa01416808ed4c6
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004dfed2
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_64, local_68
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ca3e, KERNEL32.dll!WritePrivateProfileStringA, FUN_0050ce04
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 78 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68

# --- external targets -----------------------------------------------
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004dfed2 - 0x401000
.globl FUN_004dfed2
FUN_004dfed2:
    # block 0x004dfed2: entry, 78 instruction(s), calls FUN_0050ca3e, KERNEL32.dll!WritePrivateProfileStringA, FUN_0050ce04, ends with ret
    push ebp                                     # 004dfed2
    {load} mov ebp, esp                          # 004dfed3
    sub esp, 0x68                                # 004dfed5
    mov dword ptr [ebp - local_68], ecx          # 004dfed8
    mov eax, dword ptr [0x5bb202]                # 004dfedb
    push eax                                     # 004dfee0
    push 0x55b9c0                                # 004dfee1
    lea ecx, [ebp - local_64]                    # 004dfee6
    push ecx                                     # 004dfee9
    call FUN_0050ca3e                            # 004dfeea
    add esp, 0xc                                 # 004dfeef
    push 0x639897                                # 004dfef2
    lea edx, [ebp - local_64]                    # 004dfef7
    push edx                                     # 004dfefa
    push 0x55b9c4                                # 004dfefb
    push 0x55b9d8                                # 004dff00
    call dword ptr [0x52a26c]                    # 004dff05
    mov eax, dword ptr [0x5bb206]                # 004dff0b
    push eax                                     # 004dff10
    push 0x55b9e4                                # 004dff11
    lea ecx, [ebp - local_64]                    # 004dff16
    push ecx                                     # 004dff19
    call FUN_0050ca3e                            # 004dff1a
    add esp, 0xc                                 # 004dff1f
    push 0x639897                                # 004dff22
    lea edx, [ebp - local_64]                    # 004dff27
    push edx                                     # 004dff2a
    push 0x55b9e8                                # 004dff2b
    push 0x55b9f4                                # 004dff30
    call dword ptr [0x52a26c]                    # 004dff35
    fld dword ptr [0x5cf1cb]                     # 004dff3b
    fmul qword ptr [0x52c680]                    # 004dff41
    call FUN_0050ce04                            # 004dff47
    push eax                                     # 004dff4c
    push 0x55ba00                                # 004dff4d
    lea eax, [ebp - local_64]                    # 004dff52
    push eax                                     # 004dff55
    call FUN_0050ca3e                            # 004dff56
    add esp, 0xc                                 # 004dff5b
    push 0x639897                                # 004dff5e
    lea ecx, [ebp - local_64]                    # 004dff63
    push ecx                                     # 004dff66
    push 0x55ba04                                # 004dff67
    push 0x55ba18                                # 004dff6c
    call dword ptr [0x52a26c]                    # 004dff71
    fld dword ptr [0x5cf1cf]                     # 004dff77
    fmul qword ptr [0x52c680]                    # 004dff7d
    call FUN_0050ce04                            # 004dff83
    push eax                                     # 004dff88
    push 0x55ba24                                # 004dff89
    lea edx, [ebp - local_64]                    # 004dff8e
    push edx                                     # 004dff91
    call FUN_0050ca3e                            # 004dff92
    add esp, 0xc                                 # 004dff97
    push 0x639897                                # 004dff9a
    lea eax, [ebp - local_64]                    # 004dff9f
    push eax                                     # 004dffa2
    push 0x55ba28                                # 004dffa3
    push 0x55ba3c                                # 004dffa8
    call dword ptr [0x52a26c]                    # 004dffad
    fld dword ptr [0x5cf1d3]                     # 004dffb3
    fmul qword ptr [0x52c680]                    # 004dffb9
    call FUN_0050ce04                            # 004dffbf
    push eax                                     # 004dffc4
    push 0x55ba48                                # 004dffc5
    lea ecx, [ebp - local_64]                    # 004dffca
    push ecx                                     # 004dffcd
    call FUN_0050ca3e                            # 004dffce
    add esp, 0xc                                 # 004dffd3
    push 0x639897                                # 004dffd6
    lea edx, [ebp - local_64]                    # 004dffdb
    push edx                                     # 004dffde
    push 0x55ba4c                                # 004dffdf
    push 0x55ba68                                # 004dffe4
    call dword ptr [0x52a26c]                    # 004dffe9
    {load} mov esp, ebp                          # 004dffef
    pop ebp                                      # 004dfff1
    ret                                          # 004dfff2

