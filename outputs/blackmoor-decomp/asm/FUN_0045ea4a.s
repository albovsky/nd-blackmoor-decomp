# FUN_0045ea4a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045ea4a
# extent:       0x0045ea4a-0x0045eadc (146 code bytes)
# span:         0x0045ea4a-0x0045eadc (code 146, tables 0, padding 0)
# sha256:       e8db9a7b2322f9e3b0b5b7ace96e3f44e19969ec00b1673341d5021a2b781491
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_card_refill_check_a
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_f6_runtime.h:25 says "0x45ea4a / 0x45eadc refill checks"
# name-note:    One of the two refill checks of the card puzzle.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_25; [ecx + n] field_24, field_142; [edx + n] field_d0, field_31d
# callees:      calls FUN_0045de8a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 40 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_24, 0x24  # offset +0x24
.equ field_25, 0x25  # offset +0x25
.equ field_d0, 0xd0  # offset +0xd0
.equ field_142, 0x142  # offset +0x142
.equ field_31d, 0x31d  # offset +0x31d

# --- external targets -----------------------------------------------
.set FUN_0045de8a, .text + (0x0045de8a - 0x401000)

.org 0x0045ea4a - 0x401000
.globl FUN_0045ea4a
FUN_0045ea4a:
    # block 0x0045ea4a: entry, 7 instruction(s), ends with forward jump to 0x0045ea6d
    push ebp                                     # 0045ea4a
    {load} mov ebp, esp                          # 0045ea4b
    sub esp, 0xc                                 # 0045ea4d
    mov dword ptr [ebp - local_c], ecx           # 0045ea50
    mov word ptr [ebp - local_4], 0x0            # 0045ea53
    mov word ptr [ebp - local_8], 0x0            # 0045ea59
    jmp.d8 L_0045ea6d                            # 0045ea5f
L_0045ea61:
    # block 0x0045ea61: entered by jmp at 0x0045eaa7, 3 instruction(s), falls into the block at 0x0045ea6d
    mov ax, word ptr [ebp - local_8]             # 0045ea61
    .insn 0x66, 0x05, 0x0001{:u16}               # 0045ea65
    mov word ptr [ebp - local_8], ax             # 0045ea69
L_0045ea6d:
    # block 0x0045ea6d: entered by jmp at 0x0045ea5f, 6 instruction(s), ends with jge to 0x0045eaa9 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0045ea6d
    mov edx, dword ptr [ebp - local_c]           # 0045ea71
    mov eax, dword ptr [edx + field_31d]         # 0045ea74
    movsx edx, word ptr [eax + field_25]         # 0045ea7a
    {load} cmp ecx, edx                          # 0045ea7e
    jge.d8 L_0045eaa9                            # 0045ea80
    # block 0x0045ea82: entered by fall-through of jge at 0x0045ea80, 9 instruction(s), ends with backward jump to 0x0045ea61
    movsx eax, word ptr [ebp + arg_8]            # 0045ea82
    imul eax, eax, 0x120                         # 0045ea86
    mov ecx, dword ptr [ebp - local_c]           # 0045ea8c
    lea edx, [ecx + eax + field_24]              # 0045ea8f
    movsx eax, word ptr [ebp - local_8]          # 0045ea93
    mov cx, word ptr [ebp - local_4]             # 0045ea97
    add cx, word ptr [edx + 2*eax + field_d0]    # 0045ea9b
    mov word ptr [ebp - local_4], cx             # 0045eaa3
    jmp.d8 L_0045ea61                            # 0045eaa7
L_0045eaa9:
    # block 0x0045eaa9: entered by jge at 0x0045ea80, 8 instruction(s), ends with jne to 0x0045ead6 (forward)
    movsx edx, word ptr [ebp - local_4]          # 0045eaa9
    movsx eax, word ptr [ebp + arg_8]            # 0045eaad
    imul eax, eax, 0x120                         # 0045eab1
    mov ecx, dword ptr [ebp - local_c]           # 0045eab7
    movsx eax, word ptr [ecx + eax + field_142]  # 0045eaba
    imul eax, eax, 0x3                           # 0045eac2
    {load} cmp edx, eax                          # 0045eac5
    jne.d8 L_0045ead6                            # 0045eac7
    # block 0x0045eac9: entered by fall-through of jne at 0x0045eac7, 4 instruction(s), calls FUN_0045de8a, falls into the block at 0x0045ead6
    mov cx, word ptr [ebp + arg_8]               # 0045eac9
    push ecx                                     # 0045eacd
    mov ecx, dword ptr [ebp - local_c]           # 0045eace
    call FUN_0045de8a                            # 0045ead1
L_0045ead6:
    # block 0x0045ead6: entered by jne at 0x0045eac7, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0045ead6
    pop ebp                                      # 0045ead8
    ret 0x4                                      # 0045ead9

