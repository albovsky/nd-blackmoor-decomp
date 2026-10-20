# FUN_0047e8fe
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047e8fe
# extent:       0x0047e8fe-0x0047e99e (160 code bytes)
# span:         0x0047e8fe-0x0047e99e (code 160, tables 0, padding 0)
# sha256:       1ddeb99e03ecbb86547e2a76f2e7e57bd47673cb4039efbf9649f98c7fd2388d
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         top_piece_47e8fe
# naming:       native port src/action_family_eb_runtime.c:top_piece_47e8fe (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with top_piece_47e8fe (list +0x1419, count +0x1441, strict less keeps the first, -1 if empty). No bounds guard on list entries, as in the original.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1441; [ecx + n] field_7b4; [edx + n] field_1419, field_1441
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_eb_runtime.c:top_piece_47e8fe (function ledger class native_oracle_verified; also top_piece_of_list; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 44 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_7b4, 0x7b4  # offset +0x7b4
.equ field_1419, 0x1419  # offset +0x1419
.equ field_1441, 0x1441  # offset +0x1441

# --- external targets -----------------------------------------------

.org 0x0047e8fe - 0x401000
.globl FUN_0047e8fe
FUN_0047e8fe:
    # block 0x0047e8fe: entry, 9 instruction(s), ends with jne to 0x0047e921 (forward)
    push ebp                                     # 0047e8fe
    {load} mov ebp, esp                          # 0047e8ff
    sub esp, 0xc                                 # 0047e901
    mov dword ptr [ebp - local_c], ecx           # 0047e904
    mov word ptr [ebp - local_8], 0xffff         # 0047e907
    mov eax, dword ptr [ebp - local_c]           # 0047e90d
    movsx ecx, word ptr [eax + field_1441]       # 0047e910
    test ecx, ecx                                # 0047e917
    jne.d8 L_0047e921                            # 0047e919
    # block 0x0047e91b: entered by fall-through of jne at 0x0047e919, 2 instruction(s), ends with forward jump to 0x0047e99a
    mov ax, word ptr [ebp - local_8]             # 0047e91b
    jmp.d8 L_0047e99a                            # 0047e91f
L_0047e921:
    # block 0x0047e921: entered by jne at 0x0047e919, 5 instruction(s), ends with forward jump to 0x0047e941
    mov edx, dword ptr [ebp - local_c]           # 0047e921
    mov ax, word ptr [edx + field_1419]          # 0047e924
    mov word ptr [ebp - local_8], ax             # 0047e92b
    mov dword ptr [ebp - local_4], 0x1           # 0047e92f
    jmp.d8 L_0047e941                            # 0047e936
L_0047e938:
    # block 0x0047e938: entered by jmp at 0x0047e994, 3 instruction(s), falls into the block at 0x0047e941
    mov ecx, dword ptr [ebp - local_4]           # 0047e938
    add ecx, 0x1                                 # 0047e93b
    mov dword ptr [ebp - local_4], ecx           # 0047e93e
L_0047e941:
    # block 0x0047e941: entered by jmp at 0x0047e936, 4 instruction(s), ends with jge to 0x0047e996 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047e941
    movsx eax, word ptr [edx + field_1441]       # 0047e944
    cmp dword ptr [ebp - local_4], eax           # 0047e94b
    jge.d8 L_0047e996                            # 0047e94e
    # block 0x0047e950: entered by fall-through of jge at 0x0047e94e, 12 instruction(s), ends with jle to 0x0047e994 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0047e950
    mov edx, dword ptr [ebp - local_c]           # 0047e953
    movsx eax, word ptr [edx + 2*ecx + field_1419] # 0047e956
    imul eax, eax, 0x25                          # 0047e95e
    mov ecx, dword ptr [ebp - local_c]           # 0047e961
    movsx edx, word ptr [ecx + eax + field_7b4]  # 0047e964
    movsx eax, word ptr [ebp - local_8]          # 0047e96c
    imul eax, eax, 0x25                          # 0047e970
    mov ecx, dword ptr [ebp - local_c]           # 0047e973
    movsx eax, word ptr [ecx + eax + field_7b4]  # 0047e976
    {load} cmp edx, eax                          # 0047e97e
    jle.d8 L_0047e994                            # 0047e980
    # block 0x0047e982: entered by fall-through of jle at 0x0047e980, 4 instruction(s), falls into the block at 0x0047e994
    mov ecx, dword ptr [ebp - local_4]           # 0047e982
    mov edx, dword ptr [ebp - local_c]           # 0047e985
    mov ax, word ptr [edx + 2*ecx + field_1419]  # 0047e988
    mov word ptr [ebp - local_8], ax             # 0047e990
L_0047e994:
    # block 0x0047e994: entered by jle at 0x0047e980, 1 instruction(s), ends with backward jump to 0x0047e938
    jmp.d8 L_0047e938                            # 0047e994
L_0047e996:
    # block 0x0047e996: entered by jge at 0x0047e94e, 1 instruction(s), falls into the block at 0x0047e99a
    mov ax, word ptr [ebp - local_8]             # 0047e996
L_0047e99a:
    # block 0x0047e99a: entered by jmp at 0x0047e91f, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0047e99a
    pop ebp                                      # 0047e99c
    ret                                          # 0047e99d

