# FUN_004fd370
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fd370
# extent:       0x004fd370-0x004fd3d4 (100 code bytes)
# span:         0x004fd370-0x004fd3e0 (code 100, tables 0, padding 12)
# sha256:       b03d1820f1e9082f26b0eefb6fb76db2286482fb82243a2e9dba6348611e25d0
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fd370
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_18, field_2ae; [esp + n] stk_8
# callees:      calls FUN_0050ea7e, FUN_0050b500, FUN_0050b580; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 40 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_18, 0x18  # offset +0x18
.equ field_2ae, 0x2ae  # offset +0x2ae

# --- external targets -----------------------------------------------
.set FUN_0050b500, .text + (0x0050b500 - 0x401000)
.set FUN_0050b580, .text + (0x0050b580 - 0x401000)
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)

.org 0x004fd370 - 0x401000
.globl FUN_004fd370
FUN_004fd370:
    # block 0x004fd370: entry, 6 instruction(s), calls FUN_0050ea7e, ends with je to 0x004fd3d0 (forward)
    push esi                                     # 004fd370
    call FUN_0050ea7e                            # 004fd371
    mov esi, dword ptr [esp + stk_8]             # 004fd376
    mov dword ptr [eax], 0x0                     # 004fd37a
    cmp dword ptr [esi], 0x0                     # 004fd380
    je.d8 L_004fd3d0                             # 004fd383
    # block 0x004fd385: entered by fall-through of je at 0x004fd383, 15 instruction(s), calls FUN_0050b500, indirect dword ptr [esi + 0x2ae], ends with jle to 0x004fd3b8 (forward)
    push edi                                     # 004fd385
    lea edi, [esi + field_18]                    # 004fd386
    push 0x2134                                  # 004fd389
    push edi                                     # 004fd38e
    call FUN_0050b500                            # 004fd38f
    mov ecx, dword ptr [esi]                     # 004fd394
    push ecx                                     # 004fd396
    push 0x2134                                  # 004fd397
    push 0x1                                     # 004fd39c
    push eax                                     # 004fd39e
    call dword ptr [esi + field_2ae]             # 004fd39f
    {load} mov esi, eax                          # 004fd3a5
    add esp, 0x18                                # 004fd3a7
    test esi, esi                                # 004fd3aa
    jle.d8 L_004fd3b8                            # 004fd3ac
    # block 0x004fd3ae: entered by fall-through of jle at 0x004fd3ac, 4 instruction(s), calls FUN_0050b580, falls into the block at 0x004fd3b8
    push esi                                     # 004fd3ae
    push edi                                     # 004fd3af
    call FUN_0050b580                            # 004fd3b0
    add esp, 0x8                                 # 004fd3b5
L_004fd3b8:
    # block 0x004fd3b8: entered by jle at 0x004fd3ac, 3 instruction(s), ends with jne to 0x004fd3cc (forward)
    test esi, esi                                # 004fd3b8
    pop edi                                      # 004fd3ba
    jne.d8 L_004fd3cc                            # 004fd3bb
    # block 0x004fd3bd: entered by fall-through of jne at 0x004fd3bb, 3 instruction(s), calls FUN_0050ea7e, ends with je to 0x004fd3cc (forward)
    call FUN_0050ea7e                            # 004fd3bd
    cmp dword ptr [eax], 0x0                     # 004fd3c2
    je.d8 L_004fd3cc                             # 004fd3c5
    # block 0x004fd3c7: entered by fall-through of je at 0x004fd3c5, 3 instruction(s), ends with ret
    or eax, -0x1                                 # 004fd3c7
    pop esi                                      # 004fd3ca
    ret                                          # 004fd3cb
L_004fd3cc:
    # block 0x004fd3cc: entered by jne at 0x004fd3bb; je at 0x004fd3c5, 3 instruction(s), ends with ret
    {load} mov eax, esi                          # 004fd3cc
    pop esi                                      # 004fd3ce
    ret                                          # 004fd3cf
L_004fd3d0:
    # block 0x004fd3d0: entered by je at 0x004fd383, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 004fd3d0
    pop esi                                      # 004fd3d2
    ret                                          # 004fd3d3

# --- data items (not part of the function) -------------------------
.org 0x004fd3d4 - 0x401000
PAD_004fd3d4:  # 12 byte(s) of nop padding
    .fill 12, 1, 0x90

