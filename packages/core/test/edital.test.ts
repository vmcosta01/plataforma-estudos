import { describe, expect, it } from 'vitest';
import { banestes2026TecnicoBancario as banestes } from '../src/editais/banestes-2026-tecnico-bancario';
import { questoesPorBloco, validarEdital } from '../src/edital/validar';
import type { Concurso } from '../src/edital/tipos';

describe('edital Banestes 2026 — Técnico Bancário', () => {
  it('é válido', () => {
    expect(validarEdital(banestes)).toEqual([]);
  });

  it('tem 9 disciplinas, 30 questões em Gerais, 40 em Específicos e 70 no total', () => {
    expect(banestes.disciplinas).toHaveLength(9);
    const q = questoesPorBloco(banestes);
    expect(q.gerais).toBe(30);
    expect(q.especificos).toBe(40);
    expect(q.gerais + q.especificos).toBe(70);
  });

  it('usa peso 1 para Gerais e 2 para Específicos, nota mínima 6', () => {
    expect(banestes.blocos.gerais.peso).toBe(1);
    expect(banestes.blocos.especificos.peso).toBe(2);
    expect(banestes.notaMinima).toBe(6);
  });

  it('tem prova em 24/01/2027 e banca FCC', () => {
    expect(banestes.dataProva).toBe('2027-01-24');
    expect(banestes.banca).toBe('FCC');
  });
});

describe('validarEdital — detecta erros', () => {
  const base: Concurso = structuredClone(banestes);

  it('acusa soma de questões diferente do total do bloco', () => {
    const c = structuredClone(base);
    c.disciplinas[0]!.questoes += 1;
    expect(validarEdital(c).join(' ')).toMatch(/questões/i);
  });

  it('acusa disciplina sem tópicos', () => {
    const c = structuredClone(base);
    c.disciplinas[0]!.topicos = [];
    expect(validarEdital(c).join(' ')).toMatch(/tópico/i);
  });

  it('acusa nomes de disciplina repetidos', () => {
    const c = structuredClone(base);
    c.disciplinas[1]!.nome = c.disciplinas[0]!.nome;
    expect(validarEdital(c).join(' ')).toMatch(/repetid/i);
  });
});
