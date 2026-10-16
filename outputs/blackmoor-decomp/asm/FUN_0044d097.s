# FUN_0044d097
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044d097
# extent:       0x0044d097-0x0044d0eb (84 code bytes)
# span:         0x0044d097-0x0044d0eb (code 84, tables 0, padding 0)
# sha256:       e9100ce3a492c60dcea7c91ecfb2d8739622c758ad9c39e747ced93b56a40319
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044d097
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_0044d107
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0044d107, .text + (0x0044d107 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0044d097 - 0x401000
.globl FUN_0044d097
FUN_0044d097:
    # block 0x0044d097: entry, 23 instruction(s), calls FUN_0051d716, FUN_0044d107, ends with ret
    push ebp                                     # 0044d097
    {load} mov ebp, esp                          # 0044d098
    push -0x1                                    # 0044d09a
    push 0x527fad                                # 0044d09c
    mov eax, dword ptr fs:[0x0]                  # 0044d0a1
    push eax                                     # 0044d0a7
    mov dword ptr fs:[0x0], esp                  # 0044d0a8
    push ecx                                     # 0044d0af
    mov dword ptr [ebp - local_10], ecx          # 0044d0b0
    mov ecx, dword ptr [ebp - local_10]          # 0044d0b3
    call FUN_0051d716                            # 0044d0b6
    mov dword ptr [ebp - local_4], 0x0           # 0044d0bb
    mov eax, dword ptr [ebp - local_10]          # 0044d0c2
    mov dword ptr [eax], 0x52cc38                # 0044d0c5
    mov ecx, dword ptr [ebp - local_10]          # 0044d0cb
    call FUN_0044d107                            # 0044d0ce
    mov dword ptr [ebp - local_4], 0xffffffff    # 0044d0d3
    mov eax, dword ptr [ebp - local_10]          # 0044d0da
    mov ecx, dword ptr [ebp - local_c]           # 0044d0dd
    mov dword ptr fs:[0x0], ecx                  # 0044d0e0
    {load} mov esp, ebp                          # 0044d0e7
    pop ebp                                      # 0044d0e9
    ret                                          # 0044d0ea

