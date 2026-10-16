# FUN_0047e1ea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047e1ea
# extent:       0x0047e1ea-0x0047e23e (84 code bytes)
# span:         0x0047e1ea-0x0047e23e (code 84, tables 0, padding 0)
# sha256:       30ab0c5f73640a7c533882e264f2ce821047d8715f2cab6e7e5d306e7e1ad58f
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047e1ea
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_0047e25a
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
.set FUN_0047e25a, .text + (0x0047e25a - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0047e1ea - 0x401000
.globl FUN_0047e1ea
FUN_0047e1ea:
    # block 0x0047e1ea: entry, 23 instruction(s), calls FUN_0051d716, FUN_0047e25a, ends with ret
    push ebp                                     # 0047e1ea
    {load} mov ebp, esp                          # 0047e1eb
    push -0x1                                    # 0047e1ed
    push 0x52838d                                # 0047e1ef
    mov eax, dword ptr fs:[0x0]                  # 0047e1f4
    push eax                                     # 0047e1fa
    mov dword ptr fs:[0x0], esp                  # 0047e1fb
    push ecx                                     # 0047e202
    mov dword ptr [ebp - local_10], ecx          # 0047e203
    mov ecx, dword ptr [ebp - local_10]          # 0047e206
    call FUN_0051d716                            # 0047e209
    mov dword ptr [ebp - local_4], 0x0           # 0047e20e
    mov eax, dword ptr [ebp - local_10]          # 0047e215
    mov dword ptr [eax], 0x52d630                # 0047e218
    mov ecx, dword ptr [ebp - local_10]          # 0047e21e
    call FUN_0047e25a                            # 0047e221
    mov dword ptr [ebp - local_4], 0xffffffff    # 0047e226
    mov eax, dword ptr [ebp - local_10]          # 0047e22d
    mov ecx, dword ptr [ebp - local_c]           # 0047e230
    mov dword ptr fs:[0x0], ecx                  # 0047e233
    {load} mov esp, ebp                          # 0047e23a
    pop ebp                                      # 0047e23c
    ret                                          # 0047e23d

