# FUN_00522316
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522316
# extent:       0x00522316-0x0052233d (39 code bytes)
# span:         0x00522316-0x0052233d (code 39, tables 0, padding 0)
# sha256:       aae3da5183efcd551feb21733cf1e6e6c93140964ab357ceb33e380e77ba9085
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522316
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c; [ecx + n] field_1c
# callees:      calls FUN_00521de7, FUN_0050c1b4, USER32.dll!SendMessageA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050c1b4, .text + (0x0050c1b4 - 0x401000)
.set FUN_00521de7, .text + (0x00521de7 - 0x401000)

.org 0x00522316 - 0x401000
.globl FUN_00522316
FUN_00522316:
    # block 0x00522316: entry, 2 instruction(s), ends with jne to 0x00522325 (forward)
    cmp dword ptr [ecx + field_1c], 0x0          # 00522316
    jne.d8 L_00522325                            # 0052231a
    # block 0x0052231c: entered by fall-through of jne at 0x0052231a, 3 instruction(s), calls FUN_00521de7, ends with ret
    call FUN_00521de7                            # 0052231c
    mov eax, dword ptr [eax + field_1c]          # 00522321
    ret                                          # 00522324
L_00522325:
    # block 0x00522325: entered by jne at 0x0052231a, 7 instruction(s), calls FUN_0050c1b4, USER32.dll!SendMessageA, ends with ret
    call FUN_0050c1b4                            # 00522325
    push 0x0                                     # 0052232a
    push 0x0                                     # 0052232c
    push 0x130b                                  # 0052232e
    push dword ptr [eax + field_1c]              # 00522333
    call dword ptr [0x52a4c8]                    # 00522336
    ret                                          # 0052233c

