import { describe, expect, it } from 'vitest';
import { banestes2026TecnicoBancario as banestes } from '../src/editais/banestes-2026-tecnico-bancario';
import { calcularNota } from '../src/nota/calcular';

// Casos de TESTING.md §2.1 (conferidos contra planilha: G = a/30*10, E = a/40*10, F = (G + 2E) / 3).
const casos: Array<[number, number, string, boolean]> = [
  [30, 40, '10.00', true],
  [0, 0, '0.00', false],
  [18, 24, '6.00', true], // borda exata da nota mínima
  [17, 24, '5.89', false],
  [30, 18, '6.33', true],
  [15, 30, '6.67', true],
  [21, 20, '5.67', false],
  [24, 26, '7.00', true],
  [9, 36, '7.00', true],
  [27, 21, '6.50', true],
];

describe('calcularNota — Banestes 2026 Técnico Bancário', () => {
  it.each(casos)('G=%i E=%i → final %s, habilitado=%s', (g, e, finalEsperada, habilitado) => {
    const r = calcularNota(banestes, { gerais: g, especificos: e });
    expect(r.final.toFixed(2)).toBe(finalEsperada);
    expect(r.habilitado).toBe(habilitado);
  });

  it('decide a borda 6,00 sem erro de ponto flutuante', () => {
    const r = calcularNota(banestes, { gerais: 18, especificos: 24 });
    expect(r.finalExata).toEqual({ numerador: 6, denominador: 1 });
    expect(r.habilitado).toBe(true);
  });

  it('expõe notas por bloco na escala 0 a 10', () => {
    const r = calcularNota(banestes, { gerais: 15, especificos: 20 });
    expect(r.porBloco.gerais).toBeCloseTo(5, 10);
    expect(r.porBloco.especificos).toBeCloseTo(5, 10);
  });

  it('arredonda com duas casas, meia para cima (item 14.2 do edital)', () => {
    // 17/30 → 5,6667 → 5,67 ; 24/40 → 6,00 ; final (5,67 + 12,00) / 3 = 5,89
    const r = calcularNota(banestes, { gerais: 17, especificos: 24 });
    expect(r.porBlocoCentesimos).toEqual({ gerais: 567, especificos: 600 });
    expect(r.finalCentesimos).toBe(589);
  });

  it.each([
    [{ gerais: -1, especificos: 0 }],
    [{ gerais: 31, especificos: 0 }],
    [{ gerais: 0, especificos: 41 }],
    [{ gerais: 2.5, especificos: 0 }],
  ])('rejeita acertos inválidos %o', (acertos) => {
    expect(() => calcularNota(banestes, acertos)).toThrow(/acertos/i);
  });
});
