# FUN_0045b300
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045b300
# extent:       0x0045b300-0x0045b36a (106 code bytes)
# span:         0x0045b300-0x0045b36a (code 106, tables 0, padding 0)
# sha256:       2737275bbd5c95482561ca0f98b6755df183e7cb606800a99558c430f2433446
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_bul_puzzle_object_allocator
# naming:       INFERRED (lower confidence, not verified): the repository text tasks/RT-59-bul-puzzle-da-runtime.md:9 says "allocated by `0x45b300`"
# name-note:    Allocates the 0x1b9-byte raw 0xda Bul puzzle singleton object.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0045b37a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_0045b37a, .text + (0x0045b37a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0045b300 - 0x401000
.globl FUN_0045b300
FUN_0045b300:
    # block 0x0045b300: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x0045b345 (forward)
    push ebp                                     # 0045b300
    {load} mov ebp, esp                          # 0045b301
    push -0x1                                    # 0045b303
    push 0x5280ba                                # 0045b305
    mov eax, dword ptr fs:[0x0]                  # 0045b30a
    push eax                                     # 0045b310
    mov dword ptr fs:[0x0], esp                  # 0045b311
    sub esp, 0xc                                 # 0045b318
    push 0x1b9                                   # 0045b31b
    call FUN_0051dc43                            # 0045b320
    add esp, 0x4                                 # 0045b325
    mov dword ptr [ebp - local_14], eax          # 0045b328
    mov dword ptr [ebp - local_4], 0x0           # 0045b32b
    cmp dword ptr [ebp - local_14], 0x0          # 0045b332
    je.d8 L_0045b345                             # 0045b336
    # block 0x0045b338: entered by fall-through of je at 0x0045b336, 4 instruction(s), calls FUN_0045b37a, ends with forward jump to 0x0045b34c
    mov ecx, dword ptr [ebp - local_14]          # 0045b338
    call FUN_0045b37a                            # 0045b33b
    mov dword ptr [ebp - local_18], eax          # 0045b340
    jmp.d8 L_0045b34c                            # 0045b343
L_0045b345:
    # block 0x0045b345: entered by je at 0x0045b336, 1 instruction(s), falls into the block at 0x0045b34c
    mov dword ptr [ebp - local_18], 0x0          # 0045b345
L_0045b34c:
    # block 0x0045b34c: entered by jmp at 0x0045b343, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0045b34c
    mov dword ptr [ebp - local_10], eax          # 0045b34f
    mov dword ptr [ebp - local_4], 0xffffffff    # 0045b352
    mov eax, dword ptr [ebp - local_10]          # 0045b359
    mov ecx, dword ptr [ebp - local_c]           # 0045b35c
    mov dword ptr fs:[0x0], ecx                  # 0045b35f
    {load} mov esp, ebp                          # 0045b366
    pop ebp                                      # 0045b368
    ret                                          # 0045b369

