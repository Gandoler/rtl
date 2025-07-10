 # 32 BIT Summator
 
 [ссылка на проекит в  drowio](https://clck.ru/3N2niM)
 
# Суууууупер примерная поведения на графике 

 ```md
 { "signal" : [
  { "name": "CLK",  "wave": "P.......", "period": 2 },
  { "name": "rst",  "wave": "10......" },
  { "name": "a[15:0]", "wave": "x.3.....", "data": "a0" },
  { "name": "b[15:0]", "wave": "x.3.....", "data": "b0" },
  { "name": "sum[15:0]", "wave": "x..3....", "data": "s0" },
  { "name": "carry", "wave": "x..1....", "data": "c" },

  { "name": "a[31:16]", "wave": "x...3...", "data": "a1" },
  { "name": "b[31:16]", "wave": "x...3...", "data": "b1" },
  { "name": "sum[31:16]", "wave": "x....3..", "data": "s1" }
]}

```

 ```md
 {reg: [
    {bits: 7,  name: 'opcode',    attr: 'BRANCH'},
    {bits: 5,  name: 'imm',       attr: 'offset[11|4:1]', type: 7},
    {bits: 3,  name: 'func3',     attr: ['BEQ', 'BNE', 'BLT', 'BLTU', 'BGE', 'BGEU'], type: 4},
    {bits: 5,  name: 'rs1',       attr: 'src1'},
    {bits: 5,  name: 'rs2',       attr: 'src2'},
    {bits: 7,  name: 'imm',       attr: 'offset[12|10:5]', type: 3}
]}

 ```