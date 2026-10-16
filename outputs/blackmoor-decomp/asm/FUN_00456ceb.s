# FUN_00456ceb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00456ceb
# extent:       0x00456ceb-0x00456d07 (28 code bytes)
# span:         0x00456ceb-0x00456d07 (code 28, tables 0, padding 0)
# sha256:       1c3a119af87039f8b91747a2de8af3331dba0f32da3a10ecd7bcd60349db0c63
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00456ceb
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

.org 0x00456ceb - 0x401000
.globl FUN_00456ceb
FUN_00456ceb:
    # block 0x00456ceb: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 00456ceb
    {load} mov ebp, esp                          # 00456cec
    push ecx                                     # 00456cee
    mov dword ptr [ebp - local_4], ecx           # 00456cef
    mov eax, dword ptr [ebp - local_4]           # 00456cf2
    mov dword ptr [eax], 0x52cdd8                # 00456cf5
    mov ecx, dword ptr [ebp - local_4]           # 00456cfb
    call FUN_0051d730                            # 00456cfe
    {load} mov esp, ebp                          # 00456d03
    pop ebp                                      # 00456d05
    ret                                          # 00456d06

