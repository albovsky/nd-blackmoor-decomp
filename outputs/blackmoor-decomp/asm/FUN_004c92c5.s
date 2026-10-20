# FUN_004c92c5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c92c5
# extent:       0x004c92c5-0x004c9340 (123 code bytes)
# span:         0x004c92c5-0x004c9340 (code 123, tables 0, padding 0)
# sha256:       367561d23a3a01a88e45d0ea6887498ac8f95e1d4d48d34f78c7b05b70aaacca
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_font_sheet_release
# naming:       INFERRED (lower confidence, not verified): the repository text src/session_bindings_af5.h:27 says "it still issues the font release 0x4c92c5(10)"; src/blackmoor_app.mm:7293 says "0x4c92c5: the font reference the text draws would hold."
# name-note:    Releases a font-sheet reference (font surface count), counterpart of 0x4c924d.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c2dfb
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:native_a76_font_acquire (function ledger class candidate_port; also native_ae4_font_release, native_af5_font_acquire; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 30 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)

.org 0x004c92c5 - 0x401000
.globl FUN_004c92c5
FUN_004c92c5:
    # block 0x004c92c5: entry, 7 instruction(s), ends with je to 0x004c931c (forward)
    push ebp                                     # 004c92c5
    {load} mov ebp, esp                          # 004c92c6
    push ecx                                     # 004c92c8
    mov dword ptr [ebp - local_4], ecx           # 004c92c9
    movsx eax, word ptr [ebp + arg_8]            # 004c92cc
    cmp dword ptr [4*eax + 0x5d032f], 0x0        # 004c92d0
    je.d8 L_004c931c                             # 004c92d8
    # block 0x004c92da: entered by fall-through of je at 0x004c92d8, 9 instruction(s), ends with jne to 0x004c931c (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004c92da
    mov dx, word ptr [2*ecx + 0x5afbda]          # 004c92de
    sub dx, 0x1                                  # 004c92e6
    movsx eax, word ptr [ebp + arg_8]            # 004c92ea
    mov word ptr [2*eax + 0x5afbda], dx          # 004c92ee
    movsx ecx, word ptr [ebp + arg_8]            # 004c92f6
    movsx edx, word ptr [2*ecx + 0x5afbda]       # 004c92fa
    test edx, edx                                # 004c9302
    jne.d8 L_004c931c                            # 004c9304
    # block 0x004c9306: entered by fall-through of jne at 0x004c9304, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004c931c
    movsx eax, word ptr [ebp + arg_8]            # 004c9306
    lea ecx, [4*eax + 0x5d032f]                  # 004c930a
    push ecx                                     # 004c9311
    mov ecx, 0x5cf659                            # 004c9312
    call FUN_004c2dfb                            # 004c9317
L_004c931c:
    # block 0x004c931c: entered by je at 0x004c92d8; jne at 0x004c9304, 4 instruction(s), ends with jge to 0x004c933a (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004c931c
    movsx eax, word ptr [2*edx + 0x5afbda]       # 004c9320
    test eax, eax                                # 004c9328
    jge.d8 L_004c933a                            # 004c932a
    # block 0x004c932c: entered by fall-through of jge at 0x004c932a, 2 instruction(s), falls into the block at 0x004c933a
    movsx ecx, word ptr [ebp + arg_8]            # 004c932c
    mov word ptr [2*ecx + 0x5afbda], 0x0         # 004c9330
L_004c933a:
    # block 0x004c933a: entered by jge at 0x004c932a, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004c933a
    pop ebp                                      # 004c933c
    ret 0x4                                      # 004c933d

