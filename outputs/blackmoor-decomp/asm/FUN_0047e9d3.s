# FUN_0047e9d3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047e9d3
# extent:       0x0047e9d3-0x0047ea73 (160 code bytes)
# span:         0x0047e9d3-0x0047ea73 (code 160, tables 0, padding 0)
# sha256:       6b853c69409e513634d40120b1f49f54196392c50b43854d9c29597f71893a05
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         top_piece_47e9d3
# naming:       native port src/action_family_eb_runtime.c:top_piece_47e9d3 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with top_piece_47e9d3 (list +0x13ef, count +0x1417; -1 if empty). The empty list is unreachable by click (K3), so a new oracle calls the original on forced lists; native results come from the direct test.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1417; [ecx + n] field_7b4; [edx + n] field_13ef, field_1417
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_eb_runtime.c:top_piece_47e9d3 (function ledger class native_oracle_verified; also top_piece_of_list; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 44 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_7b4, 0x7b4  # offset +0x7b4
.equ field_13ef, 0x13ef  # offset +0x13ef
.equ field_1417, 0x1417  # offset +0x1417

# --- external targets -----------------------------------------------

.org 0x0047e9d3 - 0x401000
.globl FUN_0047e9d3
FUN_0047e9d3:
    # block 0x0047e9d3: entry, 9 instruction(s), ends with jne to 0x0047e9f6 (forward)
    push ebp                                     # 0047e9d3
    {load} mov ebp, esp                          # 0047e9d4
    sub esp, 0xc                                 # 0047e9d6
    mov dword ptr [ebp - local_c], ecx           # 0047e9d9
    mov word ptr [ebp - local_8], 0xffff         # 0047e9dc
    mov eax, dword ptr [ebp - local_c]           # 0047e9e2
    movsx ecx, word ptr [eax + field_1417]       # 0047e9e5
    test ecx, ecx                                # 0047e9ec
    jne.d8 L_0047e9f6                            # 0047e9ee
    # block 0x0047e9f0: entered by fall-through of jne at 0x0047e9ee, 2 instruction(s), ends with forward jump to 0x0047ea6f
    mov ax, word ptr [ebp - local_8]             # 0047e9f0
    jmp.d8 L_0047ea6f                            # 0047e9f4
L_0047e9f6:
    # block 0x0047e9f6: entered by jne at 0x0047e9ee, 5 instruction(s), ends with forward jump to 0x0047ea16
    mov edx, dword ptr [ebp - local_c]           # 0047e9f6
    mov ax, word ptr [edx + field_13ef]          # 0047e9f9
    mov word ptr [ebp - local_8], ax             # 0047ea00
    mov dword ptr [ebp - local_4], 0x1           # 0047ea04
    jmp.d8 L_0047ea16                            # 0047ea0b
L_0047ea0d:
    # block 0x0047ea0d: entered by jmp at 0x0047ea69, 3 instruction(s), falls into the block at 0x0047ea16
    mov ecx, dword ptr [ebp - local_4]           # 0047ea0d
    add ecx, 0x1                                 # 0047ea10
    mov dword ptr [ebp - local_4], ecx           # 0047ea13
L_0047ea16:
    # block 0x0047ea16: entered by jmp at 0x0047ea0b, 4 instruction(s), ends with jge to 0x0047ea6b (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047ea16
    movsx eax, word ptr [edx + field_1417]       # 0047ea19
    cmp dword ptr [ebp - local_4], eax           # 0047ea20
    jge.d8 L_0047ea6b                            # 0047ea23
    # block 0x0047ea25: entered by fall-through of jge at 0x0047ea23, 12 instruction(s), ends with jle to 0x0047ea69 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0047ea25
    mov edx, dword ptr [ebp - local_c]           # 0047ea28
    movsx eax, word ptr [edx + 2*ecx + field_13ef] # 0047ea2b
    imul eax, eax, 0x25                          # 0047ea33
    mov ecx, dword ptr [ebp - local_c]           # 0047ea36
    movsx edx, word ptr [ecx + eax + field_7b4]  # 0047ea39
    movsx eax, word ptr [ebp - local_8]          # 0047ea41
    imul eax, eax, 0x25                          # 0047ea45
    mov ecx, dword ptr [ebp - local_c]           # 0047ea48
    movsx eax, word ptr [ecx + eax + field_7b4]  # 0047ea4b
    {load} cmp edx, eax                          # 0047ea53
    jle.d8 L_0047ea69                            # 0047ea55
    # block 0x0047ea57: entered by fall-through of jle at 0x0047ea55, 4 instruction(s), falls into the block at 0x0047ea69
    mov ecx, dword ptr [ebp - local_4]           # 0047ea57
    mov edx, dword ptr [ebp - local_c]           # 0047ea5a
    mov ax, word ptr [edx + 2*ecx + field_13ef]  # 0047ea5d
    mov word ptr [ebp - local_8], ax             # 0047ea65
L_0047ea69:
    # block 0x0047ea69: entered by jle at 0x0047ea55, 1 instruction(s), ends with backward jump to 0x0047ea0d
    jmp.d8 L_0047ea0d                            # 0047ea69
L_0047ea6b:
    # block 0x0047ea6b: entered by jge at 0x0047ea23, 1 instruction(s), falls into the block at 0x0047ea6f
    mov ax, word ptr [ebp - local_8]             # 0047ea6b
L_0047ea6f:
    # block 0x0047ea6f: entered by jmp at 0x0047e9f4, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0047ea6f
    pop ebp                                      # 0047ea71
    ret                                          # 0047ea72

