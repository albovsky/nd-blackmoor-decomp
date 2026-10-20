# FUN_004e7253
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7253
# extent:       0x004e7253-0x004e72fb (168 code bytes)
# span:         0x004e7253-0x004e72fb (code 168, tables 0, padding 0)
# sha256:       6f97228b97fa7f03a82c4ef2a4533570bc1216c73af943f249b76cb326c679e2
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e7253_store_record
# naming:       native port src/original_methods_fl18.c:m4e7253_store_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4e7253_store_record. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 168 bytes.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e45be, FUN_004e3ade, FUN_004e0559
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl18.c:m4e7253_store_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 53 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004e0559, .text + (0x004e0559 - 0x401000)
.set FUN_004e3ade, .text + (0x004e3ade - 0x401000)
.set FUN_004e45be, .text + (0x004e45be - 0x401000)

.org 0x004e7253 - 0x401000
.globl FUN_004e7253
FUN_004e7253:
    # block 0x004e7253: entry, 21 instruction(s), calls FUN_004e45be, ends with je to 0x004e72ae (forward)
    push ebp                                     # 004e7253
    {load} mov ebp, esp                          # 004e7254
    sub esp, 0xc                                 # 004e7256
    push esi                                     # 004e7259
    push edi                                     # 004e725a
    mov dword ptr [ebp - local_c], ecx           # 004e725b
    movsx eax, word ptr [ebp + arg_8]            # 004e725e
    imul eax, eax, 0x8d                          # 004e7262
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004e7268
    mov dword ptr [ebp - local_4], ecx           # 004e726e
    push 0xb                                     # 004e7271
    push 0x1                                     # 004e7273
    mov edx, dword ptr [ebp - local_4]           # 004e7275
    add edx, 0x2                                 # 004e7278
    push edx                                     # 004e727b
    lea eax, [ebp - local_8]                     # 004e727c
    push eax                                     # 004e727f
    mov ecx, dword ptr [ebp - local_c]           # 004e7280
    call FUN_004e45be                            # 004e7283
    test eax, eax                                # 004e7288
    je.d8 L_004e72ae                             # 004e728a
    # block 0x004e728c: entered by fall-through of je at 0x004e728a, 10 instruction(s), calls FUN_004e3ade, ends with forward jump to 0x004e72e3
    movsx edi, word ptr [ebp - local_8]          # 004e728c
    imul edi, edi, 0x29                          # 004e7290
    add edi, 0x5a1e62                            # 004e7293
    mov ecx, 0xa                                 # 004e7299
    mov esi, dword ptr [ebp - local_4]           # 004e729e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e72a1
    movsb byte ptr es:[edi], byte ptr [esi]      # 004e72a3
    mov ecx, dword ptr [ebp - local_c]           # 004e72a4
    call FUN_004e3ade                            # 004e72a7
    jmp.d8 L_004e72e3                            # 004e72ac
L_004e72ae:
    # block 0x004e72ae: entered by je at 0x004e728a, 12 instruction(s), calls FUN_004e3ade, falls into the block at 0x004e72e3
    movsx edi, word ptr [0x5a1e5c]               # 004e72ae
    imul edi, edi, 0x29                          # 004e72b5
    add edi, 0x5a1e62                            # 004e72b8
    mov ecx, 0xa                                 # 004e72be
    mov esi, dword ptr [ebp - local_4]           # 004e72c3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e72c6
    movsb byte ptr es:[edi], byte ptr [esi]      # 004e72c8
    mov cx, word ptr [0x5a1e5c]                  # 004e72c9
    add cx, 0x1                                  # 004e72d0
    mov word ptr [0x5a1e5c], cx                  # 004e72d4
    mov ecx, dword ptr [ebp - local_c]           # 004e72db
    call FUN_004e3ade                            # 004e72de
L_004e72e3:
    # block 0x004e72e3: entered by jmp at 0x004e72ac, 10 instruction(s), calls FUN_004e0559, ends with ret 0x4
    push 0x0                                     # 004e72e3
    push 0x1                                     # 004e72e5
    push 0x3                                     # 004e72e7
    mov ecx, 0x570508                            # 004e72e9
    call FUN_004e0559                            # 004e72ee
    pop edi                                      # 004e72f3
    pop esi                                      # 004e72f4
    {load} mov esp, ebp                          # 004e72f5
    pop ebp                                      # 004e72f7
    ret 0x4                                      # 004e72f8

