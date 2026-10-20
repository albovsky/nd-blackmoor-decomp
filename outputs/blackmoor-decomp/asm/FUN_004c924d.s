# FUN_004c924d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c924d
# extent:       0x004c924d-0x004c92c5 (120 code bytes)
# span:         0x004c924d-0x004c92c5 (code 120, tables 0, padding 0)
# sha256:       e475cd56cf48f243d65af4bac77bf5b42d25ba3ca2243d775b3e2a2a58793a81
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c924d_count_up
# naming:       native port src/original_methods_fl18.c:m4c924d_count_up (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4c924d_count_up. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 120 bytes.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c2790
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:native_a76_font_acquire (function ledger class native_oracle_verified; also native_ae4_alloc_slot, native_af5_font_acquire; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 30 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)

.org 0x004c924d - 0x401000
.globl FUN_004c924d
FUN_004c924d:
    # block 0x004c924d: entry, 8 instruction(s), ends with jne to 0x004c92a3 (forward)
    push ebp                                     # 004c924d
    {load} mov ebp, esp                          # 004c924e
    push ecx                                     # 004c9250
    mov dword ptr [ebp - local_4], ecx           # 004c9251
    movsx eax, word ptr [ebp + arg_8]            # 004c9254
    movsx ecx, word ptr [2*eax + 0x5afbda]       # 004c9258
    test ecx, ecx                                # 004c9260
    jne.d8 L_004c92a3                            # 004c9262
    # block 0x004c9264: entered by fall-through of jne at 0x004c9262, 3 instruction(s), ends with jne to 0x004c92a3 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004c9264
    cmp dword ptr [4*edx + 0x5d032f], 0x0        # 004c9268
    jne.d8 L_004c92a3                            # 004c9270
    # block 0x004c9272: entered by fall-through of jne at 0x004c9270, 11 instruction(s), calls FUN_004c2790, falls into the block at 0x004c92a3
    push 0x557acc                                # 004c9272
    push 0x6                                     # 004c9277
    movsx eax, word ptr [ebp + arg_8]            # 004c9279
    imul eax, eax, 0x7f3                         # 004c927d
    add eax, 0x5a4c24                            # 004c9283
    push eax                                     # 004c9288
    push 0x557adc                                # 004c9289
    mov ecx, 0x5cf659                            # 004c928e
    call FUN_004c2790                            # 004c9293
    movsx ecx, word ptr [ebp + arg_8]            # 004c9298
    mov dword ptr [4*ecx + 0x5d032f], eax        # 004c929c
L_004c92a3:
    # block 0x004c92a3: entered by jne at 0x004c9262; jne at 0x004c9270, 8 instruction(s), ends with ret 0x4
    movsx edx, word ptr [ebp + arg_8]            # 004c92a3
    mov ax, word ptr [2*edx + 0x5afbda]          # 004c92a7
    .insn 0x66, 0x05, 0x0001{:u16}               # 004c92af
    movsx ecx, word ptr [ebp + arg_8]            # 004c92b3
    mov word ptr [2*ecx + 0x5afbda], ax          # 004c92b7
    {load} mov esp, ebp                          # 004c92bf
    pop ebp                                      # 004c92c1
    ret 0x4                                      # 004c92c2

