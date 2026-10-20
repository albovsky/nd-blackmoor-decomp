# FUN_004757da
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004757da
# extent:       0x004757da-0x00475885 (171 code bytes)
# span:         0x004757da-0x00475885 (code 171, tables 0, padding 0)
# sha256:       97c269ad9e8b9145f13ebf0aec9f5f78cb6845ac340f1135988b9827d3fe2f00
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4757da_clear_grid
# naming:       native port src/original_methods_fl20a.c:m4757da_clear_grid (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4757da_clear_grid. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 171 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_22, field_89e; [ecx + n] field_4, field_8, field_c, field_10, field_1c, field_20; [edx + n] field_30, field_89a
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_e4_runtime.c:e4r_cleanup (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 48 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_22, 0x22  # offset +0x22
.equ field_30, 0x30  # offset +0x30
.equ field_89a, 0x89a  # offset +0x89a
.equ field_89e, 0x89e  # offset +0x89e

# --- external targets -----------------------------------------------

.org 0x004757da - 0x401000
.globl FUN_004757da
FUN_004757da:
    # block 0x004757da: entry, 16 instruction(s), ends with forward jump to 0x0047582d
    push ebp                                     # 004757da
    {load} mov ebp, esp                          # 004757db
    sub esp, 0xc                                 # 004757dd
    mov dword ptr [ebp - local_c], ecx           # 004757e0
    mov eax, dword ptr [ebp - local_c]           # 004757e3
    mov word ptr [eax + field_22], 0xffff        # 004757e6
    mov ecx, dword ptr [ebp - local_c]           # 004757ec
    mov word ptr [ecx + field_20], 0xffff        # 004757ef
    mov edx, dword ptr [ebp - local_c]           # 004757f5
    mov dword ptr [edx + field_89a], 0x0         # 004757f8
    mov eax, dword ptr [ebp - local_c]           # 00475802
    mov dword ptr [eax + field_89e], 0x0         # 00475805
    mov ecx, dword ptr [ebp - local_c]           # 0047580f
    mov dword ptr [ecx + field_1c], 0x0          # 00475812
    mov word ptr [ebp - local_4], 0x0            # 00475819
    jmp.d8 L_0047582d                            # 0047581f
L_00475821:
    # block 0x00475821: entered by jmp at 0x0047587f, 3 instruction(s), falls into the block at 0x0047582d
    mov dx, word ptr [ebp - local_4]             # 00475821
    add dx, 0x1                                  # 00475825
    mov word ptr [ebp - local_4], dx             # 00475829
L_0047582d:
    # block 0x0047582d: entered by jmp at 0x0047581f, 3 instruction(s), ends with jge to 0x00475881 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0047582d
    cmp eax, 0xa                                 # 00475831
    jge.d8 L_00475881                            # 00475834
    # block 0x00475836: entered by fall-through of jge at 0x00475834, 2 instruction(s), ends with forward jump to 0x0047584a
    mov word ptr [ebp - local_8], 0x0            # 00475836
    jmp.d8 L_0047584a                            # 0047583c
L_0047583e:
    # block 0x0047583e: entered by jmp at 0x0047587d, 3 instruction(s), falls into the block at 0x0047584a
    mov cx, word ptr [ebp - local_8]             # 0047583e
    add cx, 0x1                                  # 00475842
    mov word ptr [ebp - local_8], cx             # 00475846
L_0047584a:
    # block 0x0047584a: entered by jmp at 0x0047583c, 3 instruction(s), ends with jge to 0x0047587f (forward)
    movsx edx, word ptr [ebp - local_8]          # 0047584a
    cmp edx, 0xa                                 # 0047584e
    jge.d8 L_0047587f                            # 00475851
    # block 0x00475853: entered by fall-through of jge at 0x00475851, 14 instruction(s), ends with backward jump to 0x0047583e
    {load} xor eax, eax                          # 00475853
    movsx ecx, word ptr [ebp - local_4]          # 00475855
    imul ecx, ecx, 0xc8                          # 00475859
    mov edx, dword ptr [ebp - local_c]           # 0047585f
    lea ecx, [edx + ecx + field_30]              # 00475862
    movsx edx, word ptr [ebp - local_8]          # 00475866
    imul edx, edx, 0x14                          # 0047586a
    {load} add ecx, edx                          # 0047586d
    mov dword ptr [ecx], eax                     # 0047586f
    mov dword ptr [ecx + field_4], eax           # 00475871
    mov dword ptr [ecx + field_8], eax           # 00475874
    mov dword ptr [ecx + field_c], eax           # 00475877
    mov dword ptr [ecx + field_10], eax          # 0047587a
    jmp.d8 L_0047583e                            # 0047587d
L_0047587f:
    # block 0x0047587f: entered by jge at 0x00475851, 1 instruction(s), ends with backward jump to 0x00475821
    jmp.d8 L_00475821                            # 0047587f
L_00475881:
    # block 0x00475881: entered by jge at 0x00475834, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00475881
    pop ebp                                      # 00475883
    ret                                          # 00475884

