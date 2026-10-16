# FUN_0048215e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048215e
# extent:       0x0048215e-0x0048217a (28 code bytes)
# span:         0x0048215e-0x0048217a (code 28, tables 0, padding 0)
# sha256:       d96fab5d2adb232bc2cbabe8d06a46feb8822637d09aa2629b5bf834056b277e
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048215e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x0048215e - 0x401000
.globl FUN_0048215e
FUN_0048215e:
    # block 0x0048215e: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 0048215e
    {load} mov ebp, esp                          # 0048215f
    push ecx                                     # 00482161
    mov dword ptr [ebp - local_4], ecx           # 00482162
    mov eax, dword ptr [ebp - local_4]           # 00482165
    mov dword ptr [eax], 0x52d6b8                # 00482168
    mov ecx, dword ptr [ebp - local_4]           # 0048216e
    call FUN_0051d730                            # 00482171
    {load} mov esp, ebp                          # 00482176
    pop ebp                                      # 00482178
    ret                                          # 00482179

