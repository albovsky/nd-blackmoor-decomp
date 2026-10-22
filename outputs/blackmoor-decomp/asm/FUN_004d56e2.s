# FUN_004d56e2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d56e2
# extent:       0x004d56e2-0x004d57e8 (262 code bytes)
# span:         0x004d56e2-0x004d57e8 (code 262, tables 0, padding 0)
# sha256:       767a94702977d1f1070ddbd5f317062c54bb59025d3ae335eaca24cd33e15bad
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d56e2_lifted
# naming:       native port src/original_methods_fl39d.c:m4d56e2_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (21 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_4, field_8, field_c, field_minus_1; [ecx + n] field_4, field_8, field_c, field_minus_1; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4d56e2_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 92 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x004d56e2 - 0x401000
.globl FUN_004d56e2
FUN_004d56e2:
    # block 0x004d56e2: entry, 6 instruction(s), ends with je to 0x004d56fd (forward)
    push ebp                                     # 004d56e2
    {load} mov ebp, esp                          # 004d56e3
    sub esp, 0x14                                # 004d56e5
    mov dword ptr [ebp - local_14], ecx          # 004d56e8
    cmp dword ptr [ebp + arg_8], 0x0             # 004d56eb
    je.d8 L_004d56fd                             # 004d56ef
    # block 0x004d56f1: entered by fall-through of je at 0x004d56ef, 2 instruction(s), ends with je to 0x004d56fd (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004d56f1
    je.d8 L_004d56fd                             # 004d56f5
    # block 0x004d56f7: entered by fall-through of je at 0x004d56f5, 2 instruction(s), ends with jne to 0x004d5704 (forward)
    cmp dword ptr [ebp + arg_10], 0x0            # 004d56f7
    jne.d8 L_004d5704                            # 004d56fb
L_004d56fd:
    # block 0x004d56fd: entered by je at 0x004d56ef; je at 0x004d56f5; fall-through of jne at 0x004d56fb, 2 instruction(s), ends with forward jump to 0x004d57e2
    {load} xor eax, eax                          # 004d56fd
    jmp.d32 L_004d57e2                           # 004d56ff
L_004d5704:
    # block 0x004d5704: entered by jne at 0x004d56fb, 5 instruction(s), ends with jl to 0x004d573a (forward)
    mov eax, dword ptr [ebp + arg_10]            # 004d5704
    mov ecx, dword ptr [ebp + arg_c]             # 004d5707
    mov edx, dword ptr [eax]                     # 004d570a
    cmp edx, dword ptr [ecx]                     # 004d570c
    jl.d8 L_004d573a                             # 004d570e
    # block 0x004d5710: entered by fall-through of jl at 0x004d570e, 5 instruction(s), ends with jg to 0x004d573a (forward)
    mov eax, dword ptr [ebp + arg_10]            # 004d5710
    mov ecx, dword ptr [ebp + arg_c]             # 004d5713
    mov edx, dword ptr [eax + field_8]           # 004d5716
    cmp edx, dword ptr [ecx + field_8]           # 004d5719
    jg.d8 L_004d573a                             # 004d571c
    # block 0x004d571e: entered by fall-through of jg at 0x004d571c, 5 instruction(s), ends with jl to 0x004d573a (forward)
    mov eax, dword ptr [ebp + arg_10]            # 004d571e
    mov ecx, dword ptr [ebp + arg_c]             # 004d5721
    mov edx, dword ptr [eax + field_4]           # 004d5724
    cmp edx, dword ptr [ecx + field_4]           # 004d5727
    jl.d8 L_004d573a                             # 004d572a
    # block 0x004d572c: entered by fall-through of jl at 0x004d572a, 5 instruction(s), ends with jle to 0x004d5741 (forward)
    mov eax, dword ptr [ebp + arg_10]            # 004d572c
    mov ecx, dword ptr [ebp + arg_c]             # 004d572f
    mov edx, dword ptr [eax + field_c]           # 004d5732
    cmp edx, dword ptr [ecx + field_c]           # 004d5735
    jle.d8 L_004d5741                            # 004d5738
L_004d573a:
    # block 0x004d573a: entered by jl at 0x004d570e; jg at 0x004d571c; jl at 0x004d572a; fall-through of jle at 0x004d5738, 2 instruction(s), ends with forward jump to 0x004d57e2
    {load} xor eax, eax                          # 004d573a
    jmp.d32 L_004d57e2                           # 004d573c
