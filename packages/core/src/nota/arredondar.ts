export interface Fracao {
  numerador: number;
  denominador: number;
}

/**
 * Item 14.2 do edital Banestes 01/2026: cálculos com duas casas decimais,
 * arredondando para cima quando a terceira casa for ≥ 5.
 * Opera só com inteiros (frações não negativas) para não sofrer erro de ponto flutuante.
 * Retorna o valor em centésimos (ex.: 5,67 → 567).
 */
export function arredondarCentesimos(f: Fracao): number {
  if (!(f.denominador > 0) || !Number.isInteger(f.denominador) || !Number.isInteger(f.numerador) || f.numerador < 0) {
    throw new RangeError(`Fração inválida para arredondamento: ${f.numerador}/${f.denominador}`);
  }
  // milésimos truncados: floor(n × 1000 / d); a 3ª casa decide o arredondamento
  const milesimos = Math.floor((f.numerador * 1000) / f.denominador);
  const centesimos = Math.floor(milesimos / 10);
  return milesimos % 10 >= 5 ? centesimos + 1 : centesimos;
}
