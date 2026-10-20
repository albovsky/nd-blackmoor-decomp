# FUN_004632bf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004632bf
# extent:       0x004632bf-0x00463392 (211 code bytes)
# span:         0x004632bf-0x00463392 (code 211, tables 0, padding 0)
# sha256:       ebaa96204b12ef3064a71bd81781a85c1912211b2f65ea0320190801adeae3bf
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         solved_scan
# naming:       native port src/action_family_d3_runtime.c:solved_scan (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the summary is the acceptance note
# summary:      1:1 with solved_scan (all cells vs target types, one state store). Native takes a CpzHost for the observer; oracle is aggregate (object image, effect).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1e, field_24; [ecx + n] field_47; [edx + n] field_22, field_24
# callees:      calls FUN_00461d4b
# track-n:      outputs/blackmoor-decomp/src/action_family_d3_runtime.c:solved_scan (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 60 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_22, 0x22  # offset +0x22
.equ field_24, 0x24  # offset +0x24
.equ field_47, 0x47  # offset +0x47

# --- external targets -----------------------------------------------
.set FUN_00461d4b, .text + (0x00461d4b - 0x401000)

.org 0x004632bf - 0x401000
.globl FUN_004632bf
FUN_004632bf:
    # block 0x004632bf: entry, 11 instruction(s), ends with forward jump to 0x004632f2
    push ebp                                     # 004632bf
    {load} mov ebp, esp                          # 004632c0
    sub esp, 0x10                                # 004632c2
    mov dword ptr [ebp - local_10], ecx          # 004632c5
    mov eax, dword ptr [ebp - local_10]          # 004632c8
    movsx ecx, word ptr [eax + field_1e]         # 004632cb
    imul ecx, ecx, 0x8d                          # 004632cf
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004632d5
    mov dword ptr [ebp - local_8], edx           # 004632db
    mov word ptr [ebp - local_4], 0x0            # 004632de
    jmp.d8 L_004632f2                            # 004632e4
L_004632e6:
    # block 0x004632e6: entered by jmp at 0x00463375, 3 instruction(s), falls into the block at 0x004632f2
    mov ax, word ptr [ebp - local_4]             # 004632e6
    .insn 0x66, 0x05, 0x0001{:u16}               # 004632ea
    mov word ptr [ebp - local_4], ax             # 004632ee
L_004632f2:
    # block 0x004632f2: entered by jmp at 0x004632e4, 5 instruction(s), ends with jge to 0x0046337a (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004632f2
    mov edx, dword ptr [ebp - local_8]           # 004632f6
    movsx eax, word ptr [edx + field_22]         # 004632f9
    {load} cmp ecx, eax                          # 004632fd
    jge.d8 L_0046337a                            # 004632ff
    # block 0x00463301: entered by fall-through of jge at 0x004632ff, 2 instruction(s), ends with forward jump to 0x00463315
    mov word ptr [ebp - local_c], 0x0            # 00463301
    jmp.d8 L_00463315                            # 00463307
L_00463309:
    # block 0x00463309: entered by jmp at 0x00463373, 3 instruction(s), falls into the block at 0x00463315
    mov cx, word ptr [ebp - local_c]             # 00463309
    add cx, 0x1                                  # 0046330d
    mov word ptr [ebp - local_c], cx             # 00463311
L_00463315:
    # block 0x00463315: entered by jmp at 0x00463307, 5 instruction(s), ends with jge to 0x00463375 (forward)
    movsx edx, word ptr [ebp - local_c]          # 00463315
    mov eax, dword ptr [ebp - local_8]           # 00463319
    movsx ecx, word ptr [eax + field_24]         # 0046331c
    {load} cmp edx, ecx                          # 00463320
    jge.d8 L_00463375                            # 00463322
    # block 0x00463324: entered by fall-through of jge at 0x00463322, 7 instruction(s), ends with je to 0x00463373 (forward)
    movsx edx, word ptr [ebp - local_4]          # 00463324
    imul edx, edx, 0x140                         # 00463328
    movsx eax, word ptr [ebp - local_c]          # 0046332e
    imul eax, eax, 0x28                          # 00463332
    movsx ecx, word ptr [edx + eax + 0x594ddb]   # 00463335
    test ecx, ecx                                # 0046333d
    je.d8 L_00463373                             # 0046333f
    # block 0x00463341: entered by fall-through of je at 0x0046333f, 14 instruction(s), calls FUN_00461d4b, ends with jne to 0x00463373 (forward)
    mov dx, word ptr [ebp - local_c]             # 00463341
    push edx                                     # 00463345
    mov ax, word ptr [ebp - local_4]             # 00463346
    push eax                                     # 0046334a
    movsx ecx, word ptr [ebp - local_4]          # 0046334b
    imul ecx, ecx, 0x140                         # 0046334f
    movsx edx, word ptr [ebp - local_c]          # 00463355
    imul edx, edx, 0x28                          # 00463359
    mov ax, word ptr [ecx + edx + 0x594ddb]      # 0046335c
    push eax                                     # 00463364
    mov ecx, dword ptr [ebp - local_10]          # 00463365
    call FUN_00461d4b                            # 00463368
    test eax, eax                                # 0046336d
    jne.d8 L_00463373                            # 0046336f
    # block 0x00463371: entered by fall-through of jne at 0x0046336f, 1 instruction(s), ends with forward jump to 0x0046338e
    jmp.d8 L_0046338e                            # 00463371
L_00463373:
    # block 0x00463373: entered by je at 0x0046333f; jne at 0x0046336f, 1 instruction(s), ends with backward jump to 0x00463309
    jmp.d8 L_00463309                            # 00463373
L_00463375:
    # block 0x00463375: entered by jge at 0x00463322, 1 instruction(s), ends with backward jump to 0x004632e6
    jmp.d32 L_004632e6                           # 00463375
L_0046337a:
    # block 0x0046337a: entered by jge at 0x004632ff, 4 instruction(s), falls into the block at 0x0046338e
    mov ecx, dword ptr [ebp - local_10]          # 0046337a
    mov dword ptr [ecx + field_47], 0x1          # 0046337d
    mov edx, dword ptr [ebp - local_10]          # 00463384
    mov dword ptr [edx + field_24], 0x1          # 00463387
L_0046338e:
    # block 0x0046338e: entered by jmp at 0x00463371, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0046338e
    pop ebp                                      # 00463390
    ret                                          # 00463391

