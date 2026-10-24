# FUN_0045818a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045818a
# extent:       0x0045818a-0x00458262 (216 code bytes)
# span:         0x0045818a-0x00458262 (code 216, tables 0, padding 0)
# sha256:       efe2f23539b342c092f2e420aec64754623d4d5435d8931b73ee0c408354c2be
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45818a_lifted
# naming:       native port src/original_methods_fl40.c:m45818a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 17 seeds; oracle 69/69 instructions, 8/8 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4, field_8, field_c; [ecx + n] field_4, field_c; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m45818a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 69 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0045818a - 0x401000
.globl FUN_0045818a
FUN_0045818a:
    # block 0x0045818a: entry, 18 instruction(s), ends with jge to 0x004581dd (forward)
    push ebp                                     # 0045818a
    {load} mov ebp, esp                          # 0045818b
    sub esp, 0xc                                 # 0045818d
    mov dword ptr [ebp - local_c], ecx           # 00458190
    mov eax, dword ptr [ebp + arg_8]             # 00458193
    mov ecx, dword ptr [ebp + arg_8]             # 00458196
    mov edx, dword ptr [eax + field_8]           # 00458199
    sub edx, dword ptr [ecx]                     # 0045819c
    mov word ptr [ebp - local_8], dx             # 0045819e
    mov eax, dword ptr [ebp + arg_8]             # 004581a2
    mov ecx, dword ptr [ebp + arg_8]             # 004581a5
    mov edx, dword ptr [eax + field_c]           # 004581a8
    sub edx, dword ptr [ecx + field_4]           # 004581ab
    mov word ptr [ebp - local_4], dx             # 004581ae
    mov eax, dword ptr [ebp + arg_8]             # 004581b2
    mov ecx, dword ptr [eax + field_4]           # 004581b5
    cmp ecx, dword ptr [0x58319a]                # 004581b8
    jge.d8 L_004581dd                            # 004581be
    # block 0x004581c0: entered by fall-through of jge at 0x004581be, 9 instruction(s), falls into the block at 0x004581dd
    mov edx, dword ptr [ebp + arg_8]             # 004581c0
    mov eax, dword ptr [0x58319a]                # 004581c3
    mov dword ptr [edx + field_4], eax           # 004581c8
    movsx ecx, word ptr [ebp - local_4]          # 004581cb
    mov edx, dword ptr [ebp + arg_8]             # 004581cf
    mov eax, dword ptr [edx + field_4]           # 004581d2
    {load} add eax, ecx                          # 004581d5
    mov ecx, dword ptr [ebp + arg_8]             # 004581d7
    mov dword ptr [ecx + field_c], eax           # 004581da
L_004581dd:
    # block 0x004581dd: entered by jge at 0x004581be, 4 instruction(s), ends with jle to 0x00458209 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004581dd
    mov eax, dword ptr [edx + field_c]           # 004581e0
    cmp eax, dword ptr [0x5831a2]                # 004581e3
    jle.d8 L_00458209                            # 004581e9
    # block 0x004581eb: entered by fall-through of jle at 0x004581e9, 9 instruction(s), falls into the block at 0x00458209
    mov ecx, dword ptr [ebp + arg_8]             # 004581eb
    mov edx, dword ptr [0x5831a2]                # 004581ee
    mov dword ptr [ecx + field_c], edx           # 004581f4
    movsx eax, word ptr [ebp - local_4]          # 004581f7
    mov ecx, dword ptr [ebp + arg_8]             # 004581fb
    mov edx, dword ptr [ecx + field_c]           # 004581fe
    {load} sub edx, eax                          # 00458201
    mov eax, dword ptr [ebp + arg_8]             # 00458203
    mov dword ptr [eax + field_4], edx           # 00458206
L_00458209:
    # block 0x00458209: entered by jle at 0x004581e9, 4 instruction(s), ends with jge to 0x00458232 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00458209
    mov edx, dword ptr [ecx]                     # 0045820c
    cmp edx, dword ptr [0x583196]                # 0045820e
    jge.d8 L_00458232                            # 00458214
    # block 0x00458216: entered by fall-through of jge at 0x00458214, 9 instruction(s), falls into the block at 0x00458232
    mov eax, dword ptr [ebp + arg_8]             # 00458216
    mov ecx, dword ptr [0x583196]                # 00458219
    mov dword ptr [eax], ecx                     # 0045821f
    movsx edx, word ptr [ebp - local_8]          # 00458221
    mov eax, dword ptr [ebp + arg_8]             # 00458225
    mov ecx, dword ptr [eax]                     # 00458228
    {load} add ecx, edx                          # 0045822a
    mov edx, dword ptr [ebp + arg_8]             # 0045822c
    mov dword ptr [edx + field_8], ecx           # 0045822f
L_00458232:
    # block 0x00458232: entered by jge at 0x00458214, 4 instruction(s), ends with jle to 0x0045825c (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00458232
    mov ecx, dword ptr [eax + field_8]           # 00458235
    cmp ecx, dword ptr [0x58319e]                # 00458238
    jle.d8 L_0045825c                            # 0045823e
    # block 0x00458240: entered by fall-through of jle at 0x0045823e, 9 instruction(s), falls into the block at 0x0045825c
    mov edx, dword ptr [ebp + arg_8]             # 00458240
    mov eax, dword ptr [0x58319e]                # 00458243
    mov dword ptr [edx + field_8], eax           # 00458248
    movsx ecx, word ptr [ebp - local_8]          # 0045824b
    mov edx, dword ptr [ebp + arg_8]             # 0045824f
    mov eax, dword ptr [edx + field_8]           # 00458252
    {load} sub eax, ecx                          # 00458255
    mov ecx, dword ptr [ebp + arg_8]             # 00458257
    mov dword ptr [ecx], eax                     # 0045825a
L_0045825c:
    # block 0x0045825c: entered by jle at 0x0045823e, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0045825c
    pop ebp                                      # 0045825e
    ret 0x4                                      # 0045825f

