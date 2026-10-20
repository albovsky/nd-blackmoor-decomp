# FUN_00470d0a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00470d0a
# extent:       0x00470d0a-0x00470d5e (84 code bytes)
# span:         0x00470d0a-0x00470d5e (code 84, tables 0, padding 0)
# sha256:       50acc5204b8b0bf0c0be6c537e318f449e4591e86b72d371b2d13f8ca82a949c
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00470d0a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_00470d7a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00470d7a, .text + (0x00470d7a - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x00470d0a - 0x401000
.globl FUN_00470d0a
FUN_00470d0a:
    # block 0x00470d0a: entry, 23 instruction(s), calls FUN_0051d716, FUN_00470d7a, ends with ret
    push ebp                                     # 00470d0a
    {load} mov ebp, esp                          # 00470d0b
    push -0x1                                    # 00470d0d
    push 0x52828d                                # 00470d0f
    mov eax, dword ptr fs:[0x0]                  # 00470d14
    push eax                                     # 00470d1a
    mov dword ptr fs:[0x0], esp                  # 00470d1b
    push ecx                                     # 00470d22
    mov dword ptr [ebp - local_10], ecx          # 00470d23
    mov ecx, dword ptr [ebp - local_10]          # 00470d26
    call FUN_0051d716                            # 00470d29
    mov dword ptr [ebp - local_4], 0x0           # 00470d2e
    mov eax, dword ptr [ebp - local_10]          # 00470d35
    mov dword ptr [eax], 0x52d3f8                # 00470d38
    mov ecx, dword ptr [ebp - local_10]          # 00470d3e
    call FUN_00470d7a                            # 00470d41
    mov dword ptr [ebp - local_4], 0xffffffff    # 00470d46
    mov eax, dword ptr [ebp - local_10]          # 00470d4d
    mov ecx, dword ptr [ebp - local_c]           # 00470d50
    mov dword ptr fs:[0x0], ecx                  # 00470d53
    {load} mov esp, ebp                          # 00470d5a
    pop ebp                                      # 00470d5c
    ret                                          # 00470d5d

