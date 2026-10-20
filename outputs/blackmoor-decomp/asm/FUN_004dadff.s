# FUN_004dadff
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dadff
# extent:       0x004dadff-0x004dae66 (103 code bytes)
# span:         0x004dadff-0x004dae66 (code 103, tables 0, padding 0)
# sha256:       544471b7b218e2aed1e198ed97871fbaefed650f64473a2f472d9d5ac03f45a2
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_async_key_state_poll
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_3f_runtime.h:334 says "0x4dadff: GetAsyncKeyState of two keys."
# name-note:    Polls GetAsyncKeyState of two keys on the input object.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_20, field_24
# callees:      calls USER32.dll!GetAsyncKeyState
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:phase1 (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------

.org 0x004dadff - 0x401000
.globl FUN_004dadff
FUN_004dadff:
    # block 0x004dadff: entry, 12 instruction(s), calls USER32.dll!GetAsyncKeyState, ends with jne to 0x004dae2d (forward)
    push ebp                                     # 004dadff
    {load} mov ebp, esp                          # 004dae00
    push ecx                                     # 004dae02
    mov dword ptr [ebp - local_4], ecx           # 004dae03
    mov eax, dword ptr [ebp - local_4]           # 004dae06
    mov ecx, dword ptr [eax + field_20]          # 004dae09
    push ecx                                     # 004dae0c
    call dword ptr [0x52a4b4]                    # 004dae0d
    movsx edx, ax                                # 004dae13
    and edx, 0x8000                              # 004dae16
    cmp edx, 0x8000                              # 004dae1c
    jne.d8 L_004dae2d                            # 004dae22
    # block 0x004dae24: entered by fall-through of jne at 0x004dae22, 2 instruction(s), ends with forward jump to 0x004dae34
    mov byte ptr [0x58321d], 0x1                 # 004dae24
    jmp.d8 L_004dae34                            # 004dae2b
L_004dae2d:
    # block 0x004dae2d: entered by jne at 0x004dae22, 1 instruction(s), falls into the block at 0x004dae34
    mov byte ptr [0x58321d], 0x0                 # 004dae2d
L_004dae34:
    # block 0x004dae34: entered by jmp at 0x004dae2b, 8 instruction(s), calls USER32.dll!GetAsyncKeyState, ends with jne to 0x004dae5b (forward)
    mov eax, dword ptr [ebp - local_4]           # 004dae34
    mov ecx, dword ptr [eax + field_24]          # 004dae37
    push ecx                                     # 004dae3a
    call dword ptr [0x52a4b4]                    # 004dae3b
    movsx edx, ax                                # 004dae41
    and edx, 0x8000                              # 004dae44
    cmp edx, 0x8000                              # 004dae4a
    jne.d8 L_004dae5b                            # 004dae50
    # block 0x004dae52: entered by fall-through of jne at 0x004dae50, 2 instruction(s), ends with forward jump to 0x004dae62
    mov byte ptr [0x58321e], 0x1                 # 004dae52
    jmp.d8 L_004dae62                            # 004dae59
L_004dae5b:
    # block 0x004dae5b: entered by jne at 0x004dae50, 1 instruction(s), falls into the block at 0x004dae62
    mov byte ptr [0x58321e], 0x0                 # 004dae5b
L_004dae62:
    # block 0x004dae62: entered by jmp at 0x004dae59, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004dae62
    pop ebp                                      # 004dae64
    ret                                          # 004dae65

