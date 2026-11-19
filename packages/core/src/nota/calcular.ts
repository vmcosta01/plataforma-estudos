import type { Bloco, Concurso } from '../edital/tipos';
import { arredondarCentesimos, type Fracao } from './arredondar';

export type { Fracao } from './arredondar';

export interface ResultadoNota {
  /** Nota de cada prova (bloco) em centésimos, já arredondada pelo item 14.2 (ex.: 567 = 5,67). */
  porBlocoCentesimos: Record<Bloco, number>;
  /** Nota de cada prova na escala 0 a 10, para exibição. */
  porBloco: Record<Bloco, number>;
  /** Nota final em centésimos: média ponderada das notas por prova já arredondadas, arredondada de novo. */
  finalCentesimos: number;
  /** Nota final na escala 0 a 10, para exibição. */
  final: number;
  /** Nota final sem nenhum arredondamento (referência, não decide habilitação). */
  finalExata: Fracao;
  /** Habilitado se a nota final (com duas casas) ≥ nota mínima (item 10.3). */
  habilitado: boolean;
}

const mdc = (a: number, b: number): number => (b === 0 ? Math.abs(a) : mdc(b, a % b));

function reduzir(f: Fracao): Fracao {
  const d = mdc(f.numerador, f.denominador) || 1;
  return { numerador: f.numerador / d, denominador: f.denominador / d };
}

/**
 * Nota pela regra do edital (itens 10.1 a 10.3 e 14.2):
 * - cada prova vale (acertos / questões) × 10, com duas casas, meia para cima;
 * - final = Σ(nota_prova × peso) / Σ(peso), com duas casas, meia para cima;
 * - habilitado se final ≥ nota mínima.
 * Interpretação adotada: arredonda cada prova e depois a média (ver DECISIONS.md, ADR-8).
 * Para o Banestes (30 e 40 questões), o arredondamento nunca muda quem é habilitado.
 */
export function calcularNota(c: Concurso, acertos: Record<Bloco, number>): ResultadoNota {
  const blocos = Object.keys(c.blocos) as Bloco[];

  for (const b of blocos) {
    const a = acertos[b];
    const n = c.blocos[b].questoes;
    if (!Number.isInteger(a) || a < 0 || a > n) {
      throw new RangeError(`Número de acertos inválido no bloco "${b}": ${a} (esperado inteiro de 0 a ${n}).`);
    }
  }

  const porBlocoCentesimos = Object.fromEntries(
    blocos.map((b) => [b, arredondarCentesimos({ numerador: acertos[b] * 10, denominador: c.blocos[b].questoes })]),
  ) as Record<Bloco, number>;

  // Pesos podem ter até 2 casas: trabalha com pesos × 100 para manter inteiros.
  const pesos100 = Object.fromEntries(blocos.map((b) => [b, Math.round(c.blocos[b].peso * 100)])) as Record<Bloco, number>;
  const somaPesos100 = blocos.reduce((s, b) => s + pesos100[b], 0);
  const somaPonderada = blocos.reduce((s, b) => s + porBlocoCentesimos[b] * pesos100[b], 0);
  // somaPonderada está em (centésimos × pesos×100); dividir por 100 × Σpesos×100 volta à escala 0–10.
  const finalCentesimos = arredondarCentesimos({ numerador: somaPonderada, denominador: somaPesos100 * 100 });

  // Valor exato (sem arredondar), só como referência.
  const denomComum = blocos.reduce((p, b) => p * c.blocos[b].questoes, 1);
  let numerador = 0;
  for (const b of blocos) numerador += acertos[b] * 10 * pesos100[b] * (denomComum / c.blocos[b].questoes);
  const finalExata = reduzir({ numerador, denominador: denomComum * somaPesos100 });

  const habilitado = finalCentesimos >= Math.round(c.notaMinima * 100);

  return {
    porBlocoCentesimos,
    porBloco: Object.fromEntries(blocos.map((b) => [b, porBlocoCentesimos[b] / 100])) as Record<Bloco, number>,
    finalCentesimos,
    final: finalCentesimos / 100,
    finalExata,
    habilitado,
  };
}
