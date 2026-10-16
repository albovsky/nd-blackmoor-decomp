# FUN_004a631a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a631a
# extent:       0x004a631a-0x004a636e (84 code bytes)
# span:         0x004a631a-0x004a636e (code 84, tables 0, padding 0)
# sha256:       128d97bc67e8595306b09f6529bdf800d8f72ae53cdc3fc5e0efb39e2b0ab750
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a631a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_004a638a
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
.set FUN_004a638a, .text + (0x004a638a - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x004a631a - 0x401000
.globl FUN_004a631a
FUN_004a631a:
    # block 0x004a631a: entry, 23 instruction(s), calls FUN_0051d716, FUN_004a638a, ends with ret
    push ebp                                     # 004a631a
    {load} mov ebp, esp                          # 004a631b
    push -0x1                                    # 004a631d
    push 0x5285fd                                # 004a631f
    mov eax, dword ptr fs:[0x0]                  # 004a6324
    push eax                                     # 004a632a
    mov dword ptr fs:[0x0], esp                  # 004a632b
    push ecx                                     # 004a6332
    mov dword ptr [ebp - local_10], ecx          # 004a6333
    mov ecx, dword ptr [ebp - local_10]          # 004a6336
    call FUN_0051d716                            # 004a6339
    mov dword ptr [ebp - local_4], 0x0           # 004a633e
    mov eax, dword ptr [ebp - local_10]          # 004a6345
    mov dword ptr [eax], 0x52dd68                # 004a6348
    mov ecx, dword ptr [ebp - local_10]          # 004a634e
    call FUN_004a638a                            # 004a6351
    mov dword ptr [ebp - local_4], 0xffffffff    # 004a6356
    mov eax, dword ptr [ebp - local_10]          # 004a635d
    mov ecx, dword ptr [ebp - local_c]           # 004a6360
    mov dword ptr fs:[0x0], ecx                  # 004a6363
    {load} mov esp, ebp                          # 004a636a
    pop ebp                                      # 004a636c
    ret                                          # 004a636d

