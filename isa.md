# TIS-100

This is an attempt at an actual instruction set architecture for the TIS-100.

Instructions are two bytes, fixed width. This is necessary because `mov`
instructions may use immediate mode with constants a full byte in size. This
leaves _no_ extra room within a one-byte ISA for the rest of the necessary
information.

## Registers / Ports / Pseudoports

The following may all be used as either the source or destination of a `mov`
instruction:

|Name|Code|
|----|----|
|`ACC`|`000`|
|`NIL`|`001`|
|`LEFT`|`010`|
|`RIGHT`|`011`|
|`UP`|`100`|
|`DOWN`|`101`|
|`ANY`|`110`|
|`LAST`|`111`|

## Instruction Classes

Instructions are divided into 4 different classes based on their arities and the
types of the arguments, each of which is represented by a 3 bit prefix.

|Class Number|Description|Prefix|
|------------|-----------|------|
|0|Move from register to register|`000`|
|1|Move from constant to register|`001`|
|2|Nullary Instructions|`010`|
|3|Unary Constant Instructions|`011`|
|4|Unary Register Instructions|`100`|

### Class 0 Instructions

Format:

```
000     XXX 00      XXX 00000
class   src unused  dst unused
```

The 3 bit source and destination IDs follow the register/port/pseudoport list
above. 7 bits are left unused and their contents are ignored by the machine.

Examples:

```
MOV ACC, NIL
000 000 00    001 00000
```

```
MOV LEFT, RIGHT
000 010 00    011 00000
```

### Class 1 Instructions

Format:

```
001    XXX 00       XXXXXXXX
class  dst unused   constant
```

The 3 bit destination ID follows the register/port/pseudoport list above. 2 bits
are left unused and their contents are ignored by the machine.

### Class 2 Instructions

A 3 bit specifier is used to distinguish between the 3 nullary instructions in class 2:

|Instruction|Code|
|-----------|----|
|`SWP`|000|
|`SAV`|001|
|`NEG`|010|

Format:

```
010     XXX       00      00000000
prefix  specifier unused  unused
```

Examples:

```
SWP
01000000 0000000
```

```
NEG
01001000 0000000
```

### Class 3 Instructions

Classes 3 and 4 are both subdivided into two subclasses: conditional
instructions and arithmetic instructions. An additional 1-bit specifier is
defined for these two types:

|Type|Specifier|
|----|---------|
|Conditional|0|
|Arithmetic|1|

Then a 3-bit specifier within each subclass defines the specific instruction:

|Type|Specifier|
|----|---------|
|`JMP`|`000`|
|`JNZ`|`001`|
|`JGZ`|`010`|
|`JLZ`|`011`|
|`JLZ`|`011`|
|`JRO`|`100`|

|Type|Specifier|
|----|---------|
|`ADD`|`000`|
|`SUB`|`001`|

Format:

```
011   X        XXX  0     XXXXXXXX
class subclass inst unused constant
```

Examples:

```
JNZ 3
01100010 00000011
```

```
SUB 3
01110010 00000011
```

### Class 4 Instructions

Finally, in class 4, the source register/port/pseudoport is included as the
final 3 bits of the second byte.

Format:

```
100   X        XXX  0      00000  XXX
class subclass inst unused unused src
```

Examples:

```
JGZ RIGHT
10000100 00000011
```

```
ADD ANY
10010000 00000110
```
