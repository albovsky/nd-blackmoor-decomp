# FUN_004846c2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004846c2
# extent:       0x004846c2-0x00484762 (160 code bytes)
# span:         0x004846c2-0x00484762 (code 160, tables 0, padding 0)
# sha256:       afbc1b372e487fedc24fdbe351e9220c6997945c75a6094c91fd3c68efa00eea
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         top_piece_unplaced
# naming:       native port src/action_family_ea_runtime.c:top_piece_unplaced (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with top_piece_unplaced (list +0xbd1, count +0xbf9, twin of 0x484622). Body/obj are parameters; host callbacks; oracle aggregate.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_bf9; [ecx + n] field_28; [edx + n] field_bd1, field_bf9
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_ea_runtime.c:top_piece_unplaced (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 44 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_28, 0x28  # offset +0x28
.equ field_bd1, 0xbd1  # offset +0xbd1
.equ field_bf9, 0xbf9  # offset +0xbf9

# --- external targets -----------------------------------------------

.org 0x004846c2 - 0x401000
.globl FUN_004846c2
FUN_004846c2:
    # block 0x004846c2: entry, 9 instruction(s), ends with jne to 0x004846e5 (forward)
    push ebp                                     # 004846c2
    {load} mov ebp, esp                          # 004846c3
    sub esp, 0xc                                 # 004846c5
    mov dword ptr [ebp - local_c], ecx           # 004846c8
    mov word ptr [ebp - local_8], 0xffff         # 004846cb
    mov eax, dword ptr [ebp - local_c]           # 004846d1
    movsx ecx, word ptr [eax + field_bf9]        # 004846d4
    test ecx, ecx                                # 004846db
    jne.d8 L_004846e5                            # 004846dd
    # block 0x004846df: entered by fall-through of jne at 0x004846dd, 2 instruction(s), ends with forward jump to 0x0048475e
    mov ax, word ptr [ebp - local_8]             # 004846df
    jmp.d8 L_0048475e                            # 004846e3
L_004846e5:
    # block 0x004846e5: entered by jne at 0x004846dd, 5 instruction(s), ends with forward jump to 0x00484705
    mov edx, dword ptr [ebp - local_c]           # 004846e5
    mov ax, word ptr [edx + field_bd1]           # 004846e8
    mov word ptr [ebp - local_8], ax             # 004846ef
    mov dword ptr [ebp - local_4], 0x1           # 004846f3
    jmp.d8 L_00484705                            # 004846fa
L_004846fc:
    # block 0x004846fc: entered by jmp at 0x00484758, 3 instruction(s), falls into the block at 0x00484705
    mov ecx, dword ptr [ebp - local_4]           # 004846fc
    add ecx, 0x1                                 # 004846ff
    mov dword ptr [ebp - local_4], ecx           # 00484702
L_00484705:
    # block 0x00484705: entered by jmp at 0x004846fa, 4 instruction(s), ends with jge to 0x0048475a (forward)
    mov edx, dword ptr [ebp - local_c]           # 00484705
    movsx eax, word ptr [edx + field_bf9]        # 00484708
    cmp dword ptr [ebp - local_4], eax           # 0048470f
    jge.d8 L_0048475a                            # 00484712
    # block 0x00484714: entered by fall-through of jge at 0x00484712, 12 instruction(s), ends with jle to 0x00484758 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00484714
    mov edx, dword ptr [ebp - local_c]           # 00484717
    movsx eax, word ptr [edx + 2*ecx + field_bd1] # 0048471a
    imul eax, eax, 0x85                          # 00484722
    mov ecx, dword ptr [ebp - local_c]           # 00484728
    movsx edx, word ptr [ecx + eax + field_28]   # 0048472b
    movsx eax, word ptr [ebp - local_8]          # 00484730
    imul eax, eax, 0x85                          # 00484734
    mov ecx, dword ptr [ebp - local_c]           # 0048473a
    movsx eax, word ptr [ecx + eax + field_28]   # 0048473d
    {load} cmp edx, eax                          # 00484742
    jle.d8 L_00484758                            # 00484744
    # block 0x00484746: entered by fall-through of jle at 0x00484744, 4 instruction(s), falls into the block at 0x00484758
    mov ecx, dword ptr [ebp - local_4]           # 00484746
    mov edx, dword ptr [ebp - local_c]           # 00484749
    mov ax, word ptr [edx + 2*ecx + field_bd1]   # 0048474c
    mov word ptr [ebp - local_8], ax             # 00484754
L_00484758:
    # block 0x00484758: entered by jle at 0x00484744, 1 instruction(s), ends with backward jump to 0x004846fc
    jmp.d8 L_004846fc                            # 00484758
L_0048475a:
    # block 0x0048475a: entered by jge at 0x00484712, 1 instruction(s), falls into the block at 0x0048475e
    mov ax, word ptr [ebp - local_8]             # 0048475a
L_0048475e:
    # block 0x0048475e: entered by jmp at 0x004846e3, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0048475e
    pop ebp                                      # 00484760
    ret                                          # 00484761

