# FUN_00401589
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401589
# extent:       0x00401589-0x004015fb (114 code bytes)
# span:         0x00401589-0x004015fb (code 114, tables 0, padding 0)
# sha256:       362a4e73706ee80342183295ea7f791015494d0941f950f279e22ff266922fa3
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00401589
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_c, local_ec, local_f0
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00401cb0, FUN_00402322, FUN_0051de13
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_ec, 0xec  # offset -0xec
.equ local_f0, 0xf0  # offset -0xf0
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00401cb0, .text + (0x00401cb0 - 0x401000)
.set FUN_00402322, .text + (0x00402322 - 0x401000)
.set FUN_0051de13, .text + (0x0051de13 - 0x401000)

.org 0x00401589 - 0x401000
.globl FUN_00401589
FUN_00401589:
    # block 0x00401589: entry, 29 instruction(s), calls FUN_00401cb0, FUN_00402322, FUN_0051de13, ends with ret 0xc
    push ebp                                     # 00401589
    {load} mov ebp, esp                          # 0040158a
    push -0x1                                    # 0040158c
    push 0x526b09                                # 0040158e
    mov eax, dword ptr fs:[0x0]                  # 00401593
    push eax                                     # 00401599
    mov dword ptr fs:[0x0], esp                  # 0040159a
    sub esp, 0xe4                                # 004015a1
    mov dword ptr [ebp - local_f0], ecx          # 004015a7
    push 0x0                                     # 004015ad
    lea ecx, [ebp - local_ec]                    # 004015af
    call FUN_00401cb0                            # 004015b5
    mov dword ptr [ebp - local_4], 0x0           # 004015ba
    mov eax, dword ptr [ebp + arg_10]            # 004015c1
    push eax                                     # 004015c4
    mov ecx, dword ptr [ebp + arg_c]             # 004015c5
    push ecx                                     # 004015c8
    mov dx, word ptr [ebp + arg_8]               # 004015c9
    push edx                                     # 004015cd
    lea ecx, [ebp - local_ec]                    # 004015ce
    call FUN_00402322                            # 004015d4
    mov dword ptr [ebp - local_4], 0xffffffff    # 004015d9
    lea ecx, [ebp - local_ec]                    # 004015e0
    call FUN_0051de13                            # 004015e6
    mov ecx, dword ptr [ebp - local_c]           # 004015eb
    mov dword ptr fs:[0x0], ecx                  # 004015ee
    {load} mov esp, ebp                          # 004015f5
    pop ebp                                      # 004015f7
    ret 0xc                                      # 004015f8

