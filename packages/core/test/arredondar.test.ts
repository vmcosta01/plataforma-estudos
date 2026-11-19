import { describe, expect, it } from 'vitest';
import { arredondarCentesimos } from '../src/nota/arredondar';

describe('arredondarCentesimos — item 14.2: duas casas, para cima se a 3ª casa ≥ 5', () => {
  it.each([
    [5995, 1000, 600], // 5,995 → 6,00
    [59949, 10000, 599], // 5,9949 → 5,99
    [17, 3, 567], // 5,666… → 5,67
    [16, 3, 533], // 5,333… → 5,33
    [6, 1, 600],
    [0, 7, 0],
    [1005, 1000, 101], // 1,005 → 1,01 (sem erro de ponto flutuante)
  ])('%i/%i → %i centésimos', (n, d, esperado) => {
    expect(arredondarCentesimos({ numerador: n, denominador: d })).toBe(esperado);
  });

  it('rejeita denominador zero ou negativo', () => {
    expect(() => arredondarCentesimos({ numerador: 1, denominador: 0 })).toThrow();
  });
});
