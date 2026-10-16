# FUN_004c4202
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c4202
# extent:       0x004c4202-0x004c425e (92 code bytes)
# span:         0x004c4202-0x004c425e (code 92, tables 0, padding 0)
# sha256:       4759b7f595ea50378bb6643c9c222b560fece4f7b9c28c25fef32bd4a677007f
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c4202
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_c; [ecx + n] field_80
# callees:      calls FUN_004c88c7, FUN_0042639d, FUN_004c97b4; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 32 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ field_80, 0x80  # offset +0x80

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c88c7, .text + (0x004c88c7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)

.org 0x004c4202 - 0x401000
.globl FUN_004c4202
FUN_004c4202:
    # block 0x004c4202: entry, 8 instruction(s), ends with jne to 0x004c4218 (forward)
    push ebp                                     # 004c4202
    {load} mov ebp, esp                          # 004c4203
    sub esp, 0x8                                 # 004c4205
    mov dword ptr [ebp - local_8], ecx           # 004c4208
    mov eax, dword ptr [ebp - local_8]           # 004c420b
    mov ecx, dword ptr [ebp + arg_8]             # 004c420e
    cmp ecx, dword ptr [eax + field_c]           # 004c4211
    jne.d8 L_004c4218                            # 004c4214
    # block 0x004c4216: entered by fall-through of jne at 0x004c4214, 1 instruction(s), ends with forward jump to 0x004c4258
    jmp.d8 L_004c4258                            # 004c4216
L_004c4218:
    # block 0x004c4218: entered by jne at 0x004c4214, 10 instruction(s), calls indirect dword ptr [ecx + 0x80], ends with je to 0x004c4258 (forward)
    mov edx, dword ptr [ebp + arg_c]             # 004c4218
    push edx                                     # 004c421b
    mov eax, dword ptr [ebp + arg_8]             # 004c421c
    mov ecx, dword ptr [eax]                     # 004c421f
    mov edx, dword ptr [ebp + arg_8]             # 004c4221
    push edx                                     # 004c4224
    call dword ptr [ecx + field_80]              # 004c4225
    mov dword ptr [ebp - local_4], eax           # 004c422b
    cmp dword ptr [ebp - local_4], 0x0           # 004c422e
    je.d8 L_004c4258                             # 004c4232
    # block 0x004c4234: entered by fall-through of je at 0x004c4232, 10 instruction(s), calls FUN_004c88c7, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004c4258
    mov eax, dword ptr [ebp - local_4]           # 004c4234
    push eax                                     # 004c4237
    mov ecx, dword ptr [ebp - local_8]           # 004c4238
    call FUN_004c88c7                            # 004c423b
    push eax                                     # 004c4240
    push 0x5543f0                                # 004c4241
    mov ecx, 0x583979                            # 004c4246
    call FUN_0042639d                            # 004c424b
    mov ecx, dword ptr [ebp - local_8]           # 004c4250
    call FUN_004c97b4                            # 004c4253
L_004c4258:
    # block 0x004c4258: entered by jmp at 0x004c4216; je at 0x004c4232, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004c4258
    pop ebp                                      # 004c425a
    ret 0xc                                      # 004c425b

