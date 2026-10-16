# FUN_004e3525
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e3525
# extent:       0x004e3525-0x004e354a (37 code bytes)
# span:         0x004e3525-0x004e354a (code 37, tables 0, padding 0)
# sha256:       a30f744c78edba5708e6d2a8d3942f43e11307c2c31a2980be6e07b214c6aaab
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e3525
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_452c
# callees:      calls FUN_004edf96
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_452c, 0x452c  # offset +0x452c

# --- external targets -----------------------------------------------
.set FUN_004edf96, .text + (0x004edf96 - 0x401000)

.org 0x004e3525 - 0x401000
.globl FUN_004e3525
FUN_004e3525:
    # block 0x004e3525: entry, 14 instruction(s), calls FUN_004edf96, ends with ret 0x4
    push ebp                                     # 004e3525
    {load} mov ebp, esp                          # 004e3526
    push ecx                                     # 004e3528
    mov dword ptr [ebp - local_4], ecx           # 004e3529
    mov eax, dword ptr [ebp - local_4]           # 004e352c
    mov ecx, dword ptr [ebp + arg_8]             # 004e352f
    mov dword ptr [eax + field_452c], ecx        # 004e3532
    mov edx, dword ptr [ebp + arg_8]             # 004e3538
    push edx                                     # 004e353b
    mov ecx, dword ptr [ebp - local_4]           # 004e353c
    call FUN_004edf96                            # 004e353f
    {load} mov esp, ebp                          # 004e3544
    pop ebp                                      # 004e3546
    ret 0x4                                      # 004e3547

