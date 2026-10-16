# FUN_0040192a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040192a
# extent:       0x0040192a-0x00401947 (29 code bytes)
# span:         0x0040192a-0x00401947 (code 29, tables 0, padding 0)
# sha256:       1c09ba46186fdb777792479d68215b24e9913249d37624800ff1f4088a4457e3
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040192a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00401526
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00401526, .text + (0x00401526 - 0x401000)

.org 0x0040192a - 0x401000
.globl FUN_0040192a
FUN_0040192a:
    # block 0x0040192a: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 0040192a
    {load} mov ebp, esp                          # 0040192b
    push ecx                                     # 0040192d
    mov dword ptr [ebp - local_4], ecx           # 0040192e
    mov dword ptr [0x569138], 0x17               # 00401931
    mov ecx, dword ptr [ebp - local_4]           # 0040193b
    call FUN_00401526                            # 0040193e
    {load} mov esp, ebp                          # 00401943
    pop ebp                                      # 00401945
    ret                                          # 00401946

