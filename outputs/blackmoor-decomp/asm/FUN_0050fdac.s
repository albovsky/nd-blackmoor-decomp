# FUN_0050fdac
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050fdac
# extent:       0x0050fdac-0x0050fdc5 (25 code bytes)
# span:         0x0050fdac-0x0050fdc5 (code 25, tables 0, padding 0)
# sha256:       b3acb9236b17a8d7439e76ed3fde70b7fb65fdb8059f9026cc1081acbf77754d
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050fa90 (+0x31c)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050fdac
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8; [edi + n] field_1, field_2, field_3; [esi + n] field_1, field_2, field_3
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ field_3, 0x3  # offset +0x3
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0050fdac - 0x401000
.globl FUN_0050fdac
FUN_0050fdac:
    # block 0x0050fdac: entry, 11 instruction(s), ends with ret
    mov al, byte ptr [esi + field_3]             # 0050fdac
    mov byte ptr [edi + field_3], al             # 0050fdaf
    mov al, byte ptr [esi + field_2]             # 0050fdb2
    mov byte ptr [edi + field_2], al             # 0050fdb5
    mov al, byte ptr [esi + field_1]             # 0050fdb8
    mov byte ptr [edi + field_1], al             # 0050fdbb
    mov eax, dword ptr [ebp + field_8]           # 0050fdbe
    pop esi                                      # 0050fdc1
    pop edi                                      # 0050fdc2
    leave                                        # 0050fdc3
    ret                                          # 0050fdc4

