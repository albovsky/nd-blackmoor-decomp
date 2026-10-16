# FUN_004a371a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a371a
# extent:       0x004a371a-0x004a376e (84 code bytes)
# span:         0x004a371a-0x004a376e (code 84, tables 0, padding 0)
# sha256:       6dd6bcbdc1fed627d3e0d2a53970f68a82bb6a5c8aa77ec9e52c28b68c246cc2
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a371a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_004a378a
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
.set FUN_004a378a, .text + (0x004a378a - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x004a371a - 0x401000
.globl FUN_004a371a
FUN_004a371a:
    # block 0x004a371a: entry, 23 instruction(s), calls FUN_0051d716, FUN_004a378a, ends with ret
    push ebp                                     # 004a371a
    {load} mov ebp, esp                          # 004a371b
    push -0x1                                    # 004a371d
    push 0x5285cd                                # 004a371f
    mov eax, dword ptr fs:[0x0]                  # 004a3724
    push eax                                     # 004a372a
    mov dword ptr fs:[0x0], esp                  # 004a372b
    push ecx                                     # 004a3732
    mov dword ptr [ebp - local_10], ecx          # 004a3733
    mov ecx, dword ptr [ebp - local_10]          # 004a3736
    call FUN_0051d716                            # 004a3739
    mov dword ptr [ebp - local_4], 0x0           # 004a373e
    mov eax, dword ptr [ebp - local_10]          # 004a3745
    mov dword ptr [eax], 0x52dce0                # 004a3748
    mov ecx, dword ptr [ebp - local_10]          # 004a374e
    call FUN_004a378a                            # 004a3751
    mov dword ptr [ebp - local_4], 0xffffffff    # 004a3756
    mov eax, dword ptr [ebp - local_10]          # 004a375d
    mov ecx, dword ptr [ebp - local_c]           # 004a3760
    mov dword ptr fs:[0x0], ecx                  # 004a3763
    {load} mov esp, ebp                          # 004a376a
    pop ebp                                      # 004a376c
    ret                                          # 004a376d

