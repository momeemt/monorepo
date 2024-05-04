# Supported instructions

| Instruction | Execution Supported | Validation Supported | Binary Opcode |
| --- | --- | --- | --- |
| unreachable | x | x | 0x00 |
| nop | x | x | 0x01 |
| block $bt$ | x | x | 0x02 |
| loop $bt$ | x | x | 0x03 |
| if $bt$ | x | x | 0x04 |
| else | x | x | 0x05 |
| end | todo | x | 0x0B |
| br $l$ | x | x | 0x0C |
| br_if $l$ | x | x | 0x0D |
| br_table $l\times l$ | x | x | 0x0E |
| return | x | x | 0x0F |
| call $x$ | todo | x | 0x10 |
| call_indirect $x\; y$ | x | x | 0x11 |
| drop | x | x | 0x1A |
| select | x | x | 0x1B |
| select $t$ | x | x | 0x1C |
| local.get $x$ | ✅ | x | 0x20 |
| local.set $x$ | ✅ | x | 0x21 |
| local.tee $x$ | x | x | 0x22 |
| global.get $x$ | x | x | 0x23 |
| global.set $x$ | x | x | 0x24 |
| table.get $x$ | x | x | 0x25 |
| table.set $x$ | x | x | 0x26 |
| i32.load memarg | x | x | 0x28 |
| i64.load memarg | x | x | 0x29 |
| f32.load memarg | x | x | 0x2A |
| f64.load memarg | x | x | 0x2B |
| i32.load8_s memarg | x | x | 0x2C |
| i32.load8_u memarg | x | x | 0x2D |
| i32.load16_s memarg | x | x | 0x2E |
| i32.load16_u memarg | x | x | 0x2F |
| i64.load8_s memarg | x | x | 0x30 |
| i64.load8_u memarg | x | x | 0x31 |
| i64.load16_s memarg | x | x | 0x32 |
| i64.load16_u memarg | x | x | 0x33 |
| i64.load32_s memarg | x | x | 0x34 |
| i64.load32_u memarg | x | x | 0x35 |
| i32.store memarg | todo | x | 0x36 |
| i64.store memarg | x | x | 0x37 |
| f32.store memarg | x | x | 0x38 |
| f64.store memarg | x | x | 0x39 |
| i32.store8 memarg | x | x | 0x3A |
| i32.store16 memarg | x | x | 0x3B |
| i64.store8 memarg | x | x | 0x3C |
| i64.store16 memarg | x | x | 0x3D |
| i64.store32 memarg | x | x | 0x3E |
| memory.size | x | x | 0x3F |
| memory.grow | x | x | 0x40 |
| i32.const i32 | todo | x | 0x41 |
| i64.const i64 | x | x | 0x42 |
| f32.const f32 | x | x | 0x43 |
| f64.const f64 | x | x | 0x44 |
| i32.eqz | ✅ | x | 0x45 |
| i32.eq | x | x | 0x46 |
| i32.ne | x | x | 0x47 |
| i32.lt_s | x | x | 0x48 |
| i32.lt_u | x | x | 0x49 |
| i32.gt_s | x | x | 0x4A |
| i32.gt_u | x | x | 0x4B |
| i32.le_s | x | x | 0x4C |
| i32.le_u | x | x | 0x4D |
| i32.ge_s | x | x | 0x4E |
| i32.ge_u | x | x | 0x4F |
| i64.eqz | x | x | 0x50 |
| i64.eq | x | x | 0x51 |
| i64.ne | x | x | 0x52 |
| i64.lt_s | x | x | 0x53 |
| i64.lt_u | x | x | 0x54 |
| i64.gt_s | x | x | 0x55 |
| i64.gt_u | x | x | 0x56 |
| i64.le_s | x | x | 0x57 |
| i64.le_u | x | x | 0x58 |
| i64.ge_s | x | x | 0x59 |
| i64.ge_u | x | x | 0x5A |
| f32.eq | x | x | 0x5B |
| f32.ne | x | x | 0x5C |
| f32.lt | x | x | 0x5D |
| f32.gt | x | x | 0x5E |
| f32.le | x | x | 0x5F |
| f32.ge | x | x | 0x60 |
| f64.eq | x | x | 0x61 |
| f64.ne | x | x | 0x62 |
| f64.lt | x | x | 0x63 |
| f64.gt | x | x | 0x64 |
| f64.le | x | x | 0x65 |
| f64.ge | x | x | 0x66 |
| i32.clz | x | x | 0x67 |
| i32.ctz | x | x | 0x68 |
| i32.popcnt | x | x | 0x69 |
| i32.add | ✅ | x | 0x6A |
| i32.sub | ✅ | x | 0x6B |
| i32.mul | ✅ | x | 0x6C |
| i32.div_s | x | x | 0x6D |
| i32.div_u | x | x | 0x6E |
| i32.rem_s | x | x | 0x6F |
| i32.rem_u | x | x | 0x70 |
| i32.and | x | x | 0x71 |
| i32.or | x | x | 0x72 |
| i32.xor | x | x | 0x73 |
| i32.shl | x | x | 0x74 |
| i32.shr_s | x | x | 0x75 |
| i32.shr_u | x | x | 0x76 |
| i32.rotl | x | x | 0x77 |
| i32.rotr | x | x | 0x78 |
| i64.clz | x | x | 0x79 |
| i64.ctz | x | x | 0x7A |
| i64.popcnt | x | x | 0x7B |
| i64.add | x | x | 0x7C |
| i64.sub | x | x | 0x7D |
| i64.mul | x | x | 0x7E |
| i64.div_s | x | x | 0x7F |
| i64.div_u | x | x | 0x80 |
| i64.rem_s | x | x | 0x81 |
| i64.rem_u | x | x | 0x82 |
| i64.and | x | x | 0x83 |
| i64.or | x | x | 0x84 |
| i64.xor | x | x | 0x85 |
| i64.shl | x | x | 0x86 |
| i64.shr_s | x | x | 0x87 |
| i64.shr_u | x | x | 0x88 |
| i64.rotl | x | x | 0x89 |
| i64.rotr | x | x | 0x8A |
| f32.abs | x | x | 0x8B |
| f32.neg | x | x | 0x8C |
| f32.ceil | x | x | 0x8D |
| f32.floor | x | x | 0x8E |
| f32.trunc | x | x | 0x8F |
| f32.nearest | x | x | 0x90 |
| f32.sqrt | x | x | 0x91 |
| f32.add | x | x | 0x92 |
| f32.sub | x | x | 0x93 |
| f32.mul | x | x | 0x94 |
| f32.div | x | x | 0x95 |
| f32.min | x | x | 0x96 |
| f32.max | x | x | 0x97 |
| f32.copysign | x | x | 0x98 |
| f64.abs | x | x | 0x99 |
| f64.neg | x | x | 0x9A |
| f64.ceil | x | x | 0x9B |
| f64.floor | x | x | 0x9C |
| f64.trunc | x | x | 0x9D |
| f64.nearest | x | x | 0x9E |
| f64.sqrt | x | x | 0x9F |
| f64.add | x | x | 0xA0 |
| f64.sub | x | x | 0xA1 |
| f64.mul | x | x | 0xA2 |
| f64.div | x | x | 0xA3 |
| f64.min | x | x | 0xA4 |
| f64.max | x | x | 0xA5 |
| f64.copysign | x | x | 0xA6 |
| i32.wrap_i64 | x | x | 0xA7 |
| i32.trunc_f32_s | x | x | 0xA8 |
| i32.trunc_f32_u | x | x | 0xA9 |
| i32.trunc_f64_s | x | x | 0xAA |
| i32.trunc_f64_u | x | x | 0xAB |
| i64.extend_i32_s | x | x | 0xAC |
| i64.extend_i32_u | x | x | 0xAD |
| i64.trunc_f32_s | x | x | 0xAE |
| i64.trunc_f32_u | x | x | 0xAF |
| i64.trunc_f64_s | x | x | 0xB0 |
| i64.trunc_f64_u | x | x | 0xB1 |
| f32.convert_i32_s | x | x | 0xB2 |
| f32.convert_i32_u | x | x | 0xB3 |
| f32.convert_i64_s | x | x | 0xB4 |
| f32.convert_i64_u | x | x | 0xB5 |
| f32.demote_f64 | x | x | 0xB6 |
| f64.convert_i32_s | x | x | 0xB7 |
| f64.convert_i32_u | x | x | 0xB8 |
| f64.convert_i64_s | x | x | 0xB9 |
| f64.convert_i64_u | x | x | 0xBA |
| f64.promote_f32 | x | x | 0xBB |
| i32.reinterpret_f32 | x | x | 0xBC |
| i64.reinterpret_f64 | x | x | 0xBD |
| f32.reinterpret_i32 | x | x | 0xBE |
| f64.reinterpret_i64 | x | x | 0xBF |
| i32.extend8_s | x | x | 0xC0 |
| i32.extend16_s | x | x | 0xC1 |
| i64.extend8_s | x | x | 0xC2 |
| i64.extend16_s | x | x | 0xC3 |
| i64.extend32_s | x | x | 0xC4 |

