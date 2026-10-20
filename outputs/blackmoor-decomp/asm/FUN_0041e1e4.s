# FUN_0041e1e4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041e1e4
# extent:       0x0041e1e4-0x0041e250 (108 code bytes)
# span:         0x0041e1e4-0x0041e250 (code 108, tables 0, padding 0)
# sha256:       9bbe379f0523d99fe874ac3a10302d21fda25564610e3b28743877298d1655db
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         cel_find_slot
# naming:       native port src/action_family_3f_runtime.c:cel_find_slot (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-16); the summary is the acceptance note
# summary:      Cel video cache lookup by frame. RT-25 oracle runs the original, every byte executed, compared after every effect. Native loop bound is the clamped capacity.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_68e; [ecx + n] field_1c, field_696
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:cel_find_slot (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 34 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_68e, 0x68e  # offset +0x68e
.equ field_696, 0x696  # offset +0x696

# --- external targets -----------------------------------------------

.org 0x0041e1e4 - 0x401000
.globl FUN_0041e1e4
FUN_0041e1e4:
    # block 0x0041e1e4: entry, 8 instruction(s), ends with jne to 0x0041e201 (forward)
    push ebp                                     # 0041e1e4
    {load} mov ebp, esp                          # 0041e1e5
    sub esp, 0x8                                 # 0041e1e7
    mov dword ptr [ebp - local_8], ecx           # 0041e1ea
    mov eax, dword ptr [ebp - local_8]           # 0041e1ed
    movsx ecx, word ptr [eax + field_68e]        # 0041e1f0
    test ecx, ecx                                # 0041e1f7
    jne.d8 L_0041e201                            # 0041e1f9
    # block 0x0041e1fb: entered by fall-through of jne at 0x0041e1f9, 2 instruction(s), ends with forward jump to 0x0041e24a
    .insn 0x66, 0x0d, 0xffff{:u16}               # 0041e1fb
    jmp.d8 L_0041e24a                            # 0041e1ff
L_0041e201:
    # block 0x0041e201: entered by jne at 0x0041e1f9, 2 instruction(s), ends with forward jump to 0x0041e215
    mov word ptr [ebp - local_4], 0x0            # 0041e201
    jmp.d8 L_0041e215                            # 0041e207
L_0041e209:
    # block 0x0041e209: entered by jmp at 0x0041e244, 3 instruction(s), falls into the block at 0x0041e215
    mov dx, word ptr [ebp - local_4]             # 0041e209
    add dx, 0x1                                  # 0041e20d
    mov word ptr [ebp - local_4], dx             # 0041e211
L_0041e215:
    # block 0x0041e215: entered by jmp at 0x0041e207, 5 instruction(s), ends with jge to 0x0041e246 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0041e215
    mov ecx, dword ptr [ebp - local_8]           # 0041e219
    movsx edx, word ptr [ecx + field_696]        # 0041e21c
    {load} cmp eax, edx                          # 0041e223
    jge.d8 L_0041e246                            # 0041e225
    # block 0x0041e227: entered by fall-through of jge at 0x0041e225, 7 instruction(s), ends with jne to 0x0041e244 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0041e227
    imul eax, eax, 0x16                          # 0041e22b
    mov ecx, dword ptr [ebp - local_8]           # 0041e22e
    movsx edx, word ptr [ecx + eax + field_1c]   # 0041e231
    movsx eax, word ptr [ebp + arg_8]            # 0041e236
    {load} cmp edx, eax                          # 0041e23a
    jne.d8 L_0041e244                            # 0041e23c
    # block 0x0041e23e: entered by fall-through of jne at 0x0041e23c, 2 instruction(s), ends with forward jump to 0x0041e24a
    mov ax, word ptr [ebp - local_4]             # 0041e23e
    jmp.d8 L_0041e24a                            # 0041e242
L_0041e244:
    # block 0x0041e244: entered by jne at 0x0041e23c, 1 instruction(s), ends with backward jump to 0x0041e209
    jmp.d8 L_0041e209                            # 0041e244
L_0041e246:
    # block 0x0041e246: entered by jge at 0x0041e225, 1 instruction(s), falls into the block at 0x0041e24a
    .insn 0x66, 0x0d, 0xffff{:u16}               # 0041e246
L_0041e24a:
    # block 0x0041e24a: entered by jmp at 0x0041e1ff; jmp at 0x0041e242, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0041e24a
    pop ebp                                      # 0041e24c
    ret 0x4                                      # 0041e24d