L_004d5741:
    # block 0x004d5741: entered by jle at 0x004d5738, 55 instruction(s), falls into the block at 0x004d57e2
    mov eax, dword ptr [ebp + arg_10]            # 004d5741
    mov ecx, dword ptr [ebp + arg_c]             # 004d5744
    mov edx, dword ptr [eax]                     # 004d5747
    sub edx, dword ptr [ecx]                     # 004d5749
    mov dword ptr [ebp - local_c], edx           # 004d574b
    mov eax, dword ptr [ebp + arg_10]            # 004d574e
    mov ecx, dword ptr [ebp + arg_c]             # 004d5751
    mov edx, dword ptr [eax + field_4]           # 004d5754
    sub edx, dword ptr [ecx + field_4]           # 004d5757
    mov dword ptr [ebp - local_4], edx           # 004d575a
    mov eax, dword ptr [ebp + arg_10]            # 004d575d
    mov ecx, dword ptr [ebp + arg_10]            # 004d5760
    mov edx, dword ptr [eax + field_8]           # 004d5763
    sub edx, dword ptr [ecx]                     # 004d5766
    add edx, 0x1                                 # 004d5768
    mov dword ptr [ebp - local_10], edx          # 004d576b
    mov eax, dword ptr [ebp + arg_10]            # 004d576e
    mov ecx, dword ptr [ebp + arg_10]            # 004d5771
    mov edx, dword ptr [eax + field_c]           # 004d5774
    sub edx, dword ptr [ecx + field_4]           # 004d5777
    add edx, 0x1                                 # 004d577a
    mov dword ptr [ebp - local_8], edx           # 004d577d
    mov eax, dword ptr [ebp + arg_8]             # 004d5780
    mov ecx, dword ptr [eax]                     # 004d5783
    add ecx, dword ptr [ebp - local_c]           # 004d5785
    mov edx, dword ptr [ebp + arg_8]             # 004d5788
    mov dword ptr [edx], ecx                     # 004d578b
    mov eax, dword ptr [ebp + arg_8]             # 004d578d
    mov ecx, dword ptr [eax + field_4]           # 004d5790
    add ecx, dword ptr [ebp - local_4]           # 004d5793
    mov edx, dword ptr [ebp + arg_8]             # 004d5796
    mov dword ptr [edx + field_4], ecx           # 004d5799
    mov eax, dword ptr [ebp + arg_8]             # 004d579c
    mov ecx, dword ptr [eax]                     # 004d579f
    mov edx, dword ptr [ebp - local_10]          # 004d57a1
    lea eax, [ecx + edx - field_minus_1]         # 004d57a4
    mov ecx, dword ptr [ebp + arg_8]             # 004d57a8
    mov dword ptr [ecx + field_8], eax           # 004d57ab
    mov edx, dword ptr [ebp + arg_8]             # 004d57ae
    mov eax, dword ptr [edx + field_4]           # 004d57b1
    mov ecx, dword ptr [ebp - local_8]           # 004d57b4
    lea edx, [eax + ecx - field_minus_1]         # 004d57b7
    mov eax, dword ptr [ebp + arg_8]             # 004d57bb
    mov dword ptr [eax + field_c], edx           # 004d57be
    mov ecx, dword ptr [ebp + arg_10]            # 004d57c1
    mov edx, dword ptr [ebp + arg_c]             # 004d57c4
    mov eax, dword ptr [ecx]                     # 004d57c7
    mov dword ptr [edx], eax                     # 004d57c9
    mov eax, dword ptr [ecx + field_4]           # 004d57cb
    mov dword ptr [edx + field_4], eax           # 004d57ce
    mov eax, dword ptr [ecx + field_8]           # 004d57d1
    mov dword ptr [edx + field_8], eax           # 004d57d4
    mov ecx, dword ptr [ecx + field_c]           # 004d57d7
    mov dword ptr [edx + field_c], ecx           # 004d57da
    mov eax, 0x1                                 # 004d57dd
L_004d57e2:
    # block 0x004d57e2: entered by jmp at 0x004d56ff; jmp at 0x004d573c, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004d57e2
    pop ebp                                      # 004d57e4
    ret 0xc                                      # 004d57e5

