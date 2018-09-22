# Simplex Method Matlab Implementation

This is matlab implementation of simplex method only using basic functions to better understand logics.

#### There are three modes to choose pivots

* Smallest Index Rule (SIR): Blend's rule

* Largest Index Rule (LIR): Reverse of SIR

* Successive Ratio Rule (SRR): Lexicographic order

### Running the tests

```
matlab -r main
```
- #### You can change the file to import (in main.m file)

```
t = importdata('./data/XXX.txt', ' ');
```

- #### You can choose mode 'SIR' by (in main.m file)

```
mode = 'SIR';
```

### Data Format (.txt)

![equation](./image/CodeCogsEgn.gif)
